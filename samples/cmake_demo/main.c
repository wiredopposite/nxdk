#include <string.h>
#include <stdbool.h>
#include <windows.h>
#include <hal/debug.h>
#include <hal/video.h>
#include <hal/xbox.h>

#define CdRomPath "\\Device\\CdRom0\\"
#define ChildXbeName "child.xbe"
#define DefaultXbeName "default.xbe"
#define DefaultPath CdRomPath DefaultXbeName
#define ChildPath CdRomPath ChildXbeName

int main(void) {
    XVideoSetMode(640, 480, 32, REFRESH_DEFAULT);

    debugPrint("Hello CMake Demo!\n");

    const unsigned char *launchData = NULL;
    unsigned long launchDataType;

    XGetLaunchInfo(&launchDataType, &launchData);

    const char *launchPath = LaunchDataPage->Header.szLaunchPath;
    bool isChild = false;

    if (strstr(launchPath, ChildXbeName) != NULL) {
        debugPrint("Current executable: child.xbe\n");
        isChild = true;
    } 
    else {
        debugPrint("Current executable: default.xbe\n");
    }   

    const char *pathToLaunch = isChild ? DefaultPath : ChildPath;
    debugPrint("Launching %s...\n", pathToLaunch);
    Sleep(3000);
    XLaunchXBE(pathToLaunch);

    return 0;
}