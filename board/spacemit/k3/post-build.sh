#!/bin/bash -e
DATE=$(date +%Y%m%d%H%M%S)
echo "$DATE" | tee "${TARGET_DIR}/etc/bianbu_version"