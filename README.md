# tg-gcp-ci-tools-image

A dockerfile for running CI/CD pipelines in GCP, and corresponding terraform and terragrunt tooling

## Permissions required

private github repo access, through SSH keys, bound to user in trusted repo
gcloud access, to check

## Running locally

in terragrunt folder:

```console
docker run -it \
  -w /code \
  -v $(pwd):/code \
  -v $HOME/.config/gcloud:/home/tfuser/.config/gcloud \
  -v $HOME/.ssh:/home/tfuser/.ssh \
<image>

# once inside the container

tfuser@dc9f56bbe43d:/code$ cd Environments/
tfuser@dc9f56bbe43d:/code/Environments$ tg run-all plan


```

## TODO

Install tflint
Install tfvc for
pin versions inside container, including tgswitch and tfswitch (install them without | bash)
hadolint
tests, make sure stuff is installed
see if we can squash image to make it smaller

check if we need the gcloud sdk in terraform?
