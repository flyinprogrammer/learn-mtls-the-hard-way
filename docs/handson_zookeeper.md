---
id: handson_zookeeper
title: Let's Play With Zookeeper on Digital Ocean
sidebar_label: Zookeeper on Digital Ocean
---
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Run Zookeeper Locally

You can get Zookeeper a few ways:

* [Releases Page](https://zookeeper.apache.org/releases.html)
* [Docker Hub](https://hub.docker.com/_/zookeeper)

We're going to use the `tar.gz` from the Releases Page, and we're using version 3.6.x

Also, here's a [semi-official guide](https://cwiki.apache.org/confluence/display/ZOOKEEPER/ZooKeeper+SSL+User+Guide).

## Run Zookeeper on Digital Ocean

In the [examples/zookeeper-digitalocean](https://github.com/flyinprogrammer/learn-mtls-the-hard-way/tree/master/examples/zookeeper-digitalocean)
directory we have some Terraform scripts you can use to spin up 3 nodes, and a [cloud-init](https://cloudinit.readthedocs.io/en/latest/)
Bash script you might find interesting.

Our goal with this exercise is to create 3 Zookeeper nodes, and to get them use TLS for following use cases:
- Admin Server on port 8080
- Quroum ports on ports 2888 & 3888
- Client port on 2281

The nodes will only be accessible over the Private IP addresses because of how we'll configure the certificates.

## Create the ZK Nodes

You'll need to use [doctl](https://github.com/digitalocean/doctl#installing-doctl) to set up a Digital Ocean credential file.
Then you'll need to create a Digital Ocean [Personal Access Token](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/).
And finally you'll need valid, public addressable DNS Domain. For this tutorial we're using `zkocean.hpy.dev` but you'll
need to supply your own, or create your own solution for dns.

You can edit the `variable.tf` to satisfy any of the requirements you might have.

Depending on whether or not you're on macOS, linux, or windows, you'll probably need to adjust the source of your `doctl`
config file inside of `data.tf` or you'll need to adjust the Digital Ocean provider in `providers.tf`

Once that's ready, run the following Terraform commands:

```bash
cd ./examples/zookeeper-digitalocean/
terraform init
terraform plan -out tfout
terraform apply "tfout"
```

In a few moments you should have 3 nodes which you can start using immediately.

## Validate that ZK works without SSL

Locally, get the SSH key out of terraform:
```bash
./scripts/fetch_ssh_key.sh
```

And then SSH to your nodes:

```bash
ssh -i ./outputs/ec2_key.pem root@zk-1.zkocean.hpy.dev
ssh -i ./outputs/ec2_key.pem root@zk-2.zkocean.hpy.dev
ssh -i ./outputs/ec2_key.pem root@zk-3.zkocean.hpy.dev
```

On each host start zookeeper:

```bash
sudo systemctl start zookeeper
sudo journalctl -f -u zookeeper.service
```

Once the logs get boring, validate each node agrees on the same leader:

```bash
curl -s localhost:8080/commands/leader | jq .
```

Now that we have validated a basic, working Zookeeper cluster, let's enable some TLS!

## Create ZK Keystores

:::info
Most of this work is already done for you via `cloudinit.sh` on first boot.
:::

Create SSL keystore JKS to store local credentials, one keystore should be created for each ZK instance.

In this example we generate a self-signed certificate and store it together with the private key in keystore.jks.
This is suitable for testing purposes, but you probably need an official certificate to sign your keys in a production environment.

:::note
The alias (-alias) and the distinguished name (-dname) must match the hostname of the machine that is associated with, otherwise hostname verification won't work.
:::

(This is already done for you in the `cloudinit.sh` on boot.)
```bash
keytool -genkeypair -alias zk-1.private.zkocean.hpy.dev \
  -keyalg RSA -keysize 2048 -dname "cn=zk-1.private.zkocean.hpy.dev" \
  -keypass password \
  -keystore /opt/zookeeper/conf/keystore.jks \
  -ext san=ip:10.10.20.4,dns:zk-1.private.zkocean.hpy.dev,dns:localhost
  -storepass password
```

We add the additional SAN addresses so that we can properly use this certificate with Curl later on when we want to access
the Admin Server over HTTPS.

Extract the signed public key (certificate) from keystore, this step might only necessary for self-signed certificates.

(This is already done for you in the `cloudinit.sh` on boot.)
```bash
keytool -exportcert -alias zk-1.private.zkocean.hpy.dev \
  -keystore /opt/zookeeper/conf/keystore.jks \
  -file /opt/zookeeper/conf/zk-1.private.zkocean.hpy.dev.cer -rfc
```

Locally download the certs on to your developer computer:

```bash
mkdir certs
cd certs
scp -i ../outputs/ec2_key.pem root@zk-1.zkocean.hpy.dev:/opt/zookeeper/conf/zk-1.private.zkocean.hpy.dev.cer .
scp -i ../outputs/ec2_key.pem root@zk-2.zkocean.hpy.dev:/opt/zookeeper/conf/zk-2.private.zkocean.hpy.dev.cer .
scp -i ../outputs/ec2_key.pem root@zk-3.zkocean.hpy.dev:/opt/zookeeper/conf/zk-3.private.zkocean.hpy.dev.cer .
```

Create a `truststore.jks` with all our certificates.

```bash
keytool -keystore truststore.jks -storepass password \
    -importcert -alias zk-1.private.zkocean.hpy.dev -file zk-1.private.zkocean.hpy.dev.cer
keytool -keystore truststore.jks -storepass password \
    -importcert -alias zk-2.private.zkocean.hpy.dev -file zk-2.private.zkocean.hpy.dev.cer
keytool -keystore truststore.jks -storepass password \
    -importcert -alias zk-3.private.zkocean.hpy.dev -file zk-3.private.zkocean.hpy.dev.cer
```

Create a combined CA Cert to install system wide:

```bash
cat *.cer >> zk-all.crt
```

List certs:

```bash
keytool -list -v -keystore truststore.jks
# Enter keystore password:  
# Keystore type: PKCS12
# Keystore provider: SUN
#
# Your keystore contains 3 entries
# ...
```

We can also use `openssl` to look at the `.cer` files, for example:

```bash
openssl x509 -text -noout -in ./zk-1.private.zkocean.hpy.dev.cer
```

Upload your `truststore.jks` to your nodes:

```bash
scp -i ../outputs/ec2_key.pem ./truststore.jks root@zk-1.zkocean.hpy.dev:/opt/zookeeper/conf/truststore.jks
scp -i ../outputs/ec2_key.pem ./truststore.jks root@zk-2.zkocean.hpy.dev:/opt/zookeeper/conf/truststore.jks
scp -i ../outputs/ec2_key.pem ./truststore.jks root@zk-3.zkocean.hpy.dev:/opt/zookeeper/conf/truststore.jks
scp -i ../outputs/ec2_key.pem ./zk-all.crt root@zk-1.zkocean.hpy.dev:/usr/local/share/ca-certificates/zk-all.crt
scp -i ../outputs/ec2_key.pem ./zk-all.crt root@zk-2.zkocean.hpy.dev:/usr/local/share/ca-certificates/zk-all.crt
scp -i ../outputs/ec2_key.pem ./zk-all.crt root@zk-3.zkocean.hpy.dev:/usr/local/share/ca-certificates/zk-all.crt
```

Configure our server with some new properties:

```bash
sudo -u zookeeper vim /opt/zookeeper/conf/zoo.cfg
```

Now you can uncomment the following configuration:

```
secureClientPort=2281

sslQuorum=true
serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory
ssl.quorum.keyStore.location=/opt/zookeeper/conf/keystore.jks
ssl.quorum.keyStore.password=password
ssl.quorum.trustStore.location=/opt/zookeeper/conf/truststore.jks
ssl.quorum.trustStore.password=password

ssl.keyStore.location=/opt/zookeeper/conf/keystore.jks
ssl.keyStore.password=password 
ssl.trustStore.location=/opt/zookeeper/conf/truststore.jks
ssl.trustStore.password=password

admin.portUnification=true
```

Then restart Zookeeper:

```bash
sudo systemctl restart zookeeper.service
journalctl -f -u zookeeper.service 
```

Show that the certificates aren't installed system wide yet:

```bash
curl https://localhost:8080/commands
# curl: (60) SSL certificate problem: self signed certificate
# More details here: https://curl.haxx.se/docs/sslcerts.html
#
# curl failed to verify the legitimacy of the server and therefore could not
# establish a secure connection to it. To learn more about this situation and
# how to fix it, please visit the web page mentioned above.
```

Update your local CA Certs store:

```bash
sudo update-ca-certificates
```

Validate Leader on each node:

```bash
curl -s https://localhost:8080/commands/leader | jq .
curl -s https://zk-1.private.zkocean.hpy.dev:8080/commands/leader | jq .
```

Validate with `openssl`:

```bash
sudo netstat -nltpu | grep java
openssl s_client -connect localhost:2181
# no SSL cert found
openssl s_client -connect localhost:2281
# requires client cert
openssl s_client -connect localhost:8080
# has a server cert
openssl s_client -connect localhost:7000
# no SSL cert found
```

Now connect with `zkCli.sh`:

```bash
export CLIENT_JVMFLAGS="
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.client.secure=true 
-Dzookeeper.ssl.keyStore.location=/opt/zookeeper/conf/keystore.jks
-Dzookeeper.ssl.keyStore.password=password 
-Dzookeeper.ssl.trustStore.location=/opt/zookeeper/conf/truststore.jks
-Dzookeeper.ssl.trustStore.password=password"
/opt/zookeeper/bin/zkCli.sh -server 127.0.0.1:2281
```

Try setting `ssl.clientAuth=none` and then let's try connecting with only the keystore:

```bash
export CLIENT_JVMFLAGS="
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.client.secure=true 
-Dzookeeper.ssl.trustStore.location=/opt/zookeeper/conf/truststore.jks
-Dzookeeper.ssl.trustStore.password=password"
/opt/zookeeper/bin/zkCli.sh -server 127.0.0.1:2281
```

We can see the server no longer sends a list of client certs:

```bash
openssl s_client -connect localhost:2281
# No client certificate CA names sent
```

If we set the configuration to: `ssl.clientAuth=want` we'll see that it asks for them but they still aren't required:

```bash
openssl s_client -connect localhost:2281
# Acceptable client certificate CA names
# CN = zk-2.private.zkocean.hpy.dev
# CN = zk-3.private.zkocean.hpy.dev
# CN = zk-1.private.zkocean.hpy.dev
# Client Certificate Types: RSA sign, DSA sign, ECDSA sign
```


## Destroy our workshop

When you're ready you can destroy everything with:

```bash
terraform destroy
```
