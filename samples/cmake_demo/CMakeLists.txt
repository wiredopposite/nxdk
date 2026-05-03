set(_DISC_NAME "CMake Demo")
set(_DEFAULT_XBE_TARGET "cmakedemo")
set(_CHILD_XBE_TARGET "cmakedemo_child")
set(_TTF_PATH "D:\\assets\\vegur-regular.ttf")

# Main executable

add_executable(${_DEFAULT_XBE_TARGET}
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(${_DEFAULT_XBE_TARGET}
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(${_DEFAULT_XBE_TARGET}
    DISC ${_DISC_NAME}
    PATH "default.xbe"
)

# Child executable

add_executable(${_CHILD_XBE_TARGET}
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(${_CHILD_XBE_TARGET}
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(${_CHILD_XBE_TARGET}
    DISC ${_DISC_NAME}
    PATH "child.xbe"
)

# Disc level commands
# target is provided to ensure commands are
# bound to an executable and run post build, 
# but are not otherwise relevant.

nxdk_generate_xiso(${_DEFAULT_XBE_TARGET}
    DISC ${_DISC_NAME}
)