resource "google_storage_bucket" "NLP-bucket" {
  name = "${var.bucket_name}"
  location = "${var.bucket_location}"
  #storage_class = "${var.storage_class}"
  force_destroy = true


  labels = {
     name = "test-bucket"
     location = "${var.bucket_location}"

  }

  versioning {
    enabled = true
      }
}