# SWB Private APT Repository

This repository hosts pre-compiled, binary-only Debian (`.deb`) packages for SWB's internal ROS 2 deployments. Source code is excluded from these packages for security.

## Quick Setup

Choose your Ubuntu version and run these commands:

### Ubuntu 22.04 (Jammy Jellyfish) - ROS 2 Humble - Stable

```bash
# Install GPG key
curl -fsSL https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/swb-robotics-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jammy main" | sudo tee /etc/apt/sources.list.d/swb-ros.list

# Update and install
sudo apt update
sudo apt install ros-humble-swb-power
```

### Ubuntu 22.04 (Jammy Jellyfish) - ROS 2 Humble - Latest (Rolling)

Rolling builds published automatically from the `main` branch on every successful CI run. Package versions carry a `+mainN` suffix. **Not stable - for testing/development only.**

```bash
# Install GPG key
curl -fsSL https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/swb-robotics-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jammy-latest main" | sudo tee /etc/apt/sources.list.d/swb-ros.list

# Update and install
sudo apt update
sudo apt install ros-humble-swb-power
```

### Ubuntu 24.04 (Noble Numbat) - ROS 2 Jazzy

```bash
# Install GPG key
curl -fsSL https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/swb-robotics-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ noble main" | sudo tee /etc/apt/sources.list.d/swb-ros.list

# Update and install
sudo apt update
sudo apt install ros-jazzy-swb-<package-name>
```

## Switching Between Stable and Latest

The `Add repository` command in Quick Setup uses `sudo tee` (not `tee -a`), so it **overwrites** `/etc/apt/sources.list.d/swb-ros.list` each time — you can only have one channel active at once, not both at the same time in this file.

To switch channels, re-run only the `Add repository` step for the channel you want, then update. There is no need to reinstall the GPG key again, since the same key signs both channels:

```bash
# Switch to Latest (Rolling)
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jammy-latest main" | sudo tee /etc/apt/sources.list.d/swb-ros.list
sudo apt update

# Switch back to Stable
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jammy main" | sudo tee /etc/apt/sources.list.d/swb-ros.list
sudo apt update
```

### Downgrade warning

Latest package versions carry a `+mainN` suffix (e.g. `1.0.0-0jammy+main23`), which APT considers *newer* than the plain Stable version (`1.0.0-0jammy`). If you installed a package from Latest and then switch back to Stable, `apt upgrade` will refuse to downgrade it automatically. Force it explicitly:

```bash
sudo apt install ros-humble-swb-power=1.0.0-0jammy
# or
sudo apt install --allow-downgrades ros-humble-swb-power
```

## Repository Management

This repository uses **reprepro** for professional APT repository management with GPG signing.

### Adding New Packages

To add a new package to the repository:

```bash
cd repo
./add-package.sh /path/to/package_1.0.0-0jammy_amd64.deb
```

The script will automatically:
- Add the package to the repository
- Generate package indexes
- Update Release files with checksums
- Sign the repository with GPG

After adding packages:
```bash
git add -A
git commit -m "Add new package"
git push
```

### Supported Distributions and Architectures

**Ubuntu 22.04 (Jammy Jellyfish) - Stable:**
- `ros-humble-swb-web-bridge` (arm64) - Professional Web-to-ROS2 Bridge
- `ros-humble-swb-power` (amd64) - Autonomous robot docking system for wireless charging stations

**Ubuntu 22.04 (Jammy Jellyfish) - Latest (Rolling):**
- Automatically published from every successful `main` branch CI run (amd64, arm64)
- Includes packages ahead of the stable `jammy` release, e.g. `ros-humble-swb-robot`, `ros-humble-swb-mqtt-bridge`, `ros-humble-swb-pcl-processor`
- Not stable - for testing/development only

**Ubuntu 24.04 (Noble Numbat):**
- Ready for ROS 2 Jazzy packages (no packages yet)

**Architectures:**
- amd64 (64-bit Intel/AMD)
- arm64 (64-bit ARM)
- armhf (32-bit ARM hard-float)
- i386 (32-bit Intel)

