#instance Template <- Describe Instance

resource "google_compute_instance_template" "instance_template" {
    count = 1
  name = "temlate-server-${count.index+1}"
  description = "this template is for autoscaling"
  
  #tags = [] #network

    labels = {
      enviornment = "production"
       name = "temlate-server-${count.index+1}"
    }
     
     instance_description = "this is auto scale intance"
     machine_type = "n1-standard-1"
     can_ip_forward = "false"

     scheduling {
       automatic_restart = true
       on_host_maintenance = "MIGRATE"
     }
     
     disk {
         source_image = "debian-cloud/debian-11"
         auto_delete = true
         boot = true

     }

     disk {

        auto_delete = false
        disk_size_gb = 10
        mode = "READ_WRITE"
        type = "PERSISTENT"
            
        }

        network_interface {
          network = "default"
        }

        metadata = {
          foo = "bar"
        }

       service_account {
       scopes = ["userinfo-email", "compute-ro", "storage-ro"]
       }
     }

# Health Check <-- Auto Scaling Policy (when to scale)

resource "google_compute_health_check" "health" {
    count = 1
    name = "udemy"
    check_interval_sec = 5
    timeout_sec = 5
    healthy_threshold = 2
    unhealthy_threshold = 10

    http_health_check {
      request_path = "/alive.jsp"
      port = "8080"
    }
  
}

# Group Manager <-- manages the nodes

resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name = "instance-group-manager"
  #instance_template = "${google_compute_instance_template.instance_template.name}"
  base_instance_name = "instance-group-manager"
  region = "europe-west2"
  version {
    instance_template = google_compute_instance_template.instance_template[0].id
    name              = "primary"
  }
  
}

# Auto Scale Policy <-- How many Instances

resource "google_compute_region_autoscaler" "autoscaler" {

    count = 1
    name = "autoscaler"
    project = "terra-practice"
    region = "europe-west2"
    target = "${google_compute_region_instance_group_manager.instance_group_manager.id}"

    autoscaling_policy {
      
      max_replicas = 2
      min_replicas = 1
      cooldown_period = 60
      cpu_utilization {
        target = "0.8"

      }
    }
  
}