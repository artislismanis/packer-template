#!/bin/bash -eux

# This needs to be the very last step in the provisioning process or packer will error out
# if a reboot is required. 

echo "==> Re-setting user password..."

if [[ "$USER_REGENERATE_SECRETS" = "true" ]]
then
	# Reset user password to one generated before
	NEW_PASSW=$(cat /home/${USER_USERNAME}/${VM_NAME}.password)
	echo -e "$NEW_PASSW\n$NEW_PASSW" | passwd ${USER_USERNAME}
	# Remove files with auto-generated secrets
	rm /home/${USER_USERNAME}/${VM_NAME}.password
	rm /home/${USER_USERNAME}/${VM_NAME}.key
fi
