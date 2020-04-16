---
id: ltc_consul
title: Consul Code Snippets
sidebar_label: Consul Code Snippets
---

If verify_server_hostname is set, then outgoing connections perform hostname verification.

All servers must have a certificate valid for `server.<datacenter>.<domain>` or the client will reject the handshake. 

This is accomlished in the `tlsutil` package in [config.go L706-L727](https://github.com/hashicorp/consul/blob/v1.7.0/tlsutil/config.go#L706-L727).
```go
// Wrap a net.Conn into a client tls connection, performing any
// additional verification as needed.
//
// As of go 1.3, crypto/tls only supports either doing no certificate
// verification, or doing full verification including of the peer's
// DNS name. For consul, we want to validate that the certificate is
// signed by a known CA, but because consul doesn't use DNS names for
// node names, we don't verify the certificate DNS names. Since go 1.3
// no longer supports this mode of operation, we have to do it
// manually.
func (c *Configurator) wrapTLSClient(dc string, conn net.Conn) (net.Conn, error) {
	config := c.OutgoingRPCConfig()
	verifyServerHostname := c.VerifyServerHostname()
	verifyOutgoing := c.verifyOutgoing()
	domain := c.domain()

	if verifyServerHostname {
		// Strip the trailing '.' from the domain if any
		domain = strings.TrimSuffix(domain, ".")
		config.ServerName = "server." + dc + "." + domain
	}
	tlsConn := tls.Client(conn, config)
```

The `if verifyServerHostname {}` block is the part that forces the TLS configuration to have a specific server name,
regardless of what else might have been provided. The `tls.Client` then uses a `Verify` function in the Standard Library
to validate the TLS connection.
