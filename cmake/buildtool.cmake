function(_nxdk_build_host_tool xbox_target host_target_root c_flags cpp_flags out_exe)
    cmake_path(GET host_target_root FILENAME _out_target_name)

    set(_build_dir "${CMAKE_BINARY_DIR}/_nxdk_host_tools/${_out_target_name}")
    set(_host_tmp_dir "${CMAKE_BINARY_DIR}/_nxdk_host_tools/_tmp")
    set(_host_defs "")
    set(_host_warning_flags "-w")

    if(CMAKE_HOST_WIN32)
        set(_host_defs "-DWIN32")
        set(_out_exe "${_build_dir}/${_out_target_name}.exe")
    else()
        set(_out_exe "${_build_dir}/${_out_target_name}")
    endif()

    set(${out_exe} "${_out_exe}" PARENT_SCOPE)

    find_program(_CLANG_PATH clang REQUIRED)
    find_program(_CLANGPP_PATH clang++ REQUIRED)
    find_program(_LLD_PATH lld-link REQUIRED)
    find_program(_NINJA_PATH Ninja REQUIRED)

    if(NOT TARGET _build_${_out_target_name})
        add_custom_command(
            OUTPUT ${_out_exe}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${_host_tmp_dir}"
            COMMAND ${CMAKE_COMMAND}
                -E env
                "TEMP=${_host_tmp_dir}"
                "TMP=${_host_tmp_dir}"
                ${CMAKE_COMMAND}
                -Wno-deprecated
                -S "${host_target_root}"
                -B "${_build_dir}"
                -G Ninja
                -DCMAKE_TOOLCHAIN_FILE:FILEPATH=
                -DCMAKE_C_COMPILER:FILEPATH=${_CLANG_PATH}
                -DCMAKE_CXX_COMPILER:FILEPATH=${_CLANGPP_PATH}
                "-DCMAKE_C_FLAGS:STRING=${_host_defs} ${_host_warning_flags} ${c_flags}"
                "-DCMAKE_CXX_FLAGS:STRING=${_host_defs} ${_host_warning_flags} ${cpp_flags}"
                -DCMAKE_BUILD_TYPE:STRING=Release
            COMMAND ${CMAKE_COMMAND}
                -E env
                "TEMP=${_host_tmp_dir}"
                "TMP=${_host_tmp_dir}"
                ${CMAKE_COMMAND}
                "--build" "${_build_dir}"
                "--target" "${_out_target_name}"
                "--"
                "--quiet"
        )

        add_custom_target(_build_${_out_target_name} ALL DEPENDS ${_out_exe})
    endif()

    add_dependencies(${xbox_target} _build_${_out_target_name})
endfunction()

function(_nxdk_get_extract_xiso xbox_target out_exe)
    _nxdk_build_host_tool(
        ${xbox_target}
        "$ENV{NXDK_DIR}/tools/extract-xiso"
        "-D_CRT_SECURE_NO_WARNINGS \
         -D_CRT_NONSTDC_NO_WARNINGS"
        ""
        _out_exe
    )
    set(${out_exe} "${_out_exe}" PARENT_SCOPE)
endfunction()

function(_nxdk_get_cxbe xbox_target out_exe)
    _nxdk_build_host_tool(
        ${xbox_target}
        "$ENV{NXDK_DIR}/tools/cxbe"
        "" ""
        _out_exe
    )
    set(${out_exe} "${_out_exe}" PARENT_SCOPE)
endfunction()

function(_nxdk_get_vp20 xbox_target out_exe)
    _nxdk_build_host_tool(
        ${xbox_target}
        "$ENV{NXDK_DIR}/tools/vp20compiler"
        "" ""
        _out_exe
    )
    set(${out_exe} "${_out_exe}" PARENT_SCOPE)
endfunction()

function(_nxdk_get_fp20 xbox_target out_exe)
    set(_fp20_c_flags "")
    set(_fp20_cpp_flags "")
    if(CMAKE_HOST_WIN32)
        set(_fp20_c_flags "\
            -DYY_NO_UNISTD_H \
            -D_CRT_SECURE_NO_WARNINGS \
            -D_CRT_NONSTDC_NO_WARNINGS")
        set(_fp20_cpp_flags "\
            -DYY_NO_UNISTD_H \
            -D_CRT_SECURE_NO_WARNINGS \
            -D_CRT_NONSTDC_NO_WARNINGS \
            -include io.h \
            -Disatty=_isatty \
            -Dfileno=_fileno")
    endif()

    _nxdk_build_host_tool(
        ${xbox_target}
        "$ENV{NXDK_DIR}/tools/fp20compiler"
        "${_fp20_c_flags}"
        "${_fp20_cpp_flags}"
        _out_exe
    )
    set(${out_exe} "${_out_exe}" PARENT_SCOPE)
endfunction()

function(_nxdk_get_cgc out_exe)
    if(CMAKE_HOST_WIN32)
        set(_cgc_exe "$ENV{NXDK_DIR}/tools/cg/win/cgc.exe")
    elseif(CMAKE_HOST_APPLE)
        set(_cgc_exe "$ENV{NXDK_DIR}/tools/cg/mac/cgc")
    else()
        if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
            set(_cgc_exe "$ENV{NXDK_DIR}/tools/cg/linux/cgc")
        else()
            set(_cgc_exe "$ENV{NXDK_DIR}/tools/cg/linux/cgc.i386")
        endif()
    endif()

    if(NOT EXISTS "${_cgc_exe}")
        message(FATAL_ERROR "CGC executable not found at ${_cgc_exe}")
    endif()

    set(${out_exe} "${_cgc_exe}" PARENT_SCOPE)
endfunction()