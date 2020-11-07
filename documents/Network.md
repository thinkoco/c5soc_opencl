# Enable ethernet

1. connect de10_nano to router
   
2. run `dpkg-reconfigure network-manager` 
   
3. run `dhclient eth0`

![](figure/c5soc_dhclient.png)

4. set nameserver and ping result

```
echo "nameserver 8.8.8.8" > /etc/resolv.conf
ping bing.com
```

![](figure/c5soc_nameserver.png)

