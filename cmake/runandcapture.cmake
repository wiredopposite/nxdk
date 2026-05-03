execute_process(
    COMMAND ${COMPILER} ${INPUT}
    OUTPUT_FILE "${OUTPUT}"
    RESULT_VARIABLE _result
)
if(NOT _result EQUAL 0)
    message(FATAL_ERROR "Shader compiler failed: ${COMPILER} ${INPUT}")
endif()
