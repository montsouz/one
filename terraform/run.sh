#!/bin/bash

terraform plan -var-file=dev.tfvars
read -r -p "Enter 1 to continue:" mainmenuinput
if [ "$mainmenuinput" -eq 1 ]; then
  terraform apply -var-file=dev.tfvars -auto-approve
fi