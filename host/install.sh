#!/bin/bash
# Registers the native messaging host with Chrome.
#
# The host script is copied to Application Support rather than run from its
# repo location: Chrome cannot execute native hosts from TCC-protected folders
# such as Desktop, Documents, or Downloads.
set -euo pipefail

extension_id="${1:-}"
if [ -z "$extension_id" ]; then
	cat >&2 <<'USAGE'
Usage: ./install.sh <extension-id>

Find the ID at chrome://extensions (enable Developer mode) under "Toggle Vertical Tabs".
USAGE
	exit 1
fi

host_name="com.tabbar.toggle"
source_script="$(cd "$(dirname "$0")" && pwd)/toggle-tabbar.sh"
install_dir="$HOME/Library/Application Support/tabbar-shortcut"
host_script="$install_dir/toggle-tabbar.sh"
manifest_dir="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
manifest="$manifest_dir/$host_name.json"

mkdir -p "$install_dir" "$manifest_dir"
install -m 755 "$source_script" "$host_script"

cat > "$manifest" <<EOF
{
  "name": "$host_name",
  "description": "Toggle Chrome vertical tab bar",
  "path": "$host_script",
  "type": "stdio",
  "allowed_origins": ["chrome-extension://$extension_id/"]
}
EOF

echo "Registered $host_name for $extension_id"
echo "  host script: $host_script"
echo "  manifest:    $manifest"
echo
echo "Grant Accessibility to Google Chrome: System Settings > Privacy & Security > Accessibility."
