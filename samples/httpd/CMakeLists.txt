add_executable(httpd
    ${CMAKE_CURRENT_LIST_DIR}/main.c
    ${CMAKE_CURRENT_LIST_DIR}/httpserver.c
)

target_link_libraries(httpd 
    PRIVATE
        nxdk_core
        nxdk_net
)

nxdk_generate_xbe(httpd)
nxdk_generate_xiso(httpd)