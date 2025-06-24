#!/bin/bash

ssh -o StrictHostKeyChecking=no $VM_USER@$VM_HOST << 'EOF'
  echo "✅ Connected to VM"

  # Step 1: Install system dependencies
  sudo apt-get update -y
  sudo apt-get install -y git python3 python3-pip python3-venv

  # Step 2: Clone repo if not present
  if [ ! -d ~/vm-deploy-demo ]; then
    git clone https://github.com/'$REPO_USERNAME'/vm-deploy-demo.git ~/vm-deploy-demo
  fi

  cd ~/vm-deploy-demo
  git pull origin main

  # Step 3: Create virtual environment
  python3 -m venv venv
  source venv/bin/activate

  # Step 4: Install dependencies with --break-system-packages flag
  pip install --break-system-packages --upgrade pip
  pip install --break-system-packages -r requirements.txt

  # Step 5: Stop any running app
  pkill -f app.py || true

  # Step 6: Start the app
  nohup venv/bin/python app.py > log.txt 2>&1 &
EOF
