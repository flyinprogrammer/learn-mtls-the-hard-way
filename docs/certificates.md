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

## Basic Fields

Here are a few basic fields that will allow you to understand what makes an X.509 v3 Certificate:

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
[RFC 3279](https://tools.ietf.org/html/rfc3279),
[RFC 4055](https://tools.ietf.org/html/rfc4055), and
[RFC 4491](https://tools.ietf.org/html/rfc4491) list supported signature
algorithms, but other signature algorithms MAY also be supported.

### [Issuer](https://tools.ietf.org/html/rfc5280#section-4.1.2.4)

The `issuer` field identifies the entity that has signed and issued the
certificate.  The `issuer` field MUST contain a non-empty distinguished
name (DN).  The `issuer` field is defined as the X.501 type Name
[X.501](https://www.itu.int/rec/T-REC-X.501/en).

Standard sets of attributes have been defined in the X.500 series of
specifications [X.520](https://www.itu.int/itu-t/recommendations/rec.aspx?rec=X.520).
Implementations of this specification MUST be prepared to receive the following standard attribute types in
issuer and subject ([Section 4.1.2.6](https://tools.ietf.org/html/rfc5280#section-4.1.2.6)) names:

* country,
* organization,
* organizational unit,
* distinguished name qualifier,
* state or province name,
* common name (e.g., "Susan Housley"), and
* serial number.
      
#### Country

The `Country` Name attribute type specifies a country. When used as a component of a directory name, it identifies the
country in which the named object is physically located or with which it is associated in some other important way.
An attribute value for country name is a string chosen from ISO 3166-1 alpha-2 or ISO 3166-3 alpha-2. 

#### Organization

The Organization Name attribute type specifies an organization. When used as a component of a directory name, it
identifies an organization with which the named object is affiliated.

An attribute value for OrganizationName is a string chosen by the organization (e.g., O = "Scottish Telecommunications
plc"). Any variants should be associated with the named Organization as separate and alternative attribute values.

#### Organizational Unit

The Organizational Unit Name attribute type specifies an organizational unit. When used as a component of a directory
name, it identifies an organizational unit with which the named object is affiliated.

The designated organizational unit is understood to be part of an organization designated by an organizationName
attribute. It follows that if an Organizational Unit Name attribute is used in a directory name, it shall be associated with
an organizationName attribute.

An attribute value for Organizational Unit Name is a string chosen by the organization of which it is part (e.g., OU =
"Technology Division"). Note that the commonly used abbreviation "TD" would be a separate and alternative attribute
value.

#### Distinguished Name Qualifier

The DN Qualifier attribute type specifies disambiguating information to add to the relative distinguished name of an
entry. It is intended to be used for entries held in multiple DSAs which would otherwise have the same name, and that its
value be the same in a given DSA for all entries to which this information has been added.

#### State or Province

The State or Province Name attribute type specifies a state or province. When used as a component of a directory name,
it identifies a geographical subdivision in which the named object is physically located or with which it is associated in
some other important way.

An attribute value for State or Province Name is a string, e.g., S = "Ohio". 

#### Common Name

The Common Name attribute type specifies an identifier of an object. A Common Name is not a directory name; it is a
(possibly ambiguous) name by which the object is commonly known in some limited scope (such as an organization) and
conforms to the naming conventions of the country or culture with which it is associated.

An attribute value for common name is a string chosen either by the person or organization it describes or the
organization responsible for the object it describes for devices and application entities. For example, a typical name of a
person in an English-speaking country comprises a personal title (e.g., Mr., Ms., Rd, Professor, Sir, Lord), a first name,
middle name(s), last name, generation qualifier (if any, e.g., Jr.) and decorations and awards (if any, e.g., QC). 


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
carried in the `subject` field and/or the `subjectAltName` extension.  If
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
naming information is present only in the `subjectAltName` extension
(e.g., a key bound only to an email address or URI), then the subject
name MUST be an empty sequence and the `subjectAltName` extension MUST
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
materials (public key and parameters) are specified in [RFC 3279](https://tools.ietf.org/html/rfc3279),
[RFC 4055](https://tools.ietf.org/html/rfc4055), and [RFC 4491](https://tools.ietf.org/html/rfc4491).

### [Extensions](https://tools.ietf.org/html/rfc5280#section-4.1.2.9)

This field MUST only appear if the version is 3 (
[Section 4.1.2.1](https://tools.ietf.org/html/rfc5280#section-4.1.2.1)).
If present, this field is a SEQUENCE of one or more certificate
extensions.  The format and content of certificate extensions in the
Internet PKI are defined in
[Section 4.2](https://tools.ietf.org/html/rfc5280#section-4.2).

## Where did this originate?

This specification actually has its roots in an older publication: [Blue Book Volume VIII - Fascicle VIII.8](http://search.itu.int/history/HistoryDigitalCollectionDocLibrary/4.260.43.en.1056.pdf)

Originally it seems certificates were created to solve "directory" type problems, with the intention that if we had
a directory of objects (humans, computers, printers, etc.) we could use digital certificates to establish a hierarchy of
those objects, and use the certificates to establish authenticity between objects.

## What is a Root Certificate Authority (CA)?

It's simply an entity that issues digital certificates.

## What is an Intermediate CA?

It's a child certificate of the root certificate, which can be used to issue additional Intermediate CA certificates
or End-entity certificates.

## What is an End-entity certificate?

The End-entity is the last certificate issued to an actual Object. In most case this certificate represents a Server or
a Client, but remember, it can truly be almost anything.

## Why do we need Intermediate CAs?

By using Intermediate CAs we're able to keep the total number of Root Certificates that we trust to a relatively low
number. In the event that an Intermediate certificate expires, or is compromised, it's much easier to replace the
Intermediate certificate with a new one, then update the list of trusted CAs.

## What's a Certificate Chain of Trust?

In order to for your client to trust the authenticity of the final end-entity certificate your server uses, we must be able
to establish links from the end-entity certificate all the way back to the Root certificate:

![certificate chain of trust](/img/1920px-Chain_of_trust.svg.png)

Those links are what make up the "Chain of Trust", and enable us to have a very flexible certificate hierarchy which can
sometimes prove useful.

## A Practical Example with Amazon RDS Certificates

Let us use the [Amazon RDS certificates](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html) as an example.

Amazon RDS has 1 Root certificate, and 1 Intermediate certificate per region. It's recommended that by default you deploy
and trust the 1 Root certificate. However, when Amazon issues your database instance an End-entity certificate, it will be
issued from the regional Intermediate certificate, which was created by the Root certificate.

By using an Intermediate certificate per region Amazon can more easily manage expiration, revocation, and compromise
because the event(s) will now only happen at the regional level. This means if the us-east-1 RDS certificate needs to be
replaced, only us-east-1 RDS instances will be affected. Additionally, because we deployed and trust the Root certificate,
the new, and all future, certificates created by new Intermediate certificates will typically continue to be trusted.
 