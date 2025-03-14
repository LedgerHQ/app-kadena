#*******************************************************************************
#  Ledger App
#  (c) 2018 - 2024 Zondax AG
#  (c) 2017 Ledger
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

ifeq ($(BOLOS_SDK),)
$(error BOLOS_SDK is not set)
endif

MY_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Set the default value for PRODUCTION_BUILD to 0 if not already defined
PRODUCTION_BUILD ?= 1

# Display whether this is a production build or for internal use
ifeq ($(PRODUCTION_BUILD), 1)
    $(info ************ PRODUCTION_BUILD  = [PRODUCTION BUILD])
else
    $(info ************ PRODUCTION_BUILD  = [INTERNAL USE])
endif

# Display whether swap functionality is enabled or not
ifeq ($(ENABLE_SWAP), 1)
    $(info ************ HAVE_SWAP  = [ENABLED])
else
    $(info ************ HAVE_SWAP  = [DISABLED])
endif

# Add the PRODUCTION_BUILD definition to the compiler flags
DEFINES += APP_BLINDSIGN_MODE_ENABLED
DEFINES += PRODUCTION_BUILD=$(PRODUCTION_BUILD)

include $(CURDIR)/../deps/ledger-zxlib/makefiles/Makefile.app_testing

ifndef COIN
COIN=kadena
endif

VARIANT_PARAM=COIN
VARIANT_VALUES=$(COIN)

include $(CURDIR)/Makefile.version

$(info COIN  = [$(COIN)])

ifeq ($(COIN),kadena)
# Main app configuration
APPNAME = "Kadena"
APPPATH = "44'/626'"

else
define error_message

COIN value not supported: [$(COIN)]

endef
$(error "$(error_message)")
endif

$(info PATHS LIST = $(APPPATH))

APP_LOAD_PARAMS =  --curve ed25519 --delete $(COMMON_LOAD_PARAMS) --path $(APPPATH)

# DEFINES += BLAKE3_NO_SSE2 BLAKE3_NO_SSE41 BLAKE3_NO_AVX2 BLAKE3_NO_AVX512 BLAKE3_USE_NEON=0
# BLAKE3_DIR := $(CURDIR)/../deps/BLAKE3-c
# INCLUDES_PATH += $(BLAKE3_DIR)
# APP_SOURCE_FILES += $(BLAKE3_DIR)/blake3.c $(BLAKE3_DIR)/blake3_dispatch.c $(BLAKE3_DIR)/blake3_portable.c

include $(BOLOS_SDK)/Makefile.target

include $(CURDIR)/../deps/ledger-zxlib/makefiles/Makefile.devices

include $(CURDIR)/../deps/ledger-zxlib/makefiles/Makefile.platform

CFLAGS += -Wvla
# LDFLAGS += -z muldefs
# LDLIBS += -Lrust/target/thumbv6m-none-eabi/release -lrslib
# APP_SOURCE_PATH += $(CURDIR)/rust/include

include $(CURDIR)/../deps/ledger-zxlib/makefiles/Makefile.installer_script

$(info TARGET_NAME  = [$(TARGET_NAME)])
$(info ICONNAME  = [$(ICONNAME)])

ifndef ICONNAME
$(error ICONNAME is not set)
endif


.PHONY: rust
rust:
	@echo "No rust code"

# Before linking, we need to be sure rust lib is there
bin/app.elf: rust

.PHONY: rust_clean
rust_clean:
	@echo "No rust code"

clean: rust_clean

# .PHONY: rust
# rust:
# 	cd rust && CARGO_HOME="$(CURDIR)/rust/.cargo" cargo build --target thumbv6m-none-eabi --release

# # Before linking, we need to be sure rust lib is there
# bin/app.elf: rust

# .PHONY: rust_clean
# rust_clean:
# 	cd rust && CARGO_HOME="$(CURDIR)/rust/.cargo" cargo clean

# clean: rust_clean

#add dependency on custom makefile filename
dep/%.d: %.c Makefile

.PHONY: version
version:
	@echo "v$(APPVERSION)" > app.version
