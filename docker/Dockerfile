FROM node:12.14.0
ARG codeServerVersion=docker
ARG vscodeVersion="release/1.41"
ARG githubToken

ENV ELECTRON_MIRROR "https://npm.taobao.org/mirrors/electron/"

COPY ./docker/sources.list /etc/apt/sources.list

# Install VS Code's deps. These are the only two it seems we need.
RUN apt-get update \
	&& apt-get install -y libxkbfile-dev libsecret-1-dev \
	&& apt-get clean

RUN npm config set registry https://registry.npm.taobao.org \
	&& npm config set disturl https://npm.taobao.org/dist \
	&& npm config set ELECTRON_MIRROR https://npm.taobao.org/mirrors/electron/

# Ensure latest yarn.
RUN npm install -g yarn@1.13

RUN yarn config set registry https://registry.npm.taobao.org \
	&& yarn config set disturl https://npm.taobao.org/dist \
	&& yarn config set ELECTRON_MIRROR https://npm.taobao.org/mirrors/electron/

WORKDIR /src

COPY . .

RUN yarn \
	&& MINIFY=true GITHUB_TOKEN="${githubToken}" yarn build "${vscodeVersion}" "${codeServerVersion}" \
	&& yarn binary "${vscodeVersion}" "${codeServerVersion}" \
	&& mv "/src/binaries/code-server${codeServerVersion}-vsc${vscodeVersion}-linux-x86_64" /src/binaries/code-server \
	&& rm -r /src/build \
	&& rm -r /src/source

# We deploy with ubuntu so that devs have a familiar environment.
FROM ubuntu:18.04

RUN apt-get update \
	&& apt-get install -y openssl net-tools git locales sudo dumb-init vim curl wget \
	&& apt-get clean

RUN locale-gen en_US.UTF-8

# We cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LC_ALL=en_US.UTF-8 \
	SHELL=/bin/bash

RUN adduser --gecos '' --disabled-password coder \
	&& echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder
# We create first instead of just using WORKDIR as when WORKDIR creates, the
# user is root.
RUN mkdir -p /home/coder/project
# To avoid EACCES issues on f.ex Crostini (ChromeOS)
RUN mkdir -p /home/coder/.local/share/code-server

WORKDIR /home/coder/project

# This ensures we have a volume mounted even if the user forgot to do bind
# mount. So that they do not lose their data if they delete the container.
VOLUME [ "/home/coder/project" ]

COPY --from=0 /src/binaries/code-server /usr/local/bin/code-server

EXPOSE 8080

ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0"]
