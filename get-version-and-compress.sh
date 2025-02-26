#!/bin/bash

# Check if version argument was provided
if [ $# -eq 0 ]; then
    echo "Error: MariaDB version must be specified"
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1
WORKDIR=$(pwd)/mariadb-${VERSION}

# Create working directory
mkdir -p ${WORKDIR}
cd ${WORKDIR} || exit 1

# Clone repository
echo "Cloning MariaDB repository..."
git clone -b "mariadb-${VERSION}" --depth=1 https://github.com/MariaDB/server "mariadb-${VERSION}" || {
    echo "Failed to clone repository"
    exit 1
}

# Change to repository directory init submodules
cd "mariadb-${VERSION}" || exit 1
git submodule update --init --recursive
cd ..

# Create tarball
echo "Creating tarball..."
tar --exclude='.git*' -cvzf mariadb-${VERSION}.tar.gz mariadb-${VERSION}/ || {
    echo "Failed to create tarball"
    exit 1
}

echo "Success: mariadb-${VERSION}.tar.gz created in ${WORKDIR}/.."

# Clean up working directory
rm -rf ${WORKDIR}/mariadb-${VERSION}
