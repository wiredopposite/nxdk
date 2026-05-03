add_executable(triangle
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

nxdk_add_shaders(triangle
    ${CMAKE_CURRENT_LIST_DIR}/ps.ps.cg
    ${CMAKE_CURRENT_LIST_DIR}/vs.vs.cg
)

target_link_libraries(triangle 
    PRIVATE
        nxdk_core
        nxdk_pbkit
)

nxdk_generate_xbe(triangle)
nxdk_generate_xiso(triangle)