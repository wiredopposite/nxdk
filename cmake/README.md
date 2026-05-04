NXDK CMake Toolchain 
====================

## Libraries
| Name | Description |
| :--- | :--- |
| **nxdk_runtime** | Runtime library required by all targets, contains xboxkrnl, hal, stdlibs, winapi, etc. |
| **nxdk_core** | Core functionality, including drive mounting, filesystem, XBE parsing, and other utilities. |
| **nxdk_libjpeg** | JPEG decoding |
| **nxdk_libpng** | PNG decoding |
| **nxdk_net** | Network library, includes lwip and nxdk net API |
| **nxdk_pbkit** | PBKit graphics library |
| **nxdk_sdl** | SDL2 and related libraries (SDL2_image, SDL_tff) |
| **nxdk_usb** | USB host stack, include all available drivers. Individual components are available (nxdk_usb_core, nxdk_usb_hid, etc.) if you don't need all drivers. |
| **nxdk_zlib** | Zlib compression library |

## API
See cmake/API.md for list of CMake methods available for use.

## Dependencies
 - **cmake**
 - **ninja**
 - **clang/clang++**
 - **lld-link**
 - **flex/bison** (Only required if compiling shaders.)
 - **dlltool** (Only required if regenerating libxboxkrnl.lib)

On Linux all deps can be installed with
```bash
sudo apt update
sudo apt install cmake ninja-build lld llvm clang flex bison
```
On Windows you can install CMake, Ninja, LLVM, and WinFlexBison and you'll have everything.

## Usage
```cmake
cmake_minimum_required(VERSION 3.5)

# Set NXDK toolchain
set(CMAKE_TOOLCHAIN_FILE "/path_to_nxdk/cmake/toolchain.cmake")

project(my_project C)

add_subdirectory("/path_to_nxdk" nxdk)

add_executable(my_project src/main.c)

# Add desired nxdk libs
target_link_libraries(my_project 
    PRIVATE 
        nxdk_core 
        nxdk_libpng 
        nxdk_pbkit
)

# Add and compile any shaders your project requires
nxdk_add_shaders(my_project ps.ps.cg vs.vs.cg)

# Add any required assets so they're copied to the output
nxdk_add_assets(my_project FILES my_image.png)

# Convert executable to XBE
nxdk_generate_xbe(my_project)

# Convert disc structure to XISO post build
nxdk_generate_xiso(my_project)

```

See `samples/CMakeLists.txt` and `samples/cmake_demo/CMakeLists.txt` for another basic usage example.

## Build Samples
```
git clone --recursive https://github.com/XboxDev/nxdk.git
cd nxdk/samples
cmake -S . -B build -G Ninja
cmake --build build
```
