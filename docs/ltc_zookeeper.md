---
id: ltc_zookeeper
title: Zookeeper Code Snippets
sidebar_label: Zookeeper Code Snippets
---

[ZKTrustManager.java](https://github.com/apache/zookeeper/blob/master/zookeeper-server/src/main/java/org/apache/zookeeper/common/ZKTrustManager.java)

```java
/**
 * Compares peer's hostname with the one stored in the provided client certificate. Performs verification
 * with the help of provided HostnameVerifier.
 *
 * @param inetAddress Peer's inet address.
 * @param certificate Peer's certificate
 * @throws CertificateException Thrown if the provided certificate doesn't match the peer hostname.
 */
private void performHostVerification(
    InetAddress inetAddress,
    X509Certificate certificate
                                    ) throws CertificateException {
    String hostAddress = "";
    String hostName = "";
    try {
        hostAddress = inetAddress.getHostAddress();
        hostnameVerifier.verify(hostAddress, certificate);
    } catch (SSLException addressVerificationException) {
        try {
            LOG.debug(
                "Failed to verify host address: {} attempting to verify host name with reverse dns lookup",
                hostAddress,
                addressVerificationException);
            hostName = inetAddress.getHostName();
            hostnameVerifier.verify(hostName, certificate);
        } catch (SSLException hostnameVerificationException) {
            LOG.error("Failed to verify host address: {}", hostAddress, addressVerificationException);
            LOG.error("Failed to verify hostname: {}", hostName, hostnameVerificationException);
            throw new CertificateException("Failed to verify both host address and host name", hostnameVerificationException);
        }
    }
}
```

[ZKhostnameVerifier.java](https://github.com/apache/zookeeper/blob/master/zookeeper-server/src/main/java/org/apache/zookeeper/common/ZKHostnameVerifier.java)

```java
void verify(final String host, final X509Certificate cert) throws SSLException {
    final HostNameType hostType = determineHostFormat(host);
    final List<SubjectName> subjectAlts = getSubjectAltNames(cert);
    if (subjectAlts != null && !subjectAlts.isEmpty()) {
        switch (hostType) {
        case IPv4:
            matchIPAddress(host, subjectAlts);
            break;
        case IPv6:
            matchIPv6Address(host, subjectAlts);
            break;
        default:
            matchDNSName(host, subjectAlts);
        }
    } else {
        // CN matching has been deprecated by rfc2818 and can be used
        // as fallback only when no subjectAlts are available
        final X500Principal subjectPrincipal = cert.getSubjectX500Principal();
        final String cn = extractCN(subjectPrincipal.getName(X500Principal.RFC2253));
        if (cn == null) {
            throw new SSLException("Certificate subject for <"
                                   + host
                                   + "> doesn't contain "
                                   + "a common name and does not have alternative names");
        }
        matchCN(host, cn);
    }
}
```

```java
private static List<SubjectName> getSubjectAltNames(final X509Certificate cert) {
    try {
        final Collection<List<?>> entries = cert.getSubjectAlternativeNames();
        if (entries == null) {
            return Collections.emptyList();
        }
        final List<SubjectName> result = new ArrayList<SubjectName>();
        for (List<?> entry : entries) {
            final Integer type = entry.size() >= 2 ? (Integer) entry.get(0) : null;
            if (type != null) {
                final String s = (String) entry.get(1);
                result.add(new SubjectName(s, type));
            }
        }
        return result;
    } catch (final CertificateParsingException ignore) {
        return Collections.emptyList();
    }
}
```