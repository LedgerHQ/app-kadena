#*******************************************************************************
#*   (c) 2019 - 2024 Zondax AG
#*
#*  Licensed under the Apache License, Version 2.0 (the "License");
#*  you may not use this file except in compliance with the License.
#*  You may obtain a copy of the License at
#*
#*      http://www.apache.org/licenses/LICENSE-2.0
#*
#*  Unless required by applicable law or agreed to in writing, software
#*  distributed under the License is distributed on an "AS IS" BASIS,
#*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#*  See the License for the specific language governing permissions and
#*  limitations under the License.
#********************************************************************************

# We use BOLOS_SDK to determine the development environment that is being used
# BOLOS_SDK IS  DEFINED	 	We use the plain Makefile for Ledger
# BOLOS_SDK NOT DEFINED		We use a containerized build approach

# TESTS_JS_PACKAGE = "@zondax/ledger-kadena"
# TESTS_JS_DIR = $(CURDIR)/../ledger-kadena-js

ifeq ($(BOLOS_SDK),)
# In this case, there is not predefined SDK and we run dockerized
# When not using the SDK, we override and build the XL complete app

PRODUCTION_BUILD ?= 1
SKIP_NANOS = 1

ifeq ($(SKIP_NANOS), 0)
$(error "NanoS device is not supported")
endif

include $(CURDIR)/deps/ledger-zxlib/dockerized_build.mk

else
default:
	$(MAKE) -C app
%:
	$(info "Calling app Makefile for target $@")
	COIN=$(COIN) $(MAKE) -C app $@
endif

test_all:
	make zemu_install
	make
	make zemu_test

test_ledger_try:
	make zemu_install
	cd tests_zemu && yarn try

test_ledger_try_legacy:
	make zemu_install
	cd tests_zemu && yarn try_legacy