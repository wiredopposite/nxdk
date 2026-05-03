add_executable(xaudio
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(xaudio 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(xaudio)
nxdk_generate_xiso(xaudio)