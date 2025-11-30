#!/bin/bash
make ruby_user_defconfig

MERGE_CONFIG=$KERNEL_NAME/scripts/kconfig/merge_config.sh
CONFIGS="vendor/bbr.config vendor/noop.config vendor/lru.config vendor/kernelsu.config vendor/susfs.config"

cd $KERNEL_NAME

$MERGE_CONFIG -m .config $CONFIGS

echo "Configuration fragments applied manually."
