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

# Save username to file 
echo "$USER_USERNAME" > /home/${USER_USERNAME}/${VM_NAME}.username

if [[ "$USER_REGENERATE_SECRETS" = "false" ]]
then
	echo "${USER_SSH_PUBLIC_KEY}" > /home/${USER_USERNAME}/.ssh/authorized_keys
	# Use Vagrant insecure SSH keypair
	# https://github.com/hashicorp/vagrant/tree/master/keys
	cat <<- EOF > /home/${USER_USERNAME}/${VM_NAME}.key
	-----BEGIN RSA PRIVATE KEY-----
	MIIEogIBAAKCAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzI
	w+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoP
	kcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2
	hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NO
	Td0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcW
	yLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQIBIwKCAQEA4iqWPJXtzZA68mKd
	ELs4jJsdyky+ewdZeNds5tjcnHU5zUYE25K+ffJED9qUWICcLZDc81TGWjHyAqD1
	Bw7XpgUwFgeUJwUlzQurAv+/ySnxiwuaGJfhFM1CaQHzfXphgVml+fZUvnJUTvzf
	TK2Lg6EdbUE9TarUlBf/xPfuEhMSlIE5keb/Zz3/LUlRg8yDqz5w+QWVJ4utnKnK
	iqwZN0mwpwU7YSyJhlT4YV1F3n4YjLswM5wJs2oqm0jssQu/BT0tyEXNDYBLEF4A
	sClaWuSJ2kjq7KhrrYXzagqhnSei9ODYFShJu8UWVec3Ihb5ZXlzO6vdNQ1J9Xsf
	4m+2ywKBgQD6qFxx/Rv9CNN96l/4rb14HKirC2o/orApiHmHDsURs5rUKDx0f9iP
	cXN7S1uePXuJRK/5hsubaOCx3Owd2u9gD6Oq0CsMkE4CUSiJcYrMANtx54cGH7Rk
	EjFZxK8xAv1ldELEyxrFqkbE4BKd8QOt414qjvTGyAK+OLD3M2QdCQKBgQDtx8pN
	CAxR7yhHbIWT1AH66+XWN8bXq7l3RO/ukeaci98JfkbkxURZhtxV/HHuvUhnPLdX
	3TwygPBYZFNo4pzVEhzWoTtnEtrFueKxyc3+LjZpuo+mBlQ6ORtfgkr9gBVphXZG
	YEzkCD3lVdl8L4cw9BVpKrJCs1c5taGjDgdInQKBgHm/fVvv96bJxc9x1tffXAcj
	3OVdUN0UgXNCSaf/3A/phbeBQe9xS+3mpc4r6qvx+iy69mNBeNZ0xOitIjpjBo2+
	dBEjSBwLk5q5tJqHmy/jKMJL4n9ROlx93XS+njxgibTvU6Fp9w+NOFD/HvxB3Tcz
	6+jJF85D5BNAG3DBMKBjAoGBAOAxZvgsKN+JuENXsST7F89Tck2iTcQIT8g5rwWC
	P9Vt74yboe2kDT531w8+egz7nAmRBKNM751U/95P9t88EDacDI/Z2OwnuFQHCPDF
	llYOUI+SpLJ6/vURRbHSnnn8a/XG+nzedGH5JGqEJNQsz+xT2axM0/W/CRknmGaJ
	kda/AoGANWrLCz708y7VYgAtW2Uf1DPOIYMdvo6fxIB5i9ZfISgcJ/bbCUkFrhoH
	+vq/5CIWxCPp0f85R4qxxQ5ihxJ0YDQT9Jpx4TMss4PSavPaBH3RXow5Ohe+bYoQ
	NE5OgEXk2wVfZczCZpigBKbKZHNYcelXtTt/nP3rsCuGcM4h53s=
	-----END RSA PRIVATE KEY-----
	EOF
	# Save the password passed in from Packer template
	echo "$USER_PASSWORD" > /home/${USER_USERNAME}/${VM_NAME}.password
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
chmod 700 /home/${USER_USERNAME}/.ssh  
chown -R ${USER_USERNAME} /home/${USER_USERNAME}/
