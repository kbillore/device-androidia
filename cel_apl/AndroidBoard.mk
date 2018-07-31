# ----------------- BEGIN MIX-IN DEFINITIONS -----------------
# Mix-In definitions are auto-generated by mixin-update
##############################################################
# Source: device/intel/mixins/groups/variants/false/AndroidBoard.mk
##############################################################
# flashfile_add_blob <blob_name> <path> <mandatory> <var_name>
# - Delete ::variant:: from <path>
# - If the result does not exists and <mandatory> is set, error
# - If <var_name> is set, put the result in <var_name>
# - Add the pair <result>:<blob_name> in BOARD_FLASHFILES_FIRMWARE
define flashfile_add_blob
$(eval blob := $(subst ::variant::,,$(2))) \
$(if $(wildcard $(blob)), \
    $(if $(4), $(eval $(4) := $(blob))) \
    $(eval BOARD_FLASHFILES_FIRMWARE += $(blob):$(1)) \
    , \
    $(if $(3), $(error $(blob) does not exist)))
endef

##############################################################
# Source: device/intel/mixins/groups/boot-arch/efi/AndroidBoard.mk.1
##############################################################
GPT_INI2BIN := ./$(INTEL_PATH_COMMON)/gpt_bin/gpt_ini2bin.py

$(BOARD_GPT_BIN): $(BOARD_GPT_INI)
	$(hide) $(GPT_INI2BIN) $< > $@
	$(hide) echo GEN $(notdir $@)
##############################################################
# Source: device/intel/mixins/groups/boot-arch/efi/AndroidBoard.mk
##############################################################
# Rules to create bootloader zip file, a precursor to the bootloader
# image that is stored in the target-files-package. There's also
# metadata file which indicates how large to make the VFAT filesystem
# image

ifeq ($(TARGET_UEFI_ARCH),i386)
efi_default_name := bootia32.efi
LOADER_TYPE := linux-x86
else
efi_default_name := bootx64.efi
LOADER_TYPE := linux-x86_64
endif

# (pulled from build/core/Makefile as this gets defined much later)
# Pick a reasonable string to use to identify files.
ifneq "" "$(filter eng.%,$(BUILD_NUMBER))"
# BUILD_NUMBER has a timestamp in it, which means that
# it will change every time.  Pick a stable value.
FILE_NAME_TAG := eng.$(USER)
else
FILE_NAME_TAG := $(BUILD_NUMBER)
endif

BOARD_FIRST_STAGE_LOADER := $(PRODUCT_OUT)/efi/kernelflinger.efi
BOARD_EXTRA_EFI_MODULES :=

$(call flashfile_add_blob,capsule.fv,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/capsule.fv,,BOARD_SFU_UPDATE)
$(call flashfile_add_blob,ifwi.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/ifwi.bin,,EFI_IFWI_BIN)
$(call flashfile_add_blob,ifwi_dnx.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/ifwi_dnx.bin,,EFI_IFWI_DNX_BIN)
$(call flashfile_add_blob,firmware.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/emmc.bin,,EFI_EMMC_BIN)
$(call flashfile_add_blob,afu.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/afu.bin,,EFI_AFU_BIN)
$(call flashfile_add_blob,dnxp_0x1.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/dnxp_0x1.bin,,DNXP_BIN)
$(call flashfile_add_blob,cfgpart.xml,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/cfgpart.xml,,CFGPART_XML)
$(call flashfile_add_blob,cse_spi.bin,$(INTEL_PATH_HARDWARE)/fw_capsules/cel_apl/::variant::/$(BIOS_VARIANT)/cse_spi.bin,,CSE_SPI_BIN)


ifneq ($(EFI_IFWI_BIN),)
$(call dist-for-goals,droidcore,$(EFI_IFWI_BIN):$(TARGET_PRODUCT)-ifwi-$(FILE_NAME_TAG).bin)
endif

ifneq ($(EFI_IFWI_DNX_BIN),)
$(call dist-for-goals,droidcore,$(EFI_IFWI_DNX_BIN):$(TARGET_PRODUCT)-ifwi_dnx-$(FILE_NAME_TAG).bin)
endif

