include(${CMAKE_CURRENT_LIST_DIR}/buildtool.cmake)

macro(_nxdk_get_disc_target_name disc_name out_target_name)
    string(REPLACE " " "_" _clean_disc_name "${disc_name}")
    set(${out_target_name} "${_clean_disc_name}_disc_target")
endmacro()

macro(_nxdk_get_disc_output_path disc_name out_path)
    set(${out_path} "${CMAKE_SOURCE_DIR}/bin/${disc_name}")
endmacro()

function(_nxdk_generate_disc target_name disc_name out_target_name)
    _nxdk_get_disc_target_name(${disc_name} _disc_target_name)

    if(NOT TARGET ${_disc_target_name})
        # This is a placeholder target for adding deps to a disc
        # like xbes and assets before running extract-xiso
        _nxdk_get_disc_output_path(${disc_name} _disc_output_path)
        add_custom_command(
            TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND} 
                -E make_directory "${_disc_output_path}"
        )
        add_custom_target(${_disc_target_name} ALL DEPENDS ${target_name})
    endif()

    add_dependencies(${_disc_target_name} ${target_name})
    set(${out_target_name} ${_disc_target_name} PARENT_SCOPE)
endfunction()

function(nxdk_add_target target_name)
    cmake_parse_arguments(ARG "" "DISC" "" ${ARGN})
    set(_disc_name ${ARG_DISC})
    if(NOT _disc_name)
        set(_disc_name ${target_name})
    endif()

    _nxdk_generate_disc(${target_name} ${_disc_name} _disc_target)
endfunction()

function(nxdk_generate_xbe target_name)
    cmake_parse_arguments(ARG "" "DISC;PATH;TITLE;DEVKIT" "" ${ARGN})
    set(_disc_name ${ARG_DISC})
    set(_out_path ${ARG_PATH})
    set(_xbe_title ${ARG_TITLE})

    if(NOT _xbe_title)
        set(_xbe_title ${target_name})
    endif()
    if(NOT _disc_name)
        set(_disc_name ${target_name})
    endif()
    if(NOT _out_path)
        set(_out_path "default.xbe")
    endif()

    _nxdk_generate_disc(${target_name} ${_disc_name} _disc_target)

    set(_xbe_tag "${_disc_target}_${_out_path}")
    string(MD5 _xbe_target "${_xbe_tag}")

    if(NOT TARGET ${_xbe_target})
        _nxdk_get_disc_output_path(${_disc_name} _disc_output_path)
        set(_out_path "${_disc_output_path}/${_out_path}")
        file(TO_NATIVE_PATH "${_out_path}" _out_path)
        get_filename_component(_dir_path ${_out_path} DIRECTORY)

        _nxdk_get_cxbe(${target_name} _cxbe_exe)

        if(${ARG_DEVKIT})
            set(_cxbe_flags "-MODE:debug")
        else()
            set(_cxbe_flags "-MODE:retail")
        endif()

        add_custom_command(
            TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory "${_dir_path}"
            COMMAND ${CMAKE_COMMAND} -E rm -f "${_out_path}"
            COMMAND
                ${_cxbe_exe}
                "-OUT:${_out_path}"
                "-TITLE:${_xbe_title}"
                ${_cxbe_flags}
                "$<TARGET_FILE:${target_name}>"
            COMMENT "Generating XBE for ${target_name}"
        )
        add_custom_target(${_xbe_target} ALL 
            DEPENDS ${target_name} ${_cxbe_exe}
        )
        # the disc target depends on the xbe target, xiso target
        # depends on the disc target, so this ensures the correct order
        add_dependencies(${_disc_target} ${_xbe_target})
    else()
        message(WARNING "XBE target for ${target_name} with disc ${_disc_name} and path ${_out_path} already exists, skipping generation")
    endif()
endfunction()

