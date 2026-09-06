#!/bin/bash
echo "Updating and installing common ML packages..."
sudo apt update && sudo apt install -y build-essential python3 python3-venv python3-pip git
