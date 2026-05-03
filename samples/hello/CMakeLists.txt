add_executable(hello
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(hello 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(hello)
nxdk_generate_xiso(hello)