ifneq ($(EFI_AFU_BIN),)
$(call dist-for-goals,droidcore,$(EFI_AFU_BIN):$(TARGET_PRODUCT)-afu-$(FILE_NAME_TAG).bin)
endif

ifneq ($(BOARD_SFU_UPDATE),)
$(call dist-for-goals,droidcore,$(BOARD_SFU_UPDATE):$(TARGET_PRODUCT)-sfu-$(FILE_NAME_TAG).fv)
endif

ifneq ($(CALLED_FROM_SETUP),true)
ifeq ($(wildcard $(BOARD_SFU_UPDATE)),)
$(warning BOARD_SFU_UPDATE not found, OTA updates will not provide a firmware capsule)
endif
ifeq ($(wildcard $(EFI_EMMC_BIN)),)
$(warning EFI_EMMC_BIN not found, flashfiles will not include 2nd stage EMMC firmware)
endif
ifeq ($(wildcard $(EFI_IFWI_BIN)),)
$(warning EFI_IFWI_BIN not found, IFWI binary will not be provided in out/dist/)
endif
ifeq ($(wildcard $(EFI_AFU_BIN)),)
$(warning EFI_AFU_BIN not found, AFU IFWI binary will not be provided in out/dist/)
endif
endif

# We stash a copy of BIOSUPDATE.fv so the FW sees it, applies the
# update, and deletes the file. Follows Google's desire to update all
# bootloader pieces with a single "fastboot flash bootloader" command.
# Since it gets deleted we can't do incremental updates of it, we keep
# a copy as capsules/current.fv for this purpose.
intermediates := $(call intermediates-dir-for,PACKAGING,bootloader_zip)
bootloader_zip := $(intermediates)/bootloader.zip
$(bootloader_zip): intermediates := $(intermediates)
$(bootloader_zip): efi_root := $(intermediates)/root
$(bootloader_zip): \
		$(TARGET_DEVICE_DIR)/AndroidBoard.mk \
		$(BOARD_FIRST_STAGE_LOADER) \
		$(BOARD_EXTRA_EFI_MODULES) \
		$(BOARD_SFU_UPDATE) \
		| $(ACP) \

	$(hide) rm -rf $(efi_root)
	$(hide) rm -f $@
	$(hide) mkdir -p $(efi_root)/capsules
	$(hide) mkdir -p $(efi_root)/EFI/BOOT
	$(foreach EXTRA,$(BOARD_EXTRA_EFI_MODULES), \
		$(hide) $(ACP) $(EXTRA) $(efi_root)/)
ifneq ($(BOARD_SFU_UPDATE),)
	$(hide) $(ACP) $(BOARD_SFU_UPDATE) $(efi_root)/BIOSUPDATE.fv
	$(hide) $(ACP) $(BOARD_SFU_UPDATE) $(efi_root)/capsules/current.fv
endif
	$(hide) $(ACP) $(BOARD_FIRST_STAGE_LOADER) $(efi_root)/loader.efi
	$(hide) $(ACP) $(BOARD_FIRST_STAGE_LOADER) $(efi_root)/EFI/BOOT/$(efi_default_name)
	$(hide) echo "Android-IA=\\EFI\\BOOT\\$(efi_default_name)" > $(efi_root)/manifest.txt
	$(hide) (cd $(efi_root) && zip -qry ../$(notdir $@) .)

bootloader_info := $(intermediates)/bootloader_image_info.txt
$(bootloader_info):
	$(hide) mkdir -p $(dir $@)
	$(hide) echo "size=$(BOARD_BOOTLOADER_PARTITION_SIZE)" > $@
	$(hide) echo "block_size=$(BOARD_BOOTLOADER_BLOCK_SIZE)" >> $@

INSTALLED_RADIOIMAGE_TARGET += $(bootloader_zip) $(bootloader_info)

# Rule to create $(OUT)/bootloader image, binaries within are signed with
# testing keys

