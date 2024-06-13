#!/bin/bash -e

cp -r $BR2_EXTERNAL_Bianbu_PATH/board/spacemit/k1/plt_overlay/* $TARGET_DIR

if [ -f $BR2_EXTERNAL_Bianbu_PATH/../package-src/factorytest/run_weston.sh ]
then
	cp $BR2_EXTERNAL_Bianbu_PATH/../package-src/factorytest/run_weston.sh $TARGET_DIR/root
fi

DATE=$(date +%Y%m%d%H%M%S)
echo "$DATE" | tee "${TARGET_DIR}/etc/bianbu_version"
