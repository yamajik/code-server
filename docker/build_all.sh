#!/bin/bash

set -e

VERSION=0.1.5

. docker/build.sh ${VERSION} $@