function(nxdk_generate_xiso target_name)
    cmake_parse_arguments(ARG "" "DISC" "" ${ARGN})

    set(_disc_name ${ARG_DISC})
    if(NOT _disc_name)
        set(_disc_name ${target_name})
    endif()

    _nxdk_get_disc_target_name(${_disc_name} _disc_target)

    if(NOT TARGET ${_disc_target})
        message(FATAL_ERROR "Disc target ${_disc_target} does not exist, make sure to add a target with nxdk_add_target or by generating an xbe for this disc before generating an xiso")
    endif()

    set(_xiso_target_name "${_disc_name}_xiso_target")
    string(REPLACE " " "_" _xiso_target_name "${_disc_name}")
    set(_xiso_target_name "${_xiso_target_name}_xiso_target")

    if(NOT TARGET ${_xiso_target_name})
        _nxdk_get_extract_xiso(${target_name} _extract_xiso_exe)
        _nxdk_get_disc_output_path(${_disc_name} _disc_output_path)

        set(_disc_dir "${_disc_output_path}")
        set(_xiso_path "${_disc_output_path}.iso")
        file(TO_NATIVE_PATH "${_disc_dir}" _disc_dir)
        file(TO_NATIVE_PATH "${_xiso_path}" _xiso_path)

        add_custom_command(
            TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E rm -f ${_xiso_path}
            COMMAND
                ${_extract_xiso_exe}
                "-c"
                ${_disc_dir}
                ${_xiso_path}
            WORKING_DIRECTORY ${_disc_output_path}
            COMMENT "Generating XISO for ${target_name} at ${_xiso_path}"
            VERBATIM
        )
        add_custom_target(${_xiso_target_name} ALL 
            DEPENDS ${_disc_target} ${_extract_xiso_exe}
        )
    endif()
endfunction()

macro(_nxdk_add_asset_file target_name disc_target asset_path out_path)
    set(_asset_tag "${target_name}_${disc_target}_${asset_path}_${out_path}")
    string(MD5 _asset_hash "${_asset_tag}")
    if(NOT TARGET ${_asset_hash})
        get_filename_component(_out_dir ${out_path} DIRECTORY)
        add_custom_command(
            TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory ${_out_dir}
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${asset_path} ${out_path}
            COMMENT "Adding asset ${asset_path} to ${out_path}"
        )
        add_custom_target(${_asset_hash} ALL DEPENDS ${_asset_path})
        add_dependencies(${disc_target} ${_asset_hash})
    endif()
endmacro()

function(nxdk_add_assets target_name)
    cmake_parse_arguments(ARG "" "DISC" "FILES;DIRECTORIES;CONTENTS" ${ARGN})
    set(_disc_name ${ARG_DISC})
    if(NOT _disc_name)
        set(_disc_name ${target_name})
    endif()

    _nxdk_generate_disc(${target_name} ${_disc_name} _disc_target)
    _nxdk_get_disc_target_name(${_disc_name} _disc_target)
    _nxdk_get_disc_output_path(${_disc_name} _disc_dir)

    foreach(_file ${ARG_FILES})
        if(NOT EXISTS "${_file}")
            message(FATAL_ERROR "Asset file ${_file} does not exist")
        endif()

        get_filename_component(_file_name ${_file} NAME)
        set(_out_path "${_disc_dir}/${_file_name}")
        _nxdk_add_asset_file(
            ${target_name} 
            ${_disc_target}
            ${_file} 
            ${_out_path}
        )
    endforeach()

    foreach(_dir ${ARG_DIRECTORIES})
        if(NOT EXISTS "${_dir}")
            message(FATAL_ERROR "Asset directory ${_dir} does not exist")
        endif()

        get_filename_component(_dir_name ${_dir} NAME)
        file(GLOB_RECURSE _dir_files "${_dir}/*")
        foreach(_file ${_dir_files})
            file(RELATIVE_PATH _rel_path "${_dir}" "${_file}")
            set(_out_path "${_disc_dir}/${_dir_name}/${_rel_path}")
            _nxdk_add_asset_file(
                ${target_name} 
                ${_disc_target}
                ${_file} 
                ${_out_path}
            )
        endforeach()
    endforeach()

    foreach(_dir ${ARG_CONTENTS})
        if(NOT EXISTS "${_dir}")
            message(FATAL_ERROR "Asset directory ${_dir} does not exist")
        endif()

        file(GLOB_RECURSE _dir_files "${_dir}/*")
        foreach(_file ${_dir_files})
            file(RELATIVE_PATH _rel_path "${_dir}" "${_file}")
            set(_out_path "${_disc_dir}/${_rel_path}")
            _nxdk_add_asset_file(
                ${target_name} 
                ${_disc_target}
                ${_file} 
                ${_out_path}
            )
        endforeach()
    endforeach()
endfunction()

