resource "google_cloud_run_service" "example" {
  name = "cloud-run-example"
  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  location = "europe-west1"
  depends_on = [
    google_project_service.activate_cloudrun_api
  ]
}

resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.example.name
  location = google_cloud_run_service.example.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_project_service" "activate_cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = true
}
