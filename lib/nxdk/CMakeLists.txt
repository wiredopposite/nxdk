add_library(nxdk_core STATIC
	"${CMAKE_CURRENT_LIST_DIR}/configsector.c"
	"${CMAKE_CURRENT_LIST_DIR}/format.c"
	"${CMAKE_CURRENT_LIST_DIR}/mount.c"
	"${CMAKE_CURRENT_LIST_DIR}/path.c"
	"${CMAKE_CURRENT_LIST_DIR}/xbe.c"
	"${CMAKE_CURRENT_LIST_DIR}/automount_d.c"
)
target_include_directories(nxdk_core PUBLIC "${CMAKE_CURRENT_LIST_DIR}/..")
target_link_libraries(nxdk_core PUBLIC nxdk_runtime)
target_link_options(nxdk_core PUBLIC
    "/INCLUDE:_automount_d_drive"
)

add_library(_nxdk_core_net STATIC
	"${CMAKE_CURRENT_LIST_DIR}/net.c"		
)
target_link_libraries(_nxdk_core_net PRIVATE _nxdk_lwip)