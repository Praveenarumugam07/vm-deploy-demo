#!/bin/bash

ssh -o StrictHostKeyChecking=no $VM_USER@$VM_HOST << EOF
  echo "✅ Connected to VM"
  sudo apt-get update -y
  sudo apt-get install -y git python3 python3-pip

  # Clone repo if not already
  if [ ! -d ~/vm-deploy-demo ]; then
    git clone https://github.com/$REPO_USERNAME/vm-deploy-demo.git ~/vm-deploy-demo
  fi

  cd ~/vm-deploy-demo
  git pull origin main

  cd app
  pip3 install -r requirements.txt

  # Kill any previous app
  sudo pkill -f app.py || true

  # Start app
  nohup sudo python3 app.py > log.txt 2>&1 &
EOF
