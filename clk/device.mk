# ----------------- BEGIN MIX-IN DEFINITIONS -----------------
# Mix-In definitions are auto-generated by mixin-update
##############################################################
# Source: device/intel/mixins/groups/slot-ab/true/product.mk
##############################################################
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_verifier \
    libavb \
    bootctrl.avb \
    bootctrl.intel \
    bootctrl.intel.static \
    update_engine_sideload \
    avbctl \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.bootctrl=intel

PRODUCT_PACKAGES_DEBUG += \
	bootctl
##############################################################
# Source: device/intel/mixins/groups/disk-bus/auto/product.mk
##############################################################
# create primary storage symlink dynamically
PRODUCT_PACKAGES += set_storage
PRODUCT_PACKAGES += set_storage.vendor
##############################################################
# Source: device/intel/mixins/groups/vendor-partition/true/product.mk
##############################################################

PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/vendor-partition/sh_recovery:recovery/root/vendor/bin/sh
PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/vendor-partition/mkshrc_recovery:recovery/root/vendor/etc/mkshrc
PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/vendor-partition/toolbox_recovery:recovery/root/vendor/bin/toolbox_static
PRODUCT_PACKAGES += \
     toybox_static \
     toybox_vendor \
##############################################################
# Source: device/intel/mixins/groups/boot-arch/project-celadon/product.mk.1
##############################################################

ifneq (0x0,static)
BOOTLOADER_POLICY_OEMVARS = $(PRODUCT_OUT)/bootloader_policy-oemvars.txt
BOARD_FLASHFILES += $(BOOTLOADER_POLICY_OEMVARS)
BOARD_OEM_VARS += $(BOOTLOADER_POLICY_OEMVARS)
endif
##############################################################
# Source: device/intel/mixins/groups/boot-arch/project-celadon/product.mk
##############################################################
TARGET_UEFI_ARCH := x86_64
BIOS_VARIANT := release


PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(TARGET_PRODUCT)

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.software.verified_boot.xml:vendor/etc/permissions/android.software.verified_boot.xml

PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/boot-arch/update_ifwi_ab.sh:vendor/bin/update_ifwi_ab
PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/boot-arch/update_ifwi_ab.sh:recovery/root/vendor/bin/update_ifwi_ab

# Allow Kernelflinger to start watchdog prior to boot the kernel
KERNELFLINGER_USE_WATCHDOG := true
# It activates the Bootloader policy and RMA refurbishing
# features. TARGET_BOOTLOADER_POLICY is the desired bitmask for this
# device.
# * bit 0:
#   - 0: GVB class B.
#   - 1: GVB class A.  Device unlock is not permitted.  The only way
#     to unlock is to use the secured force-unlock mechanism.
# * bit 1 and 2 defines the minimal boot state required to boot the
#   device:
#   - 0x0: BOOT_STATE_RED (GVB default behavior)
#   - 0x1: BOOT_STATE_ORANGE
#   - 0x2: BOOT_STATE_YELLOW
#   - 0x3: BOOT_STATE_GREEN
# If TARGET_BOOTLOADER_POLICY is equal to 'static' the bootloader
# policy is not built but is provided statically in the repository.
# If TARGET_BOOTLOADER_POLICY is equal to 'external' the bootloader
# policy OEMVARS should be installed manually in
# $(BOOTLOADER_POLICY_OEMVARS).
TARGET_BOOTLOADER_POLICY := 0x0
# If the following variable is set to false, the bootloader policy and
# RMA refurbishing features does not use time-based authenticated EFI
# variables to store the BPM and OAK values.  The BPM value is defined
# compilation time by the TARGET_BOOTLOADER_POLICY variable.
TARGET_BOOTLOADER_POLICY_USE_EFI_VAR := true
ifeq ($(TARGET_BOOTLOADER_POLICY),$(filter $(TARGET_BOOTLOADER_POLICY),0x0 0x2 0x4 0x6))
# OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	ro.oem_unlock_supported=1
endif
ifeq ($(TARGET_BOOTLOADER_POLICY),$(filter $(TARGET_BOOTLOADER_POLICY),static external))
# The bootloader policy is not generated build time but is supplied
# statically in the repository or in $(PRODUCT_OUT)/.  If your
# bootloader policy allows the device to be unlocked, uncomment the
# following lines:
# PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
# 	ro.oem_unlock_supported=1
endif
# Allow Kernelflinger to ignore the RSCI reset source "not_applicable"
# when setting the bootreason
KERNELFLINGER_IGNORE_NOT_APPLICABLE_RESET := true
# Android Kernelflinger uses the OpenSSL library to support the
# bootloader policy
KERNELFLINGER_SSL_LIBRARY := boringssl

