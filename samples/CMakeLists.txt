cmake_minimum_required(VERSION 3.5)

if(NOT CMAKE_TOOLCHAIN_FILE)
	set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/../cmake/toolchain.cmake"
		CACHE FILEPATH "nxdk toolchain file")
endif()

project(nxdk_samples C CXX ASM)

add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/.." "nxdk")

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake_demo)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/gamma)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/gamma-fade)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/hello)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/hello++)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/httpd)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/httpd_bsd)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/led)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/mesh)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sdl)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sdl_gamecontroller)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sdl_image)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sdl_ttf)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/triangle)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/usb)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/winapi_drivelist)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/winapi_filefind)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/xaudio)