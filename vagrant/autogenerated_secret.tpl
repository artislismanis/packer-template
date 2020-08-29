# Box template level settings
# https://www.vagrantup.com/docs/vagrantfile/



Vagrant.configure("2") do |config|

    # Install vagrant-vbguest plugin to help manage VB Guest Additions 
    config.vagrant.plugins = "vagrant-vbguest"
    
    # Get the root folder of the box
    box_root = File.expand_path(File.dirname(__FILE__))
    # Read username
    user_username = File.read(File.join(box_root, "box.username")).strip
    
    # Reference customised username and SSH key
    config.ssh.username = user_username
    config.ssh.private_key_path = File.join(box_root, "box.key")

    # Copy box information files to the Vagrant project folder for reference
    config.trigger.before [:up] do |trigger|
        trigger.name = "Box Template User & Secrets"
        trigger.info = "Getting default box login information..."
        trigger.ruby do |env,machine|
            FileUtils.mkdir_p("boxinfo") if File.directory?("boxinfo") == false && File.exists?("vagrantfile")
            FileUtils.cp(File.join(box_root, "box.key"),"boxinfo/box.key") if File.exists?("boxinfo/box.key") == false && File.exists?("vagrantfile")
            FileUtils.cp(File.join(box_root, "box.password"),"boxinfo/box.password") if File.exists?("boxinfo/box.password") == false && File.exists?("vagrantfile")
            FileUtils.cp(File.join(box_root, "box.username"),"boxinfo/box.username") if File.exists?("boxinfo/box.username") == false && File.exists?("vagrantfile")
        end
    end
    config.trigger.after [:destroy] do |trigger|
        trigger.name = "Box Template User & Secrets"
        trigger.info = "Removing default box login information..."
        trigger.ruby do |env,machine|
            FileUtils.rm_rf("boxinfo") if File.directory?("boxinfo") && File.exists?("vagrantfile")
        end
    end
    # Default provisioning steps
    config.vm.provision "shell", inline: <<-EOF
        echo "Extending Logical Volume to use all available space on VM"
        lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
        resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
    EOF
end