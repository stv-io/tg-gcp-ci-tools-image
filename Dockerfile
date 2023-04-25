# hadolint global ignore=DL3008,DL4006

FROM debian:11.6-slim 
# https://hub.docker.com/_/debian/tags?page=1&name=11.

ENV GCLOUD_VERSION=427.0.0
# https://cloud.google.com/sdk/docs/release-notes

ENV TERRAFORM_SWITCHER_VERSION=0.13.1308
# https://github.com/warrensbox/terraform-switcher/releases

ENV TGSWITCH_VERSION=0.6.0
# https://github.com/warrensbox/tgswitch/releases

RUN apt-get update && apt-get upgrade -y \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    openssh-client \
    sudo \
    ca-certificates \
    jq \
    python3 \
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

RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh ${TERRAFORM_SWITCHER_VERSION} | bash && \
    curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh ${TGSWITCH_VERSION} | bash && \
    mkdir -p /home/tfuser/.local/gcloud && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-cli=${GCLOUD_VERSION}-0 -y --no-install-recommends && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://raw.githubusercontent.com/twistedpair/google-cloud-sdk/master/google-cloud-sdk/completion.bash.inc /home/tfuser/.local/gcloud/completion.bash.inc
ADD https://raw.githubusercontent.com/twistedpair/google-cloud-sdk/master/google-cloud-sdk/path.bash.inc /home/tfuser/.local/gcloud/path.bash.inc
COPY .bashrc /home/tfuser/.bashrc

RUN echo 'source "/home/tfuser/.local/gcloud/path.bash.inc"' >> /home/tfuser/.bashrc \
    && echo 'source "/home/tfuser/.local/gcloud/completion.bash.inc"' >> /home/tfuser/.bashrc \
    && chown -R tfuser:tfuser /home/tfuser/.local  /home/tfuser/.bashrc

USER tfuser
WORKDIR /home/tfuser

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash"]
