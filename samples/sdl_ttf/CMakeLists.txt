add_executable(sdl_ttf
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(sdl_ttf 
    PRIVATE
        nxdk_core
        nxdk_sdl
)

nxdk_add_assets(sdl_ttf
    FILES 
        ${CMAKE_CURRENT_LIST_DIR}/vegur-regular.ttf
)

nxdk_generate_xbe(sdl_ttf)
nxdk_generate_xiso(sdl_ttf)