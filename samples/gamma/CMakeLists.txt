add_executable(gamma
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(gamma 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(gamma)
nxdk_generate_xiso(gamma)