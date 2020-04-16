---
id: ltc_nomad
title: Nomad Code Snippets
sidebar_label: Nomad Code Snippets
---

To fulfill desired security properties, Nomad certificates can be signed with their region and role in their certificate
`Common Name` such as:

* `client.global.nomad` for a `client` node in the `global` region
* `server.us-west.nomad` for a `server` node in the `us-west` region

Let's take a look at how these certificates are validated in the code.

## Standard TLS

In the Golang standard `tls` package in [common.go L511-L522](https://github.com/golang/go/blob/master/src/crypto/tls/common.go#L511-L522)
there's the ability to supply a function which can do additional verification of a peer certificate.

```go
// VerifyPeerCertificate, if not nil, is called after normal
// certificate verification by either a TLS client or server. It
// receives the raw ASN.1 certificates provided by the peer and also
// any verified chains that normal processing found. If it returns a
// non-nil error, the handshake is aborted and that error results.
//
// If normal verification fails then the handshake will abort before
// considering this callback. If normal verification is disabled by
// setting InsecureSkipVerify, or (for a server) when ClientAuth is
// RequestClientCert or RequireAnyClientCert, then this callback will
// be considered but the verifiedChains argument will always be nil.
VerifyPeerCertificate func(rawCerts [][]byte, verifiedChains [][]*x509.Certificate)
``` 

## Nomad Server

Nomad wires this up in their tls config in [server.go L451-L447](https://github.com/hashicorp/nomad/blob/v0.10.3/nomad/server.go#L451-L477):

```go
func getTLSConf(enableRPC bool, tlsConf *tlsutil.Config, region string) (*tls.Config, tlsutil.RegionWrapper, error) {
	var tlsWrap tlsutil.RegionWrapper
	var incomingTLS *tls.Config
	if !enableRPC {
		return incomingTLS, tlsWrap, nil
	}

	tlsWrap, err := tlsConf.OutgoingTLSWrapper()
	if err != nil {
		return nil, nil, err
	}

	itls, err := tlsConf.IncomingTLSConfig()
	if err != nil {
		return nil, nil, err
	}

	if tlsConf.VerifyServerHostname {
		incomingTLS = itls.Clone()
		incomingTLS.VerifyPeerCertificate = rpcNameAndRegionValidator(region)
	} else {
		incomingTLS = itls
	}
	return incomingTLS, tlsWrap, nil
}
```

Specifically in the `if tlsConf.VerifyServerHostname {}` where it sets the function to `rpcNameAndRegionValidator(region)`.

This method is defined later on in [server.go L479-L497](https://github.com/hashicorp/nomad/blob/v0.10.3/nomad/server.go#L479-L497):

```go
// implements signature of tls.Config.VerifyPeerCertificate which is called
// after the certs have been verified. We'll ignore the raw certs and only
// check the verified certs.
func rpcNameAndRegionValidator(region string) func([][]byte, [][]*x509.Certificate) error {
	return func(_ [][]byte, certificates [][]*x509.Certificate) error {
		if len(certificates) > 0 && len(certificates[0]) > 0 {
			cert := certificates[0][0]
			for _, dnsName := range cert.DNSNames {
				if validateRPCRegionPeer(dnsName, region) {
					return nil
				}
			}
			if validateRPCRegionPeer(cert.Subject.CommonName, region) {
				return nil
			}
		}
		return errors.New("invalid role or region for certificate")
	}
}
```

And `validateRPCRegionPeer` is right below, in [server.go L499-L515](https://github.com/hashicorp/nomad/blob/v0.10.3/nomad/server.go#L499-L515):

```go
func validateRPCRegionPeer(name, region string) bool {
	parts := strings.Split(name, ".")
	if len(parts) < 3 {
		// Invalid SAN
		return false
	}
	if parts[len(parts)-1] != "nomad" {
		// Incorrect service
		return false
	}
	if parts[0] == "client" {
		// Clients may only connect to servers in their region
		return name == "client."+region+".nomad"
	}
	// Servers may connect to any Nomad RPC service for federation.
	return parts[0] == "server"
}
```

Where the interesting happen when we check if the first part is a `client` or a `server`.
