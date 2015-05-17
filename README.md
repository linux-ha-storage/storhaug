# storage-ha
Pacemaker-based HA solution for clustered storage platforms

Currently this is a WIP content dump. If you want to get this up and running, don't hesitate to ask. :)

The author will update the project documentation properly once he is not jetlagged.

Some quick notes:
 * This is currently primarily aimed at CentOS 6.6.
 * Make sure IPv6 is enabled! (Ganesha requirement)
 * If you have a couple VMs you don't mind automating, phd is a useful tool to get things up and running quickly. 
   * Project : https://github.com/davidvossel/phd
   * The included scenario files require at least 2 VMs
   * You'll need valid IP addresses
   * You should also edit /etc/hosts on the VMs so they all know of each other
   * It is recommended you upload an SSH key from your local user to the root account on the VMs. This will speed up automated setup tremendously.
