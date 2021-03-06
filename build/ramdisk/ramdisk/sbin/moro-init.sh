#!/system/bin/sh
# 
# Init MoRoKernel
#

OLD_LOG="/data/morokernel.log"
MORO_DIR="/data/.morokernel"
LOG="$MORO_DIR/morokernel.log"

rm -f $LOG
rm -f $OLD_LOG

BB="/sbin/busybox"
RESETPROP="/sbin/magisk resetprop -v -n"


# Mount
$BB mount -t rootfs -o remount,rw rootfs
$BB mount -o remount,rw /system
$BB mount -o remount,rw /data
$BB mount -o remount,rw /

# Create morokernel folder
if [ ! -d $MORO_DIR ]; then
	$BB mkdir -p $MORO_DIR;
fi


(
	$BB echo $(date) "MoRo-Kernel LOG" >> $LOG
	$BB echo " " >> $LOG

	# Fake Knox 0
	$BB echo "## -- Fake Knox 0" >> $LOG
	$RESETPROP ro.boot.warranty_bit "0"
	$RESETPROP ro.warranty_bit "0"
	$BB echo " " >> $LOG

	# Fix safetynet
	$BB echo "## -- SafetyNet" >> $LOG
	$RESETPROP ro.build.fingerprint "samsung/hero2ltexx/hero2lte:8.0.0/R16NW/G935FXXU2EREM:user/release-keys"
	$BB echo " " >> $LOG

	# Samsung related flags
	$BB echo "## -- Samsung Flags" >> $LOG
	$RESETPROP ro.fmp_config "1"
	$RESETPROP ro.boot.fmp_config "1"
	$BB echo " " >> $LOG


) 2>&1 | tee -a ./$LOG

$BB chmod 777 $LOG

# Unmount
$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,ro /system
$BB mount -o remount,rw /data
$BB mount -o remount,ro /

