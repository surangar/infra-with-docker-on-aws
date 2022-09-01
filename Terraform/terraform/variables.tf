variable "region" {
  type = string
}
variable "azs" {
  type = set(string)
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnet_cidr01" {
  type = string
}
variable "public_subnet_cidr02" {
  type = string
}
variable "private_subnet_cidr01" {
  type = string
}
variable "private_subnet_cidr02" {
  type = string
}
variable "host_count" {
  type = number
}
variable "ami_id" {
  type = string
}
variable "instancetype" {
  type = string
}
variable "name" {
  type = string
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}