bootloader_bin := $(PRODUCT_OUT)/bootloader
$(bootloader_bin): \
		$(bootloader_zip) \
		$(IMG2SIMG) \
		$(BOOTLOADER_ADDITIONAL_DEPS) \
		$(INTEL_PATH_BUILD)/bootloader_from_zip \

	$(hide) $(INTEL_PATH_BUILD)/bootloader_from_zip \
		--size $(BOARD_BOOTLOADER_PARTITION_SIZE) \
		--block-size $(BOARD_BOOTLOADER_BLOCK_SIZE) \
		$(BOOTLOADER_ADDITIONAL_ARGS) \
		--zipfile $(bootloader_zip) \
		$@

droidcore: $(bootloader_bin)

.PHONY: bootloader
bootloader: $(bootloader_bin)
$(call dist-for-goals,droidcore,$(bootloader_bin):$(TARGET_PRODUCT)-bootloader-$(FILE_NAME_TAG))

$(call dist-for-goals,droidcore,$(INTEL_PATH_BUILD)/testkeys/testkeys_lockdown.txt:test-keys_efi_lockdown.txt)
$(call dist-for-goals,droidcore,$(INTEL_PATH_BUILD)/testkeys/unlock.txt:efi_unlock.txt)

##############################################################
# Source: device/intel/mixins/groups/wlan/iwlwifi/AndroidBoard.mk
##############################################################
LOCAL_KERNEL_PATH := $(abspath $(PRODUCT_OUT)/obj/kernel) is not defined yet
$(abspath $(PRODUCT_OUT)/obj/kernel)/copy_modules: iwlwifi

LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/wlan/load_iwlwifi.in
##############################################################
# Source: device/intel/mixins/groups/kernel/gmin64/AndroidBoard.mk
##############################################################
ifeq ($(TARGET_PREBUILT_KERNEL),)

LOCAL_KERNEL_PATH := $(abspath $(PRODUCT_OUT)/obj/kernel)
KERNEL_INSTALL_MOD_PATH := .
LOCAL_KERNEL := $(LOCAL_KERNEL_PATH)/arch/x86/boot/bzImage
LOCAL_KERNEL_MODULE_TREE_PATH := $(LOCAL_KERNEL_PATH)/lib/modules
KERNELRELEASE := $(shell cat $(LOCAL_KERNEL_PATH)/include/config/kernel.release)

KERNEL_CCACHE := $(realpath $(CC_WRAPPER))

#remove time_macros from ccache options, it breaks signing process
KERNEL_CCSLOP := $(filter-out time_macros,$(subst $(comma), ,$(CCACHE_SLOPPINESS)))
KERNEL_CCSLOP := $(subst $(space),$(comma),$(KERNEL_CCSLOP))


ifeq ($(DEV_BKC_KERNEL), true)
  LOCAL_KERNEL_SRC := 
  KERNEL_CONFIG_PATH := 
  EXT_MODULES := 
  DEBUG_MODULES := 
else
  LOCAL_KERNEL_SRC := kernel/4.14
  EXT_MODULES := 
  DEBUG_MODULES := 
  KERNEL_CONFIG_PATH := kernel/config-lts/v4.14/kbl/android
endif

EXTMOD_SRC := ../modules
EXTERNAL_MODULES := $(EXT_MODULES)

KERNEL_DEFCONFIG := $(KERNEL_CONFIG_PATH)/$(TARGET_KERNEL_ARCH)_defconfig
ifneq ($(TARGET_BUILD_VARIANT), user)
  KERNEL_DEBUG_DIFFCONFIG += $(wildcard $(KERNEL_CONFIG_PATH)/debug_diffconfig)
  ifneq ($(KERNEL_DEBUG_DIFFCONFIG),)
    KERNEL_DIFFCONFIG += $(KERNEL_DEBUG_DIFFCONFIG)
  else
    KERNEL_DEFCONFIG := $(LOCAL_KERNEL_SRC)/arch/x86/configs/$(TARGET_KERNEL_ARCH)_debug_defconfig
  endif
  EXTERNAL_MODULES := $(EXT_MODULES) $(DEBUG_MODULES)
