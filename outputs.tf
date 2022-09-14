output "service_url" {
  value = [for app in google_cloud_run_service.apps : app.status[0].url]

}
