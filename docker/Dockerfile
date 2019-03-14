FROM node:8.15.0

ENV ELECTRON_MIRROR "https://npm.taobao.org/mirrors/electron/"

COPY ./docker/sources.list /etc/apt/sources.list

# Install VS Code's deps. These are the only two it seems we need.
RUN apt-get update \
 && apt-get install -y libx11-dev libxkbfile-dev libsecret-1-dev \
 && apt-get clean

RUN npm config set registry https://registry.npm.taobao.org \
 && npm config set disturl https://npm.taobao.org/dist \
 && npm config set ELECTRON_MIRROR https://npm.taobao.org/mirrors/electron/

# Ensure latest yarn.
RUN npm install -g yarn

RUN yarn config set registry https://registry.npm.taobao.org \
 && yarn config set disturl https://npm.taobao.org/dist \
 && yarn config set ELECTRON_MIRROR https://npm.taobao.org/mirrors/electron/

WORKDIR /src

COPY . .

# In the future, we can use https://github.com/yarnpkg/rfcs/pull/53 to make yarn use the node_modules
# directly which should be fast as it is slow because it populates its own cache every time.
RUN yarn && yarn task build:server:binary

# We deploy with ubuntu so that devs have a familiar environemnt.
FROM ubuntu:18.10

WORKDIR /root/project

COPY --from=0 /src/packages/server/cli-linux-x64 /usr/local/bin/code-server

EXPOSE 8443

RUN apt-get update \
 && apt-get install -y openssl net-tools locales \
 && apt-get clean

RUN locale-gen en_US.UTF-8

# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LANG=en_US.UTF-8

# Unfortunately `.` does not work with code-server.
CMD code-server $PWD
