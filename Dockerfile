FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Makassar
ENV CUPSADMIN=print
ENV CUPSPASSWORD=admin1234
# Install Packages (basic tools, cups, basic drivers, HP drivers).
# See https://wiki.debian.org/CUPSDriverlessPrinting,
#     https://wiki.debian.org/CUPSPrintQueues
#     https://wiki.debian.org/CUPSQuickPrintQueues
# Note: printer-driver-all has been removed from Debian testing,
#       therefore printer-driver-* packages are manuall added.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
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
      printer-driver-gutenprint \
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
      --password=$(mkpasswd ${CUPSPASSWORD}) \
      ${CUPSADMIN} \
  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Copy sane cupsd.conf
COPY stuff/cupsd.conf /etc/cups/cupsd.conf

# Backup config & allow override
RUN cp -rp /etc/cups /etc/cups-bak
VOLUME ["/etc/cups"]

CMD ["/usr/sbin/cupsd", "-f"]