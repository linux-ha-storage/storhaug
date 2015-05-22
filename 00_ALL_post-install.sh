#!/bin/bash
# Prior to this, install base OS, configure the NICs, and set hostnames

# Install EPEL
echo "Installing EPEL"

verarch=(`yum version nogroups | grep "Installed" | cut -d \  -f 2 | tr \/ \ `)
vers=${verarch[0]}
arch=${verarch[1]}

rpm --import http://ftp-stud.hs-esslingen.de/pub/epel//RPM-GPG-KEY-EPEL-$vers
rpm -Uvh http://ftp-stud.hs-esslingen.de/pub/epel/epel-release-latest-$vers.noarch.rpm

echo "Adding repos"
# Configure repos for Gluster-related dependencies.
cat >/etc/yum.repos.d/gluster.repo <<EOF
[glusterfs-epel]
name=GlusterFS is a clustered file-system capable of scaling to several petabytes.
baseurl=http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-\$releasever/\$basearch/
enabled=1
skip_if_unavailable=1
gpgcheck=0
gpgkey=http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key

[glusterfs-noarch-epel]
name=GlusterFS is a clustered file-system capable of scaling to several petabytes.
baseurl=http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-\$releasever/noarch
enabled=1
skip_if_unavailable=1
gpgcheck=0
gpgkey=http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key

[glusterfs-source-epel]
name=GlusterFS is a clustered file-system capable of scaling to several petabytes. - Source
baseurl=http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-\$releasever/SRPMS
enabled=0
skip_if_unavailable=1
gpgcheck=0
gpgkey=http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key

[nfs-ganesha-epel]
name=NFS-Ganesha
baseurl=http://download.gluster.org/pub/gluster/glusterfs/nfs-ganesha/EPEL.repo/epel-\$releasever/\$basearch/
enabled=1
skip_if_unavailable=1
gpgcheck=0

[nfs-ganesha-noarch-epel]
name=NFS-Ganesha
baseurl=http://download.gluster.org/pub/gluster/glusterfs/nfs-ganesha/EPEL.repo/epel-\$releasever/noarch
enabled=1
skip_if_unavailable=1
gpgcheck=0

[nfs-ganesha-source-epel]
name=NFS-Ganesha
baseurl=http://download.gluster.org/pub/gluster/glusterfs/nfs-ganesha/EPEL.repo/epel-\$releasever/SRPMS
enabled=0
skip_if_unavailable=1
gpgcheck=0

[glusterfs-samba-epel]
name=GlusterFS-Samba
baseurl=http://download.gluster.org/pub/gluster/glusterfs/samba/EPEL.repo/epel-\$releasever/\$basearch/
enabled=1
skip_if_unavailable=1
gpgcheck=0

[glusterfs-samba-source-epel]
name=GlusterFS-Samba Source
baseurl=http://download.gluster.org/pub/gluster/glusterfs/samba/EPEL.repo/epel-\$releasever/SRPMS/
enabled=0
skip_if_unavailable=1
gpgcheck=0
EOF

echo "Make sure IPv6 is enabled! ( https://access.redhat.com/solutions/8709#rhel6enable )"
echo "Make sure all hosts know about each other! (edit /etc/hosts or setup DNS)"
echo "Don't forget to upload shared public SSH keys!!"
