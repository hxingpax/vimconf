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
config.color_scheme = 'OneHalfDark'

config.font = wezterm.font_with_fallback({
  'Cascadia Code',
  'CaskaydiaCove Nerd Font',
  'JetBrains Mono',
  'Menlo',
  'Consolas',
  'DejaVu Sans Mono',
})
config.font_size = 12

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
-- Keybindings (mirroring the Windows Terminal "keybindings" array)
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
  -- alt+1..9 -> switch to tab N-1
  { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = act.ActivateTab(8) },

  -- ctrl+tab / ctrl+shift+tab -> next / prev tab
  { key = 'Tab', mods = 'CTRL',       action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

  -- ctrl+1/2/3 -> open a new tab (WT spawned profile-N; here a normal tab)
  { key = '1', mods = 'CTRL', action = act.SpawnTab('CurrentPaneDomain') },
  { key = '2', mods = 'CTRL', action = act.SpawnTab('CurrentPaneDomain') },
  { key = '3', mods = 'CTRL', action = act.SpawnTab('CurrentPaneDomain') },

  -- alt+t -> duplicate (WT "duplicateTab")
  { key = 't', mods = 'ALT', action = act.SpawnTab('CurrentPaneDomain') },

  -- alt+w -> close current pane/tab
  { key = 'w', mods = 'ALT', action = act.CloseCurrentPane({ confirm = false }) },

  ----------------------------------------------------------- Find / clip --
  { key = 'f', mods = 'ALT', action = act.Search({ CaseInSensitiveString = '' }) },

  -- alt+v -> paste, plus the standard ctrl+shift+c/v as well
  { key = 'v', mods = 'ALT',        action = act.PasteFrom('Clipboard') },
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },

  ------------------------------------------------------------- Settings --
  -- alt+,           -> open this wezterm.lua in your editor
  -- ctrl+,          -> alias of the same (WT "openSettings settingsUI")
  -- ctrl+alt+,      -> alias too                ("openSettings defaultsFile")
  { key = ',', mods = 'ALT',       action = edit_config_action() },
  { key = ',', mods = 'CTRL',      action = edit_config_action() },
  { key = ',', mods = 'CTRL|ALT',  action = edit_config_action() },

  ------------------------------------------------------------ Font size --
  { key = '=', mods = 'ALT', action = act.IncreaseFontSize },
  { key = '+', mods = 'ALT', action = act.IncreaseFontSize },
  { key = '-', mods = 'ALT', action = act.DecreaseFontSize },
  { key = '0', mods = 'ALT', action = act.ResetFontSize },

  --------------------------------------------------- Pane focus (hjkl) --
  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection('Up')   },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection('Right')},
  { key = 'h', mods = 'CTRL|ALT', action = act.ActivatePaneDirection('Prev') },

  ----------------------------------------------------------- Pane resize --
  { key = 'LeftArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Left',  5 }) },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Right', 5 }) },
  { key = 'UpArrow',    mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Up',    5 }) },
  { key = 'DownArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Down',  5 }) },

  ------------------------------------------------------------ Pane split --
  -- ctrl+alt+d  -> auto-split duplicate
  { key = 'd', mods = 'CTRL|ALT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  -- ctrl+alt+v  -> split right
  { key = 'v', mods = 'CTRL|ALT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  -- ctrl+alt+n  -> split down
  { key = 'n', mods = 'CTRL|ALT', action = act.SplitVertical({   domain = 'CurrentPaneDomain' }) },

  ------------------------------------------------------------ Scrolling --
  { key = 'y', mods = 'ALT', action = act.ScrollByLine(-1) },          -- scrollUp
  { key = 'e', mods = 'ALT', action = act.ScrollByLine(1)  },          -- scrollDown
  { key = 'b', mods = 'ALT', action = act.ScrollByPage(-1) },          -- scrollUpPage
}

return config
