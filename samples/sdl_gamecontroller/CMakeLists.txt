add_executable(sdl_gamecontroller
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(sdl_gamecontroller PRIVATE
    nxdk_core
    nxdk_sdl
    nxdk_pbkit
)

nxdk_generate_xbe(sdl_gamecontroller)
nxdk_generate_xiso(sdl_gamecontroller)