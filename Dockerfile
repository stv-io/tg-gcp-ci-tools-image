# https://hub.docker.com/_/debian/tags?page=1&name=11.
FROM debian:11.6-slim

# https://cloud.google.com/sdk/docs/release-notes
ENV GCLOUD_VERSION=427.0.0
# https://github.com/warrensbox/terraform-switcher/releases
ENV TERRAFORM_SWITCHER_VERSION=0.13.1308
# https://github.com/warrensbox/tgswitch/releases
ENV TGSWITCH_VERSION=0.6.0

RUN apt-get update && apt-get upgrade -y \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    # curl=7.74.0-1.3+b3 \
    git \
    # git=1:2.30.2-1~bpo10+1 \
    openssh-client \
    # openssh-client=1:8.4p1-5 \
    sudo \
    # sudo=1.9.0-2.1+deb10u3 \
    ca-certificates \
    # ca-certificates=20210119 \
    jq \
    # jq=1.6... \
    python3 \
    # python3=3.9.13-3 \
    python3-distutils \
    gpg \
    gpg-agent \
    unzip \
    apt-transport-https \
    gnupg \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m -s /bin/bash tfuser && \
    echo "tfuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh ${TERRAFORM_SWITCHER_VERSION} | bash
RUN curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh ${TGSWITCH_VERSION} | bash
RUN mkdir -p /home/tfuser/.local/gcloud
ADD https://raw.githubusercontent.com/twistedpair/google-cloud-sdk/master/google-cloud-sdk/completion.bash.inc /home/tfuser/.local/gcloud/completion.bash.inc
ADD https://raw.githubusercontent.com/twistedpair/google-cloud-sdk/master/google-cloud-sdk/path.bash.inc /home/tfuser/.local/gcloud/path.bash.inc

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-cli=${GCLOUD_VERSION}-0 -y

COPY .bashrc /home/tfuser/.bashrc

RUN echo 'source "/home/tfuser/.local/gcloud/path.bash.inc"' >> /home/tfuser/.bashrc \
    && echo 'source "/home/tfuser/.local/gcloud/completion.bash.inc"' >> /home/tfuser/.bashrc \
    && chown -R tfuser:tfuser /home/tfuser/.local  /home/tfuser/.bashrc

USER tfuser
WORKDIR /home/tfuser

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash"]

