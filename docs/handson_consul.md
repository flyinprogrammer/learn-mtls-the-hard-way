---
id: handson_consul
title: Let's Play With Consul
sidebar_label: Consul
---
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Download Consul Locally

[Consul Download Page](https://www.consul.io/downloads.html)

:::info
this script requires `unzip` to be installed. and `sha256sum` isn't necesarily the same across distributions.
This script has only been tested on Ubuntu.
:::

```bash
CONSUL_VERSION=${1:-1.2.3}
curl -LOks https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
curl -LOks https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS
sed -n "/consul_${CONSUL_VERSION}_linux_amd64.zip/p" consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c
sudo mkdir -p /usr/local/bin/consul_${CONSUL_VERSION}/
sudo unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin/consul_${CONSUL_VERSION}
rm consul_${CONSUL_VERSION}_linux_amd64.zip
rm consul_${CONSUL_VERSION}_SHA256SUMS
sudo ln -s /usr/local/bin/consul_${CONSUL_VERSION}/consul /usr/local/bin/consul

consul -autocomplete-install
complete -C /usr/local/bin/consul consul 
```

They have an [official deployment guide](https://learn.hashicorp.com/consul/datacenter-deploy/deployment-guide) that's pretty good too.

## Create Certificates

Consul CLI now a [tls](https://www.consul.io/docs/commands/tls.html) for quickly building certificates.

```bash

```

## Validate Local Server using TLS

## Create Client Certificate

```bash
openssl pkcs12 -export \
    -inkey ./dc1-client-consul-0-key.pem \
    -in ./dc1-client-consul-0.pem \
    -certfile ./consul-agent-ca.pem \
    -out consul.pfx
```

Now open `consul.pfx`, and make your computer trust it.

## Validate Local Server uses Client Certificate

Start the Consul server:

```bash
consul agent -config-file=server.hcl
```

Open a browser to <https://localhost:8501>

Stop the Consul server and change `verify_incoming` to `true`. Then start the server again.

This time the server will request a client certificate, and it will use the one we imported previously.

`curl` can work with certificates too:

```bash
curl --cacert ./consul-agent-ca.pem -vs https://localhost:8501/v1/health/state/passing | jq .
*   Trying ::1...
* TCP_NODELAY set
* Connection failed
* connect to ::1 port 8501 failed: Connection refused
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8501 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: ./consul-agent-ca.pem
  CApath: none
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
} [223 bytes data]
* TLSv1.2 (IN), TLS handshake, Server hello (2):
{ [58 bytes data]
* TLSv1.2 (IN), TLS handshake, Certificate (11):
{ [682 bytes data]
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
{ [116 bytes data]
* TLSv1.2 (IN), TLS handshake, Server finished (14):
{ [4 bytes data]
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
} [37 bytes data]
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
} [1 bytes data]
* TLSv1.2 (OUT), TLS handshake, Finished (20):
} [16 bytes data]
* TLSv1.2 (IN), TLS change cipher, Change cipher spec (1):
{ [1 bytes data]
* TLSv1.2 (IN), TLS handshake, Finished (20):
{ [16 bytes data]
* SSL connection using TLSv1.2 / ECDHE-ECDSA-AES256-GCM-SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=server.dc1.consul
*  start date: Apr 17 03:08:15 2020 GMT
*  expire date: Apr 17 03:08:15 2021 GMT
*  subjectAltName: host "localhost" matched cert's "localhost"
*  issuer: C=US; ST=CA; L=San Francisco; street=101 Second Street; postalCode=94105; O=HashiCorp Inc.; CN=Consul Agent CA 301271136312711425275901821455482890949
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7fc8fe00f600)
> GET /v1/health/state/passing HTTP/2
> Host: localhost:8501
> User-Agent: curl/7.64.1
> Accept: */*
> 
* Connection state changed (MAX_CONCURRENT_STREAMS == 250)!
< HTTP/2 200 
< content-type: application/json
< vary: Accept-Encoding
< x-consul-effective-consistency: leader
< x-consul-index: 6
< x-consul-knownleader: true
< x-consul-lastcontact: 0
< content-length: 261
< date: Fri, 17 Apr 2020 03:48:42 GMT
< 
{ [261 bytes data]
* Connection #0 to host localhost left intact
* Closing connection 0
[
  {
    "Node": "MacBook-Pro.localdomain",
    "CheckID": "serfHealth",
    "Name": "Serf Health Status",
    "Status": "passing",
    "Notes": "",
    "Output": "Agent alive and reachable",
    "ServiceID": "",
    "ServiceName": "",
    "ServiceTags": [],
    "Type": "",
    "Definition": {},
    "CreateIndex": 6,
    "ModifyIndex": 6
  }
]
```