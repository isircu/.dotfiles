sudo apt-get install build-essential dkms linux-image-generic linux-image-$(uname -r)

sudo usermod -aG vboxsf $(whoami)