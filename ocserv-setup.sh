#!/bin/sh

####
# 安装 Cisco AnyConnect 证书验证环境 @CentOS 6.6
####

yum install -y http://mirror.umd.edu/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
yum install -y autoconf automake gcc gmp-devel bison flex  pcre-devel tar net-tools  openssl openssl-devel curl-devel bind-utils  libtasn1-devel zlib zlib-devel trousers trousers-devel gmp-devel gmp xz texinfo libnl-devel libnl tcp_wrappers-libs tcp_wrappers-devel tcp_wrappers dbus dbus-devel ncurses-devel pam pam-devel readline-devel bison bison-devel flex gcc automake autoconf wget expat-devel unbound
yum erase -y gnutls



mkdir /tmp/build && cd /tmp/build
wget http://www.lysator.liu.se/~nisse/archive/nettle-2.7.tar.gz
tar xvf nettle-2.7.tar.gz
cd nettle-2.7
./configure --prefix=/opt/
make && make install
cd ..



wget ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.12.tar.xz
tar xvf gnutls-3.2.12.tar.xz
cd gnutls-3.2.12
export LD_LIBRARY_PATH=/opt/lib/:/opt/lib64/ NETTLE_CFLAGS="-I/opt/include/" NETTLE_LIBS="-L/opt/lib64/ -lnettle" HOGWEED_CFLAGS="-I/opt/include" HOGWEED_LIBS="-L/opt/lib64/ -lhogweed"
./configure --prefix=/opt/
make && make install
cd ..



wget http://www.carisma.slowglass.com/~tgr/libnl/files/libnl-3.2.25.tar.gz
tar xvf libnl-3.2.25.tar.gz
cd libnl-3.2.25
./configure --prefix=/opt/
make && make install
cd ..



wget ftp://ftp.infradead.org/pub/ocserv/ocserv-0.8.7.tar.xz
tar xvf ocserv-0.8.7.tar.xz
cd ocserv-0.8.7
export LD_LIBRARY_PATH=/opt/lib/:/opt/lib64/ LIBGNUTLS_CFLAGS="-I/opt/include/" LIBGNUTLS_LIBS="-L/opt/lib/ -lgnutls" LIBNL3_CFLAGS="-I/opt/include" LIBNL3_LIBS="-L/opt/lib/ -lnl-3 -lnl-route-3"
./configure --prefix=/opt/
make && make install && cd ..

useradd -b /var/lib -u 998 -s /sbin/nologin -U ocserv



####
# 配置环境变量
####

echo "export LD_LIBRARY_PATH=/opt/lib/:/opt/lib64/">> /etc/rc.local
echo "export PATH=$PATH:/opt/sbin:/opt/bin">> /etc/rc.local
source /etc/rc.local
echo "export LD_LIBRARY_PATH=/opt/lib/:/opt/lib64/">> /etc/profile.d/export.sh
echo "export PATH=$PATH:/opt/sbin:/opt/bin">> /etc/profile.d/export.sh
source /etc/rc.local



####
# 下载证书生成文件
####

rm -f /opt/sbin/ocserv-genkey
pushd /opt/sbin
wget https://raw.githubusercontent.com/karevos/ocserv/master/ocserv-genkey
chmod a+x ocserv-genkey
popd



####
# 下载配置文件
####

rm -rf  /etc/ocserv
mkdir /etc/ocserv
pushd /etc/ocserv
wget https://raw.githubusercontent.com/karevos/ocserv/master/ocserv.conf
popd


exit 0
