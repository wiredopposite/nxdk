add_executable(led
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(led 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(led)
nxdk_generate_xiso(led)