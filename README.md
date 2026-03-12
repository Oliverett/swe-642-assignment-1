# SWE642 Assignment 1

**Author:** Elijah Oliver  
**Course:** SWE642  
**Date:** October 2025  

Personal portfolio and student survey website for SWE642, deployable to AWS S3 or EC2.

---

## Project Contents

| File | Description |
|------|-------------|
| **index.html** | Main website: home page, About, Skills, Student Survey, and Contact. Single-page app with tab navigation, Bootstrap 5, form validation, zipcode lookup, and cookie-based greeting. |
| **profile.jpg** | Profile photo used on the About page. |
| **zipcodes.json** | JSON data for survey zipcode auto-fill (city/state lookup). |
| **deploy.sh** | Deploys the site to an **AWS S3** bucket (static website hosting). Prompts for bucket name and uploads `index.html`, `zipcodes.json`, and optional profile image. |
| **deploy-ec2.sh** | Deploys the site to an **Amazon EC2** instance (Ubuntu/Amazon Linux). Uses SCP to copy files to the server’s web root (e.g. `/var/www/html`). Prompts for EC2 host, username, key path, and web root. |
| **check-key.sh** | Checks an EC2 `.pem` key file: permissions, PEM format, and line endings. Usage: `./check-key.sh /path/to/key.pem` |
| **bucket-policy.json** | Example S3 bucket policy for public read access (e.g. for static website hosting). |
| **apache-config.conf** | Optional Apache virtual host configuration for EC2. |
| **EC2-SETUP.md** | Step-by-step guide for launching EC2, installing Apache, and deploying the site. Includes key-pair and troubleshooting notes. |

---

## Quick Start(EC2 Public IP link)
http://54.242.32.231

### Run locally

Open `index.html` in a browser. For full survey behavior (e.g. zipcode lookup), serve the folder with a local server so `zipcodes.json` loads correctly:

```bash
# Example with Python 3
python3 -m http.server 8000
# Then open http://localhost:8000
```

### Deploy to S3

```bash
chmod +x deploy.sh
./deploy.sh
# Enter your S3 bucket name when prompted.
# Enable static website hosting on the bucket.
```

### Deploy to EC2 (Ubuntu + Apache)

1. Ensure Apache is installed and running on the EC2 instance (see **EC2-SETUP.md**).
2. From this project folder:

   ```bash
   chmod +x deploy-ec2.sh
   ./deploy-ec2.sh
   ```
3. Enter EC2 host (e.g. public IP), username (e.g. `ubuntu`), path to `.pem` key, and web root (default `/var/www/html`).

---

## Website Features

- **Home:** Intro and highlight cards (Software Engineering, Cloud, Networking).
- **About:** Bio and profile image (`profile.jpg`).
- **Skills:** Programming languages and technologies.
- **Student Survey:** Form with validation, zipcode lookup via `zipcodes.json`, campus preferences, data (10 numbers) average/max, and optional comments. Name greeting uses a cookie.
- **Contact:** Email and links (e.g. GitHub, LinkedIn).

---

## Requirements

- **S3 deployment:** AWS CLI configured (`aws configure`), bucket created, static hosting enabled.
- **EC2 deployment:** SSH key (e.g. `swe645.pem`) with permissions `chmod 400`, and EC2 security group allowing SSH (22), HTTP (80), and optionally HTTPS (443).

---

## Key and path notes

- Use the **full path** to your `.pem` file when running `deploy-ec2.sh` or `check-key.sh`.
- If you see “Permissions denied (publickey)” or “key ignored,” run:  
  `chmod 400 /path/to/your-key.pem`
- For Ubuntu EC2 use username **ubuntu**; for Amazon Linux use **ec2-user**.
