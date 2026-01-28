ARG FRM='debian:stable-slim'

FROM ${FRM}

# Install Packages (basic tools, cups, basic drivers, HP drivers).
# See https://wiki.debian.org/CUPSDriverlessPrinting,
#     https://wiki.debian.org/CUPSPrintQueues
#     https://wiki.debian.org/CUPSQuickPrintQueues
# Note: printer-driver-all has been removed from Debian testing,
#       therefore printer-driver-* packages are manuall added.
RUN apt-get update \
&& apt-get install -y \
  sudo \
  whois \
  usbutils \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  cups-browsed \
  foomatic-db-engine \
  foomatic-db-compressed-ppds \
  openprinting-ppds \
  hp-ppd \
  printer-driver-brlaser \
  printer-driver-gutenprint \
  smbclient \
  avahi-utils \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Copy the default configuration file
COPY stuff /temp
RUN chmod +x /temp/install.sh \
    && /bin/bash /temp/install.sh \
    && rm -f /temp/install.sh

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
