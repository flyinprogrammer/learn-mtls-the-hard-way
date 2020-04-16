---
id: principles_macos_ios_gotchyas
title: macOS & iOS Gotchyas
sidebar_label: macOS & iOS Gotchyas
---

In newer versions of iOS 13 and macOS 10.15 there are some things to be aware of regarding certificates.

[Requirements for trusted certificates in iOS 13 and macOS 10.15](https://support.apple.com/en-us/HT210176) TL;DR:

*  TLS server certificates and issuing CAs using RSA keys must use key sizes greater than or equal to 2048 bits.
*  For all TLS server certificates issued after **July 1, 2019**, they must have a validity period of 825 days or fewer (as expressed in the NotBefore and NotAfter fields of the certificate).
