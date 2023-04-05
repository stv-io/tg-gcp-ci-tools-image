export PATH=$PATH:/home/tfuser/bin:/home/tfuser.local/bin
export CLOUDSDK_PYTHON=/usr/bin/python3
tfswitch && tgswitch
alias tg='terragrunt'
alias tf='terraform'
git config --global --add safe.directory '*'
# terraform version
# terragrunt -v
# gcloud -v
