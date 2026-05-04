cmake_minimum_required(VERSION 3.5)
project(cxbe)

set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(cxbe
    ${CMAKE_CURRENT_LIST_DIR}/Xbe.cpp
    ${CMAKE_CURRENT_LIST_DIR}/Main.cpp
    ${CMAKE_CURRENT_LIST_DIR}/Logo.cpp
    ${CMAKE_CURRENT_LIST_DIR}/Exe.cpp
    ${CMAKE_CURRENT_LIST_DIR}/Error.cpp
    ${CMAKE_CURRENT_LIST_DIR}/Common.cpp
)

if(CMAKE_HOST_WIN32)
    target_compile_options(cxbe PRIVATE
        -Dstrcasecmp=_stricmp
        -Dstrncasecmp=_strnicmp
        -D_CRT_SECURE_NO_WARNINGS
        -D_CRT_NONSTDC_NO_WARNINGS
    )
endif()