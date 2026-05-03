cmake_minimum_required(VERSION 3.5)
project(fp20compiler)

set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(WIN32)
	if(NOT BISON_EXECUTABLE)
		find_program(_WIN_BISON_EXE NAMES bison win_bison)
		if(_WIN_BISON_EXE)
			set(BISON_EXECUTABLE "${_WIN_BISON_EXE}" CACHE FILEPATH "Path to bison executable" FORCE)
		endif()
	endif()

	if(NOT FLEX_EXECUTABLE)
		find_program(_WIN_FLEX_EXE NAMES flex win_flex)
		if(_WIN_FLEX_EXE)
			set(FLEX_EXECUTABLE "${_WIN_FLEX_EXE}" CACHE FILEPATH "Path to flex executable" FORCE)
		endif()
	endif()
endif()

find_package(BISON QUIET)
find_package(FLEX QUIET)

if(NOT BISON_FOUND OR NOT FLEX_FOUND)
	message(FATAL_ERROR
		"fp20compiler requires Bison and Flex. "
		"On Windows install WinFlexBison (win_bison/win_flex) and ensure it is on PATH, "
		"or configure with -DBISON_EXECUTABLE=<path> -DFLEX_EXECUTABLE=<path>."
	)
endif()

BISON_TARGET(PS10_PARSER
	${CMAKE_CURRENT_LIST_DIR}/ps1.0_grammar.y
	${CMAKE_CURRENT_BINARY_DIR}/_ps1.0_parser.cpp
	DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/_ps1.0_parser.hpp
	COMPILE_FLAGS "-p ps10_"
)

BISON_TARGET(RC10_PARSER
	${CMAKE_CURRENT_LIST_DIR}/rc1.0_grammar.y
	${CMAKE_CURRENT_BINARY_DIR}/_rc1.0_parser.cpp
	DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/_rc1.0_parser.hpp
	COMPILE_FLAGS "-p rc10_"
)

BISON_TARGET(TS10_PARSER
	${CMAKE_CURRENT_LIST_DIR}/ts1.0_grammar.y
	${CMAKE_CURRENT_BINARY_DIR}/_ts1.0_parser.cpp
	DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/_ts1.0_parser.hpp
	COMPILE_FLAGS "-p ts10_"
)

FLEX_TARGET(PS10_LEXER
	${CMAKE_CURRENT_LIST_DIR}/ps1.0_tokens.l
	${CMAKE_CURRENT_BINARY_DIR}/_ps1.0_lexer.cpp
	COMPILE_FLAGS "-Pps10_"
)

FLEX_TARGET(RC10_LEXER
	${CMAKE_CURRENT_LIST_DIR}/rc1.0_tokens.l
	${CMAKE_CURRENT_BINARY_DIR}/_rc1.0_lexer.cpp
	COMPILE_FLAGS "-Prc10_"
)

FLEX_TARGET(TS10_LEXER
	${CMAKE_CURRENT_LIST_DIR}/ts1.0_tokens.l
	${CMAKE_CURRENT_BINARY_DIR}/_ts1.0_lexer.cpp
	COMPILE_FLAGS "-Pts10_"
)

ADD_FLEX_BISON_DEPENDENCY(PS10_LEXER PS10_PARSER)
ADD_FLEX_BISON_DEPENDENCY(RC10_LEXER RC10_PARSER)
ADD_FLEX_BISON_DEPENDENCY(TS10_LEXER TS10_PARSER)

add_executable(fp20compiler 
	${CMAKE_CURRENT_LIST_DIR}/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/nvparse_errors.cpp
	${CMAKE_CURRENT_LIST_DIR}/rc1.0_combiners.cpp
	${CMAKE_CURRENT_LIST_DIR}/rc1.0_final.cpp
	${CMAKE_CURRENT_LIST_DIR}/rc1.0_general.cpp
	${CMAKE_CURRENT_LIST_DIR}/ts1.0_inst.cpp
	${CMAKE_CURRENT_LIST_DIR}/ts1.0_inst_list.cpp
	${BISON_TS10_PARSER_OUTPUTS}
	${FLEX_TS10_LEXER_OUTPUTS}
	${FLEX_RC10_LEXER_OUTPUTS}
	${BISON_RC10_PARSER_OUTPUTS}
	${FLEX_PS10_LEXER_OUTPUTS}
	${BISON_PS10_PARSER_OUTPUTS}
	${CMAKE_CURRENT_LIST_DIR}/ps1.0_program.cpp
)

target_include_directories(fp20compiler PRIVATE
	${CMAKE_CURRENT_LIST_DIR}
	${CMAKE_CURRENT_BINARY_DIR}
)

target_compile_definitions(fp20compiler PRIVATE YY_NO_UNPUT)

if(MSVC)
	target_compile_options(fp20compiler PRIVATE /W3)
else()
	target_compile_options(fp20compiler PRIVATE -Wall)
endif()