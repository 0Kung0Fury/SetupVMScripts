```markdown
# 🛡️ Linux ProtonVPN Router Toolkit

A collection of **hardened Bash scripts** to turn a Linux machine into a **locked-down VPN router** using **ProtonVPN**, featuring:

- Automatic ProtonVPN **country rotation**
- Secure **iptables firewall**
- **DHCP server** for LAN clients
- System update & ProtonVPN CLI installer
- Cron-based rotation with logging & locking

Designed for **headless servers, routers, and privacy gateways**.

---

## 📦 Included Scripts

### 1️⃣ ProtonVPN Country Rotator
Automatically rotates ProtonVPN exit countries on a schedule.

**Features**
- Random country selection  
- Prevents overlapping runs with lockfile  
- Runs on boot and every 90 minutes  
- Full logging  

**Installed to**
```

/usr/local/bin/proton-rotator.sh

```

**Log file**
```

/var/log/proton-rotator.log

```

**Countries Used**
```

US, CA, MX, NL, RO, PL, NO, CH, JP, SG

```

---

### 2️⃣ Locked-Down Router Firewall
A secure `iptables` firewall for a Linux router.

**Security Model**
- Default DROP on INPUT & FORWARD  
- LAN → WAN allowed  
- WAN → LAN blocked  
- NAT masquerading enabled  
- SSH & ICMP allowed from LAN only  
- Invalid packets dropped  

**Prompts for**
```

WAN interface (e.g. eth0)
LAN interface (e.g. eth1)

```

---

### 3️⃣ System Update & ProtonVPN CLI Installer
Keeps the system clean and installs ProtonVPN CLI.

**What it does**
- Updates & upgrades system packages  
- Installs `proton-vpn-cli`  
- Removes unused packages  
- Cleans package cache  

---

### 4️⃣ DHCP Server Setup (LAN)
Configures `isc-dhcp-server` for LAN clients.

**Defaults**
- Interface: `eth1`  
- Subnet: `192.168.77.0/24`  
- Gateway: `192.168.77.1`  
- DNS: `1.1.1.1`, `8.8.8.8`  
- Lease range: `192.168.77.2 – 192.168.77.254`  

Backs up existing configuration automatically.

---

## 🚀 Installation Order (Recommended)

Run scripts **as root** or using `sudo`.

1. System update & ProtonVPN install  
2. Firewall setup  
3. DHCP server setup  
4. ProtonVPN country rotator installer  

---

## ⏱️ ProtonVPN Rotation Schedule

Configured via `cron`:

- On system boot  
- Every **90 minutes**

```

@reboot proton-rotator.sh
0 */3 * * * proton-rotator.sh
30 */3 * * * proton-rotator.sh

```

---

## 🔐 Requirements

- Debian / Ubuntu-based Linux  
- Root access  
- ProtonVPN account  
- `iptables`  
- `cron`  
- `isc-dhcp-server`  

---

## ⚠️ Notes & Warnings

- Ensure ProtonVPN is **logged in** before enabling rotation:
```

protonvpn login

```

- Test firewall rules via console access to avoid lockouts.
- WAN interface should be your **VPN-bound interface**.
- LAN interface should connect only to trusted clients.

---

## 📜 Logs & Files

| Purpose | Location |
|------|---------|
| VPN rotation log | `/var/log/proton-rotator.log` |
| Lockfile | `/var/run/proton-rotator.lock` |
| Rotator script | `/usr/local/bin/proton-rotator.sh` |
| DHCP config backup | `/etc/dhcp/dhcpd.conf.bak` |

---

## 🧠 Use Cases

- Privacy router  
- VPN kill-switch gateway  
- Home lab isolation  
- Torrent / streaming gateway  
- Rotating egress IP system  

---

## 📄 License

MIT License  
Use at your own risk.

---

## 🤝 Contributions

Pull requests welcome.  
Security improvements & country list expansions encouraged.
```