KERNELFLINGER_SUPPORT_SELF_USB_DEVICE_MODE_PROTOCOL := true

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/persistent

##############################################################
# Source: device/intel/mixins/groups/sepolicy/enforcing/product.mk
##############################################################
PRODUCT_PACKAGES += sepolicy-areq-checker
##############################################################
# Source: device/intel/mixins/groups/trusty/true/product.mk
##############################################################

KM_VERSION := 2

ifeq ($(KM_VERSION),2)
PRODUCT_PACKAGES += \
	keystore.trusty
PRODUCT_PROPERTY_OVERRIDES += \
	ro.hardware.keystore=trusty
endif

ifeq ($(KM_VERSION),1)
PRODUCT_PACKAGES += \
	keystore.project-celadon
endif

PRODUCT_PACKAGES += \
	libtrusty \
	storageproxyd \
	libtrustystorage \
	libtrustystorageinterface \
	gatekeeper.trusty \
	android.hardware.gatekeeper@1.0-impl \
	android.hardware.gatekeeper@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
	ro.hardware.gatekeeper=trusty

##############################################################
# Source: device/intel/mixins/groups/project-celadon/default/product.mk
##############################################################
TARGET_BOARD_PLATFORM := project-celadon

#Product Characteristics
PRODUCT_DIR := $(dir $(lastword $(filter-out device/common/%,$(filter device/%,$(ALL_PRODUCTS)))))

INTEL_PATH_DEVICE := device/intel/project-celadon
INTEL_PATH_COMMON := device/intel/common
INTEL_PATH_SEPOLICY := device/intel/project-celadon/sepolicy
INTEL_PATH_BUILD := device/intel/build
INTEL_PATH_HARDWARE := hardware/intel
INTEL_PATH_VENDOR := vendor/intel

PRODUCT_TAGS += dalvik.gc.type-precise

DEVICE_PACKAGE_OVERLAYS += device/intel/project-celadon/common/overlay

PRODUCT_PACKAGES += $(THIRD_PARTY_APPS)

PRODUCT_PACKAGES += fio

# Set default sounds
# Note: As the override mechanism, must make sure this config 
# being in front of generic_no_telephony.mk(defined the aosp sound config) 
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Xenon.ogg \
    ro.config.alarm_alert=Cesium.ogg \
    ro.config.ringtone=Sceptrum.ogg \

# Get a list of languages.
#$(call inherit-product,$(SRC_TARGET_DIR)/product/locales_full.mk)
$(call inherit-product,$(SRC_TARGET_DIR)/product/languages_full.mk)

# Get everything else from the parent package
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_no_telephony.mk)

# Get some sounds
$(call inherit-product-if-exists,frameworks/base/data/sounds/AudioPackage6.mk)

# Get Platform specific settings
$(call inherit-product-if-exists,vendor/vendor.mk)

#Product Characteristics
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gpt.ini:root/gpt.$(TARGET_PRODUCT).ini \
    $(LOCAL_PATH)/init.recovery.rc:root/init.recovery.$(TARGET_PRODUCT).rc \
    $(LOCAL_PATH)/init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw//init.$(TARGET_PRODUCT).rc \
    $(LOCAL_PATH)/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# Voip
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.sip.xml:system/etc/permissions/android.software.sip.xml \

# Usb
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# Touch
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \

# please modify to appropriate value based on tuning
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hwui.texture_cache_size=24.0f \
    ro.hwui.text_large_cache_width=2048 \
    ro.hwui.text_large_cache_height=512

# Set filenames_mode to cts, for heh is not available
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.filenames_mode=aes-256-cts

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.rtc_local_time=1 \

# Enable MultiWindow
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.debug.multi_window=true

# DRM service
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

# Property to choose between virtual/external wfd display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.wfd.virtual=0

# Input resampling configuration
PRODUCT_PROPERTY_OVERRIDES += \
    ro.input.noresample=1

# set default DBC configuration
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.sys.usb.adbover=dwc

# AOSP Packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Terminal

PRODUCT_PACKAGES += \
    libion \
    libxml2

PRODUCT_PACKAGES += \
    libemoji

PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    WallpaperPicker \
    NotePad \
    Provision \
    drmserver \
    power.project-celadon \
    scp \
    sftp \
    ssh \
    sshd \
    local_time.default.so \
    keystore.default.so

