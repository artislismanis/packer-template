
Vagrant.configure("2") do |config|
    # Get the root folder of the box
    box_root = File.expand_path(File.dirname(__FILE__))
    # Read username
    user_username = File.read(File.join(box_root, "box.username")).strip
    # Reference customised username and SSH key
    config.ssh.username = user_username
    config.ssh.private_key_path = File.join(box_root, "box.key")
    # Copy box information files to the Vagrant project folder for reference
  	FileUtils.mkdir_p("boxinfo") if File.directory?("boxinfo") == false
    FileUtils.cp(File.join(box_root, "box.key"),"boxinfo/box.key") if File.exists?("boxinfo/box.key") == false
	  FileUtils.cp(File.join(box_root, "box.password"),"boxinfo/box.password") if File.exists?("boxinfo/box.password") == false
    FileUtils.cp(File.join(box_root, "box.username"),"boxinfo/box.username") if File.exists?("boxinfo/box.username") == false
end