#!/sbin/sh

## MUST CHANGE TO YOUR ROM NAME ##
ROMNAME=noobdev-cm-11.0

PROP=/tmp/dualboot.prop

write_prop() {
  if [ -f /system/.dualboot ]; then
    echo 'ro.dualboot=1' > $PROP
  else
    echo 'ro.dualboot=0' > $PROP
  fi
}

set_secondary() {
  echo $ROMNAME > /system/.secondary
}

set_secondary_kernel() {
  dd if=/dev/block/platform/msm_sdcc.1/by-name/boot of=/raw-system/dual-kernels/secondary.img
}

mount_system() {
  mkdir -p /raw-system /system
  chmod 0755 /raw-system
  chown 0:0 /raw-system
  mount -t $1 $2 /raw-system
  mkdir -p /raw-system/dual
  mount -o bind /raw-system/dual /system
}

unmount_system() {
  umount /system
  umount /raw-system
}

case "$1" in
  is-dualboot)
    write_prop
    ;;
  set-secondary)
    set_secondary
    ;;
  set-secondary-kernel)
    set_secondary_kernel
    ;;
  mount-system)
    mount_system $2 $3
    ;;
  unmount-system)
    unmount_system
    ;;
esac
