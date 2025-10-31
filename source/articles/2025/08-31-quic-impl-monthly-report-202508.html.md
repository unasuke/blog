---
title: "QUIC実装月報 2025年8月"
date: 2025-08-31 15:15 JST
tags: 
- quic
- tls
---

![8月のcommits stats](2025/quic-impl-monthly-report-202508-commits-stats.png)


## 8月やったこと
* Alert protocolの実装やりなおし
    * データ構造を変更しただけで、Alertが来たら終了するとかは未着手
* Client側Handshakeのリファクタリング
* SSLKEYLOGDFILEを吐けるように

<https://github.com/unasuke/raiha/compare/8dde7de...dd723bb>

SSLKEYLOGFILEを出力できるようにすることで、wiresharkを使ったデバッグが捗るようになりました。最高！

[5月のそそのかされ](/2025/quic-impl-monthly-report-202505/)からようやく、`www.example.com` へのHTTPSリクエストが受信できるようになりました。ただちょっとSignature Algorithmsを変えると証明書検証に失敗するようになってよくわからない状態になっています(後述)。

そしてこちらが[8/30に開催されたRubyKaigi 2025 follow up](https://rhc.connpass.com/event/356128/)の発表資料です。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2025-followup/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2025-followup/" title="RubyKaigi 2025 followup">RubyKaigi 2025 followup</a>
</div>


予告しておきますが、9月の進捗はありません。

## 今行き詰まっていること
`CertificateVerify`の検証がうまくいきません。

`SampleHttpsClient` というものを作成し、そこでは `www.example.com` に対してHTTP GET requestを送信しています。そこでの `Certificate` を眺めていると、証明書に `www.example.com` の証明書であるという情報が入っていませんでした。

```ruby
#<OpenSSL::X509::Certificate
 subject=#<OpenSSL::X509::Name CN=a248.e.akamai.net,O=Akamai Technologies\, Inc.,L=Cambridge,ST=Massachusetts,C=US>,
 issuer=#<OpenSSL::X509::Name CN=DigiCert TLS Hybrid ECC SHA384 2020 CA1,O=DigiCert Inc,C=US>,
 serial=#<OpenSSL::BN 13835825224934513434443952284298366893>,
 not_before=2025-03-18 00:00:00 UTC,
 not_after=2026-03-18 23:59:59 UTC>
#<OpenSSL::X509::Certificate
 subject=#<OpenSSL::X509::Name CN=DigiCert TLS Hybrid ECC SHA384 2020 CA1,O=DigiCert Inc,C=US>,
 issuer=#<OpenSSL::X509::Name CN=DigiCert Global Root CA,OU=www.digicert.com,O=DigiCert Inc,C=US>,
 serial=#<OpenSSL::BN 10566067766768619126890179173671052733>,
 not_before=2021-04-14 00:00:00 UTC,
 not_after=2031-04-13 23:59:59 UTC>
```

<details><summary>OpenSSL::X509::Certificate#to_derの結果(クリックで展開)</summary>
<p>

<pre class="highlight"><code>
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            0a:68:ae:d9:c8:61:f6:75:e9:89:cf:ef:a6:fb:cf:ad
        Signature Algorithm: ecdsa-with-SHA384
        Issuer: C=US, O=DigiCert Inc, CN=DigiCert TLS Hybrid ECC SHA384 2020 CA1
        Validity
            Not Before: Mar 18 00:00:00 2025 GMT
            Not After : Mar 18 23:59:59 2026 GMT
        Subject: C=US, ST=Massachusetts, L=Cambridge, O=Akamai Technologies, Inc., CN=a248.e.akamai.net
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:89:b3:ad:24:07:94:73:57:59:f2:44:12:43:db:
                    01:74:aa:bd:3b:1f:86:a7:81:97:7c:21:ed:e9:8c:
                    03:eb:d2:fd:e8:2e:d4:5f:12:21:c0:9c:5a:57:1f:
                    e9:11:00:c2:6e:d8:a4:5d:d8:22:2d:cb:88:d3:45:
                    cf:11:11:5c:e1
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Authority Key Identifier: 
                0A:BC:08:29:17:8C:A5:39:6D:7A:0E:CE:33:C7:2E:B3:ED:FB:C3:7A
            X509v3 Subject Key Identifier: 
                54:88:6B:D5:A2:33:57:C7:2B:A2:13:08:F2:11:F0:AA:50:F4:4E:B8
            X509v3 Subject Alternative Name: 
                DNS:a248.e.akamai.net, DNS:*.akamaized.net, DNS:*.akamaized-staging.net, DNS:*.akamaihd.net, DNS:*.akamaihd-staging.net
            X509v3 Certificate Policies: 
                Policy: 2.23.140.1.2.2
                  CPS: http://www.digicert.com/CPS
            X509v3 Key Usage: critical
                Digital Signature, Key Agreement
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 CRL Distribution Points: 
                Full Name:
                  URI:http://crl3.digicert.com/DigiCertTLSHybridECCSHA3842020CA1-1.crl
                Full Name:
                  URI:http://crl4.digicert.com/DigiCertTLSHybridECCSHA3842020CA1-1.crl
            Authority Information Access: 
                OCSP - URI:http://ocsp.digicert.com
                CA Issuers - URI:http://cacerts.digicert.com/DigiCertTLSHybridECCSHA3842020CA1-1.crt
            X509v3 Basic Constraints: critical
                CA:FALSE
            CT Precertificate SCTs: 
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : 0E:57:94:BC:F3:AE:A9:3E:33:1B:2C:99:07:B3:F7:90:
                                DF:9B:C2:3D:71:32:25:DD:21:A9:25:AC:61:C5:4E:21
                    Timestamp : Mar 18 17:53:36.647 2025 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:46:02:21:00:EB:00:F2:E9:62:D6:49:55:89:C1:E4:
                                05:19:1E:2A:5E:BD:A9:D1:78:75:02:D9:D7:B0:CD:4B:
                                F2:D0:A8:EE:11:02:21:00:C6:76:D7:59:97:0B:01:EE:
                                C1:5A:01:C1:46:4A:16:3A:D9:E1:68:85:AC:5E:14:63:
                                7C:80:FE:8A:4F:37:36:7B
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : 49:9C:9B:69:DE:1D:7C:EC:FC:36:DE:CD:87:64:A6:B8:
                                5B:AF:0A:87:80:19:D1:55:52:FB:E9:EB:29:DD:F8:C3
                    Timestamp : Mar 18 17:53:36.713 2025 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:45:02:21:00:D6:F2:EA:2A:74:A5:AC:EE:7E:77:C8:
                                98:55:13:7C:02:B4:18:08:F1:14:87:5B:2A:0E:42:37:
                                D6:88:81:17:1B:02:20:71:66:25:CB:EB:56:DC:81:B5:
                                A2:9C:C8:81:50:7D:61:52:E0:1F:B5:4D:1B:88:7B:46:
                                02:82:7F:03:5C:10:02
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : CB:38:F7:15:89:7C:84:A1:44:5F:5B:C1:DD:FB:C9:6E:
                                F2:9A:59:CD:47:0A:69:05:85:B0:CB:14:C3:14:58:E7
                    Timestamp : Mar 18 17:53:36.669 2025 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:45:02:20:4A:43:35:C2:AB:B9:8B:AC:78:0D:82:E0:
                                19:84:17:01:BA:A9:B6:C1:7F:54:BA:39:C8:DD:3A:FF:
                                FD:95:59:CB:02:21:00:DE:98:C0:7E:D2:C2:D7:E3:BE:
                                42:C7:DB:4B:E7:90:E6:F9:4D:1C:6A:7C:8F:37:44:D4:
                                B2:BC:24:1C:7E:87:98
    Signature Algorithm: ecdsa-with-SHA384
    Signature Value:
        30:65:02:30:4a:bd:dd:5d:15:a2:30:c8:5a:a4:3f:e9:db:d1:
        5a:06:b1:81:fc:13:5c:04:ad:dd:0d:08:a0:09:e5:ce:11:dc:
        9a:6b:4c:88:36:4f:b9:83:f6:eb:90:57:d7:f8:3a:f6:02:31:
        00:b3:9d:f3:57:79:99:48:16:5a:e6:c5:8a:7f:ea:14:2d:17:
        25:30:ba:ea:a3:17:ce:67:5c:05:9f:64:a7:a1:8d:c1:df:d7:
        17:3e:04:5b:5b:67:0d:27:4b:32:0e:3c:2b
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            07:f2:f3:5c:87:a8:77:af:7a:ef:e9:47:99:35:25:bd
        Signature Algorithm: sha384WithRSAEncryption
        Issuer: C=US, O=DigiCert Inc, OU=www.digicert.com, CN=DigiCert Global Root CA
        Validity
            Not Before: Apr 14 00:00:00 2021 GMT
            Not After : Apr 13 23:59:59 2031 GMT
        Subject: C=US, O=DigiCert Inc, CN=DigiCert TLS Hybrid ECC SHA384 2020 CA1
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (384 bit)
                pub:
                    04:c1:1b:c6:9a:5b:98:d9:a4:29:a0:e9:d4:04:b5:
                    db:eb:a6:b2:6c:55:c0:ff:ed:98:c6:49:2f:06:27:
                    51:cb:bf:70:c1:05:7a:c3:b1:9d:87:89:ba:ad:b4:
                    13:17:c9:a8:b4:83:c8:b8:90:d1:cc:74:35:36:3c:
                    83:72:b0:b5:d0:f7:22:69:c8:f1:80:c4:7b:40:8f:
                    cf:68:87:26:5c:39:89:f1:4d:91:4d:da:89:8b:e4:
                    03:c3:43:e5:bf:2f:73
                ASN1 OID: secp384r1
                NIST CURVE: P-384
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier: 
                0A:BC:08:29:17:8C:A5:39:6D:7A:0E:CE:33:C7:2E:B3:ED:FB:C3:7A
            X509v3 Authority Key Identifier: 
                03:DE:50:35:56:D1:4C:BB:66:F0:A3:E2:1B:1B:C3:97:B2:3D:D1:55
            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign, CRL Sign
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication
            Authority Information Access: 
                OCSP - URI:http://ocsp.digicert.com
                CA Issuers - URI:http://cacerts.digicert.com/DigiCertGlobalRootCA.crt
            X509v3 CRL Distribution Points: 
                Full Name:
                  URI:http://crl3.digicert.com/DigiCertGlobalRootCA.crl
            X509v3 Certificate Policies: 
                Policy: 2.16.840.1.114412.2.1
                Policy: 2.23.140.1.1
                Policy: 2.23.140.1.2.1
                Policy: 2.23.140.1.2.2
                Policy: 2.23.140.1.2.3
    Signature Algorithm: sha384WithRSAEncryption
    Signature Value:
        47:59:81:7f:d4:1b:1f:b0:71:f6:98:5d:18:ba:98:47:98:b0:
        7e:76:2b:ea:ff:1a:8b:ac:26:b3:42:8d:31:e6:4a:e8:19:d0:
        ef:da:14:e7:d7:14:92:a1:92:f2:a7:2e:2d:af:fb:1d:f6:fb:
        53:b0:8a:3f:fc:d8:16:0a:e9:b0:2e:b6:a5:0b:18:90:35:26:
        a2:da:f6:a8:b7:32:fc:95:23:4b:c6:45:b9:c4:cf:e4:7c:ee:
        e6:c9:f8:90:bd:72:e3:99:c3:1d:0b:05:7c:6a:97:6d:b2:ab:
        02:36:d8:c2:bc:2c:01:92:3f:04:a3:8b:75:11:c7:b9:29:bc:
        11:d0:86:ba:92:bc:26:f9:65:c8:37:cd:26:f6:86:13:0c:04:
        aa:89:e5:78:b1:c1:4e:79:bc:76:a3:0b:51:e4:c5:d0:9e:6a:
        fe:1a:2c:56:ae:06:36:27:a3:73:1c:08:7d:93:32:d0:c2:44:
        19:da:8d:f4:0e:7b:1d:28:03:2b:09:8a:76:ca:77:dc:87:7a:
        ac:7b:52:26:55:a7:72:0f:9d:d2:88:4f:fe:b1:21:c5:1a:a1:
        aa:39:f5:56:db:c2:84:c4:35:1f:70:da:bb:46:f0:86:bf:64:
        00:c4:3e:f7:9f:46:1b:9d:23:05:b9:7d:b3:4f:0f:a9:45:3a:
        e3:74:30:98

</code></pre>


</p>
</details>


この状態でどうやってこの証明書が `www.example.com` のものか検証するのかよくわからなくなり、そういえば`ClientHello`において [`server_name` extension (RFC 6066)](https://datatracker.ietf.org/doc/html/rfc6066#section-3)を付けていなかったことを思い出し、`ClientHello`に `server_name` 拡張を含めてサーバー側に送信するようにしました。すると`Certificate` に含まれる証明書のCommon Nameに `*.example.com`が含まれるようになりました。

```ruby
#<OpenSSL::X509::Certificate
 subject=#<OpenSSL::X509::Name CN=*.example.com,O=Internet Corporation for Assigned Names and Numbers,L=Los Angeles,ST=California,C=US>,
 issuer=#<OpenSSL::X509::Name CN=DigiCert Global G3 TLS ECC SHA384 2020 CA1,O=DigiCert Inc,C=US>,
 serial=#<OpenSSL::BN 14416812407440461216471976375640436634>,
 not_before=2025-01-15 00:00:00 UTC,
 not_after=2026-01-15 23:59:59 UTC>
#<OpenSSL::X509::Certificate
 subject=#<OpenSSL::X509::Name CN=DigiCert Global G3 TLS ECC SHA384 2020 CA1,O=DigiCert Inc,C=US>,
 issuer=#<OpenSSL::X509::Name CN=DigiCert Global Root G3,OU=www.digicert.com,O=DigiCert Inc,C=US>,
 serial=#<OpenSSL::BN 14626237344301700912191253757342652550>,
 not_before=2021-04-14 00:00:00 UTC,
 not_after=2031-04-13 23:59:59 UTC>
```

<details><summary>server_name拡張を付けた場合に返ってくる証明書のOpenSSL::X509::Certificate#to_derの結果(クリックで展開)</summary>
<p>

<pre class="highlight"><code>
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            0a:d8:93:ba:fa:68:b0:b7:fb:7a:40:4f:06:ec:af:9a
        Signature Algorithm: ecdsa-with-SHA384
        Issuer: C=US, O=DigiCert Inc, CN=DigiCert Global G3 TLS ECC SHA384 2020 CA1
        Validity
            Not Before: Jan 15 00:00:00 2025 GMT
            Not After : Jan 15 23:59:59 2026 GMT
        Subject: C=US, ST=California, L=Los Angeles, O=Internet Corporation for Assigned Names and Numbers, CN=*.example.com
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:9a:48:97:84:2d:61:6c:08:c9:6a:14:a0:c8:38:
                    80:e6:00:c0:87:fa:99:57:0e:1b:00:e2:d8:87:92:
                    57:e7:08:fb:3c:5e:b0:d3:84:28:37:c1:24:11:8e:
                    d3:20:71:74:bd:93:8f:4e:09:03:ce:02:3b:b0:e4:
                    66:73:cf:af:ee
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Authority Key Identifier: 
                8A:23:EB:9E:6B:D7:F9:37:5D:F9:6D:21:39:76:9A:A1:67:DE:10:A8
            X509v3 Subject Key Identifier: 
                F0:C1:6A:32:0D:EC:DA:C7:EA:8F:CD:0D:6D:19:12:59:D1:BE:72:ED
            X509v3 Subject Alternative Name: 
                DNS:*.example.com, DNS:example.com
            X509v3 Certificate Policies: 
                Policy: 2.23.140.1.2.2
                  CPS: http://www.digicert.com/CPS
            X509v3 Key Usage: critical
                Digital Signature, Key Agreement
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 CRL Distribution Points: 
                Full Name:
                  URI:http://crl3.digicert.com/DigiCertGlobalG3TLSECCSHA3842020CA1-2.crl
                Full Name:
                  URI:http://crl4.digicert.com/DigiCertGlobalG3TLSECCSHA3842020CA1-2.crl
            Authority Information Access: 
                OCSP - URI:http://ocsp.digicert.com
                CA Issuers - URI:http://cacerts.digicert.com/DigiCertGlobalG3TLSECCSHA3842020CA1-2.crt
            X509v3 Basic Constraints: critical
                CA:FALSE
            CT Precertificate SCTs: 
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : 0E:57:94:BC:F3:AE:A9:3E:33:1B:2C:99:07:B3:F7:90:
                                DF:9B:C2:3D:71:32:25:DD:21:A9:25:AC:61:C5:4E:21
                    Timestamp : Jan 15 01:01:25.319 2025 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:43:02:1F:24:17:0F:5A:4C:7C:D2:29:3B:B8:B6:16:
                                E8:E1:AF:35:8B:C9:E0:D9:8E:47:64:57:73:DB:AF:88:
                                53:C7:E9:02:20:52:DB:AE:51:E9:C7:21:3E:54:35:62:
                                5F:7C:10:51:AB:7D:6D:50:68:BB:64:34:D2:AE:B3:34:
                                7F:8C:F5:55:AE
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : 64:11:C4:6C:A4:12:EC:A7:89:1C:A2:02:2E:00:BC:AB:
                                4F:28:07:D4:1E:35:27:AB:EA:FE:D5:03:C9:7D:CD:F0
                    Timestamp : Jan 15 01:01:25.381 2025 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:44:02:20:70:AE:E8:D8:07:85:5D:50:BE:27:FF:1B:
                                B0:47:AB:B7:22:30:61:FC:8D:D7:21:FF:1C:B8:2F:3A:
                                D8:95:EB:17:02:20:72:30:53:2F:0E:11:A0:E2:C6:26:
                                D4:CB:2B:0C:65:5E:75:CC:29:13:87:8D:D1:1B:99:70:
                                51:A6:5B:1C:09:72
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : 49:9C:9B:69:DE:1D:7C:EC:FC:36:DE:CD:87:64:A6:B8:
                                5B:AF:0A:87:80:19:D1:55:52:FB:E9:EB:29:DD:F8:C3
                    Timestamp : Jan 15 01:01:25.401 2025 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:45:02:20:68:58:7A:EF:21:10:DA:5C:20:9B:75:F5:
                                EA:7D:A2:5A:31:10:14:82:36:6F:67:E9:38:DB:41:56:
                                26:D9:55:6C:02:21:00:F9:A6:CA:A3:5C:36:2C:20:46:
                                F5:87:28:74:4B:C6:C1:37:73:B8:BB:6B:00:F7:38:AC:
                                28:89:58:8D:98:3C:C2
    Signature Algorithm: ecdsa-with-SHA384
    Signature Value:
        30:65:02:31:00:f9:a6:82:46:53:db:6f:e5:58:fa:ee:1a:bc:
        fc:9a:1b:b7:ef:50:32:6a:37:c2:b0:96:b5:c3:e1:7a:6d:4f:
        b4:0b:f8:3d:37:f8:10:3f:15:41:28:dd:d0:f5:8b:3d:fb:02:
        30:64:63:78:e1:b2:e2:c0:5b:ba:56:b0:36:ed:5f:f4:30:c6:
        9e:a4:36:c2:b8:8e:1d:7f:46:3b:d5:ff:6e:b4:b3:14:30:33:
        f1:8c:ee:dd:3e:4f:4b:8f:d8:bf:98:d7:65
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            0b:00:e9:2d:4d:6d:73:1f:ca:30:59:c7:cb:1e:18:86
        Signature Algorithm: ecdsa-with-SHA384
        Issuer: C=US, O=DigiCert Inc, OU=www.digicert.com, CN=DigiCert Global Root G3
        Validity
            Not Before: Apr 14 00:00:00 2021 GMT
            Not After : Apr 13 23:59:59 2031 GMT
        Subject: C=US, O=DigiCert Inc, CN=DigiCert Global G3 TLS ECC SHA384 2020 CA1
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (384 bit)
                pub:
                    04:78:a9:9c:75:ae:88:5d:63:a4:ad:5d:86:d8:10:
                    49:d6:af:92:59:63:43:23:85:f4:48:65:30:cd:4a:
                    34:95:a6:0e:3e:d9:7c:08:d7:57:05:28:48:9e:0b:
                    ab:eb:c2:d3:96:9e:ed:45:d2:8b:8a:ce:01:4b:17:
                    43:e1:73:cf:6d:73:48:34:dc:00:46:09:b5:56:54:
                    c9:5f:7a:c7:13:07:d0:6c:18:17:6c:ca:db:c7:0b:
                    26:56:2e:8d:07:f5:67
                ASN1 OID: secp384r1
                NIST CURVE: P-384
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier: 
                8A:23:EB:9E:6B:D7:F9:37:5D:F9:6D:21:39:76:9A:A1:67:DE:10:A8
            X509v3 Authority Key Identifier: 
                B3:DB:48:A4:F9:A1:C5:D8:AE:36:41:CC:11:63:69:62:29:BC:4B:C6
            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign, CRL Sign
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication
            Authority Information Access: 
                OCSP - URI:http://ocsp.digicert.com
                CA Issuers - URI:http://cacerts.digicert.com/DigiCertGlobalRootG3.crt
            X509v3 CRL Distribution Points: 
                Full Name:
                  URI:http://crl3.digicert.com/DigiCertGlobalRootG3.crl
            X509v3 Certificate Policies: 
                Policy: 2.16.840.1.114412.2.1
                Policy: 2.23.140.1.1
                Policy: 2.23.140.1.2.1
                Policy: 2.23.140.1.2.2
                Policy: 2.23.140.1.2.3
    Signature Algorithm: ecdsa-with-SHA384
    Signature Value:
        30:65:02:30:7e:26:58:6e:ee:88:ec:0c:dd:15:41:ee:7a:b8:
        99:99:70:d1:62:65:4f:a0:20:9e:47:b1:5b:c1:b2:67:31:1d:
        cc:72:7a:af:22:72:40:42:6e:65:84:fe:87:4b:0f:19:02:31:
        00:e6:bf:d6:ae:34:87:5b:3f:67:c7:1d:a8:6f:d5:12:78:b5:
        e6:87:31:44:a9:5d:c6:b8:78:cc:cf:ef:d4:32:58:11:ff:3a:
        85:06:3c:1d:84:6f:d3:f5:f9:da:33:1c:a4
</code></pre>

</p>
</details>


が、しかし、`server_name`を付けるようにしたhandshakeにおいては、 `CertificateVerify`によって返却されるsignatureに対しての [`OpenSSL::PKey::PKey#verify`](https://docs.ruby-lang.org/en/master/OpenSSL/PKey/PKey.html#method-i-verify) が成功しなくなります。なんで……？

まあそうなると、こっちで導出しているTranscript HashとServer側で導出しているTranscript Hashが一致していないということが考えられるわけです。

なので(？)一旦Server側も `openssl s_server` で起動した、手元でどう動いているか確認できるものに対してリクエストを飛ばすようにしてみました。すると`server_name`を付けているのに`OpenSSL::PKey::PKey#verify`が通るようになってしまい、後段のHTTP GET requestも受信できるようになってしまいました。なんで……？またさらに、HTTP GET requestではなく単純な文字列、例として `HELLO` を送信してみると、これもdecode_errorにはならずにちゃんと受けとれますし、OpenSSL側からのメッセージも自分の実装で復号できます。

![実行した様子](2025/quic-impl-monthly-report-202508-debugging.png)

現状をまとめると、以下のようになっています。

* `www.example.com` に対して
    * `server_name`拡張なしの場合HTTP GET requestが成功する (verify成功)
    * `server_name`拡張ありの場合`OpenSSL::PKey::PKey#verify`が失敗する
* `openssl s_server`に対して
    * `server_name`拡張なしの場合`OpenSSL::PKey::PKey#verify`が成功する
    * `server_name`拡張ありの場合`OpenSSL::PKey::PKey#verify`が成功する
        * 自前実装からの`HELLO`の送信に成功する
        * OpenSSL側からの`WORLD`の受信に成功する

行き詰まっています。

## 2025-10-31 追記
[解決しました](/2025/quic-impl-monthly-report-202510/)
