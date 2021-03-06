#!/usr/bin/env bash
set -e

# Detect OS and architecture
kernel=`uname -s`
arch=`uname -m`
if [[ $kernel == "Linux" ]]; then
    os="linux";
elif [[ $kernel == "Darwin" ]]; then # MacOS
    os="osx";
elif [[ $kernel == "FreeBSD" ]]; then
	if [[ -x `which protoc` ]]; then
		echo "protoc already installed"
		exit 0
	else
		echo "protoc not found in \$PATH, install it with: sudo pkg install protobuf"
		exit 1
	fi
else
    echo "unsupported OS, protoc not installed"
    exit 1;
fi


protoc_url=https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-${os}-${arch}.zip

# Make sure you grab the latest version
echo "fetching ${protoc_url}"
curl -L -o "protoc.zip" ${protoc_url}

# Unzip
rm -rf protoc3
echo "extracting..."
unzip -u protoc.zip -d protoc3

# create local devtools dir.
rm -rf devtools
mkdir -p devtools/bin
mkdir -p devtools/include

# Don't reinstall protoc if it's already installed
if (hash protoc 2>/dev/null) ; then
    echo "found systemwide protoc, not installing locally"
else
    echo "no systemwide protoc installation found"
    echo "moving bin/protoc to ./devtools/bin/protoc"
    mv protoc3/bin/* devtools/bin/
fi

# Move protoc3/include to /usr/local/include/
echo "syncing include to ./devtools/include"
rsync -r protoc3/include/ devtools/include/

# Cleanup
echo "cleaning up..."
rm protoc.zip
rm -rf protoc3
echo "done"
