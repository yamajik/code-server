#!/bin/bash

set -e

VERSION=0.2.0

. docker/build.sh ${VERSION} $@
