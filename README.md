# 🔐 SSL Certificate Expiry Alert Script
This script checks all Let's Encrypt SSL certificates on your server and sends an email alert if any certificate is expiring within the defined threshold (default: 15 days).

## 🚀 Features

- Checks all certbot-managed SSL certificates
- Sends alert emails when certificates are close to expiry
- Skips none (you can customize exclusions)
- Clean output in mail body

---

## 📁 Files

- `ssl_cert_expiry_checker.sh` – Main script
- `msmtprc` – Email SMTP configuration

## ⚙️ Setup Instructions

### 1. Setup Email Notifications
Install the required packages:

```bash
sudo apt update
sudo apt install msmtp mailutils -y
```
Create or edit `/etc/msmtprc` with your Gmail SMTP config (replace with your info):
```bash
vim /etc/msmtprc
sudo chmod 600 /etc/msmtprc
```

### 2. Add the Script

Save `ssl_cert_expiry_checker.sh` to `/usr/local/bin/ssl_cert_expiry_checker.sh`

```bash
vim /usr/local/bin/ssl_cert_expiry_checker.sh
sudo chmod +x /usr/local/bin/ssl_cert_expiry_checker.sh
sudo ln -sf /usr/bin/msmtp /usr/sbin/sendmail
```

### 3. Testing

You can temporarily lower the threshold to test:
THRESHOLD_DAYS=90
```bash
vim /usr/local/bin/ssl_cert_expiry_checker.sh
```
Then run:
```bash
sudo /usr/local/bin/ssl_cert_expiry_checker.sh
```

### Sample Output

![Output](https://github.com/abrahimcse/ssl_cert_expiry_checker/blob/main/ssl-alert-email.png)

### 4. Automate with Cron

To check daily at `9 AM` and send alerts automatically, add a `cron job`:
```bash
sudo crontab -e
```
Add this line at the end:

```bash
0 9 * * * /usr/local/bin/ssl_cert_expiry_checker.sh
```

Done! 🎉
Your SSL certificate expiry alerts are now automated with email notifications.

