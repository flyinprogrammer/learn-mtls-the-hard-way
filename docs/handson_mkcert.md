---
id: handson_mkcert
title: Let's Play With mkcert
sidebar_label: mkcert
---
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Installation

You should probably use the official, and up-to-date [installtion guide](https://github.com/FiloSottile/mkcert#installation),
but at one point in time these commands worked for installing the CLI tool.

<Tabs defaultValue="macos" values={[{ label: 'macOS', value: 'macos', },{ label: 'Linux', value: 'linux', }]}>
<TabItem value="macos">

```bash
brew install mkcert
```

</TabItem>
<TabItem value="linux">

```bash
MKCERT_VERSION="1.4.1"
curl -OL https://github.com/FiloSottile/mkcert/releases/download/v${MKCERT_VERSION}/mkcert-v${MKCERT_VERSION}-linux-amd64
chmod +x mkcert-v${MKCERT_VERSION}-linux-amd64
sudo mv mkcert-v${MKCERT_VERSION}-linux-amd64 /usr/local/bin/mkcert
```

</TabItem>
</Tabs>

## Install a Root Certificate Authority

The first step to using this tool is to create a Root Certificate Authority, and have it become trusted by the system
you're currently running:

<Tabs defaultValue="macos" values={[{ label: 'macOS', value: 'macos', },{ label: 'Linux', value: 'linux', }]}>
<TabItem value="macos">

```bash
mkcert -install
# Created a new local CA at "/Users/ascherger/Library/Application Support/mkcert" 💥
# The local CA is now installed in the system trust store! ⚡️
# The local CA is now installed in the Firefox trust store (requires browser restart)! 🦊
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

## Parts of a Root Certificate

Now let's use openssl to inspect the certificate that was made:

<Tabs defaultValue="macos" values={[{ label: 'macOS', value: 'macos', },{ label: 'Linux', value: 'linux', }]}>
<TabItem value="macos">

```bash
openssl x509 -text -noout -in ~/Library/Application\ Support/mkcert/rootCA.pem
```

</TabItem>
<TabItem value="linux">

```shell
openssl x509 -text -noout -in ~/.local/share/mkcert/rootCA.pem
```

</TabItem>
</Tabs>

Here's the certificate from one of my runs on my mac host:

```text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            61:ca:06:c5:21:85:b2:d6:b3:91:a5:30:38:77:8c:5d
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: O=mkcert development CA, OU=ascherger@MacBook-Pro.localdomain (Alan Scherger), CN=mkcert ascherger@MacBook-Pro.localdomain (Alan Scherger)
        Validity
            Not Before: Apr 16 03:15:22 2020 GMT
            Not After : Apr 16 03:15:22 2030 GMT
        Subject: O=mkcert development CA, OU=ascherger@MacBook-Pro.localdomain (Alan Scherger), CN=mkcert ascherger@MacBook-Pro.localdomain (Alan Scherger)
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (3072 bit)
                Modulus:
                    00:ba:0e:3e:67:9a:f2:f7:13:d9:d1:98:e2:15:86:
                    66:6e:64:a6:d6:72:8b:51:12:36:03:bf:41:f2:82:
                    50:e9:03:dc:82:88:f3:a8:28:90:e7:39:53:65:cf:
                    14:05:a1:cd:c9:4a:fc:43:e8:df:84:ff:80:8b:5b:
                    1e:19:1f:f6:60:e8:c0:85:12:2c:95:d1:b9:32:67:
                    00:43:03:11:86:d4:dd:c7:4e:ad:bf:4c:76:c6:67:
                    5f:d1:6f:c7:ef:bc:8b:48:2c:75:df:4f:f4:8c:eb:
                    3f:f8:7e:93:1b:37:c4:66:62:dd:9f:af:3d:99:11:
                    a8:24:0f:ba:fc:42:ea:3d:ac:3f:1c:a0:2f:c6:1a:
                    19:0a:fd:34:0e:5e:c5:4a:e5:a9:13:88:24:82:ed:
                    fa:fa:82:3b:99:55:a0:ec:ca:7f:ab:84:5a:6c:fc:
                    dc:e2:f4:3a:7d:50:ad:c1:82:a7:4c:42:0e:90:b1:
                    16:d3:6b:6d:27:4e:cc:71:dd:01:61:19:9f:e6:4c:
                    03:db:8c:b4:56:f3:c8:c3:48:4c:27:c7:46:db:f5:
                    7b:f4:51:4c:5a:51:61:43:90:59:06:23:d5:0d:1e:
                    7b:e7:fe:5a:02:2f:b8:68:24:18:58:1e:32:5a:0a:
                    a4:47:61:31:c2:76:4c:45:17:5b:16:9c:c5:05:27:
                    c6:52:e3:4a:06:87:52:46:e8:b7:5c:9a:fe:c0:7a:
                    44:e3:25:c8:d0:5a:57:a9:6b:fe:61:1a:8e:e0:df:
                    6f:38:a3:84:2b:5e:f3:54:78:f6:69:3e:13:ab:75:
                    12:49:41:60:08:43:62:18:7a:4c:4f:39:3a:9c:0a:
                    48:3a:75:9b:d1:df:3f:f6:60:23:2b:61:b1:59:9e:
                    cd:96:ff:38:55:98:f8:b9:94:ce:4b:0f:48:e1:10:
                    2d:67:ea:2b:8d:6b:3f:48:7c:5b:fd:4e:bd:f5:82:
                    71:72:32:7c:ab:15:e8:ed:5a:50:bc:69:15:37:1f:
                    a9:91:81:df:79:16:8e:29:df:a5
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier:
                3C:30:C0:57:4F:54:F7:B9:26:6A:77:60:7E:C4:1C:00:0E:F4:C2:FC
    Signature Algorithm: sha256WithRSAEncryption
         37:0a:02:86:e1:8f:99:d8:d5:17:02:d8:a0:d8:a6:8a:d7:f6:
         be:97:47:f9:4a:5b:d5:08:94:6d:6e:bc:24:b0:47:b4:9d:ea:
         1c:e1:2f:08:4e:a9:bc:ff:14:20:27:82:ad:0c:29:22:02:fa:
         b4:cd:de:be:cc:66:8e:93:c6:99:d7:32:f0:d3:a8:47:6a:9c:
         6d:16:5e:98:89:8c:3c:04:f3:c0:65:5e:9a:0b:e8:28:d7:6f:
         b9:d9:4a:b9:8e:7e:c6:eb:19:11:78:2d:56:1e:dd:5b:0c:1e:
         11:d3:05:14:49:00:25:ad:23:78:99:4b:6f:ab:c8:25:9a:5d:
         8c:1e:a2:d3:e2:4a:0d:46:3d:e4:d1:bf:66:5a:1b:93:88:b1:
         af:54:f8:91:5f:58:70:2b:c8:56:4e:5d:97:55:fe:fb:e1:ed:
         61:57:af:65:7b:36:48:e9:62:fe:7b:5a:fb:ba:47:b2:cd:82:
         41:ce:6b:75:41:8d:e6:ca:83:1a:c5:bb:3b:ef:05:f1:b7:32:
         d2:c1:3b:01:4b:94:2a:77:3b:2b:75:aa:75:bb:34:db:21:65:
         64:d1:c0:01:eb:11:f0:0c:1d:5e:20:be:07:43:ab:69:b5:2d:
         e2:9f:ce:06:0b:d2:1c:71:0d:54:f9:d4:22:76:49:33:44:a8:
         71:b4:45:82:8c:8e:c3:d4:63:83:70:ec:ef:d5:08:bb:56:ee:
         54:ed:12:5f:cd:c7:b0:26:57:ff:b7:fe:fd:3d:ca:dd:27:37:
         4d:2b:e4:56:89:74:74:ba:e9:4c:05:8b:40:d4:64:59:db:b6:
         fa:0b:81:77:ed:ca:ed:0a:2b:30:ed:d4:e5:22:bd:01:54:8b:
         3a:77:36:d8:2c:a3:71:37:ae:af:c9:da:13:9d:d7:2a:c2:ad:
         7e:59:fd:b8:c0:83:87:ed:20:af:7d:1e:a6:9b:1a:66:29:05:
         ac:20:7b:e6:15:ff:a2:a2:cc:ae:12:81:0a:8b:c2:ac:21:8e:
         a5:bf:b2:8a:bb:86
```

### Version Number

```text
Version: 3 (0x2)
```

We know that we're using v3 of the specification.

### Serial Number

```text
Serial Number:
    61:ca:06:c5:21:85:b2:d6:b3:91:a5:30:38:77:8c:5d
```

This [Serial Number](https://tools.ietf.org/html/rfc5280#section-4.1.2.2) is guaranteed to be a unique positive integer,
and cannot be longer than 20 octets.

### Signature Algorithm

```text
Signature Algorithm: sha256WithRSAEncryption
```

### Issuer

```text
Issuer:
    O=mkcert development CA,
    OU=ascherger@MacBook-Pro.localdomain (Alan Scherger),
    CN=mkcert ascherger@MacBook-Pro.localdomain (Alan Scherger)
```

### Validity

The [Validity](https://tools.ietf.org/html/rfc5280#section-4.1.2.5) of the certificate is the first line of defense
for determining if we should trust the certificate. If the current time is outside the bounds of the certificate, it
should no longer be trusted.

```text
Validity
    Not Before: Apr 16 03:15:22 2020 GMT
    Not After : Apr 16 03:15:22 2030 GMT
```

Here we see that this certificate is good for 10 years.

### Subject

```text
Subject:
    O=mkcert development CA,
    OU=ascherger@MacBook-Pro.localdomain (Alan Scherger),
    CN=mkcert ascherger@MacBook-Pro.localdomain (Alan Scherger)
```

### Subject Public Key Info

Next is the [Subject Public Key Info](https://tools.ietf.org/html/rfc5280#section-4.1.2.7) object, which has an
[RSA Public Key](https://tools.ietf.org/html/rfc3279#section-2.3.1).

```text
Subject Public Key Info:
    Public Key Algorithm: rsaEncryption
        Public-Key: (3072 bit)
        Modulus:
            00:ba:0e:3e:67:9a:f2:f7:13:d9:d1:98:e2:15:86:
            66:6e:64:a6:d6:72:8b:51:12:36:03:bf:41:f2:82:
            50:e9:03:dc:82:88:f3:a8:28:90:e7:39:53:65:cf:
            14:05:a1:cd:c9:4a:fc:43:e8:df:84:ff:80:8b:5b:
            1e:19:1f:f6:60:e8:c0:85:12:2c:95:d1:b9:32:67:
            00:43:03:11:86:d4:dd:c7:4e:ad:bf:4c:76:c6:67:
            5f:d1:6f:c7:ef:bc:8b:48:2c:75:df:4f:f4:8c:eb:
            3f:f8:7e:93:1b:37:c4:66:62:dd:9f:af:3d:99:11:
            a8:24:0f:ba:fc:42:ea:3d:ac:3f:1c:a0:2f:c6:1a:
            19:0a:fd:34:0e:5e:c5:4a:e5:a9:13:88:24:82:ed:
            fa:fa:82:3b:99:55:a0:ec:ca:7f:ab:84:5a:6c:fc:
            dc:e2:f4:3a:7d:50:ad:c1:82:a7:4c:42:0e:90:b1:
            16:d3:6b:6d:27:4e:cc:71:dd:01:61:19:9f:e6:4c:
            03:db:8c:b4:56:f3:c8:c3:48:4c:27:c7:46:db:f5:
            7b:f4:51:4c:5a:51:61:43:90:59:06:23:d5:0d:1e:
            7b:e7:fe:5a:02:2f:b8:68:24:18:58:1e:32:5a:0a:
            a4:47:61:31:c2:76:4c:45:17:5b:16:9c:c5:05:27:
            c6:52:e3:4a:06:87:52:46:e8:b7:5c:9a:fe:c0:7a:
            44:e3:25:c8:d0:5a:57:a9:6b:fe:61:1a:8e:e0:df:
            6f:38:a3:84:2b:5e:f3:54:78:f6:69:3e:13:ab:75:
            12:49:41:60:08:43:62:18:7a:4c:4f:39:3a:9c:0a:
            48:3a:75:9b:d1:df:3f:f6:60:23:2b:61:b1:59:9e:
            cd:96:ff:38:55:98:f8:b9:94:ce:4b:0f:48:e1:10:
            2d:67:ea:2b:8d:6b:3f:48:7c:5b:fd:4e:bd:f5:82:
            71:72:32:7c:ab:15:e8:ed:5a:50:bc:69:15:37:1f:
            a9:91:81:df:79:16:8e:29:df:a5
        Exponent: 65537 (0x10001)
```

The RSA key, as the specification implies, is literally just 2 numbers, the `Modulus` and `Exponent`. The `Modulus` is 
randomly generated, and in this case happens to be 3072 bits long, but in other cases might be shorter or longer. And
the `Exponent` is typically always set to 65537.

:::info
Why is the `Exponent` always set to 65537? Because compromises had to be made. Here's
the [Crypto StackExchange discussion](https://crypto.stackexchange.com/questions/3110/impacts-of-not-using-rsa-exponent-of-65537).
:::

### Extentions

```text
X509v3 extensions:
    X509v3 Key Usage: critical
        Certificate Sign
    X509v3 Basic Constraints: critical
        CA:TRUE, pathlen:0
    X509v3 Subject Key Identifier:
        3C:30:C0:57:4F:54:F7:B9:26:6A:77:60:7E:C4:1C:00:0E:F4:C2:FC
```

## Parts of a Leaf Certificate
