#!/bin/bash
# http://dev.classmethod.jp/etc/centos-on-ec2-disksize-change/

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
  echo "==> Applying updates"
  sudo yum install -y dracut-modules-growroot
  sudo /sbin/dracut --force --add growroot /boot/initramfs-$(uname -r).img
  sleep 10
  sudo /sbin/reboot
  sleep 120
fi