endif # variant not eq user

KERNEL_CONFIG := $(LOCAL_KERNEL_PATH)/.config

ifeq ($(TARGET_BUILD_VARIANT), eng)
  KERNEL_ENG_DIFFCONFIG := $(wildcard $(KERNEL_CONFIG_PATH)/eng_diffconfig)
  ifneq ($(KERNEL_ENG_DIFFCONFIG),)
    KERNEL_DIFFCONFIG += $(KERNEL_ENG_DIFFCONFIG)
  endif
endif

KERNEL_MAKE_OPTIONS = \
    SHELL=/bin/bash \
    -C $(LOCAL_KERNEL_SRC) \
    O=$(LOCAL_KERNEL_PATH) \
    ARCH=$(TARGET_KERNEL_ARCH) \
    INSTALL_MOD_PATH=$(KERNEL_INSTALL_MOD_PATH) \
    CROSS_COMPILE="$(KERNEL_CCACHE) $(YOCTO_CROSSCOMPILE)" \
    CCACHE_SLOPPINESS=$(KERNEL_CCSLOP)

KERNEL_MAKE_OPTIONS += \
    EXTRA_FW="$(_EXTRA_FW_)" \
    EXTRA_FW_DIR="$(abspath $(PRODUCT_OUT)/vendor/firmware)"

KERNEL_CONFIG_DEPS = $(strip $(KERNEL_DEFCONFIG) $(KERNEL_DIFFCONFIG))
KERNEL_CONFIG_MK := $(LOCAL_KERNEL_PATH)/config.mk
-include $(KERNEL_CONFIG_MK)

ifneq ($(KERNEL_CONFIG_DEPS),$(KERNEL_CONFIG_PREV_DEPS))
.PHONY: $(KERNEL_CONFIG)
endif

CHECK_CONFIG_SCRIPT := $(LOCAL_KERNEL_SRC)/scripts/diffconfig
CHECK_CONFIG_LOG :=  $(LOCAL_KERNEL_PATH)/.config.check

KERNEL_DEPS := $(shell find $(LOCAL_KERNEL_SRC) \( -name *.git -prune \) -o -print )

# Before building final defconfig with debug diffconfigs
# Check that base defconfig is correct. Check is performed
# by comparing generated .config with .config.old
# If differences are observed, display a help message
# and stop kernel build.
# If a .config is already present, save it before processing
# the check and restore it at the end
$(CHECK_CONFIG_LOG): $(KERNEL_DEFCONFIG) $(KERNEL_DEPS)
	$(hide) mkdir -p $(@D)
	-$(hide) [[ -e $(KERNEL_CONFIG) ]] && mv -f $(KERNEL_CONFIG) $(KERNEL_CONFIG).save
	$(hide) cat $< > $(KERNEL_CONFIG)
	$(hide) $(MAKE) $(KERNEL_MAKE_OPTIONS) olddefconfig
	$(hide) $(CHECK_CONFIG_SCRIPT) $(KERNEL_CONFIG).old $(KERNEL_CONFIG) > $@
	-$(hide) [[ -e $(KERNEL_CONFIG).save ]] && mv -f $(KERNEL_CONFIG).save $(KERNEL_CONFIG)
	$(hide) if [[ -s $@ ]] ; then \
	  echo "CHECK KERNEL DEFCONFIG FATAL ERROR :" ; \
	  echo "Kernel config copied from $(KERNEL_DEFCONFIG) has some config issue." ; \
	  echo "Final '.config' and '.config.old' differ. This should never happen." ; \
	  echo "Observed diffs are :" ; \
	  cat $@ ; \
	  echo "Root cause is probably that a dependancy declared in Kconfig is not respected" ; \
	  echo "or config was added in Kconfig but value not explicitly added to defconfig." ; \
	  echo "Recommanded method to generate defconfig is menuconfig tool instead of manual edit." ; \
	  exit 1;  fi;

