-- $HOME/.config/wezterm/wezterm.lua
-- Works on Windows, macOS, Linux.
-- Reference: https://wezterm.org/config/files.html

local wezterm = require 'wezterm'
local act     = wezterm.action
local config  = wezterm.config_builder()

-- ===========================================================================
-- OS detection
-- ===========================================================================
local target     = wezterm.target_triple
local is_windows = target:find('windows') ~= nil
local is_mac     = target:find('apple')   ~= nil
local is_linux   = target:find('linux')   ~= nil and not is_windows

-- On macOS the primary modifier should be SUPER (⌘ Command), so Option (⌥)
-- stays free for typing accented characters, em-dashes, etc.  On Windows /
-- Linux the primary modifier remains ALT to match the original WT bindings.
local primary = is_mac and 'SUPER' or 'ALT'

-- ===========================================================================
-- Default shell / domain
--   * Windows -> WSL:Ubuntu  (matches WT "defaultProfile" Ubuntu2404)
--   * macOS / Linux -> auto-detect shell from $SHELL, fall back sensibly,
--                      working for both zsh and bash.
-- ===========================================================================
local function detect_unix_shell()
  local shell = os.getenv('SHELL')
  if shell and shell ~= '' then
    return shell
  end
  -- Probe common locations.
  for _, candidate in ipairs({ '/bin/zsh', '/usr/bin/zsh', '/bin/bash', '/usr/bin/bash' }) do
    local f = io.open(candidate, 'r')
    if f then f:close(); return candidate end
  end
  return is_mac and '/bin/zsh' or '/bin/bash'
end

if is_windows then
  config.default_domain = 'WSL:Ubuntu'
else
  local shell = detect_unix_shell()
  -- `-l` makes both bash and zsh source their login profiles
  -- (~/.zprofile, ~/.bash_profile, etc.) so PATH/aliases are loaded.
  config.default_prog = { shell, '-l' }
end

-- ===========================================================================
-- Appearance (Cascadia Code + One Half Dark + acrylic-ish opacity)
-- ===========================================================================
config.color_scheme = 'duskfox'

-- Different operating systems ship different default monospace fonts, so use
-- a per-OS fallback list.  Each list contains only fonts that are typically
-- preinstalled on that OS (no third-party installs required) — WezTerm will
-- fall through to its own bundled JetBrains Mono / Last Resort if none match.
local function default_fonts()
  if is_mac then
    -- All preinstalled on modern macOS (/System/Library/Fonts/).
    return {
      'SF Mono',
      'Menlo',
      'Monaco',
      'Courier New',
    }
  elseif is_windows then
    -- Cascadia ships with Windows 11 / Windows Terminal; Consolas and
    -- Courier New are present on every Windows since Vista.
    return {
      'Cascadia Code',
      'Cascadia Mono',
      'Consolas',
      'Courier New',
    }
  else
    -- Linux defaults vary by distro, but DejaVu / Liberation / Noto cover
    -- the vast majority of mainstream installs (Ubuntu, Fedora, Arch, …).
    return {
      'DejaVu Sans Mono',
      'Liberation Mono',
      'Noto Sans Mono',
      'Ubuntu Mono',
      'monospace',
    }
  end
end

-- macOS ships SF Mono inside Terminal.app's Resources but doesn't register the
-- .otf files as system fonts, so WezTerm's font discovery can't see them by
-- default (causing "Unable to load a font specified by your font=...SF Mono"
-- warnings).  Point font_dirs at Terminal.app's bundle so SF Mono works on any
-- Mac with no manual install step — but only include paths that actually exist
-- (covers Catalina+ at /System/Applications/..., pre-Catalina at /Applications/...,
-- and silently degrades to fallback fonts if Apple ever relocates the bundle).
local function dir_exists(path)
  -- A directory opened as a file via io.open returns a handle on macOS even
  -- though it isn't a regular file; that's fine for an existence probe.
  local f = io.open(path, 'r')
  if f then f:close(); return true end
  return false
end

