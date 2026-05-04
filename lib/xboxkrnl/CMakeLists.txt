set(NXDK_XBOXKRNL_LIB "${CMAKE_CURRENT_LIST_DIR}/libxboxkrnl.lib")

if(NOT EXISTS "${NXDK_XBOXKRNL_LIB}")
    set(NXDK_XBOXKRNL_LIB "${CMAKE_CURRENT_BINARY_DIR}/libxboxkrnl.lib")
    set(NXDK_XBOXKRNL_DEF "${CMAKE_CURRENT_LIST_DIR}/xboxkrnl.exe.def")

    find_program(_DLLTOOL_EXE llvm-dlltool REQUIRED)

    add_custom_command(
        OUTPUT "${NXDK_XBOXKRNL_LIB}"
        COMMAND
            "${_DLLTOOL_EXE}"
            -d "${NXDK_XBOXKRNL_DEF}"
            -l "${NXDK_XBOXKRNL_LIB}"
            -m i386
        DEPENDS "${NXDK_XBOXKRNL_DEF}"
        COMMENT "Generating libxboxkrnl.lib from xboxkrnl.exe.def"
        VERBATIM
    )
endif()

add_custom_target(_nxdk_xboxkrnl_gen DEPENDS "${NXDK_XBOXKRNL_LIB}")

add_library(nxdk_xboxkrnl STATIC IMPORTED GLOBAL)
set_target_properties(nxdk_xboxkrnl PROPERTIES IMPORTED_LOCATION "${NXDK_XBOXKRNL_LIB}")
add_dependencies(nxdk_xboxkrnl _nxdk_xboxkrnl_gen)