menuconfig xconfig gconfig: $(CHECK_CONFIG_LOG)
	$(hide) xterm -e $(MAKE) $(KERNEL_MAKE_OPTIONS) $@
	$(hide) cp -f $(KERNEL_CONFIG) $(KERNEL_DEFCONFIG)
	@echo ===========
	@echo $(KERNEL_DEFCONFIG) has been modified !
	@echo ===========

$(KERNEL_CONFIG): $(KERNEL_CONFIG_DEPS) | yoctotoolchain $(CHECK_CONFIG_LOG)
	$(hide) echo "KERNEL_CONFIG_PREV_DEPS := $(KERNEL_CONFIG_DEPS)" > $(KERNEL_CONFIG_MK)
	$(hide) cat $(KERNEL_CONFIG_DEPS) > $@
	@echo "Generating Kernel configuration, using $(KERNEL_CONFIG_DEPS)"
	$(hide) $(MAKE) $(KERNEL_MAKE_OPTIONS) olddefconfig </dev/null

$(PRODUCT_OUT)/kernel: $(LOCAL_KERNEL) $(LOCAL_KERNEL_PATH)/copy_modules
	$(hide) cp $(LOCAL_KERNEL) $@

# kernel modules must be copied before vendorimage is generated
$(PRODUCT_OUT)/vendor.img: $(LOCAL_KERNEL_PATH)/copy_modules

# Copy modules in directory pointed by $(KERNEL_MODULES_ROOT)
# First copy modules keeping directory hierarchy lib/modules/`uname-r`for libkmod
# Second, create flat hierarchy for insmod linking to previous hierarchy
$(LOCAL_KERNEL_PATH)/copy_modules: $(LOCAL_KERNEL)
	@echo Copy modules from $(LOCAL_KERNEL_PATH)/lib/modules/$(KERNELRELEASE) into $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) rm -rf $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) rm -rf $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) mkdir -p $(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) cd $(LOCAL_KERNEL_PATH)/lib/modules/$(KERNELRELEASE) && for f in `find . -name '*.ko' -or -name 'modules.*'`; do \
		cp $$f $(PWD)/$(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)/$$(basename $$f) || exit 1; \
		mkdir -p $(PWD)/$(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)/$(KERNELRELEASE)/$$(dirname $$f) ; \
		ln -s /$(KERNEL_MODULES_ROOT_PATH)/$$(basename $$f) $(PWD)/$(PRODUCT_OUT)/$(KERNEL_MODULES_ROOT)/$(KERNELRELEASE)/$$f || exit 1; \
		done
	$(hide) touch $@
#usb-init for recovery
	$(hide) mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)
	$(hide) for f in dwc3.ko dwc3-pci.ko xhci-hcd.ko xhci-pci.ko; do \
		find $(LOCAL_KERNEL_PATH)/lib/modules/ -name $$f -exec cp {} $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)/ \; ;\
		done
#mei for recovery
	$(hide) for f in mei.ko mei-me.ko; do \
		find $(LOCAL_KERNEL_PATH)/lib/modules/ -name $$f -exec cp {} $(TARGET_RECOVERY_ROOT_OUT)/$(KERNEL_MODULES_ROOT)/ \; ;\
		done

$(LOCAL_KERNEL): $(MINIGZIP) $(KERNEL_CONFIG) $(BOARD_DTB) $(KERNEL_DEPS) | yoctotoolchain
	$(MAKE) $(KERNEL_MAKE_OPTIONS)
	$(MAKE) $(KERNEL_MAKE_OPTIONS) modules
	$(MAKE) $(KERNEL_MAKE_OPTIONS) INSTALL_MOD_STRIP=1 modules_install


# disable the modules built in parallel due to some modules symbols has dependency,
# and module install depmod need they be installed one at a time.

PREVIOUS_KERNEL_MODULE := $(LOCAL_KERNEL)

define bld_external_module

$(eval MODULE_DEPS_$(2) := $(shell find kernel/modules/$(1) \( -name *.git -prune \) -o -print ))

