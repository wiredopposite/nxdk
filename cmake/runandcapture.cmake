execute_process(
    COMMAND ${COMPILER} ${INPUT}
    OUTPUT_FILE "${OUTPUT}"
    ERROR_VARIABLE _stderr
    OUTPUT_VARIABLE _stdout
    RESULT_VARIABLE _result
)
if(NOT _result EQUAL 0)
    message(FATAL_ERROR
        "Shader compiler failed (exit ${_result}):\n"
        "  Command: ${COMPILER} ${INPUT}\n"
        "  Stdout: ${_stdout}\n"
        "  Stderr: ${_stderr}")
endif()
