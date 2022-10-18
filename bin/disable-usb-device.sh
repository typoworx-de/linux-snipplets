#!/bin/bash

[[ -z "${@}" ]] && {
  echo "Syntax: $(basename $0) {vendorId}:{productId}";
  echo;
  exit 1;
}

getdevice()
{
    idV=${1%:*}
    idP=${1#*:}
    for path in `LC_ALL=C find /sys/ -name idVendor 2>&1 | grep -v 'Permission denied' | rev | cut -d/ -f 2- | rev`;
    do
        if grep -q $idV $path/idVendor; then
            if grep -q $idP $path/idProduct; then
                LC_ALL=C find $path -name 'authorized' -exec sh -c 'echo 0 | sudo tee {} > /dev/null' \; -quit 2>&1 | grep -v 'Permission denied';

                [[ $(cat /sys/devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6.2/1-6.2:1.0/authorized) == 0 ]] && {
                    return 0;
                }
            fi
        fi
    done

    return 1;
}

getdevice "${1}" && {
  echo 'Success';
  exit 0;
}

exit 1;
