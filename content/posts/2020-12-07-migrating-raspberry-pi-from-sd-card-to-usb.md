---
title: "Migrating Raspberry Pi From Sd Card to Usb"
date: 2020-12-07T12:52:07-05:00
tags:
- raspberrypi
---

I've been running my Kubernetes cluster on Raspberry Pis for about a year now. Overall the cluster is stable and needs
little attention and by now many useful and important services are now running on it. With more reliance on these
services I need to ensure that the cluster doesn't fail from preventable errors. One of the common failure modes for
Raspberry Pis are sdcards. They are not very fast, they are of limited size, and worst, they tend to fail.

<!-- more -->

In order to avoid this I've been researching how to attach reliable mass storage and how to boot from them. Eventually I
settled on [Geekworm's](https://geekworm.com/) [X857](https://raspberrypiwiki.com/X857) expansion board for the
Raspberry Pi 4b and the [X850](https://raspberrypiwiki.com/X850) for the 3b models. To go with these I bought msata
drives, nothing crazy because the workloads don't require lots of storage. Installation is straightforward and for the
first one I simply mounted the msata drive into the system running of the sdcard. That worked, but what I really want is
the entire system to run off the SSD instead of the card. It took a little research on how to do this and here are the
steps I've take to successfully boot my PI 4b from msata without an sdcard.

## Initial Research

I've poked around a little and found [this thread on how to move the filesystem to USB
drive](https://www.raspberrypi.org/forums/viewtopic.php?p=351659&sid=3cd59f94982d688f8c86452fa5ca5e36#p351659) on the
raspberrypi forums very helpful. This article on [how to boot the Pi 4 from a USB
SSD](https://www.tomshardware.com/how-to/boot-raspberry-pi-4-usb) was also very useful.

But what all guides relied on sdcard copier which is a GUI app was not an option on my headless machine. So I set out to
copy the system myself and that requires a few things:

1.  creating partitions and filesystems
1.  copy filesystems
1.  update boot configuration in new filesystem
1.  reboot without sdcard

## Step by Step

### Creating Partitions and Filesystems

The ssd is registered as `/dev/sda`. Use `lsblk` to identify and check if it's properly running:
```
$ sudo lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 111.8G  0 disk
```

I followed the partition layout of the sdcard (which is `/dev/mmcblk0`). One small boot partition and one for the
operating system:

```
$ sudo fdisk -l /dev/mmcblk0
Disk /dev/mmcblk0: 14.9 GiB, 15931539456 bytes, 31116288 sectors
Units: sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x5e3da3da

Device         Boot  Start      End  Sectors  Size Id Type
/dev/mmcblk0p1        8192   532479   524288  256M  c W95 FAT32 (LBA)
/dev/mmcblk0p2      532480 31116287 30583808 14.6G 83 Linux
```

I created a new dos type partition table, and created a boot partition of type fat32, marked it as bootable, a system
partition, and I did add a separate partition for `/var/` and for `/data`. The final partition table looks like this:

```
$ sudo fdisk -l /dev/sda
Disk /dev/sda: 111.8 GiB, 120034123776 bytes, 234441648 sectors
Disk model:  SUV500MS120G
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x8459def4

Device     Boot     Start       End   Sectors  Size Id Type
/dev/sda1  *         2048    526335    524288  256M  c W95 FAT32 (LBA)
/dev/sda2          526336  34080767  33554432   16G 83 Linux
/dev/sda3        34080768 117966847  83886080   40G 83 Linux
/dev/sda4       117966848 234441647 116474800 55.6G 83 Linux
```

Next up I created the filsystems. For the boot partition `mkfs.fat /dev/sda1`. For the remaining partitions `mkfs.ext4
-L ROOT /dev/sda2`, `mkfs.ext4 -L VAR /dev/sda3`, and `mkfs.ext4 -L DATA /dev/sda4`. Now the drive is ready for copying.

### Copy Filesystems

For this step I choose to copy the fileystem from running system, so I shut down all the non-essential services. Might
have been smarter to us a second system to do so, but it worked well enough.

The flow is straightforward: mount the path, copy the files, unmount.

For `/boot/`: `sudo mount /dev/sda1 /mnt`, `sudo rsync -vax /boot/ /mnt/`, `sudo umount /mnt`.
For `/`: `sudo mount /dev/sda2 /mnt`, `sudo rsync -vax --exclude /var / /mnt/`, `sudo umount /mnt`.
For `/var`: `sudo mount /dev/sda3 /mnt`, `sudo rysnc -vax /var/ /mnt/`, `sudo umount /mnt`.

### Update Boot Configuration

Two files have to be updated to boot from the new drive: `/boot/cmdline.txt` and `/etc/fstab`. Note that these files
live on the new drive, so you'll have to mount the drive and use appropriate paths. Partitions are identified
by their their PARTUUID which you can get from `blkid`:

```
$ sudo blkid
/dev/sda1: SEC_TYPE="msdos" UUID="45C8-6810" TYPE="vfat" PARTUUID="8459def4-01"
/dev/sda2: LABEL="ROOT" UUID="fa266b1d-c288-429c-8efb-674b3ab7510b" TYPE="ext4" PARTUUID="8459def4-02"
/dev/sda3: LABEL="VAR" UUID="0202f3fc-4997-4d01-ae79-52f1f9d8182a" TYPE="ext4" PARTUUID="8459def4-03"
/dev/sda4: LABEL="DATA" UUID="28cc5c24-0f23-4224-9a55-a298e34ee9a2" TYPE="ext4" PARTUUID="8459def4-04"
```

Mount new boot drive via `sudo mount /dev/sda1 /mnt`.
Now we can update `/mnt/cmdline.txt` to set the `root` field:
```
root=PARTUUID=8459def4-02
```
Unmount drive `umount /mnt`. Now mount the new root partition: `mount /dev/sda2 /mnt`.
Then we have to update `/mnt/etc/fstab` to mount the correct partitions:
```
proc            /proc           proc    defaults          0       0
PARTUUID=8459def4-01  /boot           vfat    defaults          0       2
PARTUUID=8459def4-02  /               ext4    defaults,noatime  0       1
PARTUUID=8459def4-03  /var            ext4    defaults,noatime  0       1
PARTUUID=8459def4-04  /data           ext4    defaults,noatime  0       1
```

Unmount and we're done: `sudo umount /mnt`.

### Reboot

Shut down the pi, take out the sdcard, and start it. It should boot from the msata drive and it should run a lot faster.

