add_executable(hellopp
    ${CMAKE_CURRENT_LIST_DIR}/main.cpp
)

target_link_libraries(hellopp 
    PRIVATE
        nxdk_core
)

nxdk_generate_xbe(hellopp)
nxdk_generate_xiso(hellopp)