# USB
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Power HAL
PRODUCT_PACKAGES += \
    android.hardware.power@1.2-impl \
    android.hardware.power@1.2-service

# DumpState HAL
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-impl \
    android.hardware.dumpstate@1.0-service

# Configstore HAL
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.0-impl

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/manifest.xml:vendor/manifest.xml
##############################################################
# Source: device/intel/mixins/groups/graphics/mesa/product.mk
##############################################################
# Mesa
PRODUCT_PACKAGES += \
    libGLES_mesa \
    libGLES_android

PRODUCT_PACKAGES += \
    libdrm \
    libdrm_intel \
    libsync \
    libmd

PRODUCT_PACKAGES += ufo_prebuilts

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/extra_files/graphics/drirc:system/etc/drirc


# HWComposer IA
PRODUCT_PACKAGES += \
    hwcomposer.$(TARGET_BOARD_PLATFORM)

PRODUCT_PROPERTY_OVERRIDES += \
   ro.hardware.hwcomposer=$(TARGET_BOARD_PLATFORM)

INTEL_HWC_CONFIG := $(INTEL_PATH_VENDOR)/external/project-celadon/hwcomposer

ifeq ($(findstring _acrn,$(TARGET_PRODUCT)),_acrn)
PRODUCT_COPY_FILES += $(INTEL_HWC_CONFIG)/hwc_display_virt.ini:$(TARGET_COPY_OUT_VENDOR)/etc/hwc_display.ini
else
PRODUCT_COPY_FILES += $(INTEL_HWC_CONFIG)/hwc_display.ini:$(TARGET_COPY_OUT_VENDOR)/etc/hwc_display.ini
endif


# Mini gbm
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=$(TARGET_BOARD_PLATFORM)

PRODUCT_PACKAGES += \
    gralloc.$(TARGET_BOARD_PLATFORM)



# Mesa
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:vendor/etc/permissions/android.hardware.opengles.aep.xml

# GLES version
PRODUCT_PROPERTY_OVERRIDES += \
   ro.opengles.version=196610

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:vendor/etc/permissions/android.hardware.vulkan.level.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:vendor/etc/permissions/android.hardware.vulkan.compute.xml


PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:vendor/etc/permissions/android.hardware.vulkan.version.xml

PRODUCT_PACKAGES += \
    vulkan.$(TARGET_BOARD_PLATFORM) \
    libvulkan_intel

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.vulkan=$(TARGET_BOARD_PLATFORM)
# Graphics HAL
PRODUCT_PACKAGES += \
   android.hardware.graphics.composer@2.1-impl \
   android.hardware.graphics.composer@2.1-service

# Gralloc HAL
PRODUCT_PACKAGES += \
   android.hardware.graphics.allocator@2.0-impl \
   android.hardware.graphics.allocator@2.0-service \
   android.hardware.graphics.mapper@2.0-impl
##############################################################
# Source: device/intel/mixins/groups/media/project-celadon/product.mk
##############################################################
# libva, vaapi
PRODUCT_PACKAGES += \
    libva \
    libva-android \
    i965_drv_video

PRODUCT_PACKAGES += libpciaccess

# Audio/video codec support.
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:vendor/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:vendor/etc/media_codecs_google_video.xml \
    device/intel/project-celadon/common/media/media_profiles_1080p.xml:vendor/etc/media_profiles_V1_0.xml \
    device/intel/project-celadon/common/media/media_codecs.xml:vendor/etc/media_codecs.xml \
    device/intel/project-celadon/common/media/media_codecs_performance.xml:vendor/etc/media_codecs_performance.xml

#Enable deep buffer for video playback
PRODUCT_PROPERTY_OVERRIDES += media.stagefright.audio.deep=true

# Enable AAC 5.1 output
PRODUCT_PROPERTY_OVERRIDES += \
    media.aac_51_output_enabled=true

# Enable Media Sdk
PRODUCT_PACKAGES += \
    libmfxhw32 \
    libmfxhw64 \
    libmfx_omx_core \
    libmfx_omx_components_hw \
    libstagefrighthw


# Enable Open source hdcp
PRODUCT_PACKAGES += libhdcpsdk
PRODUCT_PACKAGES += lihdcpcommon
# hdcp daemon
PRODUCT_PACKAGES += hdcpd

PRODUCT_COPY_FILES += \
    device/intel/project-celadon/common/media/mfx_omxil_core.conf:vendor/etc/mfx_omxil_core.conf