$(LOCAL_KERNEL_PATH)/build_$(2): $(LOCAL_KERNEL) $(MODULE_DEPS_$(2)) $(PREVIOUS_KERNEL_MODULE)
	@echo BUILDING $(1)
	@mkdir -p $(LOCAL_KERNEL_PATH)/../modules/$(1)
	$(hide) $(MAKE) $$(KERNEL_MAKE_OPTIONS) M=$(EXTMOD_SRC)/$(1) V=1 $(ADDITIONAL_ARGS_$(subst /,_,$(1))) modules
	@touch $$(@)

$(LOCAL_KERNEL_PATH)/install_$(2): $(LOCAL_KERNEL_PATH)/build_$(2) $(PREVIOUS_KERNEL_MODULE)
	@echo INSTALLING $(1)
	$(hide) $(MAKE) $$(KERNEL_MAKE_OPTIONS) M=$(EXTMOD_SRC)/$(1) INSTALL_MOD_STRIP=1 modules_install
	@touch $$(@)

$(LOCAL_KERNEL_PATH)/copy_modules: $(LOCAL_KERNEL_PATH)/install_$(2)

$(eval PREVIOUS_KERNEL_MODULE := $(LOCAL_KERNEL_PATH)/install_$(2))
endef


$(foreach m,$(EXTERNAL_MODULES),$(eval $(call bld_external_module,$(m),$(subst /,_,$(m)))))



# Add a kernel target, so "make kernel" will build the kernel
.PHONY: kernel
kernel: $(LOCAL_KERNEL_PATH)/copy_modules $(PRODUCT_OUT)/kernel


endif
##############################################################
# Source: device/intel/mixins/groups/sepolicy/permissive/AndroidBoard.mk
##############################################################
include $(CLEAR_VARS)
LOCAL_MODULE := sepolicy-areq-checker
LOCAL_REQUIRED_MODULES := sepolicy

#
# On user builds, enforce that open tickets are considered violations.
#
ifeq ($(TARGET_BUILD_VARIANT),user)
LOCAL_USER_OPTIONS := -i
endif

LOCAL_POST_INSTALL_CMD := $(INTEL_PATH_SEPOLICY)/tools/capchecker $(LOCAL_USER_OPTIONS) -p $(INTEL_PATH_SEPOLICY)/tools/caps.conf $(TARGET_ROOT_OUT)/sepolicy

include $(BUILD_PHONY_PACKAGE)
##############################################################
# Source: device/intel/mixins/groups/graphics/mesa/AndroidBoard.mk
##############################################################
##############################################################
# Source: device/intel/mixins/groups/vendor-partition/true/AndroidBoard.mk
##############################################################
include $(CLEAR_VARS)
LOCAL_MODULE := vendor-partition
LOCAL_REQUIRED_MODULES := toybox_static
include $(BUILD_PHONY_PACKAGE)
##############################################################
# Source: device/intel/mixins/groups/trusty/true/AndroidBoard.mk
##############################################################
.PHONY: lk evmm tosimage multiboot

LOCAL_MAKE := make

lk:
	@echo "making lk.elf.."
	$(hide) (cd $(TOPDIR)trusty && $(TRUSTY_ENV_VAR) $(LOCAL_MAKE) sand-x86-64)

evmm: yoctotoolchain
	@echo "making evmm.."
	$(hide) (cd $(TOPDIR)$(INTEL_PATH_VENDOR)/fw/evmm && $(TRUSTY_ENV_VAR) $(LOCAL_MAKE))

# include sub-makefile according to boot_arch
include $(TARGET_DEVICE_DIR)/extra_files/trusty/trusty_efi.mk

LOAD_MODULES_H_IN += $(TARGET_DEVICE_DIR)/extra_files/trusty/load_trusty_modules.in
##############################################################
# Source: device/intel/mixins/groups/flashfiles/ini/AndroidBoard.mk
##############################################################
ff_intermediates := $(call intermediates-dir-for,PACKAGING,flashfiles)

# We need a copy of the flashfiles configuration ini in the
# TFP RADIO/ directory
ff_config := $(ff_intermediates)/flashfiles.ini
$(ff_config): $(FLASHFILES_CONFIG) | $(ACP)
	$(copy-file-to-target)

