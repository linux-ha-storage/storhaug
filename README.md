# storhaug
Pacemaker-based HA solution for clustered storage platforms

Currently this is a WIP content dump. If you want to get this up and running, don't hesitate to ask. :)

The author will update the project documentation properly once he is not jetlagged. ( EDIT: 1 year later, jetlagged again. :( )

Some quick notes:
 * This is currently primarily aimed at CentOS 6 and 7.
 * The project includes a vagrant+ansible environment to quickly setup a virtual storhaug cluster.
   * To be able to run this on a Fedora machine, install the following packages: `vagrant-libvirt ansible`
   * From the vagrant-ansible directory, run `vagrant status`. This will produce a default `vagrant.yaml` configuration file to define the VM environment. Review the settings, then run`vagrant up`.
   * If you're developing with this, it is highly reocmmended to do the following:
     * Install vagrant-cachier: `vagrant plugin install vagrant-cachier`
     * Use `scripts/vagrant-refresh.sh` to manipulate/update your VMs. This helps work around the problem where Ansible provisioning triggers before Vagrant has finished rsync operations.
