variable "environment" {
  default = "Dev"
}

variable "container_name" {
  default = "Nginx"
}

variable "name" {
  default = "ECSFargate"
}

variable "vpc_id" {
  default = ""
}

variable "private_subnets" {
  default = ""
}

variable "public_subnets" {
  default = ""
}

variable "http_port" {
  default = 80
}

variable "https_port" {
  default = 443
}

variable "container_port" {
  default = 80
}

variable "health_check_path" {
  default = "/"
}

variable "alb_tls_cert_arn" {
  default = ""
}

variable "container_image" {
  default = "nginx"
}