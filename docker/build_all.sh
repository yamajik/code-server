#!/bin/bash

set -e

VERSION=0.1.7

. docker/build.sh ${VERSION} $@
