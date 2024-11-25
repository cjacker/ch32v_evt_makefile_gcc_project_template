# WCH CH32V EVT with GCC and Makefile support

This is a project template with related tools to convert WCH official CH32V EVT package to a GCC and Makefile project.

This template will convert the EVT package to a Makefile project and setup Link.ld according to your MCU, it support All CH32V EVT packages from WCH, include:

- [CH32V003EVT.ZIP](https://www.wch.cn/downloads/CH32V003EVT_ZIP.html) V2.0 2024-10-28
  + CH32V003J4M6
  + CH32V003A4M6
  + CH32V003F4U6
  + CH32V003F4P6
- [CH32X035EVT.ZIP](https://www.wch.cn/downloads/CH32X035EVT_ZIP.html) V1.8 2024-11-07
  + CH32X035R8T6
  + CH32X035C8T6
  + CH32X035G8U6
  + CH32X035G8R6
  + CH32X035F8U6
  + CH32X035F7P6
  + CH32X033F8P6
- [CH32V103EVT.ZIP](https://www.wch.cn/downloads/CH32V103EVT_ZIP.html) V2.6 2024-06-27
  + CH32V103C6T6
  + CH32V103C8U6
  + CH32V103C8T6
  + CH32V103R8T6
- [CH32V20xEVT.ZIP](https://www.wch.cn/downloads/CH32V20xEVT_ZIP.html) V2.2 2024-11-08
  + CH32V203F6P6
  + CH32V203G6U6
  + CH32V203K6T6
  + CH32V203C6T6
  + CH32V203F8P6
  + CH32V203F8U6
  + CH32V203G8R6
  + CH32V203K8T6
  + CH32V203C8T6
  + CH32V203C8U6
  + CH32V203RBT6
  + CH32V208GBU6
  + CH32V208CBU6
  + CH32V208RBT6
  + CH32V208WBU6
- [CH32V307EVT.ZIP](https://www.wch.cn/downloads/CH32V307EVT_ZIP.html) V2.7 2024-11-08
  + CH32V303CBT6
  + CH32V303RBT6
  + CH32V303RCT6
  + CH32V303VCT6
  + CH32V305FBP6
  + CH32V305RBT6
  + CH32V307RCT6
  + CH32V307WCU6
  + CH32V307VCT6

## Usage

Assume you already have 'riscv-none-embed-gcc' toolchain installed. to generate a gcc/makefile project for specific part, type:
```
./generate_project_from_evt.sh <part>
```
If you want to change to another part in same family after project generated, use `./setpart.sh <part>`.

If you do not know which part you should specify, please run `./generate_project_from_evt.sh` directly for help.

After project generated, there is a 'User' dir contains the codes you should write or modify. By default, it use the 'GPIO_Toggle' example from EVT package.

Then type `make` to build the project.

The `<part>.elf` / `<part>.bin` / `<part>.hex` will be generated at 'build' dir and can be programmed to target device later.

