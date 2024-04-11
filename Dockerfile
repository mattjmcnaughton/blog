FROM golang:1.20

RUN go install git.sr.ht/~emersion/hut@latest

RUN apt update && apt install -y nodejs npm
RUN npm install -g sass

# For converting images (i.e. rotating, converting heic to jpg)
RUN apt install -y imagemagick libheif-examples

ARG USERNAME=nonroot
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir /site && chown $USERNAME /site
WORKDIR /site

USER $USERNAME

ENTRYPOINT ["/bin/bash"]
