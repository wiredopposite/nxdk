set(LIBJPEGT_ROOT "${CMAKE_CURRENT_LIST_DIR}/libjpeg-turbo")

add_library(nxdk_libjpeg STATIC 
    ${LIBJPEGT_ROOT}/jcapimin.c
    ${LIBJPEGT_ROOT}/jcapistd.c
    ${LIBJPEGT_ROOT}/jccoefct.c
    ${LIBJPEGT_ROOT}/jccolor.c
    ${LIBJPEGT_ROOT}/jcdctmgr.c
    ${LIBJPEGT_ROOT}/jchuff.c
    ${LIBJPEGT_ROOT}/jcicc.c
    ${LIBJPEGT_ROOT}/jcinit.c
    ${LIBJPEGT_ROOT}/jcmainct.c
    ${LIBJPEGT_ROOT}/jcmarker.c
    ${LIBJPEGT_ROOT}/jcmaster.c
    ${LIBJPEGT_ROOT}/jcomapi.c
    ${LIBJPEGT_ROOT}/jcparam.c
    ${LIBJPEGT_ROOT}/jcphuff.c
    ${LIBJPEGT_ROOT}/jcprepct.c
    ${LIBJPEGT_ROOT}/jcsample.c
    ${LIBJPEGT_ROOT}/jctrans.c
    ${LIBJPEGT_ROOT}/jdapimin.c
    ${LIBJPEGT_ROOT}/jdapistd.c
    ${LIBJPEGT_ROOT}/jdatadst.c
    ${LIBJPEGT_ROOT}/jdatasrc.c
    ${LIBJPEGT_ROOT}/jdcoefct.c
    ${LIBJPEGT_ROOT}/jdcolor.c
    ${LIBJPEGT_ROOT}/jddctmgr.c
    ${LIBJPEGT_ROOT}/jdhuff.c
    ${LIBJPEGT_ROOT}/jdicc.c
    ${LIBJPEGT_ROOT}/jdinput.c
    ${LIBJPEGT_ROOT}/jdmainct.c
    ${LIBJPEGT_ROOT}/jdmarker.c
    ${LIBJPEGT_ROOT}/jdmaster.c
    ${LIBJPEGT_ROOT}/jdmerge.c
    ${LIBJPEGT_ROOT}/jdphuff.c
    ${LIBJPEGT_ROOT}/jdpostct.c
    ${LIBJPEGT_ROOT}/jdsample.c
    ${LIBJPEGT_ROOT}/jdtrans.c
    ${LIBJPEGT_ROOT}/jerror.c
    ${LIBJPEGT_ROOT}/jfdctflt.c
    ${LIBJPEGT_ROOT}/jfdctfst.c
    ${LIBJPEGT_ROOT}/jfdctint.c
    ${LIBJPEGT_ROOT}/jidctflt.c
    ${LIBJPEGT_ROOT}/jidctfst.c
    ${LIBJPEGT_ROOT}/jidctint.c
    ${LIBJPEGT_ROOT}/jidctred.c
    ${LIBJPEGT_ROOT}/jquant1.c
    ${LIBJPEGT_ROOT}/jquant2.c
    ${LIBJPEGT_ROOT}/jutils.c
    ${LIBJPEGT_ROOT}/jmemmgr.c
    ${LIBJPEGT_ROOT}/jmemnobs.c
    ${LIBJPEGT_ROOT}/jaricom.c
    ${LIBJPEGT_ROOT}/jcarith.c
    ${LIBJPEGT_ROOT}/jdarith.c
    
    ${LIBJPEGT_ROOT}/jsimd_none.c
)

target_include_directories(nxdk_libjpeg PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}
    ${LIBJPEGT_ROOT}
)