################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="xmlrpc-c"
PKG_VERSION="1.39.07"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://xmlrpc-c.sourceforge.net"
PKG_URL="https://netix.dl.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/$PKG_VERSION/xmlrpc-c-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain libressl curl zlib libxml2 libsigc++"
PKG_PRIORITY="optional"
PKG_SHORTDESC=""
PKG_LONGDESC=""
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Daniel Forsberg (jenkins101)"

PKG_CONFIGURE_OPTS_TARGET="have_xml2_config=yes \
            CURL_CONFIG=$SYSROOT_PREFIX/usr/bin/curl-config \
            --enable-libxml2-backend \
            --disable-nls \
            --disable-cplusplus \
            --disable-libwww-client \
            --disable-wininet-client \
            --disable-abyss-server \
            --disable-cgi-server"

pre_build_target() {
  # fix curl includes
  sed -i -e '/curl\/types.h/d' $PKG_BUILD/lib/curl_transport/curlmulti.c
  sed -i -e '/curl\/types.h/d' $PKG_BUILD/lib/curl_transport/curltransaction.c
  sed -i -e '/curl\/types.h/d' $PKG_BUILD/lib/curl_transport/xmlrpc_curl_transport.c

  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_configure_target() {
  # hack
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/libxml2"
  export MAKEFLAGS="-j1"
}

post_makeinstall_target() {
  sed -i "s:/usr/include:$LIB_PREFIX/include:g" $SYSROOT_PREFIX/usr/bin/xmlrpc-c-config
  sed -i "s:/usr/lib:$LIB_PREFIX/lib:g" $SYSROOT_PREFIX/usr/bin/xmlrpc-c-config
}
