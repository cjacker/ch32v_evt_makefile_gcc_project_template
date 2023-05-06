#!/bin/bash

PART_LIST="./ch32v-parts-list.txt"

# if no arg,
if [ $# -ne 1 ]; then
  echo "Usage: ./generate_project_from_evt.sh <part>" 
  echo "please specify a ch32v part:"
  while IFS= read -r line
  do
    part=$(echo "$line"|awk -F ' ' '{print $1}'| tr '[:upper:]' '[:lower:]')
    echo "$part"
  done < "$PART_LIST"
  exit
fi

# iterate the part list to found part info.
PART=$1
FLASHSIZE=
RAMSIZE=
STARTUP_ASM=
ZIPFILE=

FOUND="f"

while IFS= read -r line
do
  cur_part=$(echo "$line"|awk -F ' ' '{print $1}'| tr '[:upper:]' '[:lower:]')
  FLASHSIZE=$(echo "$line"|awk -F ' ' '{print $2}')
  RAMSIZE=$(echo "$line"|awk -F ' ' '{print $3}')
  STARTUP_ASM=$(echo "$line"|awk -F ' ' '{print $4}')
  ZIPFILE=$(echo "$line"|awk -F ' ' '{print $5}')
  if [ "$cur_part""x" == "$PART""x" ]; then
    FOUND="t"
    break;
  fi
done < "$PART_LIST"

#if not found
if [ "$FOUND""x" == "f""x" ];then
  echo "Your part is not supported."
  exit
fi

# found
echo "Convert project for $PART"
echo "part : $PART"
echo "flash size : $FLASHSIZE"
echo "ram size : $RAMSIZE"
echo "#########################"

# clean
rm -rf evt_tmp
# remove all sources, copy from EVT later
# do not remove User dir.
rm -rf CH32V_firmware_library Examples

echo "Extract EVT package"
mkdir -p evt_tmp
unzip -q $ZIPFILE -d evt_tmp

# prepare dir structure
mkdir -p CH32V_firmware_library
cp -r evt_tmp/EVT/EXAM/SRC/* CH32V_firmware_library/

if [ ! -d ./User ]; then
  if [ -d evt_tmp/EVT/EXAM/GPIO/GPIO_Toggle ]; then
    cp -r evt_tmp/EVT/EXAM/GPIO/GPIO_Toggle/User ./User
  fi
fi

# prepare examples
mkdir -p Examples
cp -r evt_tmp/EVT/EXAM/* Examples
rm -rf Examples/SRC

# drop evt
rm -rf evt_tmp

echo "Process linker script"
LD_TEMPLATE=
if [[ $PART = ch32v3* ]]; then
  LD_TEMPLATE=Link.ld.template.ch32v3
elif [[ $PART = ch32v2* ]]; then
  LD_TEMPLATE=Link.ld.template.ch32v2
elif [[ $PART = ch32v1* ]]; then
  LD_TEMPLATE=Link.ld.template.ch32v1
elif [[ $PART = ch32v0* ]]; then
  LD_TEMPLATE=Link.ld.template.ch32v0
else
  echo "Part $part is not supported"
  exit
fi

# generate the Linker script
sed -e "s/FLASH_SIZE/$FLASHSIZE/g" $LD_TEMPLATE > CH32V_firmware_library/Ld/Link.ld
sed -i -e "s/RAM_SIZE/$RAMSIZE/g" CH32V_firmware_library/Ld/Link.ld

echo "Generate Makefile"
# collect c files and asm files
find . -path ./Examples -prune -o -type f -name "*.c"|sed -e 's@^\./@@g;s@$@ \\@g' > c_source.list
# drop Examples line in source list.
sed -i -e "/^Examples/d" c_source.list

sed -e "s/C_SOURCE_LIST/$(sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' c_source.list | tr -d '\n')/" Makefile.ch32vtemplate >Makefile
sed -i -e "s/STARTUP_ASM_SOURCE_LIST/CH32V_firmware_library\/Startup\/$STARTUP_ASM/" Makefile

rm -f c_source.list

if [[ $PART = ch32v0* ]]; then
 sed -i -e "s/CPU = -march=rv32imac -mabi=ilp32/CPU = -march=rv32ec -mabi=ilp32e/g" Makefile
fi
sed -i -e "s/CH32VXXX/$PART/g" Makefile

echo "#########################"
echo "Done, project generated, type 'make' to build"

