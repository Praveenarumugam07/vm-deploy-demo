#!/bin/bash

ssh -o StrictHostKeyChecking=no $VM_USER@$VM_HOST << EOF
  sudo pkill -f app.py || true
  cd ~/vm-deploy-demo || git clone https://github.com/$REPO_USERNAME/vm-deploy-demo.git && cd vm-deploy-demo
  git pull origin main
  cd app
  pip3 install -r requirements.txt
  nohup sudo python3 app.py > log.txt 2>&1 &
EOF
