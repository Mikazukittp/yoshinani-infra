#!/bin/bash
if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
  echo "==> Applying updates"

  echo "include_only=.ja" | sudo tee -a /etc/yum/pluginconf.d/fastestmirror.conf
  sudo yum install -y epel-release
  sudo yum update -y

  sudo /sbin/reboot
  sleep 60
fi
