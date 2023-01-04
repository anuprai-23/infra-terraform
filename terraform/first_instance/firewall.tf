resource "google_compute_firewall" "allow_http" {
    name = "allow-http"
    network = "default"

  allow {
         protocol = "tcp"
         ports = ["80"]
       }
  
    target_tags = ["allow-http"]
     #source_tags = "allow-http"
     source_tags = ["mynetwork"]
}

resource "google_compute_firewall" "allow_https" {
    name = "allow-https"
    network = "default"

 allow {
         protocol = "tcp"
         ports = ["443"]
       }
  
    target_tags = ["allow-https"]
    source_tags = ["mynetwork"]
    #source_tags = "allow-https"
}