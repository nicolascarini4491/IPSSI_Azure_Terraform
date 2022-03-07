# Création d'une variable pour la location 
variable "location" {
  type    = string
  default = "West Europe"
}

# Création d'une variable pour le temps de retention du log analytics workspace 
variable "retention" {
  type    = number
  default = "30"
}

# Création d'une variable pour le nom de l'utilisateur 
variable "name" {
  type    = string
  default = "nicolas"
}

variable "name-raphael" {
  type    = string
  default = "raphael"
}

variable "name-matthew" {
  type    = string
  default = "matthew"
}

variable "prefix" {
  default = "tfvmex"
}

variable "mail-nicolas" {
  type    = string
  default = "nicolas.carini@hotmail.fr"
}

variable "mail-raphael" {
  type    = string
  default = "raphael.deletoille@gmail.com"
}

variable "mail-matthew" {
  type    = string
  default = "maresu.pro@gmail.com"
}