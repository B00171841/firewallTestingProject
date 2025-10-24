# Focus is on detailled explanation of firewall configuration, not the sophistication of attacks.
sudo su # Make sure you are sudo for all of these commands.

firewall_ip=  # Replace with IP
web_server_ip=192.168.5.253

# Reconissance attacks - Seeing if an attacker can see the services running on web server mainly, also firewall.
## This will take several minutes, scans all ports. Returns open ports, http string and OS information.
nmap -A -p- -T4 firewall_ip
nmap -A -p- -T4  web_server_ip

## UDP scans are pointless due to ssh and http using TCP.


# Packet fragmentation
## Using nmap (may bypass filter rules to block port scanning. Could combine with -A and -p-
nmap -f firewall_ip
nmap -f web_server_ip

# Ping and hping3 - goal is to see if pings are possible and if fragmentation affects if they're blocked or not.

## Will test if ping is allowed, along with larger than 1500 byte packets.
ping -s 6000 firewall_ip
ping -s 6000 web_server_ip 

## Testing strength of packet filter
hping3 -1 -f firewall_ip   # -1 uses ICMP, -f fragments packets
hping3 -1 -f web_server_ip 



# Firewall security - Goal is to set up rate limiting.

## Rate limiting interfaces. floods address with traffic.
hping3 --flood web_server_ip
hping3 --flood firewall_ip

## Or we can use plain ping (linux method)
ping -i 0.05 -f web_server_ip
ping -i 0.05 -f firewall_ip
## To test timeout, manyally ssh with incorrect credentials
ssh root@firewall_ip 

## Using wrk to load test web servers
### -t is threads, -c is connections, -d is duration
wrk -t 4 -c 4 -d 20 http://firewall_ip
wrk -t 4 -c 4 -d 20 http://web_server_ip

sudo apt install wrk # Wrk may not be installed in kali.
