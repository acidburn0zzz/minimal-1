#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GENERATE ISO (UEFI) BEGIN ***"

FORCE_UEFI=`read_property FORCE_UEFI`

if [ ! "$FORCE_UEFI" = "true" ] ; then
  echo "Skipping ISO image preparation for UEFI systems."
  exit 0
fi

if [ ! -d $ISOIMAGE ] ; then
  echo "ISO image work folder does not exist. Cannot continue."
  exit 1
fi

cd $ISOIMAGE

# Now we generate the ISO image file.

# This generates ISO image with BIOS and UEFI compatible structure.
#xorriso -as mkisofs \
#  -isohybrid-mbr $WORK_DIR/syslinux/syslinux-*/bios/mbr/isohdpfx.bin \
#  -c boot.cat \
#  -b isolinux.bin \
#    -no-emul-boot \
#    -boot-load-size 4 \
#    -boot-info-table \
#  -eltorito-alt-boot \
#  -e uefi.img \
#    -no-emul-boot \
#    -isohybrid-gpt-basdat \
#  -o $SRC_DIR/minimal_linux_live.iso \
#  $ISOIMAGE

# This generates ISO image with UEFI compatible structure.
xorriso -as mkisofs \
  -isohybrid-mbr $WORK_DIR/syslinux/syslinux-*/bios/mbr/isohdpfx.bin \
  -c boot.cat \
  -e uefi.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
  -o $SRC_DIR/minimal_linux_live.iso \
  $ISOIMAGE

cd $SRC_DIR

cat << CEOF

  #################################################################
  #                                                               #
  #  ISO image file 'minimal_linux_live.iso' has been generated.  #
  #                                                               #
  #################################################################

CEOF

echo "*** GENERATE ISO (UEFI) END ***"
