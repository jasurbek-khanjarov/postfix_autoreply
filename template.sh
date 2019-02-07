#!/bin/sh
fromChild="order@mysite.com"
subjectChild="【Mysite】Mail Error: This address does not accept emails"
bodyChild=`cat << EOF
This is automatic email. Please send your mail to info@mysite.com
EOF
`
