Original Form [mwatz1234/cupsd](https://github.com/mwatz1234/cupsd)

# CUPS print server image

## Overview

This is a docker image based from olbat/cupsd, but edited to support ARM devices

Multi-arch image built for both Raspberry Pi (arm64, arm32/v7, arm32/v6) and amd64.

Below is an docker compose example.

```
services:
  cups:
    image: mwatz/cups:latest # admin user/password: print/print
    container_name: cups
    privileged: true
    volumes:
      - /dev/bus/usb:/dev/bus/usb # keep this under volumes, not devices
      - /run/dbus:/run/dbus
      - ./etc/cups/cupsd.conf:/etc/cups/cupsd.conf
      - ./etc/cups/printers.conf:/etc/cups/printers.conf
    ports:
      - 631:631/tcp # CUPS
    restart: always
    environment:
      - TZ=America/Los_Angeles
```

## Usage:

For addional information refer to [olbat/cupsd](https://github.com/olbat/dockerfiles/tree/master/cupsd).
