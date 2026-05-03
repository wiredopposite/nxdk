add_executable(mesh
    ${CMAKE_CURRENT_LIST_DIR}/math3d.c 
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(mesh 
    PRIVATE
        nxdk_core
        nxdk_pbkit
)

nxdk_add_shaders(mesh
    ${CMAKE_CURRENT_LIST_DIR}/ps.ps.cg
    ${CMAKE_CURRENT_LIST_DIR}/vs.vs.cg
)

nxdk_generate_xbe(mesh)
nxdk_generate_xiso(mesh)