if is_mac then
  local candidates = {
    '/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts',
    '/Applications/Utilities/Terminal.app/Contents/Resources/Fonts',
  }
  local dirs = {}
  for _, p in ipairs(candidates) do
    if dir_exists(p) then table.insert(dirs, p) end
  end
  if #dirs > 0 then
    config.font_dirs = dirs
    -- Don't set font_locator: the platform default (CoreText on macOS,
    -- FontConfig on Linux, Gdi on Windows) already discovers system fonts,
    -- and font_dirs above is searched in addition to it.
  end
end

config.font      = wezterm.font_with_fallback(default_fonts())
config.font_size = is_mac and 13 or 12

config.window_background_opacity = 0.90              -- WT "opacity": 90
if is_mac then
  config.macos_window_background_blur = 20           -- mimic WT "useAcrylic"
elseif is_windows then
  config.win32_system_backdrop = 'Acrylic'
end

config.default_cursor_style = 'SteadyBar'            -- WT "cursorShape": "bar"
config.cursor_blink_rate    = 0
config.colors = {
  cursor_bg     = '#FFFFFF',
  cursor_border = '#FFFFFF',
}

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- ===========================================================================
-- macOS-specific niceties
-- ===========================================================================
if is_mac then
  -- Let unbound Option keystrokes fall through to the OS so users can still
  -- type composed characters like é, ñ, π, –, —.
  config.send_composed_key_when_left_alt_is_pressed  = true
  config.send_composed_key_when_right_alt_is_pressed = true

  -- Use the real macOS fullscreen (separate Space, green-button friendly).
  config.native_macos_fullscreen_mode = true

  -- Smoother scrolling on Apple Silicon / Metal-capable GPUs.
  config.front_end = 'WebGpu'

  -- IME for CJK / accented input (default is already true; explicit for clarity).
  config.use_ime = true
end

-- Quality-of-life that helps everywhere but bites hardest on macOS:
config.audible_bell = 'Disabled'
config.adjust_window_size_when_changing_font_size = false

-- ===========================================================================
-- Tab bar / window behaviors
-- ===========================================================================
config.hide_tab_bar_if_only_one_tab    = false       -- WT "alwaysShowTabs"
config.use_fancy_tab_bar               = true
config.tab_bar_at_bottom               = false
config.show_new_tab_button_in_tab_bar  = true
config.show_tab_index_in_tab_bar       = true

config.initial_cols       = 120                      -- WT "initialCols"
config.initial_rows       = 30                       -- WT "initialRows"
config.scrollback_lines   = 9001                     -- WT "historySize"

config.window_close_confirmation = 'NeverPrompt'     -- WT "closeOnExit": graceful
config.exit_behavior             = 'CloseOnCleanExit'

-- WT "snapOnInput": true  ->  scroll to bottom when typing
config.scroll_to_bottom_on_input = true

-- WT "copyOnSelect": false  -> WezTerm default, no extra setting needed.

-- WT "disableAnimations": true
config.animation_fps          = 1
config.cursor_blink_ease_in   = 'Constant'
config.cursor_blink_ease_out  = 'Constant'

-- WT "launchMode": "maximized" -> maximize main window on GUI startup.
wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- ===========================================================================
-- Keybindings
--   On macOS the primary modifier is SUPER (⌘); on Windows/Linux it stays ALT.
-- ===========================================================================
config.disable_default_key_bindings = false          -- keep WezTerm defaults too

local function edit_config_action()
  local editor
  if is_windows then
    editor = { 'notepad.exe', wezterm.config_file }
  else
    editor = { os.getenv('EDITOR') or 'vi', wezterm.config_file }
  end
  return act.SpawnCommandInNewTab({ args = editor })
end

