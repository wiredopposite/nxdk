add_executable(winapi_drivelist
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(winapi_drivelist 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(winapi_drivelist)
nxdk_generate_xiso(winapi_drivelist)