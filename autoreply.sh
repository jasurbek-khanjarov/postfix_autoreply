#!/bin/sh
STDIN=$(cat -)
# Get Sender
to=`echo "${STDIN}" | egrep -i "^From:" | sed -e "s/From:\s*\(.*\)/\1/g" | grep -o "<.*" | tr -d "<" | tr -d ">"`
# Get mail sent to
mailTo=`echo "${STDIN}" | egrep -i "^To:" | sed -e "s/To:\s*\(.*\)/\1/g"`
# get domain of request
client=`echo "${STDIN}" | egrep -i "^Received: from" | head -1`

# Setting Template
if [[ "$mailTo" =~ "order@mysite.com" ]];
    then
    source /home/autoreply/template.sh
    from=$fromChild
    subject=$subjectChild
    body=$bodyChild
else
    echo "Uknown email"
    exit
fi

declare -A sites=(
[site1]=xx.xx.xxx.xxx
[site2]=1xx.xx.xxx.xxx
)
for site in "${sites[@]}"
do
  if [[ "$client" =~ "$site" ]]; then
    exit
  fi
done

invalid_address="MAILER-DAEMON"

# Create Mail Template
mail_tpl () {
        subject2=`echo "$subject"`
        body2=`echo "$body"`
        mail=`cat << EOF
From: $from
To: $1
Subject: $subject2
Content-type: text/plain; charset=UTF-8
$body2
EOF
`
        echo "$mail"
}

if [ -p /dev/stdin ]; then
  # skip mail
  invalid_num=`echo $to | egrep -i $invalid_address | wc -c`
  if [ $invalid_num -gt 0 ]; then
    exit
  fi
  # Send Mail
  echo "`mail_tpl \"$to\"`" | /usr/sbin/sendmail -it

else
  echo "no stdin"
fi
