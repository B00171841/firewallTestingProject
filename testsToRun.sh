# Focus is on detailled explanation of firewall configuration, not the sophistication of attacks.
sudo su # Make sure you are sudo for all of these commands.

firewall_ip=  # Replace with IP

# Reconissance attacks - Seeing if an attacker can see the services running on web server mainly, also firewall.
## This will take several minutes, scans all ports. Returns open ports, http string and OS information.
nmap -A -p- firewall_ip

## UDP scans are pointless due to ssh and http using TCP.


# Packet fragmentation (ICMP flooding attacks)

## Testing strength of packet filter
hping3 -1 -f firewall_ip   # -1 uses ICMP, -f fragments packets
hping3 -1 -f -d 1500 192.168.183.243
# You could include --flood in here if you want.

## Deterimental attack (be careful running on limited resources. This WILL nearly crash firewall.
hping3 -1 --flood --rand-source -x -d 1500 192.168.183.243

# Firewall security - Goal is to set up rate limiting.
## Note: May just change this to SSH attacks, in the interest of simplicity and more importantly time.

## Rate limiting interfaces. floods address with traffic.
hping3 --flood firewall_ip

## Or we can use plain ping (linux method)
ping -i 0.05 -f firewall_ip
## To test timeout, manyally ssh with incorrect credentials
ssh root@firewall_ip 

## Using hydra to brute force ssh
hydra -l root -t 3 -P /usr/share/wordlists/rockyou.txt ssh://firewall_ip:22 # You have to extract rockyou on kali, gzip -u /usr/share/wordlists/rockyou.txt.gz

## Using wrk to load test web servers
### -t is threads, -c is connections, -d is duration
wrk -t 4 -c 4 -d 20 http://firewall_ip

sudo apt install wrk # Wrk is not be installed in kali.
