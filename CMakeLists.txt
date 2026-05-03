if(NOT DEFINED ENV{NXDK_DIR})
    set(ENV{NXDK_DIR} "${CMAKE_CURRENT_LIST_DIR}")
endif()

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/lib)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/output.cmake)