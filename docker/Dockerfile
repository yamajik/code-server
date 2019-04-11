FROM node:8.15.0

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

# In the future, we can use https://github.com/yarnpkg/rfcs/pull/53 to make yarn use the node_modules
# directly which should be fast as it is slow because it populates its own cache every time.
RUN yarn && NODE_ENV=production yarn task build:server:binary

# We deploy with ubuntu so that devs have a familiar environemnt.
FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y openssl net-tools git locales sudo dumb-init \
 && apt-get clean

RUN locale-gen en_US.UTF-8

# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LC_ALL=en_US.UTF-8

RUN adduser --gecos '' --disabled-password coder \
 && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder

# We create first instead of just using WORKDIR as when WORKDIR creates, the user is root.
RUN mkdir -p /home/coder/project

WORKDIR /home/coder/project

COPY --from=0 /src/packages/server/cli-linux-x64 /usr/local/bin/code-server

EXPOSE 8443

ENTRYPOINT ["dumb-init", "code-server"]
