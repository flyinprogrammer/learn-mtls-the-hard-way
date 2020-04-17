---
id: handson_ssh
title: Let's Play With SSH
sidebar_label: SSH
---

## Create an SSH Key

Create a key called `foobar`:

```bash
ssh-keygen -t rsa -b 4096
```

## View the Key Material

View the private key material:

```bash
openssl rsa -text -noout -in foobar
# RSA Private-Key: (4096 bit, 2 primes)
# modulus: <octets>
# publicExponent: 65537 (0x10001)
# privateExponent: <octets>
# prime1: <octets>
# prime2: <octets>
# exponent1: <octets>
# exponent2: <octets>
# coefficient: <octets>
```

Export public key from private key:

```bash
openssl rsa -in foobar -pubout > foobar.pub
# writing RSA key
```

View public key:

```bash
openssl rsa -text -noout -pubin -in foobar.pub
# RSA Public-Key: (4096 bit)
# Modulus: <octets>
# Exponent: 65537 (0x10001)
```


## Create SSH Public Key From An existing Private Key

```bash
ssh-keygen -y -f foobar > ./foobar.new.pub
```

Use ssh-keygen to read a private cert:

```text
ssh-keygen -l -f ./foobar
# 4096 SHA256:w6JCjrrkZUt1XdCENaOA8SUAKXFfDJZDd9CqbpJSuwM no comment (RSA)
```

# Helpful `openssl` man pages

It turns out that once we get over our anxiety, the `openssl` tool is actually pretty easy to learn:

* [ec](https://www.openssl.org/docs/man1.1.1/man1/ec.html)
* [rsa](https://www.openssl.org/docs/man1.1.1/man1/rsa.html)
* [pkey](https://www.openssl.org/docs/man1.1.1/man1/pkey.html)
* [x509](https://www.openssl.org/docs/man1.1.1/man1/x509.html)
* [verify](https://www.openssl.org/docs/man1.1.1/man1/verify.html)
* [s_client](https://www.openssl.org/docs/man1.1.1/man1/s_client.html)

It's also a giant ball of mud, but life is hard.
