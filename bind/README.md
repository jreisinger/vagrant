* primary and slave nameserver with basic settings and mydomain.com zone file
* nsupdate

Check DNS is working

    [root@primary ~]# dig @10.0.15.11 mydomain.com
    [root@primary ~]# dig @10.0.15.11 ansible.mydomain.com

    [root@slave ~]# dig @10.0.15.12 mydomain.com

NOTE: zone transfer primary => slave does not seem to work (networking issue?)

        telnet 10.0.15.11 53
        nc -vu 10.0.15.11 53

NOTE2: there is an issue with the 'restart bind' handler

After any changes you make to the master zone files, you will need to instruct BIND to reload. Remember, you must also increment the "serial" directive to ensure synchronicity between the master and slave.

To reload the zone files, we need to run the following command on the master nameserver, followed by the slave:

    rndc reload

Resources:

* https://www.digitalocean.com/community/tutorials/how-to-install-the-bind-dns-server-on-centos-6
* http://jpmens.net/2010/09/28/performing-dynamic-dns-updates-on-your-dns/
