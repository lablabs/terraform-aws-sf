Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
${before_sf_init_userdata}

curl -s -L ${sf_init_curl_additional_params} https://raw.githubusercontent.com/lablabs/aws-sf-userdata/${sf_init_userdata_version}/init.sh | bash -s ${sf_init_userdata_version} "${sf_init_curl_additional_params}"

${after_sf_init_userdata}
--//
