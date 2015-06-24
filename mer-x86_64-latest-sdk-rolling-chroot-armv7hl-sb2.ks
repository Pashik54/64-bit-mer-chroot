#version=DEVEL
user --groups=audio,video --name=mer --password=rootme
# Keyboard layouts
keyboard us# Root password
rootpw --plaintext rootme
# System language
lang en_US.UTF-8
# Installation logging level
logging --level=info

# System timezone
timezone --isUtc UTC
# Default Desktop Settings
desktop  --autologinuser=meego
repo --name="mer-core-x86_64" --baseurl=http://repo.merproject.org/obs/mer-core:/x86_64:/devel/Core_x86_64/ --save --debuginfo --ssl_verify=yes
repo --name="mer-cross-tools-x86_64" --baseurl=http://releases.merproject.org/releases/latest/builds/x86_64/cross/ --save --debuginfo --ssl_verify=yes
repo --name="mer-tools-x86_64" --baseurl=http://repo.merproject.org/obs/mer-tools:/stable/latest_x86_64/ --save --debuginfo --ssl_verify=yes
repo --name="mer-core-devel-x86_64" --baseurl=http://repo.merproject.org/obs/home:/siteshwar:/branches:/mer-core:/devel/Core_armv7hl/ --save --debuginfo --ssl_verify=yes

repo --name="mer-tools-devel-x86_64" --baseurl=http://repo.merproject.org/obs/home:/siteshwar:/branches:/mer-tools:/devel/latest_x86_64/ --save --debuginfo --ssl_verify=yes
# Disk partitioning information
part / --fstype="ext4" --ondisk=sda --size=500

%post
## mtab.script from sdk-kickstarter-configs package
# Normally /etc/mtab is provided by systemd
#
rm -f /etc/mtab
ln -s /proc/self/mounts /etc/mtab
# end mtab.script

## tmp_perms.script from sdk-kickstarter-configs package
# Fix /tmp sticky bit
chmod 1777 /tmp
# end tmp_perms.script

## sdk_stamp.script from sdk-kickstarter-configs package
# Ensure this chroot is marked as an SDK
echo "MerSDK" > /etc/MerSDK
# end sdk_stamp.script

## rpm-rebuilddb.post from mer-kickstarter-configs package
# Rebuild db using target's rpm
echo -n "Rebuilding db using target rpm.."
rm -f /var/lib/rpm/__db*
rpm --rebuilddb
echo "done"
## end rpm-rebuilddb.post

## prelink.post from mer-kickstarter-configs package
# Prelink can reduce boot time
if [ -x /usr/sbin/prelink ]; then
   echo -n "Running prelink.."
   /usr/sbin/prelink -aRqm
   echo "done"
fi
## end prelink.post


%end

%packages
#@Mer Connectivity
bluez
connman
crda
iproute
iputils
net-tools
ofono
wireless-tools
wpa_supplicant
#@Mer Core
basesystem
bash
boardname
coreutils
deltarpm
e2fsprogs
file
filesystem
fontpackages-filesystem
kbd
lsb-release
mer-release
nss
pam
passwd
prelink
procps
readline
rootfiles
rpm
setup
shadow-utils
shared-mime-info
#systemd-sysv
time
usbutils
util-linux
xdg-user-dirs
zypper

#@Mer-SB2-armv7hl

sdk-sb2-config
qemu-usermode
cross-armv7hl-gcc
cross-armv7hl-binutils
mpc

#@Mer-development-tools
gcc
gcc-c++
make
gdb
binutils
automake
#git
patch

#@Mer-image-creation
#mic
mer-kickstarter
psmisc
#qemu-usermode-static
repomd-pattern-builder

#@Mer-packaging
osc
spectacle
build
bsdtar
sdk-utils

#extra
net-tools
sdk-chroot
sdk-utils
sudo
#vim

%end
