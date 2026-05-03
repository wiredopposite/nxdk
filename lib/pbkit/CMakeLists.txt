add_library(nxdk_pbkit STATIC
	${CMAKE_CURRENT_LIST_DIR}/pbkit.c
	${CMAKE_CURRENT_LIST_DIR}/pbkit_gamma.c
	${CMAKE_CURRENT_LIST_DIR}/pbkit_dma.c
	${CMAKE_CURRENT_LIST_DIR}/pbkit_draw.c
	${CMAKE_CURRENT_LIST_DIR}/pbkit_print.c
	${CMAKE_CURRENT_LIST_DIR}/pbkit_pushbuffer.c
)

target_include_directories(nxdk_pbkit PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
)