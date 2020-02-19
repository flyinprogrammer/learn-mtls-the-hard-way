---
id: mkcert
title: Let's Play with mkcert
sidebar_label: mkcert
---

# Installation

You should probably use the official, and up-to-date [installtion guide](https://github.com/FiloSottile/mkcert#installation),
but at one point in time these commands worked for installing the CLI tool.

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs
  defaultValue="macos"
  values={[
    { label: 'macOS', value: 'macos', },
    { label: 'Linux', value: 'linux', },
  ]
}>
<TabItem value="macos">

```bash
brew install mkcert
```

</TabItem>
<TabItem value="linux">

```bash
curl -OL https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64
chmod +x mkcert-v1.4.1-linux-amd64
sudo mv mkcert-v1.4.1-linux-amd64 /usr/local/bin/mkcert
```

</TabItem>
</Tabs>

# Install a Root Certificate Authority

The first step to using this tool is to create a Root Certificate Authority, and have it become trusted by the system
you're currently running:

<Tabs
  defaultValue="macos"
  values={[
    { label: 'macOS', value: 'macos', },
    { label: 'Linux', value: 'linux', },
  ]
}>
<TabItem value="macos">

```bash
brew install mkcert
```

</TabItem>
<TabItem value="linux">

```shell
mkcert -install
# Using the local CA at "/home/ascherger/.local/share/mkcert" ✨
# The local CA is already installed in the system trust store! 👍
# Warning: "certutil" is not available, so the CA can't be automatically installed in Firefox and/or Chrome/Chromium! ⚠️
# Install "certutil" with "apt install libnss3-tools" and re-run "mkcert -install" 
```

</TabItem>
</Tabs>

Now let's use openssl to inspect the certificate that was made:

<Tabs
  defaultValue="macos"
  values={[
    { label: 'macOS', value: 'macos', },
    { label: 'Linux', value: 'linux', },
  ]
}>
<TabItem value="macos">

```bash
brew install mkcert
```

</TabItem>
<TabItem value="linux">

```shell
openssl x509 -in ~/.local/share/mkcert/rootCA.pem -text -noout
```

</TabItem>
</Tabs>

Here's the certificate from one of my runs on a linux host:

```text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            ba:26:56:af:26:bd:3c:1a:e5:05:9d:fa:0b:83:40:26
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: O = mkcert development CA, OU = ascherger@incontrol (Alan Scherger), CN = mkcert ascherger@incontrol (Alan Scherger)
        Validity
            Not Before: Feb 18 22:34:27 2020 GMT
            Not After : Feb 18 22:34:27 2030 GMT
        Subject: O = mkcert development CA, OU = ascherger@incontrol (Alan Scherger), CN = mkcert ascherger@incontrol (Alan Scherger)
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (3072 bit)
                Modulus: [very large integer represented in colon-hexadecimal notation]
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier: 
                B9:D5:B3:06:55:B4:E6:CE:CB:CB:56:B3:4A:35:96:A3:AA:5F:2D:C4
    Signature Algorithm: sha256WithRSAEncryption
         c1:c2:17:2d:c2:ac:2f:f5:ba:30:b1:25:7e:71:e3:8a:1c:fd:
         3e:88:f3:4c:4a:94:64:05:f7:d0:14:a7:48:e7:02:c7:35:0a:
         52:cd:e8:4d:65:78:af:16:b9:38:4f:58:dc:ed:da:ac:c3:28:
         36:d2:0e:99:20:87:fa:5d:73:07:89:87:7a:c8:06:9a:88:f2:
         e6:ea:ca:e5:c4:bd:36:d4:1d:4f:26:74:bd:32:98:ff:99:82:
         cf:f8:68:9f:24:9a:1c:1c:9d:65:a1:b3:db:8d:4f:89:ef:85:
         03:0d:89:36:ae:cf:28:05:e0:ee:4e:d6:b1:f4:97:35:f2:bd:
         ae:6c:e8:8f:d5:87:8f:91:95:56:d4:bc:93:b3:82:55:c2:28:
         de:58:3e:4e:9b:a9:1b:52:1e:ed:59:68:cb:42:73:a3:d1:eb:
         73:07:7f:f9:d9:4f:b4:23:7e:69:45:b6:7c:ce:df:e8:43:d4:
         8b:89:23:d0:50:30:8a:32:c7:11:ab:b7:7a:bf:49:80:21:81:
         90:de:a9:6f:eb:a9:a8:47:7e:22:07:7c:86:a0:8e:b2:5d:4d:
         5a:1c:91:f4:30:44:67:03:09:9a:0d:86:ea:9c:df:98:20:ff:
         49:82:64:b8:9b:4c:13:ca:aa:ca:88:b4:2d:1c:aa:88:d4:30:
         6c:63:97:3e:ce:77:c4:44:5c:62:25:2d:09:43:ce:fd:e9:de:
         26:67:4b:e2:a3:3e:93:eb:bf:15:60:0b:d5:46:73:1f:86:2a:
         1d:08:2d:18:33:9c:25:46:a2:a2:a6:03:b3:3c:27:f6:4d:21:
         90:3d:2d:c1:fd:91:a2:ec:36:01:c4:5c:85:0b:f4:a7:d3:0c:
         4c:6d:4a:50:8b:7a:2b:71:78:df:6b:da:d8:bf:01:c1:ad:28:
         59:f2:f8:25:bc:21:6c:bd:23:09:5e:59:b1:f6:64:d1:36:f2:
         9f:2e:d0:df:97:26:06:b6:75:49:40:e4:49:62:3a:d8:2f:e0:
         79:79:61:48:d7:b4
```

We can see a few things of interest. The first is the Serial Number of the certificate:

```text
Serial Number:
    ba:26:56:af:26:bd:3c:1a:e5:05:9d:fa:0b:83:40:26
```

This [Serial Number](https://tools.ietf.org/html/rfc5280#section-4.1.2.2) is guaranteed to be a unique positive integer,
and cannot be longer than 20 octets.

The [Validity](https://tools.ietf.org/html/rfc5280#section-4.1.2.5) of the certificate is the first line of defense
for determining if we should trust the certificate. If the current time is outside the bounds of the certificate, it
should no longer be trusted.

Next is the [Subject Public Key Info](https://tools.ietf.org/html/rfc5280#section-4.1.2.7) object, which has an
[RSA Public Key](https://tools.ietf.org/html/rfc3279#section-2.3.1).

