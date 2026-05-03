# CMake API

```cmake
nxdk_add_target(<target> [DISC <disc>])
```
| Argument | Required | Description |
| :---- | :---- | :---- |
| `<target>` | Yes | Executable CMake target to associate the disc with, makes sure any other operations related to the disc are aware of this target.
| `DISC` | No | Name of the disc this target belongs to. Defaults to `<target>` if not specified. Multiple targets can share a disc. |

##

```cmake
nxdk_generate_xbe(<target> 
                  [DISC <disc>] 
                  [PATH <path>] 
                  [TITLE <title>]
                  [DEVKIT])
```
| Argument | Required | Description |
| :---- | :---- | :---- |
| `<target>` | Yes | Executable CMake target used to generate the XBE. |
| `DISC` | No | Name of the disc this XBE belongs to. Defaults to `<target>` if not specified. Multiple XBEs can share a disc and multiple discs can have the name xbe. Disc directory will be `"bin/<disc>"`. |
| `PATH` | No | Relative output path on the disc, including filename. Defaults to "/default.xbe" if not specified. |
| `TITLE` | No | XBE title, written to the XBE header. Defaults to `<target>` if not specified. |
| `DEVKIT` | No | If set, will indicate non-kernel import table should be kept in the resulting XBE. Meant for linking against XBDM. |

##

```cmake
nxdk_add_shaders(<target> <shaders...>)
```
| Argument | Required | Description |
| :---- | :---- | :---- |
| `<target>` | Yes | Executable CMake target to include shaders for. |
| `<shaders...>` | Yes | List of shaders to be compiled to .inl and included in the target. Takes .ps/.vs files. |

##

```cmake
nxdk_generate_xiso(<target> [DISC <disc>])
```
| Argument | Required | Description |
| :---- | :---- | :---- |
| `<target>` | Yes | Executable CMake target, only required to ensure XISO is ran post-build on the disc. |
| `DISC` | No | Name of the disc this XISO is generated from. Defaults to `<target>` if not specified. Multiple targets can share a disc/XISO. |

##

```cmake
nxdk_add_assets(<target> 
                [DISC <disc>] 
                [FILES <files>] 
                [DIRECTORIES <directories>] 
                [CONTENTS <contents>])
```
| Argument | Required | Description |
| :---- | :---- | :---- |
| `<target>` | Yes | Executable CMake target, only required to ensure copy operations are ran post-build on the disc. |
| `DISC` | No | Name of the disc assets belong to. Defaults to `<target>`. |
| `FILES` | No | List of files to add to the root of the disc. |
| `DIRECTORIES` | No | List of directories to add to the root of the disc, along with their contents. Directory structure will be preserved.
| `CONTENTS` | No | List of directories to add the contents of to the root of the disc. Directory structure will be  preserved from the root of the directory (i.e. contents of `"assets/dir"` will be added to the root of the disc, not to `"assets/dir"` on the disc). |
- **Note:** This does not need to be called multiple times for multiple targets sharing a disc, as long as all targets have been associated with the same disc name using other methods like `nxdk_generate_xbe` or `nxdk_generate_xiso`.

##

```cmake
nxdk_add_binaries(<target> <<header_name>=<binary_file>...>)
```
| Argument | Required | Description |
| :---- | :---- | :---- |
| `<target>` | Yes | Executable CMake target to include the binary headers for. |
| `<<header_name>=<binary_file>...>` | Yes | List of binary files to be converted to header files and included in the target. Generates a header with a byte array containing the binary data, along with size information. Array names are based on the header file name (e.g. "data.h" -> "data" "data_size"). |
- **Usage example:**
```cmake
nxdk_add_binaries(my_target 
    data1.h=data1.bin 
    data2.h=data2.bin
)
```