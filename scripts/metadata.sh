#!/bin/bash -eux

cat <<- EOF > /home/${USER_USERNAME}/box-template/info.json
{
 "author": "$VM_INFO_AUTHOR",
 "description": "$VM_INFO_DESCRIPTION",
 "url": "$VM_INFO_URL"
}
EOF