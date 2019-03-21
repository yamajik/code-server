#!/bin/bash

set -e

VERSION=0.1.3

. docker/build.sh ${VERSION} $@