function(nxdk_add_shaders target_name)
    _nxdk_get_cgc(_cgc_exe)
    set(_gen_dir "${CMAKE_CURRENT_BINARY_DIR}/${target_name}_shader_include")

    foreach(_shader ${ARGN})
        if(NOT EXISTS "${_shader}")
            message(FATAL_ERROR "Shader file ${_shader} does not exist")
        endif()

        get_filename_component(_shader_name ${_shader} NAME)
        get_filename_component(_shader_stem ${_shader} NAME_WE)

        if(_shader_name MATCHES "\\.vs\\.cg$")
            _nxdk_get_vp20(${target_name} _compiler_exe)
            string(REGEX REPLACE "\\.vs$" "" _shader_base "${_shader_stem}")
            set(_profile "vp20")
        elseif(_shader_name MATCHES "\\.ps\\.cg$")
            _nxdk_get_fp20(${target_name} _compiler_exe)
            string(REGEX REPLACE "\\.ps$" "" _shader_base "${_shader_stem}")
            set(_profile "fp20")
        else()
            message(FATAL_ERROR "Shader file ${_shader} has an invalid extension, expected .s.cg or .ps.cg")
        endif()

        set(_tmp_out "${_gen_dir}/${_shader_base}.${_profile}.tmp")
        set(_inl_out "${_gen_dir}/${_shader_base}.inl")

        add_custom_command(
            OUTPUT ${_inl_out}
            DEPENDS ${_shader} ${_cgc_exe} ${_compiler_exe}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${_gen_dir}"
            COMMAND ${CMAKE_COMMAND} -E rm -f "${_tmp_out}" "${_inl_out}"
            COMMAND 
                ${_cgc_exe}
                -profile ${_profile}
                -o "${_tmp_out}"
                "${_shader}"
            COMMAND ${CMAKE_COMMAND}
                -DCOMPILER=${_compiler_exe}
                -DINPUT=${_tmp_out}
                -DOUTPUT=${_inl_out}
                -P "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/runandcapture.cmake"
            # COMMAND ${CMAKE_COMMAND} -E rm -f "${_tmp_out}"
            COMMENT "Compiling shader ${_shader}"
        )
        target_sources(${target_name} PRIVATE ${_inl_out})
    endforeach()

    target_include_directories(${target_name} PRIVATE ${_gen_dir})
endfunction()

function(nxdk_add_binaries target_name)
    set(_include_dir "${CMAKE_CURRENT_BINARY_DIR}/${target_name}_bin_include")
    file(MAKE_DIRECTORY "${_include_dir}")

    foreach(_bin_pair ${ARGN})
        string(REPLACE "=" ";" _bin_pair_list "${_bin_pair}")
        list(LENGTH _bin_pair_list _pair_len)

        if(NOT _pair_len EQUAL 2)
            message(FATAL_ERROR "Binary pair ${_bin_pair} is not in the format <header_filename=binary_path>")
        endif()

        list(GET _bin_pair_list 0 _header_name)
        list(GET _bin_pair_list 1 _bin)

        if(NOT EXISTS "${_bin}")
            message(FATAL_ERROR "Binary file ${_bin} does not exist")
        endif()

        set(_out_path "${_include_dir}/${_header_name}")

        string(FIND ${_header_name} "." _ext_pos REVERSE)

        if(_ext_pos NOT EQUAL -1)
            string(SUBSTRING ${_header_name} 0 ${_ext_pos} _array_name)
        else()
            set(_array_name ${_header_name})
        endif()

        file(READ "${_bin}" _bin_data HEX)
        string(REGEX MATCHALL "([a-f0-9][a-f0-9])" _sep_hex "${_bin_data}")
        list(LENGTH _sep_hex _hex_len)
        set(_lines "")
        set(_i 0)
        while(_i LESS _hex_len)
            math(EXPR _count "${_hex_len} - ${_i}")
            if(_count GREATER 16)
                set(_count 16)
            endif()
            list(SUBLIST _sep_hex ${_i} ${_count} _chunk)
            list(JOIN _chunk ", 0x" _chunk_str)
            list(APPEND _lines "    0x${_chunk_str}")
            math(EXPR _i "${_i} + 16")
        endwhile()
        list(JOIN _lines ",\n" _formatted_hex)

        set(_header "/* This file is generated from ${_bin}, do not edit directly */\n\n")
        set(_header "${_header}#pragma once\n\n")
        set(_header "${_header}static const unsigned char ${_array_name}[] = {\n${_formatted_hex}\n};\n\n")
        set(_header "${_header}static const unsigned int ${_array_name}_size = sizeof(${_array_name});\n")

        file(WRITE "${_out_path}" "${_header}")
    endforeach()

    target_include_directories(${target_name} PRIVATE ${_include_dir})
endfunction()