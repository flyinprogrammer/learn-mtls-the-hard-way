---
id: handson_client_certs
title: "Hands-on: Client Certificate Authentication"
sidebar_label: Client Certificate Auth
---

In this lab, we'll learn how to configure a web server to require a client certificate for authentication. This is also known as mutual TLS (mTLS) because both the server and the client are presenting certificates to each other to prove their identity.

We will use Nginx as our web server and `mkcert` to create the necessary certificates.

## Prerequisites

*   You have `mkcert` installed. If not, please follow the instructions in the "Hands-on with mkcert" lab.
*   You have `nginx` installed.

## Step 1: Create a Certificate Authority (CA)

First, we need our own private CA. We can use `mkcert` for this. If you've run this before, you don't need to do it again.

```bash
mkcert -install
```

This creates a local CA and installs it in your system's trust stores.

## Step 2: Create a Server Certificate

Next, let's create a certificate for our server. We'll use `localhost` as the domain.

```bash
mkcert localhost
```

This will create `localhost.pem` (the certificate) and `localhost-key.pem` (the private key) in the current directory.

## Step 3: Create a Client Certificate

Now, let's create a certificate for our client. We'll identify the client by the name "my-client".

```bash
mkcert -client my-client
```

This will create `my-client.pem` and `my-client-key.pem` in the current directory.

## Step 4: Configure Nginx for mTLS

Now we need to configure Nginx to use these certificates. We will provide an example Nginx configuration file that you can adapt.

We will need to know where your CA certificate is stored. You can find the location of your local CA files by running:
```bash
mkcert -CAROOT
```
This will output a path. Inside that directory, you will find `rootCA.pem`. This is the file we need to reference in our Nginx config.

We will be creating the Nginx configuration file in the `examples/client-cert-nginx/` directory.

## Step 5: Test the configuration

Once we have the Nginx configuration in place, we will test it.

You can try to access `https://localhost:8443` in your browser. You should see an error because the browser is not presenting a client certificate.

To test it correctly, you can use `curl`:

```bash
curl --cacert $(mkcert -CAROOT)/rootCA.pem \
     --cert my-client.pem --key my-client-key.pem \
     https://localhost:8443
```

If everything is configured correctly, you should get the default Nginx welcome page. If you remove the `--cert` and `--key` flags, the request should fail.