##############################################################
# Source: device/intel/mixins/groups/device-type/tablet/product.mk
##############################################################
PRODUCT_CHARACTERISTICS := tablet

$(call inherit-product,frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/tablet_core_hardware.xml:vendor/etc/permissions/tablet_core_hardware.xml

##############################################################
# Source: device/intel/mixins/groups/ethernet/dhcp/product.mk
##############################################################
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.ethernet.xml:vendor/etc/permissions/android.hardware.ethernet.xml
##############################################################
# Source: device/intel/mixins/groups/display-density/default/product.mk
##############################################################
PRODUCT_AAPT_CONFIG := normal large mdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.sf.lcd_density=160
##############################################################
# Source: device/intel/mixins/groups/usb-gadget/g_ffs/product.mk
##############################################################
# Set default USB interface
ifeq ($(TARGET_BUILD_VARIANT),user)
# Enable Secure Debugging
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=1
ifeq ($(BUILD_FOR_CTS_AUTOMATION),true)
# Build for automated CTS
PRODUCT_COPY_FILES += $(INTEL_PATH_COMMON)/usb-gadget/adb_keys:root/adb_keys
endif #BUILD_FOR_CTS_AUTOMATION == true
endif #TARGET_BUILD_VARIANT == user

# Add Intel adb keys for userdebug/eng builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += $(INTEL_PATH_COMMON)/usb-gadget/adb_keys:root/adb_keys
# Enable Secure Debugging for userdebug
ifeq ($(TARGET_BUILD_VARIANT),userdebug) #userdebug
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=1
endif #userdebug
endif #userdebug/eng
##############################################################
# Source: device/intel/mixins/groups/adb_net/true/product.mk
##############################################################
# Enable Secure Debugging
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=1
endif
##############################################################
# Source: device/intel/mixins/groups/kernel/project-celadon/product.mk
##############################################################
TARGET_KERNEL_ARCH := x86_64
BOARD_USE_64BIT_KERNEL := true


KERNEL_MODULES_ROOT_PATH ?= /vendor/lib/modules
KERNEL_MODULES_ROOT ?= $(KERNEL_MODULES_ROOT_PATH)

FIRMWARES_DIR ?= vendor/linux/firmware

# Include common settings.
FIRMWARE_FILTERS ?= .git/% %.mk

# Firmware
$(call inherit-product,device/intel/project-celadon/common/firmware.mk)
##############################################################
# Source: device/intel/mixins/groups/bluetooth/btusb/product.mk
##############################################################
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    ath3k-1.fw

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.bluetooth.xml:vendor/etc/permissions/android.hardware.bluetooth.xml \
		frameworks/native/data/etc/android.hardware.bluetooth_le.xml:vendor/etc/permissions/android.hardware.bluetooth_le.xml

# Bluetooth HAL
PRODUCT_PACKAGES += \
  android.hardware.bluetooth@1.0-impl.vbt \
  android.hardware.bluetooth@1.0-service.vbt \
  libbt-vendor


PRODUCT_PACKAGE_OVERLAYS += $(INTEL_PATH_COMMON)/bluetooth/overlay-tablet
##############################################################
# Source: device/intel/mixins/groups/audio/project-celadon/product.mk
##############################################################
# Tinyalsa
PRODUCT_PACKAGES_DEBUG += \
         tinymix \
         tinyplay \
         tinycap

# Extended Audio HALs
PRODUCT_PACKAGES += \
    audio.r_submix.default \
    audio.usb.default \
    audio.usb.$(TARGET_BOARD_PLATFORM) \
    audio.hdmi.$(TARGET_BOARD_PLATFORM) \
    audio_policy.default.so \
    audio_configuration_files

# Audio HAL
PRODUCT_PACKAGES += \
    android.hardware.audio.effect@4.0-impl \
    android.hardware.audio@4.0-impl \
    android.hardware.audio@2.0-service

PRODUCT_PROPERTY_OVERRIDES += audio.safemedia.bypass=true
##############################################################
# Source: device/intel/mixins/groups/wlan/iwlwifi/product.mk
##############################################################
PRODUCT_PACKAGES += \
    hostapd \
    hostapd_cli \
    wificond \
    wifilogd \
    wpa_supplicant \
    wpa_cli \
    iw
   
# FW and PNVM
PRODUCT_PACKAGES += \
    iwl-fw          \
    iwl-nvm

# iwlwifi USC
PRODUCT_PACKAGES += \
    wifi_intel_usc

#copy iwlwifi wpa config files
PRODUCT_COPY_FILES += \
        device/intel/common/wlan/wpa_supplicant-common.conf:vendor/etc/wifi/wpa_supplicant.conf \
        device/intel/common/wlan/iwlwifi/wpa_supplicant_overlay.conf:vendor/etc/wifi/wpa_supplicant_overlay.conf \
        device/intel/common/wlan/iwlwifi/p2p_supplicant_overlay.conf:vendor/etc/wifi/p2p_supplicant_overlay.conf \
        frameworks/native/data/etc/android.hardware.wifi.xml:vendor/etc/permissions/android.hardware.wifi.xml \
        frameworks/native/data/etc/android.hardware.wifi.direct.xml:vendor/etc/permissions/android.hardware.wifi.direct.xml

# Wifi configuration
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WLAN_DEVICE := iwlwifi

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.wifi.softap_dualband_allow=false

PRODUCT_PACKAGES += \
  android.hardware.wifi@1.0-service
##############################################################
# Source: device/intel/mixins/groups/cpuset/autocores/product.mk
##############################################################
PRODUCT_PACKAGES += \
    config_cpuset.sh

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/extra_files/cpuset/config_cpuset.sh:vendor/bin/config_cpuset.sh
##############################################################
# Source: device/intel/mixins/groups/rfkill/true/product.mk
##############################################################
PRODUCT_COPY_FILES += $(INTEL_PATH_COMMON)/rfkill/rfkill-init.sh:vendor/bin/rfkill-init.sh
##############################################################
# Source: device/intel/mixins/groups/usb/host+acc/product.mk
##############################################################
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# usb accessory
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-impl \
    android.hardware.usb@1.0-service
##############################################################
# Source: device/intel/mixins/groups/lights/true/product.mk
##############################################################
# Lights HAL
BOARD_SEPOLICY_DIRS += \
    $(INTEL_PATH_SEPOLICY)/light

PRODUCT_PACKAGES += lights.$(TARGET_BOARD_PLATFORM) \
    android.hardware.light@2.0-service \
    android.hardware.light@2.0-impl

##############################################################
# Source: device/intel/mixins/groups/thermal/thermal-daemon/product.mk
##############################################################
# thermal-daemon
PRODUCT_PACKAGES += thermal-daemon
PRODUCT_COPY_FILES += \
	device/intel/project-celadon/common/thermal/thermal-conf.xml:/vendor/etc/thermal-daemon/thermal-conf.xml \
	device/intel/project-celadon/common/thermal/thermal-cpu-cdev-order.xml:/vendor/etc/thermal-daemon/thermal-cpu-cdev-order.xml
##############################################################
# Source: device/intel/mixins/groups/pstore/ram_dummy/product.mk
##############################################################
PRODUCT_PACKAGES += \
    pstore-clean
##############################################################
# Source: device/intel/mixins/groups/debug-logs/true/product.mk
##############################################################
ifneq ($(TARGET_BUILD_VARIANT),user)
MIXIN_DEBUG_LOGS := true
endif

ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/debug-logs/init.logs.rc:root/init.logs.rc
PRODUCT_PACKAGES += \
    elogs.sh \
    start_log_srv.sh \
    logcat_ep.sh
endif

ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.service.default_logfs=apklogfs
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.vendor.intel.logger=/system/bin/logcat
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.logd.kernel.raw_message=False
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.vendor.intel.logger.rot_cnt=20
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.vendor.intel.logger.rot_size=5000
BOARD_SEPOLICY_DIRS += $(INTEL_PATH_SEPOLICY)/debug-logs
BOARD_SEPOLICY_M4DEFS += module_debug_logs=true
endif
##############################################################
# Source: device/intel/mixins/groups/debug-crashlogd/true/product.mk
##############################################################
ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/extra_files/debug-crashlogd/init.crashlogd.rc:root/init.crashlogd.rc \
	$(call add-to-product-copy-files-if-exists,$(LOCAL_PATH)/extra_files/debug-crashlogd/ingredients.conf:$(TARGET_COPY_OUT_VENDOR)/etc/ingredients.conf) \
	$(call add-to-product-copy-files-if-exists,$(LOCAL_PATH)/extra_files/debug-crashlogd/crashlog.conf:$(TARGET_COPY_OUT_VENDOR)/etc/crashlog.conf)
PRODUCT_PACKAGES += crashlogd \
	dumpstate_dropbox.sh
endif

ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.vendor.crashlogd.data_quota=50
BOARD_SEPOLICY_DIRS += device/intel/project-celadon/sepolicy/crashlogd

CRASHLOGD_LOGS_PATH := "/data/logs"
CRASHLOGD_APLOG := true
CRASHLOGD_FULL_REPORT := true
CRASHLOGD_MODULE_MODEM ?= true
CRASHLOGD_USE_SD := false
endif
##############################################################
# Source: device/intel/mixins/groups/debug-coredump/true/product.mk
##############################################################
ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/debug-coredump/init.coredump.rc:root/init.coredump.rc
endif

ifeq ($(MIXIN_DEBUG_LOGS),true)
BOARD_SEPOLICY_DIRS += $(INTEL_PATH_SEPOLICY)/coredump
# Enable core dump for eng builds
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.core.enabled=1
else
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.core.enabled=0
endif
CRASHLOGD_COREDUMP := true
endif
##############################################################
# Source: device/intel/mixins/groups/debug-phonedoctor/true/product.mk
##############################################################
ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_PACKAGES += crash_package
endif
##############################################################
# Source: device/intel/mixins/groups/debug-tools/true/product.mk
##############################################################
PRODUCT_PACKAGES_DEBUG += \
    AndroidTerm \
    libjackpal-androidterm4 \
    peeknpoke \
    pytimechart-record \
    lspci \
    llvm-symbolizer
##############################################################
# Source: device/intel/mixins/groups/midi/true/product.mk
##############################################################
# MIDI support
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:vendor/etc/permissions/android.software.midi.xml
##############################################################
# Source: device/intel/mixins/groups/camera-ext/ext-camera-only/product.mk
##############################################################
# Camera: Device-specific configuration files. Supports only External USB camera, no CSI support
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.external.xml:vendor/etc/permissions/android.hardware.camera.external.xml \
    device/intel/project-celadon/common/camera-ext/external_camera_config.xml:vendor/etc/external_camera_config.xml

# External camera service
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-external-service \
                    android.hardware.camera.provider@2.4-impl

# Only include test apps in eng or userdebug builds.
PRODUCT_PACKAGES_DEBUG += TestingCamera

PRODUCT_PACKAGES += MultiCameraApp
##############################################################
# Source: device/intel/mixins/groups/memtrack/true/product.mk
##############################################################
# memtrack HAL
PRODUCT_PACKAGES += \
	memtrack.$(TARGET_BOARD_PLATFORM) \
	android.hardware.memtrack@1.0-service \
	android.hardware.memtrack@1.0-impl
##############################################################
# Source: device/intel/mixins/groups/touch/galax7200/product.mk
##############################################################
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:vendor/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml\
        $(INTEL_PATH_COMMON)/touch/Vendor_0eef_Product_7200.idc:system/usr/idc/Vendor_0eef_Product_7200.idc
##############################################################
# Source: device/intel/mixins/groups/health/true/product.mk
##############################################################
PRODUCT_PACKAGES += health
PRODUCT_PACKAGES += health.$(TARGET_BOARD_PLATFORM) \
					android.hardware.health@2.0-service.celadon
##############################################################
# Source: device/intel/mixins/groups/art-config/default/product.mk
##############################################################
# This is needed to enable silver art optimizer.
VENDOR_ART_PATH ?= $(INTEL_PATH_VENDOR)/art-extension

PRODUCT_PACKAGES_TESTS += \
    art-run-tests \
    libarttest \
    libnativebridgetest \
    libart-gtest
##############################################################
# Source: device/intel/mixins/groups/default-drm/true/product.mk
##############################################################
#only enable default drm service
PRODUCT_PACKAGES += android.hardware.drm@1.0-service \
                    android.hardware.drm@1.0-impl \
                    android.hardware.drm@1.1-service.clearkey

##############################################################
# Source: device/intel/mixins/groups/debug-kernel/default/product.mk
##############################################################
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/extra_files/debug-kernel/init.kernel.rc:root/init.kernel.rc
endif
##############################################################
# Source: device/intel/mixins/groups/debug-unresponsive/default/product.mk
##############################################################
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += sys.dropbox.max_size_kb=4096

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += sys.dump.binder_stats.uiwdt=1
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += sys.dump.binder_stats.anr=1

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += sys.dump.peer_depth=3

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += sys.dump.stacks_timeout=1500

endif
# ------------------ END MIX-IN DEFINITIONS ------------------
