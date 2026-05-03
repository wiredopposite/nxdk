set(SDL2_DIR ${CMAKE_CURRENT_LIST_DIR}/SDL2)
file(GLOB SDL2_SRCS CONFIGURE_DEPENDS
	${SDL2_DIR}/src/*.c
	${SDL2_DIR}/src/audio/*.c
	${SDL2_DIR}/src/audio/xbox/*.c
	${SDL2_DIR}/src/cpuinfo/*.c
	${SDL2_DIR}/src/events/*.c
	${SDL2_DIR}/src/file/*.c
	${SDL2_DIR}/src/haptic/*.c
	${SDL2_DIR}/src/haptic/dummy/*.c
	${SDL2_DIR}/src/joystick/*.c
	${SDL2_DIR}/src/joystick/xbox/*.c
	${SDL2_DIR}/src/loadso/dummy/*.c
	${SDL2_DIR}/src/power/*.c
	${SDL2_DIR}/src/filesystem/dummy/*.c
	${SDL2_DIR}/src/render/*.c
	${SDL2_DIR}/src/render/software/*.c
	${SDL2_DIR}/src/sensor/*.c
	${SDL2_DIR}/src/sensor/dummy/*.c
	${SDL2_DIR}/src/stdlib/*.c
	${SDL2_DIR}/src/thread/*.c
	${SDL2_DIR}/src/thread/generic/SDL_syscond.c
	${SDL2_DIR}/src/thread/windows/*.c
	${SDL2_DIR}/src/timer/*.c
	${SDL2_DIR}/src/timer/windows/*.c
	${SDL2_DIR}/src/video/*.c
	${SDL2_DIR}/src/video/xbox/*.c
	${SDL2_DIR}/src/video/yuv2rgb/*.c
	${SDL2_DIR}/src/libm/*.c
	${SDL2_DIR}/src/atomic/*.c
)

add_library(_nxdk_sdl2 STATIC ${SDL2_SRCS})
target_include_directories(_nxdk_sdl2 PUBLIC ${SDL2_DIR}/include)
target_compile_definitions(_nxdk_sdl2 PRIVATE XBOX)
target_link_libraries(_nxdk_sdl2 
	PRIVATE 
		nxdk_core 
		nxdk_usb_core 
		nxdk_libjpeg
		nxdk_libpng
)

set(SDL_TTF_DIR ${CMAKE_CURRENT_LIST_DIR}/SDL_ttf)
set(SDL_FREETYPE_DIR ${SDL_TTF_DIR}/external/freetype-2.4.12)

add_library(_nxdk_sdl_freetype STATIC
    ${SDL_FREETYPE_DIR}/src/base/ftbase.c
    ${SDL_FREETYPE_DIR}/src/base/ftglyph.c
    ${SDL_FREETYPE_DIR}/src/base/ftbitmap.c
    ${SDL_FREETYPE_DIR}/src/base/ftstroke.c
    ${SDL_FREETYPE_DIR}/src/base/ftinit.c
    ${SDL_FREETYPE_DIR}/src/base/ftsystem.c
    ${SDL_FREETYPE_DIR}/src/truetype/truetype.c
    ${SDL_FREETYPE_DIR}/src/raster/raster.c
    ${SDL_FREETYPE_DIR}/src/smooth/smooth.c
    ${SDL_FREETYPE_DIR}/src/autofit/autofit.c
    ${SDL_FREETYPE_DIR}/src/sfnt/sfnt.c
)
target_include_directories(_nxdk_sdl_freetype 
	PUBLIC 
		${CMAKE_CURRENT_LIST_DIR} 
		${SDL_FREETYPE_DIR}/include
)
target_link_libraries(_nxdk_sdl_freetype PRIVATE nxdk_runtime)

add_library(_nxdk_sdl_ttf STATIC ${SDL_TTF_DIR}/SDL_ttf.c)
target_include_directories(_nxdk_sdl_ttf PUBLIC
	${CMAKE_CURRENT_LIST_DIR}
	${SDL_TTF_DIR}
)
target_link_libraries(_nxdk_sdl_ttf PRIVATE nxdk_runtime _nxdk_sdl2 _nxdk_sdl_freetype)

set(SDL2_IMAGE_DIR ${CMAKE_CURRENT_LIST_DIR}/SDL2_image)
file(GLOB SDL2_IMAGE_SRCS CONFIGURE_DEPENDS ${SDL2_IMAGE_DIR}/IMG*.c)

add_library(_nxdk_sdl2_image STATIC ${SDL2_IMAGE_SRCS})
target_include_directories(_nxdk_sdl2_image PUBLIC ${SDL2_IMAGE_DIR})
target_link_libraries(_nxdk_sdl2_image PRIVATE _nxdk_sdl2 nxdk_libjpeg nxdk_libpng)
target_compile_definitions(_nxdk_sdl2_image PRIVATE
    LOAD_BMP 
    LOAD_GIF 
    LOAD_JPG 
    LOAD_LBM 
    LOAD_PCX 
    LOAD_PNG 
    LOAD_PNM 
    LOAD_TGA 
    LOAD_XCF 
    LOAD_XPM 
    LOAD_XV 
    LOAD_XXX
)

add_library(nxdk_sdl INTERFACE)
target_link_libraries(nxdk_sdl INTERFACE
	_nxdk_sdl2
	_nxdk_sdl_ttf
	_nxdk_sdl_freetype
	_nxdk_sdl2_image
)

# TODO: Fix this so the test suite is not pulling in win sdk headers
# file(GLOB SDL2_TEST_SRCS CONFIGURE_DEPENDS ${SDL2_DIR}/test/*.c)
# add_library(nxdk_sdl2test STATIC ${SDL2_TEST_SRCS})
# target_link_libraries(nxdk_sdl2test PUBLIC nxdk_sdl)