#!/bin/bash

set -e

DATA="/data"
VERSION="1.24.0"
SOURCE="$DATA/source"
PKGDIR="$DATA/pkg"
CLIENT_OUT="$DATA/wayland-client-$VERSION"
CURSOR_OUT="$DATA/wayland-cursor-$VERSION"
EGL_OUT="$DATA/wayland-egl-$VERSION"
SERVER_OUT="$DATA/wayland-server-$VERSION"


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
mkdir "$CLIENT_OUT" > /dev/null 2>&1 || true
mkdir "$CLIENT_OUT/include" > /dev/null 2>&1 || true
cp "$PKGDIR/lib/libwayland-client.a"           "$CLIENT_OUT"
cp "$PKGDIR/lib/libwayland-client.so.0.24.0"   "$CLIENT_OUT"
cp "$PKGDIR/include/wayland-client-core.h"     "$CLIENT_OUT/include"
cp "$PKGDIR/include/wayland-client-protocol.h" "$CLIENT_OUT/include"
cp "$PKGDIR/include/wayland-client.h"          "$CLIENT_OUT/include"
cp "$PKGDIR/include/wayland-util.h"            "$CLIENT_OUT/include"
cp "$PKGDIR/include/wayland-version.h"         "$CLIENT_OUT/include"

mkdir "$CURSOR_OUT" > /dev/null 2>&1 || true
mkdir "$CURSOR_OUT/include" > /dev/null 2>&1 || true
cp "$PKGDIR/lib/libwayland-cursor.a"         "$CURSOR_OUT"
cp "$PKGDIR/lib/libwayland-cursor.so.0.24.0" "$CURSOR_OUT"
cp "$PKGDIR/include/wayland-cursor.h"        "$CURSOR_OUT/include"

mkdir "$EGL_OUT" > /dev/null 2>&1 || true
mkdir "$EGL_OUT/include" > /dev/null 2>&1 || true
cp "$PKGDIR/lib/libwayland-egl.a"         "$EGL_OUT"
cp "$PKGDIR/lib/libwayland-egl.so.1.24.0" "$EGL_OUT"
cp "$PKGDIR/include/wayland-egl-core.h"   "$EGL_OUT/include"
cp "$PKGDIR/include/wayland-egl.h"        "$EGL_OUT/include"

mkdir "$SERVER_OUT" > /dev/null 2>&1 || true
mkdir "$SERVER_OUT/include" > /dev/null 2>&1 || true
cp "$PKGDIR/lib/libwayland-server.a"           "$SERVER_OUT"
cp "$PKGDIR/lib/libwayland-server.so.0.24.0"   "$SERVER_OUT"
cp "$PKGDIR/include/wayland-egl-backend.h"     "$SERVER_OUT/include"
cp "$PKGDIR/include/wayland-server-core.h"     "$SERVER_OUT/include"
cp "$PKGDIR/include/wayland-server-protocol.h" "$SERVER_OUT/include"
cp "$PKGDIR/include/wayland-server.h"          "$SERVER_OUT/include"
cp "$PKGDIR/include/wayland-util.h"            "$SERVER_OUT/include"
cp "$PKGDIR/include/wayland-version.h"         "$SERVER_OUT/include"

cd "$DATA"
tar --transform 's,^data/,,' --mtime='1970-01-01' --numeric-owner --owner=0 --group=0 --no-xattrs -czvf "wayland-libs-$VERSION.tar.gz" "$CLIENT_OUT" "$CURSOR_OUT" "$EGL_OUT" "$SERVER_OUT"
echo "Done"
