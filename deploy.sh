#!/bin/bash

ssh -o StrictHostKeyChecking=no $VM_USER@$VM_HOST << EOF
  echo "✅ Connected to VM"
  sudo apt-get update -y
  sudo apt-get install -y git python3 python3-pip

  # Clone repo if not present
  if [ ! -d ~/vm-deploy-demo ]; then
    git clone https://github.com/$REPO_USERNAME/vm-deploy-demo.git ~/vm-deploy-demo
  fi

  cd ~/vm-deploy-demo
  git pull origin main

  # Create a virtual environment to safely install packages
  python3 -m venv venv
  source venv/bin/activate
  pip install --upgrade pip
  pip install -r requirements.txt

  # Kill old app (optional)
  pkill -f app.py || true

  # Start app inside virtualenv
  nohup venv/bin/python app.py > log.txt 2>&1 &
EOF
