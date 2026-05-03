add_library(nxdk_winapi STATIC
	${CMAKE_CURRENT_LIST_DIR}/badptr.c
	${CMAKE_CURRENT_LIST_DIR}/debug.c
	${CMAKE_CURRENT_LIST_DIR}/errhandlingapi.c
	${CMAKE_CURRENT_LIST_DIR}/error.c
	${CMAKE_CURRENT_LIST_DIR}/fiber.c
	${CMAKE_CURRENT_LIST_DIR}/fileio.c
	${CMAKE_CURRENT_LIST_DIR}/filemanip.c
	${CMAKE_CURRENT_LIST_DIR}/findfile.c
	${CMAKE_CURRENT_LIST_DIR}/handleapi.c
	${CMAKE_CURRENT_LIST_DIR}/ioapi.c
	${CMAKE_CURRENT_LIST_DIR}/memory.c
	${CMAKE_CURRENT_LIST_DIR}/libloaderapi.c
	${CMAKE_CURRENT_LIST_DIR}/profiling.c
	${CMAKE_CURRENT_LIST_DIR}/shlobj_core.c
	${CMAKE_CURRENT_LIST_DIR}/sync.c
	${CMAKE_CURRENT_LIST_DIR}/sysinfo.c
	${CMAKE_CURRENT_LIST_DIR}/thread.c
	${CMAKE_CURRENT_LIST_DIR}/timezoneapi.c
	${CMAKE_CURRENT_LIST_DIR}/tls.c
	${CMAKE_CURRENT_LIST_DIR}/winnt.c

	# Keep separate?
	${CMAKE_CURRENT_LIST_DIR}/winmm/timeapi.c
)
target_include_directories(nxdk_winapi PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}
	${CMAKE_CURRENT_LIST_DIR}/winmm
)