$(call add_variant_flashfiles,$(ff_intermediates))

INSTALLED_RADIOIMAGE_TARGET += $(ff_config)


$(call flashfile_add_blob,extra_script.edify,$(TARGET_DEVICE_DIR)/flashfiles/::variant::/extra_script.edify)

# We take any required images that can't be derived elsewhere in
# the TFP and put them in RADIO/provdata.zip.
ff_intermediates := $(call intermediates-dir-for,PACKAGING,flashfiles)
provdata_zip := $(ff_intermediates)/provdata.zip
provdata_zip_deps := $(foreach pair,$(BOARD_FLASHFILES),$(call word-colon,1,$(pair)))
ff_root := $(ff_intermediates)/root

define copy-flashfile
$(hide) $(ACP) -fp $(1) $(2)

endef

define deploy_provdata
$(eval ff_var := $(subst provdata,,$(basename $(notdir $(1)))))
$(hide) rm -f $(1)
$(hide) rm -rf $(ff_intermediates)/root$(ff_var)
$(hide) mkdir -p $(ff_intermediates)/root$(ff_var)
$(foreach pair,$(BOARD_FLASHFILES$(ff_var)), \
	$(call copy-flashfile,$(call word-colon,1,$(pair)),$(ff_intermediates)/root$(ff_var)/$(call word-colon,2,$(pair))))
