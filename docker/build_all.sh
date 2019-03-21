#!/bin/bash

set -e

VERSION=0.1.2

. docker/build.sh ${VERSION} $@
