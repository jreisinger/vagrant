#!/bin/bash

yum install bind bind-utils -y

cat > /etc/named.conf <<'EOF'
options {
        #listen-on port 53 { 127.0.0.1; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        allow-query     { any; };

        allow-transfer { localhost; 10.0.15.12; };

        /*
         - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
         - If you are building a RECURSIVE (caching) DNS server, you need to enable
           recursion.
         - If your recursive DNS server has a public IP address, you MUST enable access
           control to limit queries to your legitimate users. Failing to do so will
           cause your server to become part of large scale DNS amplification
           attacks. Implementing BCP38 within your network would greatly
           reduce such attack surface
        */
        recursion no;

        dnssec-enable yes;
        dnssec-validation yes;
        dnssec-lookaside auto;

        /* Path to ISC DLV key */
        bindkeys-file "/etc/named.iscdlv.key";

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

zone "mydomain.com" IN {
        type master;
        file "mydomain.com.zone";
        allow-update { none; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

cat > /var/named/mydomain.com.zone <<'EOF'
$TTL 86400
@   IN  SOA     ns1.mydomain.com. root.mydomain.com. (
        2013042201  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
; Specify our two nameservers
                IN      NS              ns1.mydomain.com.
                IN      NS              ns2.mydomain.com.
; Resolve nameserver hostnames to IP, replace with your two droplet IP addresses.
ns1             IN      A               10.0.15.11
ns2             IN      A               10.0.15.12

; Define hostname -> IP pairs which you wish to resolve
@               IN      A               10.0.15.13
www             IN      A               10.0.15.13
EOF

service named restart
chkconfig named on
