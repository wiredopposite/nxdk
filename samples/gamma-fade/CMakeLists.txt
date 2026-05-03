add_executable(gamma-fade
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(gamma-fade 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(gamma-fade)
nxdk_generate_xiso(gamma-fade)