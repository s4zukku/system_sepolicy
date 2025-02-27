# Command to turn collection of policy files into a policy.conf file to be
# processed by checkpolicy
define transform-policy-to-conf
@mkdir -p $(dir $@)
$(hide) $(M4) --fatal-warnings $(PRIVATE_ADDITIONAL_M4DEFS) \
	-D mls_num_sens=$(PRIVATE_MLS_SENS) -D mls_num_cats=$(PRIVATE_MLS_CATS) \
	-D target_build_variant=$(PRIVATE_TARGET_BUILD_VARIANT) \
	-D target_with_dexpreopt=$(WITH_DEXPREOPT) \
	-D target_arch=$(PRIVATE_TGT_ARCH) \
	-D target_with_asan=$(PRIVATE_TGT_WITH_ASAN) \
	-D target_with_native_coverage=$(PRIVATE_TGT_WITH_NATIVE_COVERAGE) \
	-D target_full_treble=$(PRIVATE_SEPOLICY_SPLIT) \
	-D target_compatible_property=$(PRIVATE_COMPATIBLE_PROPERTY) \
	-D target_treble_sysprop_neverallow=$(PRIVATE_TREBLE_SYSPROP_NEVERALLOW) \
	-D target_enforce_sysprop_owner=$(PRIVATE_ENFORCE_SYSPROP_OWNER) \
	-D target_exclude_build_test=$(PRIVATE_EXCLUDE_BUILD_TEST) \
	-D target_requires_insecure_execmem_for_swiftshader=$(PRODUCT_REQUIRES_INSECURE_EXECMEM_FOR_SWIFTSHADER) \
	$(PRIVATE_TGT_RECOVERY) \
	-s $(PRIVATE_POLICY_FILES) > $@
endef
.KATI_READONLY := transform-policy-to-conf

###########################################################
## Collect file_contexts files into a single tmp file with m4
##
## $(1): list of file_contexts files
## $(2): filename into which file_contexts files are merged
###########################################################

define _merge-fc-files
$(2): $(1) $(M4)
	$(hide) mkdir -p $$(dir $$@)
	$(hide) $(M4) --fatal-warnings -s $(1) > $$@
endef

define merge-fc-files
$(eval $(call _merge-fc-files,$(1),$(2)))
endef
