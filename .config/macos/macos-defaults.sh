#!/bin/bash
# macos-defaults.sh -- idempotent macos configuration
# run: bash ~/.config/macos/macos-defaults.sh
# note: log out and back in (or restart) for all changes to take effect

set -euo pipefail

echo "configuring macos defaults..."

# ---------------------------------------------------------------------------
# helper
# ---------------------------------------------------------------------------
PB="/usr/libexec/PlistBuddy"
SH_PLIST="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

set_hotkey() {
  # usage: set_hotkey <id> <ascii> <keycode> <modifier> <enabled>
  local id="$1" ascii="$2" keycode="$3" modifier="$4" enabled="${5:-true}"
  $PB -c "Delete :AppleSymbolicHotKeys:${id}" "$SH_PLIST" 2>/dev/null || true
  $PB -c "Add :AppleSymbolicHotKeys:${id} dict" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:enabled bool ${enabled}" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:value dict" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:value:type string standard" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:value:parameters array" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:value:parameters: integer ${ascii}" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:value:parameters: integer ${keycode}" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:value:parameters: integer ${modifier}" "$SH_PLIST"
}

disable_hotkey() {
  # usage: disable_hotkey <id>
  local id="$1"
  $PB -c "Delete :AppleSymbolicHotKeys:${id}" "$SH_PLIST" 2>/dev/null || true
  $PB -c "Add :AppleSymbolicHotKeys:${id} dict" "$SH_PLIST"
  $PB -c "Add :AppleSymbolicHotKeys:${id}:enabled bool false" "$SH_PLIST"
}

# modifier values:
#   ctrl = 262144  |  shift = 131072  |  option = 524288
#   cmd  = 1048576 |  fn    = 8388608
# combine by addition: ctrl+shift = 393216, fn+ctrl = 8650752

# ---------------------------------------------------------------------------
# desktop switching -- ctrl+[1-5]
# ---------------------------------------------------------------------------
# 118-122 = switch to desktop 1-5
# keycodes: 18=1, 19=2, 20=3, 21=4, 23=5
set_hotkey 118 65535 18 262144 true    # ctrl+1 -> desktop 1
set_hotkey 119 65535 19 262144 true    # ctrl+2 -> desktop 2
set_hotkey 120 65535 20 262144 true    # ctrl+3 -> desktop 3
set_hotkey 121 65535 21 262144 true    # ctrl+4 -> desktop 4
set_hotkey 122 65535 23 262144 true    # ctrl+5 -> desktop 5
echo "  desktop switching: ctrl+[1-5]"

# ---------------------------------------------------------------------------
# mission control -- fn+ctrl+up
# ---------------------------------------------------------------------------
# 32 = mission control (keycode 126=up, fn+ctrl=8650752)
# 33 = application windows -- kept disabled
set_hotkey 32  65535 126 8650752 true
disable_hotkey 33
echo "  mission control: fn+ctrl+up"

# ---------------------------------------------------------------------------
# move between spaces -- disabled
# ---------------------------------------------------------------------------
# 79/81 = move left/right a space (would be ctrl+left/right). Disabled
# because desktop switching via ctrl+[1-5] (hotkeys 118-122) covers it.
disable_hotkey 79
disable_hotkey 81
echo "  move-between-spaces: disabled (use ctrl+[1-5] instead)"

# ---------------------------------------------------------------------------
# disable spotlight (both ctrl+space and cmd+space)
# ---------------------------------------------------------------------------
# 64 = spotlight, 65 = finder search window
disable_hotkey 64
disable_hotkey 65
echo "  spotlight shortcuts: disabled"

# ---------------------------------------------------------------------------
# disable keyboard-nav / accessibility shortcuts we don't use
# ---------------------------------------------------------------------------
# IDs 15-26 cover macOS's "Move focus to ..." family (status menus, dock,
# floating windows, toolbars, drawers, etc.) plus a couple of misc ones.
# We don't use any of them; disabling cuts down on accidental triggers.
for id in 15 16 17 18 19 20 21 22 23 24 25 26; do
  disable_hotkey "$id"
done
# 36 = show desktop, 52 = turn dock hiding on/off
disable_hotkey 36
disable_hotkey 52
echo "  keyboard-nav + misc shortcuts: disabled"

# ---------------------------------------------------------------------------
# keep enabled: help menu (cmd+shift+/)
# ---------------------------------------------------------------------------
# 98 = show help menu: cmd+shift+/ (ascii=47, keycode=44, modifier=1179648)
set_hotkey 98  47 44 1179648 true
echo "  help menu: cmd+shift+/ (kept)"

# ---------------------------------------------------------------------------
# move active window to next/prev space -- fn+ctrl+shift+left/right
# ---------------------------------------------------------------------------
# 80 = move window to left space, 82 = move window to right space
# (keycodes: 123=left, 124=right; fn+ctrl+shift=8781824)
# Only works on keyboards that send the globe/fn key (built-in Mac kb).
set_hotkey 80  65535 123 8781824 true
set_hotkey 82  65535 124 8781824 true
echo "  move window to next/prev space: fn+ctrl+shift+left/right"

# ---------------------------------------------------------------------------
# window tiling (sequoia+) -- option+ctrl+left/right
# ---------------------------------------------------------------------------
# macOS's built-in Tiling menu items, bound via NSUserKeyEquivalents so
# they work without the globe/fn key (unlike ctrl+fn+arrows).
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Tiling Left"  '~^\U2192'
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Tiling Right" '~^\U2190'
echo "  window tiling: option+ctrl+left/right"

# ---------------------------------------------------------------------------
# dock
# ---------------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false
echo "  dock: auto-hide, no recents, size 48"

# ---------------------------------------------------------------------------
# finder
# ---------------------------------------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
echo "  finder: show hidden files, path bar, status bar"

# ---------------------------------------------------------------------------
# input
# ---------------------------------------------------------------------------
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo "  keyboard: fast key repeat, no press-and-hold"

# ---------------------------------------------------------------------------
# restart affected services
# ---------------------------------------------------------------------------
echo ""
echo "restarting services..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo ""
echo "done. log out and back in for keyboard shortcut changes to take full effect."
echo ""
echo "manual steps:"
echo "  1. open mission control and create 5 desktops if not already present"
echo "  2. system settings > keyboard > keyboard shortcuts > mission control"
echo "     verify ctrl+[1-5] are set correctly"
