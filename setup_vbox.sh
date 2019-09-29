#!/bin/bash

# Enable shared folders
sudo usermod -aG vboxsf $(whoami)
