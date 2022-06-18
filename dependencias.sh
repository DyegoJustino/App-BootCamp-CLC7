#!/bin/bash
sudo apt-get update -y
sudo apt-get install git ansible -y

git clone https://github.com/DyegoJustino/App-BootCamp-CLC7.git /tmp/app/

cd /tmp/app/
ansible-playbook app-playbook.yml
