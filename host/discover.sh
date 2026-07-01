#!/bin/bash
# Prints the accessibility buttons in the frontmost Chrome window.
# Use this to locate the collapse/expand control if a Chrome update changes it.

osascript <<'APPLESCRIPT'
on walk(el, depth)
	if depth > 16 then return
	tell application "System Events"
		set elRole to ""
		try
			set elRole to role of el
		end try
		if elRole is "AXWebArea" then return
		if elRole is "AXButton" then
			set d to ""
			try
				set d to (description of el as text)
			end try
			if d is not "" then log "button: " & d
		end if
		try
			repeat with child in (every UI element of el)
				my walk(child, depth + 1)
			end repeat
		end try
	end tell
end walk

tell application "System Events" to tell process "Google Chrome"
	set win to first window whose name is not "Picture in Picture"
end tell
my walk(win, 0)
APPLESCRIPT
