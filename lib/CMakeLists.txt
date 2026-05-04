if(NOT CMAKE_ASM_COMPILER_LOADED)
    enable_language(ASM)
endif()

set(PDCLIB_DIR ${CMAKE_CURRENT_LIST_DIR}/pdclib)
file(GLOB_RECURSE PDCLIB_SRCS
    CONFIGURE_DEPENDS
    "${PDCLIB_DIR}/functions/*.c"
    "${PDCLIB_DIR}/platform/xbox/*.c"
    "${PDCLIB_DIR}/platform/xbox/*.s"
)
add_library(nxdk_pdclib STATIC ${PDCLIB_SRCS})

if(CMAKE_CXX_COMPILER_LOADED)
    set(LIBCXX_DIR ${CMAKE_CURRENT_LIST_DIR}/libcxx)
    add_library(nxdk_libcxx STATIC
        "${LIBCXX_DIR}/src/algorithm.cpp"
        "${LIBCXX_DIR}/src/any.cpp"
        "${LIBCXX_DIR}/src/bind.cpp"
        "${LIBCXX_DIR}/src/charconv.cpp"
        "${LIBCXX_DIR}/src/chrono.cpp"
        "${LIBCXX_DIR}/src/condition_variable.cpp"
        "${LIBCXX_DIR}/src/condition_variable_destructor.cpp"
        "${LIBCXX_DIR}/src/debug.cpp"
        "${LIBCXX_DIR}/src/exception.cpp"
        "${LIBCXX_DIR}/src/functional.cpp"
        "${LIBCXX_DIR}/src/future.cpp"
        "${LIBCXX_DIR}/src/hash.cpp"
        "${LIBCXX_DIR}/src/ios.cpp"
        "${LIBCXX_DIR}/src/iostream.cpp"
        "${LIBCXX_DIR}/src/locale.cpp"
        "${LIBCXX_DIR}/src/memory.cpp"
        "${LIBCXX_DIR}/src/mutex.cpp"
        "${LIBCXX_DIR}/src/mutex_destructor.cpp"
        "${LIBCXX_DIR}/src/new.cpp"
        "${LIBCXX_DIR}/src/optional.cpp"
        "${LIBCXX_DIR}/src/random.cpp"
        "${LIBCXX_DIR}/src/regex.cpp"
        "${LIBCXX_DIR}/src/shared_mutex.cpp"
        "${LIBCXX_DIR}/src/stdexcept.cpp"
        "${LIBCXX_DIR}/src/string.cpp"
        "${LIBCXX_DIR}/src/strstream.cpp"
        "${LIBCXX_DIR}/src/system_error.cpp"
        "${LIBCXX_DIR}/src/thread.cpp"
        "${LIBCXX_DIR}/src/typeinfo.cpp"
        "${LIBCXX_DIR}/src/utility.cpp"
        "${LIBCXX_DIR}/src/valarray.cpp"
        "${LIBCXX_DIR}/src/variant.cpp"
        "${LIBCXX_DIR}/src/vector.cpp"
        "${LIBCXX_DIR}/src/support/win32/support.cpp"
        "${LIBCXX_DIR}/src/support/win32/thread_win32.cpp"
    )
    target_compile_options(nxdk_libcxx PRIVATE -Wno-invalid-noreturn)
endif()

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/hal)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/libjpeg)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/libpng)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/net)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/nxdk)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/pbkit)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sdl)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/usb)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/winapi)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/xboxkrnl)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/xboxrt)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/zlib)

add_library(nxdk_runtime INTERFACE)
target_link_libraries(nxdk_runtime INTERFACE
    nxdk_pdclib
    nxdk_hal
    nxdk_winapi
    nxdk_xboxkrnl
    nxdk_xboxrt
)

if(CMAKE_CXX_COMPILER_LOADED)
    target_link_libraries(nxdk_runtime INTERFACE nxdk_libcxx)
endif()

add_library(nxdk_net INTERFACE)
target_link_libraries(nxdk_net INTERFACE
    _nxdk_lwip
    _nxdk_core_net
)