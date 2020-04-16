---
id: certificates
title: X.509 v3 Certificates
sidebar_label: X.509 v3 Certificates
---

The first thing you need to know about certificates, is that there's no such thing as an:

- SSL Certificate
- TLS Certificate
- HTTPS Certificate

There's only 1 thing, an X.509 v3 Certificate, and it's specification is discussed in
[RFC 5280](https://tools.ietf.org/html/rfc5280).

## Certificate Basic Fields

Here are a few basic fields that will allow you to understand what makes an X.509 v3 Certificate.

### [Version Number](https://tools.ietf.org/html/rfc5280#section-4.1.2.1)

This field describes the version of the encoded certificate.  When
extensions are used, as expected in this profile, version MUST be 3
(value is 2).  If no extensions are present, but a UniqueIdentifier
is present, the version SHOULD be 2 (value is 1); however, the
version MAY be 3.  If only basic fields are present, the version
SHOULD be 1 (the value is omitted from the certificate as the default
value); however, the version MAY be 2 or 3.

### [Serial Number](https://tools.ietf.org/html/rfc5280#section-4.1.2.2)

The serial number MUST be a positive integer assigned by the CA to
each certificate. 
__It MUST be unique for each certificate issued by a given CA__ 
(i.e., the issuer name and serial number identify a unique certificate).
CAs MUST force the serialNumber to be a non-negative integer.

Given the uniqueness requirements above, serial numbers can be
expected to contain long integers.  Certificate users MUST be able to
handle serialNumber values up to 20 octets.  Conforming CAs MUST NOT
use serialNumber values longer than 20 octets.

### [Signature Algorithm](https://tools.ietf.org/html/rfc5280#section-4.1.1.2)

The `signatureAlgorithm` field contains the identifier for the
cryptographic algorithm used by the CA to sign this certificate.
[RFC3279](https://tools.ietf.org/html/rfc3279),
[RFC4055](https://tools.ietf.org/html/rfc4055), and
[RFC4491](https://tools.ietf.org/html/rfc4491) list supported signature
algorithms, but other signature algorithms MAY also be supported.

### [Issuer](https://tools.ietf.org/html/rfc5280#section-4.1.2.4)

The `issuer` field identifies the entity that has signed and issued the
certificate.  The `issuer` field MUST contain a non-empty distinguished
name (DN).  The `issuer` field is defined as the X.501 type Name
[X.501](https://tools.ietf.org/html/rfc5280#ref-X.501).

### [Validity](https://tools.ietf.org/html/rfc5280#section-4.1.2.5)

The certificate validity period is the time interval during which the
CA warrants that it will maintain information about the status of the
certificate.  The field is represented as a SEQUENCE of two dates:
the date on which the certificate validity period begins (notBefore)
and the date on which the certificate validity period ends
(notAfter).  Both notBefore and notAfter may be encoded as UTCTime or
GeneralizedTime.

### [Subject](https://tools.ietf.org/html/rfc5280#section-4.1.2.6)

The `subject` field identifies the entity associated with the public
key stored in the subject public key field.  The subject name MAY be
carried in the `subject` field and/or the subjectAltName extension.  If
the subject is a CA (e.g., the basic constraints extension, as
discussed in
[Section 4.2.1.9](https://tools.ietf.org/html/rfc5280#section-4.2.1.9)
, is present and the value of cA is
TRUE), then the `subject` field MUST be populated with a non-empty
distinguished name matching the contents of the `issuer` field ([Section
4.1.2.4](https://tools.ietf.org/html/rfc5280#section-4.1.2.4)
in all certificates issued by the subject CA.  If the
subject is a CRL issuer (e.g., the key usage extension, as discussed
in [Section 4.2.1.3](https://tools.ietf.org/html/rfc5280#section-4.2.1.3)
, is present and the value of cRLSign is TRUE),then the `subject` field 
MUST be populated with a non-empty distinguished name matching the contents
of the `issuer` field ([Section 5.1.2.3](https://tools.ietf.org/html/rfc5280#section-5.1.2.3))
in all CRLs issued by the subject CRL issuer.  If subject
naming information is present only in the subjectAltName extension
(e.g., a key bound only to an email address or URI), then the subject
name MUST be an empty sequence and the subjectAltName extension MUST
be critical.

Where it is non-empty, the `subject` field MUST contain an X.500
distinguished name (DN).  The DN MUST be unique for each subject
entity certified by the one CA as defined by the `issuer` field.  A CA
MAY issue more than one certificate with the same DN to the same
subject entity.

### [Subject Public Key Info](https://tools.ietf.org/html/rfc5280#section-4.1.2.7)

This field is used to carry the public key and identify the algorithm
with which the key is used (e.g., RSA, DSA, or Diffie-Hellman).  The
algorithm is identified using the AlgorithmIdentifier structure
specified in [Section 4.1.1.2](https://tools.ietf.org/html/rfc5280#section-4.1.1.2).  The object identifiers for the
supported algorithms and the methods for encoding the public key
materials (public key and parameters) are specified in [RFC3279](https://tools.ietf.org/html/rfc3279),
[RFC4055](https://tools.ietf.org/html/rfc4055), and [RFC4491](https://tools.ietf.org/html/rfc4491).

### [Extensions](https://tools.ietf.org/html/rfc5280#section-4.1.2.9)

This field MUST only appear if the version is 3 (
[Section 4.1.2.1](https://tools.ietf.org/html/rfc5280#section-4.1.2.1)).
If present, this field is a SEQUENCE of one or more certificate
extensions.  The format and content of certificate extensions in the
Internet PKI are defined in
[Section 4.2](https://tools.ietf.org/html/rfc5280#section-4.2).
