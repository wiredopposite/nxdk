if(NOT DEFINED ENV{NXDK_DIR})
    set(ENV{NXDK_DIR} "${CMAKE_CURRENT_LIST_DIR}/..")
endif()

set(NXDK_DIR "$ENV{NXDK_DIR}")

find_program(_CLANG_PATH clang REQUIRED)
find_program(_CLANGPP_PATH clang++ REQUIRED)
find_program(_LLD_PATH lld-link REQUIRED)
find_program(_NINJA_PATH ninja REQUIRED)

set(CMAKE_C_COMPILER "${_CLANG_PATH}")
set(CMAKE_CXX_COMPILER "${_CLANGPP_PATH}")
set(CMAKE_ASM_COMPILER "${_CLANG_PATH}")
set(CMAKE_LINKER "${_LLD_PATH}")
set(CMAKE_C_LINK_EXECUTABLE
    "\"${CMAKE_LINKER}\" <LINK_FLAGS> <CMAKE_C_LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
set(CMAKE_CXX_LINK_EXECUTABLE
    "\"${CMAKE_LINKER}\" <LINK_FLAGS> <CMAKE_CXX_LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
set(CMAKE_ASM_LINK_EXECUTABLE
    "\"${CMAKE_LINKER}\" <LINK_FLAGS> <CMAKE_ASM_LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR i386)
set(TOOLCHAIN_PREFIX nxdk)
set(TOOL_OS_SUFFIX "")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_STATIC_LIBRARY_SUFFIX ".lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX_C ".lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX_CXX ".lib")

set(CMAKE_EXECUTABLE_SUFFIX ".exe")
set(CMAKE_EXECUTABLE_SUFFIX_C ".exe")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".exe")

if(CMAKE_HOST_WIN32)
    set(TOOL_OS_SUFFIX ".exe")
endif()

set(WIN32 1)
set(NXDK 1)

set(NXDK_C_INCLUDES
    ${NXDK_DIR}/lib
    ${NXDK_DIR}/lib/xboxrt/libc_extensions
    ${NXDK_DIR}/lib/pdclib/include
    ${NXDK_DIR}/lib/pdclib/platform/xbox/include
    ${NXDK_DIR}/lib/winapi
    ${NXDK_DIR}/lib/xboxrt/vcruntime
)

set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${NXDK_C_INCLUDES})
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES ${NXDK_DIR}/lib/libcxx/include ${NXDK_C_INCLUDES})
set(CMAKE_ASM_STANDARD_INCLUDE_DIRECTORIES
    ${NXDK_DIR}/lib
    ${NXDK_DIR}/lib/xboxrt
)

set(C_CXX_COMPILER_INIT_FLAGS "\
    -target i386-pc-win32 \
    -march=pentium3 \
    -fuse-ld=nxdk-link \
    -ffreestanding \
    -nostdlib \
    -fno-builtin \
    -Wno-builtin-macro-redefined \
    -DNXDK \
    -DXBOX \
    -D_XBOX \
    -D__STDC__=1 \
    -U__STDC_NO_THREADS__ \
")

set(CMAKE_C_FLAGS_INIT "${C_CXX_COMPILER_INIT_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${C_CXX_COMPILER_INIT_FLAGS} -fno-exceptions")
set(CMAKE_ASM_FLAGS_INIT "\
    -target i386-pc-win32 \
    -march=pentium3 \
    -nostdlib \
")

set(LINKER_INIT_FLAGS "\
    -subsystem:windows \
    -stack:65536 \
    -merge:.edata=.edataxb \
")

set(CMAKE_EXE_LINKER_FLAGS_INIT "${LINKER_INIT_FLAGS} -base:0x00010000 -fixed")
set(CMAKE_MODULE_LINKER_FLAGS_INIT "${LINKER_INIT_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "${LINKER_INIT_FLAGS} -dll")