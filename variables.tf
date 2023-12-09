variable "target" {
  description = "backend hostname to attack"
  type        = string
}

variable "api-gw-hostname" {
   description = "front-end hostname without zone name"
   type        = string
}

variable "zone-name" {
  description = "our zone-name"
  type = string
  default = "shadow-it.nl"
}

variable "aws-region" {
  description = "AWS region"
  type = string
}

variable "weight" {
  description = "weight of DNS record, 0-255"
  type = number
}