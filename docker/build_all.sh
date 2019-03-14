#!/bin/bash

set -xe

VERSION=0.1.0

bash docker/build.sh ${VERSION} $@
