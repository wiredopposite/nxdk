if(NOT DEFINED ENV{NXDK_DIR} OR NOT DEFINED NXDK)
    message(FATAL_ERROR "Nxdk toolchain not set, set CMAKE_TOOLCHAIN_FILE to nxdk/cmake/toolchain.cmake before setting your project name.")
endif()

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/lib)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/output.cmake)