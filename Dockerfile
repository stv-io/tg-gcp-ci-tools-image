FROM debian:11.6-slim

ENV GCLOUD_VERSION=425.0.0
ENV TERRAFORM_SWITCHER_VERSION=0.13.1308
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
    # python3-distutils=xxx \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m -s /bin/bash tfuser && \
    echo "tfuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh ${TERRAFORM_SWITCHER_VERSION} | bash
RUN curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh ${TGSWITCH_VERSION} | bash
RUN curl -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz -o /tmp/gcloud.tar.gz \
    && mkdir -p /home/tfuser/.local/gcloud \
    && tar xf /tmp/gcloud.tar.gz -C /home/tfuser/.local/gcloud --strip-components=1 \
    && rm /tmp/gcloud.tar.gz

COPY .bashrc /home/tfuser/.bashrc

RUN echo 'source "/home/tfuser/.local/gcloud/path.bash.inc"' >> /home/tfuser/.bashrc \
    && echo 'source "/home/tfuser/.local/gcloud/completion.bash.inc"' >> /home/tfuser/.bashrc \
    && chown -R tfuser:tfuser /home/tfuser/.local  /home/tfuser/.bashrc

USER tfuser
WORKDIR /home/tfuser

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash"]
