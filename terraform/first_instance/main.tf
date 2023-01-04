
resource "google_compute_instance" "default" {
#count = "${length(var.name_count)}"
#name = "app-${count.index+1}"
name = "app"
machine_type = var.machine_type
zone = var.zone  

    tags = [ "allow-http", "allow-https" ]     #FIREWALL

boot_disk {
  initialize_params {
    image = var.image
    size = "20"
  }
}

# Adding Lables
labels = {
  name = "app"
  machine_type = "${var.machine_type}"
}

network_interface {
  network = "default"
}

# Adding metadata
metadata = {
  size = "20"
  foo = "bar"
}

metadata_startup_script = "echo hi > /test.txt"

service_account {
  scopes = ["userinfo-email", "compute-ro", "storage-ro"]
}
}
# Creating a ssd disk to attach with this instance

resource "google_compute_disk" "default" {

    name = "test-disk"
    type = "pd-ssd"
    size = "10"
    zone = "${var.zone}"
    image = "debian-11-bullseye-v20220719"
}


# Attaching dissk

resource "google_compute_attached_disk" "default" {
    disk = google_compute_disk.default.id
    instance = google_compute_instance.default.id

}


output "machine_type" { value = "${google_compute_instance.default.*.machine_type}" }  #taking output of machine type

output "name" { value = "${google_compute_instance.default.*.name}" }    #taking output of machine name 

output "zone" { value = "${google_compute_instance.default.*.zone}" }    #taking output of machine zone