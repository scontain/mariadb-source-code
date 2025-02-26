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
git clone https://github.com/MariaDB/server mariadb-server || {
    echo "Failed to clone repository"
    exit 1
}

# Change to repository directory
cd mariadb-server || exit 1

# Checkout specified version
echo "Checking out version ${VERSION}..."
git checkout mariadb-${VERSION} || {
    echo "Failed to checkout version mariadb-${VERSION}"
    exit 1
}

# Create tarball
echo "Creating tarball..."
tar --exclude='.git*' -czf ../mariadb-${VERSION}.tar.gz . || {
    echo "Failed to create tarball"
    exit 1
}

echo "Success: mariadb-${VERSION}.tar.gz created in ${WORKDIR}/.."

# Clean up working directory
cd ..
rm -rf ${WORKDIR}/mariadb-server
