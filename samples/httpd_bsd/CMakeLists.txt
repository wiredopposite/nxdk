add_executable(httpd_bsd
    ${CMAKE_CURRENT_LIST_DIR}/main.c
    ${CMAKE_CURRENT_LIST_DIR}/httpserver.c
)

target_link_libraries(httpd_bsd 
    PRIVATE
        nxdk_core
        nxdk_net
)

nxdk_generate_xbe(httpd_bsd)
nxdk_generate_xiso(httpd_bsd)