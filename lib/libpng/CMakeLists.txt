set(LIBPNG_ROOT "${CMAKE_CURRENT_LIST_DIR}/libpng")

add_library(nxdk_libpng STATIC 
    ${LIBPNG_ROOT}/png.c
    ${LIBPNG_ROOT}/pngerror.c
    ${LIBPNG_ROOT}/pngget.c
    ${LIBPNG_ROOT}/pngmem.c
    ${LIBPNG_ROOT}/pngpread.c
    ${LIBPNG_ROOT}/pngread.c
    ${LIBPNG_ROOT}/pngrio.c
    ${LIBPNG_ROOT}/pngrtran.c
    ${LIBPNG_ROOT}/pngrutil.c
    ${LIBPNG_ROOT}/pngset.c
    ${LIBPNG_ROOT}/pngtrans.c
    ${LIBPNG_ROOT}/pngwio.c
    ${LIBPNG_ROOT}/pngwrite.c
    ${LIBPNG_ROOT}/pngwtran.c
    ${LIBPNG_ROOT}/pngwutil.c
)

target_include_directories(nxdk_libpng PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}
    ${LIBPNG_ROOT}
)

target_link_libraries(nxdk_libpng PRIVATE nxdk_zlib)