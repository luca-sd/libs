#
# Copyright (C) 2021 The Falco Authors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#

option(USE_BUNDLED_LIBBPF "Enable building of the bundled libbpf"
  ${USE_BUNDLED_DEPS})

if (CMAKE_SYSTEM_NAME MATCHES "Linux")
  if (NOT USE_BUNDLED_LIBBPF)
    find_path(LIBBPF_INCLUDE bpf/libbpf.h)
    find_library(LIBBPF_LIB NAMES bpf)
    if (LIBBPF_INCLUDE AND LIBBPF_LIB)
      message(
        STATUS "Found libbpf: include: ${LIBBPF_INCLUDE}, lib: ${LIBBPF_LIB}")
    else ()
      message(FATAL_ERROR "Couldn't find system libbpf")
    endif ()
  else ()

    set(LIBBPF_SRC "${CMAKE_CURRENT_BINARY_DIR}/libbpf-prefix/src")
    set(LIBBPF_BUILD_DIR "${LIBBPF_SRC}/libbpf-build")
    set(LIBBPF_INCLUDE "${LIBBPF_BUILD_DIR}/root/usr/include")
    set(LIBBPF_LIB "${LIBBPF_BUILD_DIR}/root/usr/lib64/libbpf.a")
    ExternalProject_Add(
      libbpf
      URL "https://github.com/libbpf/libbpf/archive/a199b854156ccac574eb031d464d8fd1a5523ce2.tar.gz"
      URL_HASH
      "SHA256=9519fb0df06db85484ce934adf7a4b0ea9363c9496a2b427acdd03a0a9d9348d"
      CONFIGURE_COMMAND mkdir -p build root
      BUILD_COMMAND PKG_CONFIG_PATH=${ZLIB_SRC} BUILD_STATIC_ONLY=y OBJDIR=${LIBBPF_BUILD_DIR}/build DESTDIR=${LIBBPF_BUILD_DIR}/root make -C ${LIBBPF_SRC}/libbpf/src install
      INSTALL_COMMAND "")

    message(STATUS "Using bundled libbpf: include'${LIBBPF_INCLUDE}', lib: ${LIBBPF_LIB}")
  endif ()
endif ()
