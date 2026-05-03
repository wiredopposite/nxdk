add_executable(winapi_filefind
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(winapi_filefind 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(winapi_filefind)
nxdk_generate_xiso(winapi_filefind)