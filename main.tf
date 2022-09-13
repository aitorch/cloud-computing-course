locals {
  apps = {
    helloapp = "gcr.io/cloudrun/hello"
    helloapp2 = "europe-west1-docker.pkg.dev/cloud-comp-101/examples/hello"
  }
  apis = [
    "run.googleapis.com",
    "artifactregistry.googleapis.com"
  ]

}
resource "google_cloud_run_service" "apps" {
  for_each = local.apps
  name     = each.key
  template {
    spec {
      containers {
        image = each.value
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  location = var.region
  depends_on = [
    google_project_service.activate_cloudrun_api
  ]
}

resource "google_cloud_run_service_iam_member" "run_all_users" {
  for_each = local.apps
  service  = google_cloud_run_service.apps[each.key].name
  location = google_cloud_run_service.apps[each.key].location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_project_service" "activate_cloudrun_api" {
  for_each           = toset(local.apis)
  service            = each.value
  disable_on_destroy = true
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  repository_id = "examples"
  description   = "example docker repository"
  format        = "DOCKER"
  depends_on = [
    google_project_service.activate_cloudrun_api
  ]
}

resource "google_artifact_registry_repository_iam_member" "access" {
  member     = "user:aitor.carrera@gmail.com"
  project    = google_artifact_registry_repository.my-repo.project
  location   = google_artifact_registry_repository.my-repo.location
  repository = google_artifact_registry_repository.my-repo.name
  role       = "roles/artifactregistry.admin"

}
