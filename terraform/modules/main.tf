
module "instance" {
    source = "../first_instance"

}

module "bucket" {
    source = "../bucket"

}

module "database" {
    source = "../database"

}

module "vpc" {
    source = "../vpc_example"

}