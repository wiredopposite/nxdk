add_executable(usb
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

target_link_libraries(usb 
    PRIVATE
        nxdk_core
        nxdk_usb
)

nxdk_generate_xbe(usb)
nxdk_generate_xiso(usb)