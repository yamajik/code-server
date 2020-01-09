#!/bin/bash

set -e

VERSION=0.2.1

. docker/build.sh ${VERSION} $@
