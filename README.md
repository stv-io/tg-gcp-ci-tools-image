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
ghcr.io/stv-io/tg-gcp-ci-tools-image/tg-gcp-ci-tools-image:v0.1.0

# once inside the container

tfuser@dc9f56bbe43d:/code$ cd Environments/
tfuser@dc9f56bbe43d:/code/Environments$ tg run-all plan


```

## TODO

Install tflint
Install tfvc for
pin versions inside container
hadolint
tests, make sure stuff is installed
see if we can squash image to make it smaller

check if we need the gcloud sdk in terraform?

In runner, when running `gcloud` we get this warning!
WARNING: Could not setup log file in /github/home/.config/gcloud/logs, (Error: Could not create directory [/github/home/.config/gcloud/logs/2023.04.05]: Permission denied.
Please verify that you have permissions to write to the parent directory..
The configuration directory may not be writable. To learn more, see <https://cloud.google.com/sdk/docs/configurations#creating_a_configuration>

## Improvement?

Consider starting from <https://hub.docker.com/r/google/cloud-sdk/dockerfile/> and adding terraform and terragrunt ..
