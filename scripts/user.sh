#!/bin/bash -eux

echo "==> Updating default user details..."

# Remove default user set up by OS install
# Doing this part of the cloud-init script reports error
deluser --remove-home ubuntu

# Modify the user and set full name
usermod -c "${USER_FULLNAME}" ${USER_USERNAME}

# Set supplied SSH public key as authorised key or autogenerate new key and user password 
mkdir /home/${USER_USERNAME}/.ssh
chmod 700 /home/${USER_USERNAME}/.ssh

if [[ "$USER_REGENERATE_SECRETS" = "false" ]]
then
	echo "${USER_SSH_PUBLIC_KEY}" > /home/${USER_USERNAME}/.ssh/authorized_keys
	touch /home/${USER_USERNAME}/${VM_NAME}.key
	touch /home/${USER_USERNAME}/${VM_NAME}.password
else
	# Generate new SSH key
	ssh-keygen -t rsa -N "" -f ${VM_NAME}.key -C ""
	#Add public key to authorized_keys for the user
	mv /home/${USER_USERNAME}/${VM_NAME}.key.pub /home/${USER_USERNAME}/.ssh/authorized_keys
	#Generate a random password & save it into a file
	NEW_PASSW=$(openssl rand -base64 16)
	echo "$NEW_PASSW" > /home/${USER_USERNAME}/${VM_NAME}.password
	chmod 600  /home/${USER_USERNAME}/${VM_NAME}.password
fi

# Make sure permissions / ownership are correct
chmod 600 /home/${USER_USERNAME}/.ssh/authorized_keys
chown -R ${USER_USERNAME} /home/${USER_USERNAME}/