#!/bin/bash

# Каталоги:
# KERNEL_NAME = mayuri-ksun (папка с исходным кодом ядра)
# OUT_DIR = /home/runner/work/KernelActions/KernelActions/out (папка с .config)

# Убедитесь, что .config существует в OUT_DIR (он был создан на предыдущем шаге make defconfig)
if [ ! -f "$OUT_DIR/.config" ]; then
    echo "ERROR: Base .config not found in $OUT_DIR."
    exit 1
fi

# 1. КОПИРУЕМ .config из OUT_DIR в папку ядра
cp "$OUT_DIR/.config" "$KERNEL_NAME/.config"

# 2. ПЕРЕХОДИМ в папку ядра для работы merge_config.sh
cd "$KERNEL_NAME" || exit 1

# 3. Устанавливаем переменные для merge_config.sh
MERGE_CONFIG="./scripts/kconfig/merge_config.sh"

# Фрагменты конфигурации. 
# ВАЖНО: Эти пути должны быть корректными относительно текущей папки ($KERNEL_NAME)
# Если фрагменты vendor/*.config находятся в корне репозитория ядра, эти пути верны.
CONFIGS="vendor/bbr.config vendor/noop.config vendor/lru.config vendor/kernelsu.config vendor/susfs.config"

echo "--- Starting config merge using $MERGE_CONFIG ---"
echo "Fragments: $CONFIGS"

# 4. Выполняем объединение конфигураций
$MERGE_CONFIG -m .config $CONFIGS

# 5. КОПИРУЕМ ОБНОВЛЕННЫЙ .config обратно в OUT_DIR
cp .config "$OUT_DIR/.config"

echo "--- Config merge completed and updated .config saved to $OUT_DIR/.config ---"
