set(LWIP_DIR ${CMAKE_CURRENT_LIST_DIR}/lwip)
set(LWIP_EXCLUDE_SLIPIF TRUE)
cmake_policy(PUSH)
cmake_policy(SET CMP0012 NEW)
include(${LWIP_DIR}/src/Filelists.cmake)
cmake_policy(POP)

set(LWIP_SRCS
    ${lwipcore_SRCS}
    ${lwipcore4_SRCS}
    ${lwipcore6_SRCS}
    ${lwipapi_SRCS}
    ${lwipnetif_SRCS}
)

add_library(_nxdk_lwip STATIC
    ${lwipcore_SRCS}
    ${lwipcore4_SRCS}
    ${lwipcore6_SRCS}
    ${lwipapi_SRCS}
    ${lwipnetif_SRCS}
    ${CMAKE_CURRENT_LIST_DIR}/nvnetdrv/nvnetdrv.c
    ${CMAKE_CURRENT_LIST_DIR}/nvnetdrv/nvnetdrv_lwip.c
    ${CMAKE_CURRENT_LIST_DIR}/nforceif/src/sys_arch.c
)

target_include_directories(_nxdk_lwip PUBLIC
    ${LWIP_DIR}/src/include
    ${CMAKE_CURRENT_LIST_DIR}/nforceif/include
    ${CMAKE_CURRENT_LIST_DIR}/nvnetdrv
)

target_link_libraries(_nxdk_lwip PRIVATE nxdk_runtime)