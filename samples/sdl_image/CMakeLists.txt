add_executable(sdl_image
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(sdl_image 
    PRIVATE
        nxdk_core
        nxdk_sdl
)

nxdk_add_assets(sdl_image
    FILES 
        ${CMAKE_CURRENT_LIST_DIR}/testimg.jpg
)

nxdk_generate_xbe(sdl_image)
nxdk_generate_xiso(sdl_image)