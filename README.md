# Toggle Vertical Tabs

Collapse/expand Chrome's vertical tab bar with a keyboard shortcut (macOS). Chrome has no API for it, so a native host clicks the collapse button via accessibility.

## Setup

1. `chrome://extensions` -> Developer mode -> Load unpacked -> this folder. Refresh it.
2. Grab the extension ID off its card, then in your terminal:
   ```sh
   host/install.sh <extension-id>
   ```
3. Give Chrome Accessibility perms (System Settings -> Privacy & Security -> Accessibility). Reload the extension a couple times if it's being stubborn.
4. `chrome://extensions/shortcuts` -> set it to `Cmd+S`.

Make sure vertical tabs are already on, otherwise it errors.
