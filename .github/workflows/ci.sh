#!/bin/bash +xe

echo "Testing installed dependencies"
gpg --version
unzip -v
curl --version
ssh -V
python3 --version
jq -V

echo "Testing CI/CD binaries and tools"
export PATH=$PATH:/home/tfuser/bin:/home/tfuser/.local/bin:/home/tfuser/.local/gcloud/bin
export TF_VERSION=1.4.6
tfswitch
export TG_VERSION=0.45.11
tgswitch
terraform version
terragrunt -v
export CLOUDSDK_PYTHON=/usr/bin/python3          
gcloud -v
tflint --version

echo "Done .."