#!/bin/bash +xe

export PATH=$PATH:/home/tfuser/bin:/home/tfuser/.local/bin:/home/tfuser/.local/gcloud/bin
export TF_VERSION=1.4.5
tfswitch
export TG_VERSION=0.45.4
tgswitch
terraform version
terragrunt -v
export CLOUDSDK_PYTHON=/usr/bin/python3          
gcloud -v
gpg --version
unzip -v