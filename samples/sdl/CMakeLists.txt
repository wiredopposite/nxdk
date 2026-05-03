add_executable(sdl
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(sdl 
    PRIVATE
        nxdk_core
        nxdk_sdl
)

nxdk_generate_xbe(sdl)
nxdk_generate_xiso(sdl)