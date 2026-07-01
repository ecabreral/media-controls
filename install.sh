#!/bin/bash
set -euo pipefail

EXTENSION_UUID="media-controls-ecabreral"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Building Media Controls extension..."

cd "$SCRIPT_DIR"

# Clean and prepare build directory
rm -rf dist
mkdir -p dist/temp dist/builds

# Copy source files
cp -r src/* dist/temp/

# Compile GResource
glib-compile-resources \
    assets/org.gnome.shell.extensions.mediacontrols.gresource.xml \
    --target=dist/temp/org.gnome.shell.extensions.mediacontrols.gresource \
    --sourcedir=assets

# Pack extension
PACK_ARGS=(
    -f
    -o ../builds/
    --schema="../../assets/org.gnome.shell.extensions.mediacontrols.gschema.xml"
    --extra-source=helpers
    --extra-source=types
    --extra-source=org.gnome.shell.extensions.mediacontrols.gresource
    --extra-source=utils
)

if command -v msgfmt &>/dev/null; then
    PACK_ARGS+=(--podir="../../assets/locale")
else
    echo "  (msgfmt not found, skipping translations)"
fi

cd dist/temp
gnome-extensions pack "${PACK_ARGS[@]}" .
cd "$SCRIPT_DIR"

echo "==> Installing extension..."

gnome-extensions install --force \
    "dist/builds/${EXTENSION_UUID}.shell-extension.zip"

echo "==> Enabling extension..."

if gnome-extensions enable "$EXTENSION_UUID" 2>/dev/null; then
    echo "  Extension enabled."
else
    # Fallback: enable via gsettings (GNOME Shell 50.1 compat)
    ENABLED=$(gsettings get org.gnome.shell enabled-extensions)
    if echo "$ENABLED" | grep -q "$EXTENSION_UUID"; then
        echo "  Extension already enabled."
    else
        NEW_ENABLED=$(echo "$ENABLED" | sed "s/]$/, '$EXTENSION_UUID']/")
        gsettings set org.gnome.shell enabled-extensions "$NEW_ENABLED"
        echo "  Extension enabled (via gsettings)."
    fi
fi

echo ""
echo "Done! Media Controls (2.4.6) installed and enabled."
echo "Restart your session (Alt+F2, type 'r', Enter) or log out/in for changes to take effect."
