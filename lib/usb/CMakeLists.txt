set(OHCI_DIR ${CMAKE_CURRENT_LIST_DIR}/libusbohci)
set(OHCI_XBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/libusbohci_xbox)
set(OHCI_INC_DIR ${OHCI_DIR}/inc)

add_library(nxdk_usb_core STATIC
	${OHCI_DIR}/src_core/hub.c
	${OHCI_DIR}/src_core/mem_alloc.c
	${OHCI_DIR}/src_core/ohci.c
	${OHCI_DIR}/src_core/support.c
	${OHCI_DIR}/src_core/usb_core.c
    ${OHCI_XBOX_DIR}/usbh_xbox.c
    ${OHCI_XBOX_DIR}/xid_driver.c
)
target_include_directories(nxdk_usb_core PUBLIC 
    ${OHCI_INC_DIR}
    ${OHCI_XBOX_DIR}
)
target_compile_definitions(nxdk_usb_core PUBLIC
    -DUSBH_USE_EXTERNAL_CONFIG="usbh_config_xbox.h"
)

add_library(nxdk_usb_hid STATIC
	${OHCI_DIR}/src_hid/hid_core.c
	${OHCI_DIR}/src_hid/hid_driver.c
)
target_link_libraries(nxdk_usb_hid PUBLIC nxdk_usb_core)

add_library(nxdk_usb_cdc STATIC
	${OHCI_DIR}/src_cdc/cdc_core.c
	${OHCI_DIR}/src_cdc/cdc_driver.c
	${OHCI_DIR}/src_cdc/cdc_parser.c
)
target_link_libraries(nxdk_usb_cdc PUBLIC nxdk_usb_core)

add_library(nxdk_usb_msc STATIC
    ${OHCI_DIR}/src_msc/msc_driver.c
    ${OHCI_DIR}/src_msc/msc_xfer.c
)
target_link_libraries(nxdk_usb_msc PUBLIC nxdk_usb_core)

add_library(nxdk_usb_uac STATIC
	${OHCI_DIR}/src_uac/uac_core.c
	${OHCI_DIR}/src_uac/uac_driver.c
	${OHCI_DIR}/src_uac/uac_parser.c
)
target_link_libraries(nxdk_usb_uac PUBLIC nxdk_usb_core)

add_library(nxdk_usb_uvc STATIC
    ${OHCI_DIR}/src_uvc/uvc_core.c
    ${OHCI_DIR}/src_uvc/uvc_driver.c
    ${OHCI_DIR}/src_uvc/uvc_parser.c        
)
target_link_libraries(nxdk_usb_uvc PUBLIC nxdk_usb_core)

add_library(nxdk_usb INTERFACE)
target_link_libraries(nxdk_usb INTERFACE
	nxdk_usb_core
	nxdk_usb_hid
	nxdk_usb_cdc
	nxdk_usb_msc
	nxdk_usb_uac
	nxdk_usb_uvc
)