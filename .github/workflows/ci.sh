#!/bin/bash

export PATH=$PATH:/home/tfuser/bin:/home/tfuser/.local/bin:/home/tfuser/.local/gcloud/bin
export 
export TF_VERSION=1.4.4
tfswitch
export TG_VERSION=0.45.2          
tgswitch
alias tg='terragrunt'
alias tf='terraform'
# git config --global --add safe.directory '*' # still problematic!
terraform version
tf version
terragrunt -v
tg -v
export CLOUDSDK_PYTHON=/usr/bin/python3          
gcloud -v
gpg --version
unzip -v