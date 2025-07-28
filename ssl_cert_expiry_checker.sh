#!/bin/bash

THRESHOLD=15
TMPFILE="/tmp/ssl_expiry_alert.txt"
ALERT=false

echo "[Production] 🔐 SSL Certificate Expiry Alert (Threshold: $THRESHOLD days)" > "$TMPFILE"
echo "" >> "$TMPFILE"

while IFS='|' read -r CERT_NAME EXPIRY_DATE; do

  # Skip uptime.crystaltechbd.com notifications
#  if [[ "$CERT_NAME" == "uptime.crystaltechbd.com" ]]; then
#    continue
#  fi

  EXPIRY_SECONDS=$(date -d "$EXPIRY_DATE" +%s)
  NOW_SECONDS=$(date +%s)
  REMAINING_SECONDS=$((EXPIRY_SECONDS - NOW_SECONDS))
  REMAINING_DAYS=$((REMAINING_SECONDS / 86400))

  if (( REMAINING_DAYS < THRESHOLD )); then
    ALERT=true
    echo "❗ $CERT_NAME will expire in $REMAINING_DAYS days (on $EXPIRY_DATE UTC)" >> "$TMPFILE"
  fi

done < <(certbot certificates | awk '
  BEGIN { cert_name=""; expiry_date=""; }
  /Certificate Name:/ { cert_name=$3 }
  /Expiry Date:/ { 
    expiry_date = $3 " " $4; 
    print cert_name "|" expiry_date
  }
')

if $ALERT; then
  {
    echo "To: abrahimcse@gmail.com, abc@gmail.com, xyz@gmail.com"
    echo "From: abrahim.ctech@gmail.com"
    echo "Subject: [SSL Alert] Certificate(s) expiring in less than $THRESHOLD days"
    echo ""
    cat "$TMPFILE"
  } | msmtp -a gmail -t
fi