$(hide) zip -qj $(1) $(ff_intermediates)/root$(ff_var)/*
endef

ifneq ($(FLASHFILE_VARIANTS),)
provdata_zip :=
$(foreach var,$(FLASHFILE_VARIANTS), \
	$(eval provdata_zip += $(ff_intermediates)/provdata_$(var).zip) \
	$(eval BOARD_FLASHFILES_$(var) := $(BOARD_FLASHFILES)) \
	$(eval BOARD_FLASHFILES_$(var) += $(BOARD_FLASHFILES_FIRMWARE_$(var))) \
	$(eval provdata_zip_deps += $(foreach pair,$(BOARD_FLASHFILES_FIRMWARE_$(var)),$(call word-colon,1,$(pair)))))
else
$(eval BOARD_FLASHFILES += $(BOARD_FLASHFILES_FIRMWARE))
$(eval provdata_zip_deps += $(foreach pair,$(BOARD_FLASHFILES_FIRMWARE),$(call word-colon,1,$(pair))))
endif

$(provdata_zip): $(provdata_zip_deps) | $(ACP)
	$(call deploy_provdata,$@)


INSTALLED_RADIOIMAGE_TARGET += $(provdata_zip)

##############################################################
# Source: device/intel/mixins/groups/usb-audio-init/true/AndroidBoard.mk
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/usb-audio-init/load_usbaudio_modules.in
##############################################################
# Source: device/intel/mixins/groups/bluetooth/btusb/AndroidBoard.mk
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/bluetooth/load_bt.in
##############################################################
# Source: device/intel/mixins/groups/config-partition/true/AndroidBoard.mk
##############################################################
INSTALLED_CONFIGIMAGE_TARGET := $(PRODUCT_OUT)/config.img

selinux_fc := $(TARGET_ROOT_OUT)/file_contexts.bin

$(INSTALLED_CONFIGIMAGE_TARGET) : PRIVATE_SELINUX_FC := $(selinux_fc)
$(INSTALLED_CONFIGIMAGE_TARGET) : $(MKEXTUSERIMG) $(MAKE_EXT4FS) $(E2FSCK) $(selinux_fc)
	$(call pretty,"Target config fs image: $(INSTALLED_CONFIGIMAGE_TARGET)")
	@mkdir -p $(PRODUCT_OUT)/config
	$(hide)	PATH=$(HOST_OUT_EXECUTABLES):$$PATH \
		$(MKEXTUSERIMG) -s \
		$(PRODUCT_OUT)/config \
		$(PRODUCT_OUT)/config.img \
		ext4 \
		oem_config \
		$(BOARD_CONFIGIMAGE_PARTITION_SIZE) \
		$(PRIVATE_SELINUX_FC)

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_CONFIGIMAGE_TARGET)

selinux_fc :=
##############################################################
# Source: device/intel/mixins/groups/ethernet/dhcp/AndroidBoard.mk
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/ethernet/load_eth_modules.in
##############################################################
# Source: device/intel/mixins/groups/audio/bxtp-mrb/AndroidBoard.mk.1
##############################################################
# parameter-framework audio files
include $(TARGET_DEVICE_DIR)/audio/parameter-framework/AndroidBoard.mk

# Audio DFW (Dynamic Firmware)
include $(TARGET_DEVICE_DIR)/audio/libfwdt/AndroidBoard.mk

##################################################
# Audio policy files

include $(CLEAR_VARS)
LOCAL_MODULE := meta.audio_policy_configuration.default
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES := \
    audio_policy_volumes.xml \
    default_volume_tables.xml \
    r_submix_audio_policy_configuration.xml \
    usb_audio_policy_configuration.xml \
    a2dp_audio_policy_configuration.xml
include $(BUILD_PHONY_PACKAGE)

##################################################
# The audio meta package

include $(CLEAR_VARS)
LOCAL_MODULE := meta.package.audio
LOCAL_MODULE_TAGS := optional

LOCAL_REQUIRED_MODULES := \
    audio_hal_configurable \
    meta.audio_policy_configuration.default \
    parameter-framework.audio.broxton \
    parameter-framework.route.broxton \
    audio.r_submix.default \
    audio.usb.default \
    dsp_fw_bxtp_release.bin \
    dsp_fw_bxtp_release_k44.bin \
    dsp_lib_fdk_amp.bin \
    dfw_sst_bxtp.bin \
    sspGpMrbAmp4ch.blob \
    sspGpMrbTuner.blob \
    sspGpMrbModem.blob \
    dirana_config.sh \
    sspGpMrbBtHfp.blob \
    LIBASRC.bin \
    5a98-INTEL-NHLT-GPA-3-tplg.bin

include $(BUILD_PHONY_PACKAGE)

LOAD_MODULES_H_IN += $(TARGET_DEVICE_DIR)/extra_files/audio/load_audio_modules.in

##############################################################
# Source: device/intel/mixins/groups/device-type/car/AndroidBoard.mk
##############################################################
# Car device required kernel diff config
KERNEL_CAR_DIFFCONFIG = $(wildcard $(KERNEL_CONFIG_PATH)/car_diffconfig)
KERNEL_DIFFCONFIG += $(KERNEL_CAR_DIFFCONFIG)
##############################################################
# Source: device/intel/mixins/groups/security/cse/AndroidBoard.mk
##############################################################
LOAD_MODULES_IN += $(TARGET_DEVICE_DIR)/extra_files/security/load_mei_modules.in
##############################################################
# Source: device/intel/mixins/groups/load_modules/default/AndroidBoard.mk
##############################################################
include $(CLEAR_VARS)
LOCAL_MODULE := load_modules.sh
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := intel
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC := $(LOAD_MODULES_H_IN) $(LOAD_MODULES_IN)
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE): $(LOCAL_SRC)
	$(hide) mkdir -p "$(dir $@)"
	echo "#!/system/bin/sh" > $@
	echo "modules=\`getprop ro.boot.moduleslocation\`" >> $@
	cat $(LOAD_MODULES_H_IN) >> $@
	echo wait >> $@
	cat $(LOAD_MODULES_IN) >> $@
##############################################################
# Source: device/intel/mixins/groups/mixin-check/default/AndroidBoard.mk
##############################################################
mixin_update := $(wildcard device/intel/mixins/mixin-update)

ifeq ($(mixin_update),)
mixin_update := $(wildcard $(TARGET_DEVICE_DIR)/mixins/mixin-update)
endif

ifneq ($(mixin_update),)

.PHONY: check-mixins
check-mixins:
	$(mixin_update) --dry-run -s $(TARGET_DEVICE_DIR)/mixins.spec

droidcore: check-mixins
flashfiles: check-mixins

endif

# ------------------ END MIX-IN DEFINITIONS ------------------
