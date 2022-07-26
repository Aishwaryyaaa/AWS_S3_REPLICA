variable "ami" {
  type    = string
  default = "ami-0960ab670c8bb45f3"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "public_vpc_cidr" {
  type = list(string)
}
variable "avail_zone" {
  type = list(string)
}
variable "private_vpc_cidr" {
  type = list(string)
}