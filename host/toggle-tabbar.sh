#!/bin/bash
# Native messaging host: toggles Chrome's vertical tab bar by clicking its
# collapse/expand button through the macOS accessibility API.

# Chrome sends a length-prefixed request; we only support one action, so drop it.
read -r -n 4 _

osascript >/dev/null 2>&1 <<'APPLESCRIPT'
on findButton(el, depth)
	global found
	if found or depth > 14 then return
	tell application "System Events"
		set elRole to ""
		try
			set elRole to role of el
		end try
		if elRole is "AXWebArea" then return
		if elRole is "AXButton" then
			try
				if (description of el) is in {"Collapse tabs", "Expand tabs"} then
					click el
					set found to true
					return
				end if
			end try
		end if
		try
			repeat with child in (every UI element of el)
				my findButton(child, depth + 1)
				if found then return
			end repeat
		end try
	end tell
end findButton

global found
set found to false
tell application "System Events" to tell process "Google Chrome"
	set win to window 1
	try
		set win to first window whose name is not "Picture in Picture"
	end try
	-- Direct path for the standard layout; the tree search below covers the rest.
	try
		click button 1 of group 1 of UI element 3 of group 1 of group 1 of group 1 of group 1 of win
		set found to true
	end try
end tell
if not found then my findButton(win, 0)
APPLESCRIPT

# Reply with a length-prefixed JSON acknowledgement.
message='{"status":"ok"}'
length=${#message}
printf "$(printf '\\x%02x' $((length & 0xFF)) $((length >> 8 & 0xFF)) $((length >> 16 & 0xFF)) $((length >> 24 & 0xFF)))"
printf '%s' "$message"