config.keys = {
  -------------------------------------------------------------------- Tabs --
  -- ⌘1..9 (Mac) / Alt+1..9 (other) -> activate tab N-1
  { key = '1', mods = primary, action = act.ActivateTab(0) },
  { key = '2', mods = primary, action = act.ActivateTab(1) },
  { key = '3', mods = primary, action = act.ActivateTab(2) },
  { key = '4', mods = primary, action = act.ActivateTab(3) },
  { key = '5', mods = primary, action = act.ActivateTab(4) },
  { key = '6', mods = primary, action = act.ActivateTab(5) },
  { key = '7', mods = primary, action = act.ActivateTab(6) },
  { key = '8', mods = primary, action = act.ActivateTab(7) },
  { key = '9', mods = primary, action = act.ActivateTab(8) },

  -- ctrl+tab / ctrl+shift+tab -> next / prev tab (kept cross-platform)
  { key = 'Tab', mods = 'CTRL',       action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

  -- ⌘T (Mac) / Alt+T (other) -> new / duplicate tab
  { key = 't', mods = primary, action = act.SpawnTab('CurrentPaneDomain') },

  -- ⌘W (Mac) / Alt+W (other) -> close current pane/tab
  { key = 'w', mods = primary, action = act.CloseCurrentPane({ confirm = false }) },

  ----------------------------------------------------------- Find / clip --
  { key = 'f', mods = primary, action = act.Search({ CaseInSensitiveString = '' }) },

  -- Paste / copy: primary modifier on each platform, plus the standard
  -- ctrl+shift+c/v alias (Linux muscle memory, also works on Mac/Windows).
  { key = 'v', mods = primary,      action = act.PasteFrom('Clipboard') },
  { key = 'c', mods = primary,      action = act.CopyTo('Clipboard') },
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },

  ------------------------------------------------------------- Settings --
  -- ⌘, (Mac) / Alt+, (other) -> open this wezterm.lua in your editor.
  -- Keep CTRL+, and CTRL|ALT+, as cross-platform aliases.
  { key = ',', mods = primary,    action = edit_config_action() },
  { key = ',', mods = 'CTRL',     action = edit_config_action() },
  { key = ',', mods = 'CTRL|ALT', action = edit_config_action() },

  ------------------------------------------------------------ Font size --
  { key = '=', mods = primary, action = act.IncreaseFontSize },
  { key = '+', mods = primary, action = act.IncreaseFontSize },
  { key = '-', mods = primary, action = act.DecreaseFontSize },
  { key = '0', mods = primary, action = act.ResetFontSize },

  --------------------------------------------------- Pane focus (hjkl) --
  { key = 'h', mods = primary, action = act.ActivatePaneDirection('Left') },
  { key = 'j', mods = primary, action = act.ActivatePaneDirection('Down') },
  { key = 'k', mods = primary, action = act.ActivatePaneDirection('Up')   },
  { key = 'l', mods = primary, action = act.ActivatePaneDirection('Right')},
  { key = 'h', mods = 'CTRL|ALT', action = act.ActivatePaneDirection('Prev') },

  ----------------------------------------------------------- Pane resize --
  { key = 'LeftArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Left',  5 }) },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Right', 5 }) },
  { key = 'UpArrow',    mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Up',    5 }) },
  { key = 'DownArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Down',  5 }) },

  ------------------------------------------------------------ Pane split --
  -- ctrl+alt+d / ctrl+alt+v  -> split right
  { key = 'd', mods = 'CTRL|ALT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'v', mods = 'CTRL|ALT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  -- ctrl+alt+n  -> split down
  { key = 'n', mods = 'CTRL|ALT', action = act.SplitVertical({   domain = 'CurrentPaneDomain' }) },

  ------------------------------------------------------------ Scrolling --
  { key = 'y', mods = primary, action = act.ScrollByLine(-1) },          -- scrollUp
  { key = 'e', mods = primary, action = act.ScrollByLine(1)  },          -- scrollDown
  { key = 'b', mods = primary, action = act.ScrollByPage(-1) },          -- scrollUpPage
}

-- ===========================================================================
-- Mouse: ⌘+click on a URL opens it (Mac convention).  On other platforms the
-- WezTerm default (CTRL+click) already does this.
-- ===========================================================================
if is_mac then
  config.mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = act.OpenLinkAtMouseCursor,
    },
    -- Without this, holding SUPER while clicking would still extend the
    -- selection / move the cursor; suppress the default for the down event.
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = act.Nop,
    },
  }
end

return config
