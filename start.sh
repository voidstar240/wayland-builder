#!/bin/bash

set -e

DATA="/data"
VERSION="1.24.0"
SOURCE="$DATA/source"
PKGDIR="$DATA/pkg"
OUT="$DATA/wayland-libs-$VERSION"


if [ ! -f "source.tar.gz" ]; then
    echo "Downloading wayland source..."
    cd "$DATA"
    wget "https://gitlab.freedesktop.org/wayland/wayland/-/archive/$VERSION/wayland-$VERSION.tar.gz" -O "source.tar.gz"
fi

if [ ! -d "$SOURCE" ]; then
    echo "Extracting wayland source..."
    cd "$DATA"
    mkdir "$SOURCE" > /dev/null 2>&1 || true
    tar -xf "source.tar.gz" -C "$SOURCE" --strip-components 1
fi

echo "Compiling wayland..."
cd "$SOURCE"
if [ ! -d "build" ]; then
    meson setup build
fi
cd build
meson configure --buildtype=release -Ddocumentation=false -Ddtd_validation=false -Dtests=false -Ddefault_library=both --prefix "/" --libdir "lib"
meson compile
meson install --destdir "$PKGDIR"

echo "Packaging wayland libraries..."
mkdir "$OUT" > /dev/null 2>&1 || true
mkdir "$OUT/include" > /dev/null 2>&1 || true
cp "$PKGDIR/lib/libwayland-client.a"           "$OUT"
cp "$PKGDIR/lib/libwayland-client.so.0.24.0"   "$OUT"
cp "$PKGDIR/include/wayland-client-core.h"     "$OUT/include"
cp "$PKGDIR/include/wayland-client-protocol.h" "$OUT/include"
cp "$PKGDIR/include/wayland-client.h"          "$OUT/include"
cp "$PKGDIR/include/wayland-util.h"            "$OUT/include"
cp "$PKGDIR/include/wayland-version.h"         "$OUT/include"

cp "$PKGDIR/lib/libwayland-cursor.a"           "$OUT"
cp "$PKGDIR/lib/libwayland-cursor.so.0.24.0"   "$OUT"
cp "$PKGDIR/include/wayland-cursor.h"          "$OUT/include"

cp "$PKGDIR/lib/libwayland-egl.a"              "$OUT"
cp "$PKGDIR/lib/libwayland-egl.so.1.24.0"      "$OUT"
cp "$PKGDIR/include/wayland-egl-backend.h"     "$OUT/include"
cp "$PKGDIR/include/wayland-egl-core.h"        "$OUT/include"
cp "$PKGDIR/include/wayland-egl.h"             "$OUT/include"

cp "$PKGDIR/lib/libwayland-server.a"           "$OUT"
cp "$PKGDIR/lib/libwayland-server.so.0.24.0"   "$OUT"
cp "$PKGDIR/include/wayland-server-core.h"     "$OUT/include"
cp "$PKGDIR/include/wayland-server-protocol.h" "$OUT/include"
cp "$PKGDIR/include/wayland-server.h"          "$OUT/include"
cp "$PKGDIR/include/wayland-util.h"            "$OUT/include"
cp "$PKGDIR/include/wayland-version.h"         "$OUT/include"

cd "$DATA"
tar --transform 's,^data/,,' --mtime='1970-01-01' --numeric-owner --owner=0 --group=0 --no-xattrs -czvf "wayland-libs-$VERSION.tar.gz" "$OUT"
echo "Done"
