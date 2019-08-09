#!/bin/bash

set -e

VERSION=0.1.8

. docker/build.sh ${VERSION} $@
