#!/bin/bash

set -e

VERSION=0.1.0

. docker/build.sh ${VERSION} $@
