cmake_minimum_required(VERSION 3.5)
project(vp20compiler C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED YES)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(vp20compiler
    ${CMAKE_CURRENT_LIST_DIR}/main.c
    ${CMAKE_CURRENT_LIST_DIR}/nvvertparse.c
    ${CMAKE_CURRENT_LIST_DIR}/prog_instruction.c
)

if(MSVC)
    target_compile_options(vp20compiler PRIVATE /W3)
else()
    target_compile_options(vp20compiler PRIVATE -Wall)
endif()