## Troubleshooting

### Clearing APT Cache

If you see stale metadata or errors after repository updates:

```bash
# Remove the repository source
sudo rm /etc/apt/sources.list.d/swb-ros.list

# Clear APT cache
sudo rm -rf /var/lib/apt/lists/*

# Re-add the repository (use the appropriate command from Quick Setup above)
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jammy main" | sudo tee /etc/apt/sources.list.d/swb-ros.list

# Update
sudo apt update
```

### i386 Architecture Notice

You may see this notice during `apt update`:
```
Notice: Skipping acquire of configured file 'main/binary-i386/Packages' as repository doesn't support architecture 'i386'
```

**This is normal** - it means the repository declares i386 support but currently has no i386 packages. The notice will disappear automatically when i386 packages are added.

To suppress the notice (if you don't need 32-bit packages):
```bash
sudo dpkg --remove-architecture i386
sudo apt update
```

### Verifying Repository Setup

To verify the repository is working:

```bash
# Check if repository is listed
apt policy | grep swb

# Check available packages
apt policy ros-humble-swb-power

# List all packages from the repository
apt list | grep swb
```

### Checking Available Packages per Channel

To see which packages exist in each channel, compare the Packages index files directly in this repo:

```bash
cd repo

# List all packages available in Stable (jammy)
grep "^Package:" dists/jammy/main/binary-amd64/Packages | sort

# List all packages available in Latest (jammy-latest)
grep "^Package:" dists/jammy-latest/main/binary-amd64/Packages | sort

# Show only packages that exist in Latest but not yet in Stable
comm -13 \
  <(grep "^Package:" dists/jammy/main/binary-amd64/Packages | sort -u) \
  <(grep "^Package:" dists/jammy-latest/main/binary-amd64/Packages | sort -u)
```

From a client machine, compare all versions of a specific package across every enabled channel:

```bash
apt-cache madison ros-humble-swb-robot
```

## Repository Structure

```
repo/
├── conf/
│   ├── distributions      # Repository configuration (supports jammy & noble)
│   └── updates            # Update configuration
├── db/                    # Package database
├── pool/                  # Package storage pool
│   └── main/
│       ├── a/arm64/       # ARM64 packages
│       ├── r/             # ROS packages (by name)
│       │   ├── ros-humble-power/
│       │   └── ros-humble-swb-web-bridge/
│       └── x/amd64/       # AMD64 packages
├── dists/
│   ├── jammy/
│   │   └── main/
│   │       ├── binary-amd64/  # AMD64 package indexes
│   │       ├── binary-arm64/  # ARM64 package indexes
│   │       ├── binary-armhf/  # ARM hard-float package indexes
│   │       └── binary-i386/   # i386 package indexes
│   ├── jammy-latest/          # Rolling builds from main branch CI (not stable)
│   │   └── main/
│   │       ├── binary-amd64/  # AMD64 package indexes
│   │       ├── binary-arm64/  # ARM64 package indexes
│   │       ├── binary-armhf/  # ARM hard-float package indexes
│   │       └── binary-i386/   # i386 package indexes
│   └── noble/
│       └── main/
│           ├── binary-amd64/  # AMD64 package indexes
│           ├── binary-arm64/  # ARM64 package indexes
│           ├── binary-armhf/  # ARM hard-float package indexes
│           └── binary-i386/   # i386 package indexes
├── public.key             # GPG public key for repository signing
└── add-package.sh         # Script to add new packages
```

## Security

- All repository metadata is signed with GPG
- Packages are verified using the public key
- The repository uses HTTPS for transport security
- GPG key fingerprint: `5751 9999 2A53 AB00 4A81 5BB1 7C36 C00C A528 4792`
- Key owner: SWB Robotics <dev@swbrobotics.com>

## Notes

- All packages follow the naming convention: `ros-{distro}-swb-{name}`
- The repository is hosted on GitHub and served via raw.githubusercontent.com
- For internal use only - do not make the repository public without proper access controls