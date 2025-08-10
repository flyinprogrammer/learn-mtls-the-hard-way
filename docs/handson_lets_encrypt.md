---
id: handson_lets_encrypt
title: "Hands-on: Automating Certificates with Let's Encrypt"
sidebar_label: Automating with Let's Encrypt
---

In this lab, we'll learn how to use Let's Encrypt to get a free, trusted TLS certificate for a real, public website. We'll also see how to automatically renew the certificate so it never expires.

Let's Encrypt is a free, automated, and open certificate authority (CA), run for the public's benefit. It's a service provided by the Internet Security Research Group (ISRG).

## Prerequisites

*   A publicly accessible web server. This could be a server from any cloud provider (AWS, GCP, Azure, DigitalOcean, etc.).
*   A registered domain name that you can point to your server's public IP address.
*   Shell access to your server.

## Step 1: Install Certbot

The easiest way to use Let's Encrypt is with the `certbot` client. It's a tool that automates the process of getting a certificate and configuring your web server to use it.

Installation instructions vary depending on your operating system and web server. The official Certbot website has excellent instructions for all major platforms.

**[Go to the Certbot Instructions Generator](https://certbot.eff.org/)**

Select your web server software (e.g., Nginx, Apache) and your server's operating system (e.g., Ubuntu, CentOS) and follow the instructions to install `certbot`.

## Step 2: Obtain your first certificate

Once `certbot` is installed, you can run it to get your certificate.

For example, if you are using Nginx on Ubuntu, the command is typically:

```bash
sudo certbot --nginx
```

This command will:
1.  Automatically detect the domain names your Nginx server is configured for.
2.  Ask you which domain(s) you want to get a certificate for.
3.  Obtain the certificate from Let's Encrypt.
4.  Automatically update your Nginx configuration to use the new certificate.
5.  Set up a cron job or systemd timer to automatically renew the certificate before it expires.

Follow the on-screen prompts to complete the process.

## Step 3: Verify automatic renewal

Let's Encrypt certificates are valid for 90 days. `certbot` automatically sets up a task to renew them for you. You can test that the renewal process works by doing a "dry run":

```bash
sudo certbot renew --dry-run
```

If the dry run is successful, you're all set! Your certificates will be renewed automatically.

## How does it work?

The process `certbot` uses to prove you control the domain is called the "ACME protocol" (Automated Certificate Management Environment).

When you run `certbot`, it communicates with the Let's Encrypt servers. Let's Encrypt will give `certbot` a challenge, which is usually to place a specific file with specific content on your web server at a specific URL.

For example: `http://yourdomain.com/.well-known/acme-challenge/some-random-string`

`certbot` places the file there, and then tells Let's Encrypt to go check for it. If Let's Encrypt can download the file and the content is correct, it proves you control the server for that domain, and it will issue the certificate.

This is a simplified explanation of the "HTTP-01" challenge, which is the most common one. There are other challenge types as well, like the "DNS-01" challenge.

That's it! You now have a free, trusted, and automatically renewing TLS certificate for your website.
