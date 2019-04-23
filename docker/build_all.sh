#!/bin/bash

set -e

VERSION=0.1.6

. docker/build.sh ${VERSION} $@
