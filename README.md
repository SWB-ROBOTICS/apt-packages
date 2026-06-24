# SWB Private APT Repository

This repository hosts pre-compiled, binary-only Debian (`.deb`) packages for SWB's internal ROS 2 deployments. Source code is excluded from these packages for security.

## Quick Setup

Choose your Ubuntu version and run these commands:

### Ubuntu 22.04 (Jammy Jellyfish) - ROS 2 Humble

```bash
# Install GPG key
curl -fsSL https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/swb-robotics-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jammy main" | sudo tee /etc/apt/sources.list.d/swb-ros.list

# Update and install
sudo apt update
sudo apt install ros-humble-swb-power
```

### Ubuntu 24.04 (Jazzy Jellyfish) - ROS 2 Jazzy

```bash
# Install GPG key
curl -fsSL https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/swb-robotics-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jazzy main" | sudo tee /etc/apt/sources.list.d/swb-ros.list

# Update and install
sudo apt update
sudo apt install ros-jazzy-swb-<package-name>
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

**Ubuntu 22.04 (Jammy Jellyfish):**
- `ros-humble-swb-web-bridge` (arm64) - Professional Web-to-ROS2 Bridge
- `ros-humble-swb-power` (amd64) - Autonomous robot docking system for wireless charging stations

**Ubuntu 24.04 (Jazzy Jellyfish):**
- Ready for ROS 2 Jazzy packages (no packages yet)

**Architectures:**
- amd64 (64-bit Intel/AMD)
- arm64 (64-bit ARM)
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

## Repository Structure

```
repo/
├── conf/
│   ├── distributions      # Repository configuration (supports jammy & jazzy)
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
│   │       └── binary-i386/   # i386 package indexes
│   └── jazzy/
│       └── main/
│           ├── binary-amd64/  # AMD64 package indexes
│           ├── binary-arm64/  # ARM64 package indexes
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