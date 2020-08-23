# Box template level settings
# https://www.vagrantup.com/docs/vagrantfile/



Vagrant.configure("2") do |config|
    # Install vagrant-vbguest plugin to help manage VB Guest Additions 
    config.vagrant.plugins = "vagrant-vbguest"

    # Default provisioning steps
    config.vm.provision "shell", inline: <<-EOF
        echo "Extending Logical Volume to use all available space on VM"
        lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
        resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
    EOF
end