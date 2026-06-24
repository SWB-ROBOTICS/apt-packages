# SWB Private APT Repository

This repository hosts pre-compiled, binary-only Debian (`.deb`) packages for SWB's internal ROS 2 deployments. Source code is excluded from these packages for security.

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

## Target Machine Setup

To pull packages from this repository onto a target machine or robot, follow these steps:

### 1. Install the GPG Public Key

First, download and add the repository's GPG public key:

```bash
curl -fsSL https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/swb-robotics-archive-keyring.gpg
```

### 2. Add the Repository Source

Add this repository to your system's APT sources list:

```bash
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jammy main" | sudo tee /etc/apt/sources.list.d/swb-ros.list
```

For Ubuntu 24.04 (Jazzy), use:
```bash
echo "deb [signed-by=/usr/share/keyrings/swb-robotics-archive-keyring.gpg] https://raw.githubusercontent.com/SWB-ROBOTICS/apt-packages/main/repo/ jazzy main" | sudo tee /etc/apt/sources.list.d/swb-ros.list
```

### 3. Update and Install

```bash
sudo apt update
sudo apt install ros-humble-swb-web-bridge
sudo apt install ros-humble-swb-power
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

## Notes

- The i386 architecture notice during `apt update` is normal and can be ignored if you don't need 32-bit packages
- To suppress the i386 notice, run: `sudo dpkg --remove-architecture i386 && sudo apt update`
- All packages follow the naming convention: `ros-{distro}-swb-{name}`