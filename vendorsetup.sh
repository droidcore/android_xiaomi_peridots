#!/bin/bash


# Vendor (fresh clone)
echo "Cloning vendor tree..."
rm -rf vendor/xiaomi/peridot
git clone -b lineage-23.0 https://github.com/droidcore/proprietary_vendor_xiaomi_peridot.git vendor/xiaomi/peridot

# Kernel source (fresh clone)
echo "Cloning kernel source tree..."
rm -rf kernel/xiaomi/sm8635
git clone -b lineage-23.0 --depth 1 https://github.com/droidcore/android_kernel_xiaomi_sm8635.git kernel/xiaomi/sm8635
rm -rf kernel/xiaomi/sm8635-modules
git clone -b lineage-23.0 --depth 1 https://github.com/peridot-dev/android_kernel_xiaomi_sm8635-modules.git kernel/xiaomi/sm8635-modules

rm -rf kernel/xiaomi/sm8635-devicetrees
git clone -b lineage-23.0 --depth 1 https://github.com/peridot-dev/android_kernel_xiaomi_sm8635-devicetrees.git kernel/xiaomi/sm8635-devicetrees

# Hardware xiaomi (fresh clone)
echo "Cloning hardware xiaomi source..."
rm -rf hardware/xiaomi
git clone -b lineage-23.0 https://github.com/PeridotSupremacy/hardware_xiaomi.git hardware/xiaomi

# MiuiCamera device tree (fresh clone)
echo "Cloning MiuiCamera device tree..."
rm -rf device/xiaomi/peridot-miuicamera
git clone https://github.com/peridot-hyperos-2/device_xiaomi_peridot-miuicamera.git device/xiaomi/peridot-miuicamera

# MiuiCamera vendor tree (fresh clone)
echo "Cloning MiuiCamera vendor tree..."
rm -rf vendor/xiaomi/peridot-miuicamera
git clone https://github.com/peridot-hyperos-2/vendor-xiaomi-peridot-miuicamera.git vendor/xiaomi/peridot-miuicamera

# Packages Apps Settings
echo "Cloning Custom Apps Settings tree..."
rm -rf packages/apps/Settings
git clone https://github.com/droidcore/packages_apps_Settings.git packages/apps/Settings

# Dolby
git clone -b lineage-23.0 https://github.com/Poco-F6-resources/android_packages_apps_XiaomiDolby.git packages/apps/XiaomiDolby

# system sepolicy 
echo "Cloning Custom system sepolicy tree..."
rm -rf system/sepolicy
git clone https://github.com/droidcore/system_sepolicy.git system/sepolicy

# Fix deprecated camera override flag
BOARD_CONFIG=device/xiaomi/peridot-miuicamera/BoardConfig.mk

if grep -q "TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED" "$BOARD_CONFIG"; then
    echo "[PATCH] Fixing deprecated TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED in $BOARD_CONFIG"

    # Hapus semua baris lama yang pakai var itu
    sed -i '/TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED/d' "$BOARD_CONFIG"

    # Tambahkan baris baru di akhir file
    echo '$(call soong_config_set,camera,override_format_from_reserved,true)' >> "$BOARD_CONFIG"
fi

# Refresh signing keys
if [ -d vendor/lineage-priv/keys ]; then
  echo "Removing existing signing keys..."
  rm -rf vendor/lineage-priv/keys
fi
echo "Cloning fresh signing keys..."
git clone https://github.com/droidcore/vendor_cherish-priv_keys-template.git -b master vendor/lineage-priv/keys

# Always back to root at the end
if command -v croot &>/dev/null; then
  croot
else
  cd "$ANDROID_BUILD_TOP" || true
fi

echo "vendorsetup.sh execution complete."
