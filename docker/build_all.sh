#!/bin/bash

set -e

VERSION=0.1.4

. docker/build.sh ${VERSION} $@
