-- $HOME/.config/wezterm/wezterm.lua
-- Cross-platform WezTerm config (Windows / macOS / Linux).
-- Reference: https://wezterm.org/config/files.html

local wezterm = require 'wezterm'
local act     = wezterm.action
local config  = wezterm.config_builder()

-- ---------------------------------------------------------------------------
-- Platform
-- ---------------------------------------------------------------------------
local target     = wezterm.target_triple
local is_windows = target:find('windows') ~= nil
local is_mac     = target:find('apple')   ~= nil
local is_linux   = target:find('linux')   ~= nil and not is_windows

-- macOS uses ⌘ as primary so Option (⌥) stays free for composed input.
local primary = is_mac and 'SUPER' or 'ALT'

-- ---------------------------------------------------------------------------
-- Filesystem helpers (io.open works for both files and dirs as a probe)
-- ---------------------------------------------------------------------------
local function path_exists(p)
  local f = io.open(p, 'r')
  if f then f:close(); return true end
  return false
end

local function first_existing(paths)
  for _, p in ipairs(paths) do
    if path_exists(p) then return p end
  end
end

-- ---------------------------------------------------------------------------
-- Shell / domain detection
-- ---------------------------------------------------------------------------
local function detect_unix_shell()
  local shell = os.getenv('SHELL')
  if shell and shell ~= '' then return shell end
  return first_existing({ '/bin/zsh', '/usr/bin/zsh', '/bin/bash', '/usr/bin/bash' })
      or (is_mac and '/bin/zsh' or '/bin/bash')
end

local function detect_wsl_distros()
  if not is_windows then return {} end
  local distros = {}
  local ok, stdout = wezterm.run_child_process({ 'wsl.exe', '-l', '-q' })
  if ok and stdout then
    -- wsl.exe emits UTF-16-LE on Windows; strip null bytes.
    stdout = stdout:gsub('%z', '')
    for line in stdout:gmatch('[^\r\n]+') do
      local distro = line:gsub('^%s+', ''):gsub('%s+$', '')
      if distro ~= '' then table.insert(distros, distro) end
    end
  end
  return distros
end

local wsl_distros = detect_wsl_distros()

if is_windows then
  -- Prefer Ubuntu, else first WSL distro, else fall back to local Windows shell.
  local preferred
  for _, d in ipairs(wsl_distros) do
    if d:lower():find('ubuntu') then preferred = d; break end
  end
  preferred = preferred or wsl_distros[1]
  if preferred then config.default_domain = 'WSL:' .. preferred end
else
  -- `-l` makes bash/zsh source login profiles (~/.zprofile, ~/.bash_profile).
  config.default_prog = { detect_unix_shell(), '-l' }
end

-- ---------------------------------------------------------------------------
-- 启动菜单 / Launch menu (Alt+Shift+T)
-- Detected once at config load, not per keypress.
-- ---------------------------------------------------------------------------
local function build_launch_menu()
  local menu = {}

  if is_windows then
    -- Windows-side shells must spawn in 'local' domain — otherwise they'd
    -- inherit the WSL default_domain and try to exec inside Ubuntu.
    local LOCAL = { DomainName = 'local' }

    if path_exists('C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe') then
      table.insert(menu, {
        label  = 'Windows PowerShell',
        args   = { 'powershell.exe', '-NoLogo' },
        domain = LOCAL,
      })
    end

    local pwsh = first_existing({
      'C:\\Program Files\\PowerShell\\7\\pwsh.exe',
      'C:\\Program Files\\PowerShell\\7-preview\\pwsh.exe',
    })
    if pwsh then
      table.insert(menu, {
        label  = 'PowerShell 7',
        args   = { pwsh, '-NoLogo' },
        domain = LOCAL,
      })
    end

    -- Developer PowerShell for each installed Visual Studio.
    local vs_bases = {
      'C:\\Program Files\\Microsoft Visual Studio',
      'C:\\Program Files (x86)\\Microsoft Visual Studio',
    }
    local vs_years    = { '2017', '2019', '2022' }
    local vs_editions = { 'Enterprise', 'Professional', 'Community', 'BuildTools', 'Preview' }
    for _, base in ipairs(vs_bases) do
      for _, year in ipairs(vs_years) do
        for _, ed in ipairs(vs_editions) do
          local devshell = string.format(
            '%s\\%s\\%s\\Common7\\Tools\\Launch-VsDevShell.ps1', base, year, ed)
          if path_exists(devshell) then
            table.insert(menu, {
              label  = string.format('PowerShell for VS %s (%s)', year, ed),
              args   = {
                'powershell.exe', '-NoExit', '-Command',
                string.format("& '%s'", devshell),
              },
              domain = LOCAL,
            })
          end
        end
      end
    end

    -- WSL distros: target the WSL domain directly so WezTerm spawns
    -- the distro's default login shell natively.
    for _, distro in ipairs(wsl_distros) do
      table.insert(menu, {
        label  = 'WSL: ' .. distro,
        domain = { DomainName = 'WSL:' .. distro },
      })
    end
  else
    local zsh = first_existing({
      '/bin/zsh', '/usr/bin/zsh', '/usr/local/bin/zsh', '/opt/homebrew/bin/zsh',
    })
    if zsh then table.insert(menu, { label = 'zsh', args = { zsh, '-l' } }) end

    local bash = first_existing({
      '/bin/bash', '/usr/bin/bash', '/usr/local/bin/bash', '/opt/homebrew/bin/bash',
    })
    if bash then table.insert(menu, { label = 'bash', args = { bash, '-l' } }) end
  end

  return menu
end

config.launch_menu = build_launch_menu()

-- ---------------------------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------------------------
config.color_scheme = 'duskfox'

local DEFAULT_FONT_SIZE = is_mac and 13 or 10

-- Per-OS fallback list of preinstalled monospace fonts.
local DEFAULT_FONTS = is_mac and {
  'SF Mono', 'Menlo', 'Monaco', 'Courier New',
} or is_windows and {
  'Cascadia Code', 'Cascadia Mono', 'Consolas', 'Courier New',
} or {
  'DejaVu Sans Mono', 'Liberation Mono', 'Noto Sans Mono', 'Ubuntu Mono', 'monospace',
}

-- macOS ships SF Mono inside Terminal.app but doesn't register it system-wide.
-- Add Terminal.app's Resources dir so font discovery finds it.
if is_mac then
  local dirs = {}
  for _, p in ipairs({
    '/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts',
    '/Applications/Utilities/Terminal.app/Contents/Resources/Fonts',
  }) do
    if path_exists(p) then table.insert(dirs, p) end
  end
  if #dirs > 0 then config.font_dirs = dirs end
end

config.font      = wezterm.font_with_fallback(DEFAULT_FONTS)
config.font_size = DEFAULT_FONT_SIZE

config.window_background_opacity = 0.90
if is_mac then
  config.macos_window_background_blur = 20
elseif is_windows then
  config.win32_system_backdrop = 'Acrylic'
end

config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate    = 0
config.colors = {
  cursor_bg     = '#FFFFFF',
  cursor_border = '#FFFFFF',
}

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- ---------------------------------------------------------------------------
-- macOS-specific
-- ---------------------------------------------------------------------------
if is_mac then
  -- Allow unbound Option keystrokes through the OS for composed input (é, —, π).
  config.send_composed_key_when_left_alt_is_pressed  = true
  config.send_composed_key_when_right_alt_is_pressed = true
  config.native_macos_fullscreen_mode = true
  config.front_end = 'WebGpu'
  config.use_ime   = true
end

config.audible_bell = 'Disabled'
config.adjust_window_size_when_changing_font_size = false

-- ---------------------------------------------------------------------------
-- Tabs / window
-- ---------------------------------------------------------------------------
config.hide_tab_bar_if_only_one_tab   = false
config.use_fancy_tab_bar              = true
config.tab_bar_at_bottom              = false
config.show_new_tab_button_in_tab_bar = true
config.show_tab_index_in_tab_bar      = true

config.initial_cols     = 120
config.initial_rows     = 30
config.scrollback_lines = 9001

config.window_close_confirmation = 'NeverPrompt'
config.exit_behavior             = 'CloseOnCleanExit'
config.scroll_to_bottom_on_input = true

-- Disable animations.
config.animation_fps         = 1
config.cursor_blink_ease_in  = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Maximize main window on GUI startup.
wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- ---------------------------------------------------------------------------
-- Keybindings
-- ---------------------------------------------------------------------------
config.disable_default_key_bindings = false

local function edit_config_action()
  local editor = is_windows
      and { 'notepad.exe', wezterm.config_file }
      or  { os.getenv('EDITOR') or 'vi', wezterm.config_file }
  return act.SpawnCommandInNewTab({ args = editor })
end

local show_launch_menu = act.ShowLauncherArgs({
  flags = 'FUZZY|LAUNCH_MENU_ITEMS',
  title = 'New tab',
})

local edit_config = edit_config_action()

-- Build numeric tab-activation bindings programmatically.
local tab_keys = {}
for i = 1, 9 do
  tab_keys[i] = { key = tostring(i), mods = primary, action = act.ActivateTab(i - 1) }
end

config.keys = {
  -- Launch menu
  { key = 't', mods = primary .. '|SHIFT', action = show_launch_menu },

  -- Tabs (1-9)
  tab_keys[1], tab_keys[2], tab_keys[3], tab_keys[4], tab_keys[5],
  tab_keys[6], tab_keys[7], tab_keys[8], tab_keys[9],

  { key = 'Tab', mods = 'CTRL',       action = act.ActivateTabRelative(1)  },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 't',   mods = primary,      action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w',   mods = primary,      action = act.CloseCurrentPane({ confirm = false }) },

  -- Find / clipboard
  { key = 'f', mods = primary,      action = act.Search({ CaseInSensitiveString = '' }) },
  { key = 'v', mods = primary,      action = act.PasteFrom('Clipboard') },
  { key = 'c', mods = primary,      action = act.CopyTo('Clipboard') },
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },

  -- Settings (open this file)
  { key = ',', mods = primary,    action = edit_config },
  { key = ',', mods = 'CTRL',     action = edit_config },
  { key = ',', mods = 'CTRL|ALT', action = edit_config },

  -- Font size
  { key = '=', mods = primary, action = act.IncreaseFontSize },
  { key = '+', mods = primary, action = act.IncreaseFontSize },
  { key = '-', mods = primary, action = act.DecreaseFontSize },
  { key = '0', mods = primary, action = act.ResetFontSize },

  -- Pane focus (hjkl)
  { key = 'h', mods = primary,    action = act.ActivatePaneDirection('Left')  },
  { key = 'j', mods = primary,    action = act.ActivatePaneDirection('Down')  },
  { key = 'k', mods = primary,    action = act.ActivatePaneDirection('Up')    },
  { key = 'l', mods = primary,    action = act.ActivatePaneDirection('Right') },
  { key = 'h', mods = 'CTRL|ALT', action = act.ActivatePaneDirection('Prev')  },

  -- Pane resize
  { key = 'LeftArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Left',  5 }) },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Right', 5 }) },
  { key = 'UpArrow',    mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Up',    5 }) },
  { key = 'DownArrow',  mods = 'CTRL|ALT', action = act.AdjustPaneSize({ 'Down',  5 }) },

  -- Pane split
  { key = 'v', mods = 'CTRL|' .. primary, action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'n', mods = 'CTRL|' .. primary, action = act.SplitVertical({   domain = 'CurrentPaneDomain' }) },

  -- Scrolling
  { key = 'y', mods = primary, action = act.ScrollByLine(-1) },
  { key = 'e', mods = primary, action = act.ScrollByLine(1)  },
  { key = 'b', mods = primary, action = act.ScrollByPage(-1) },
}

-- ---------------------------------------------------------------------------
-- Mouse: ⌘+click opens URLs on macOS (CTRL+click is default elsewhere).
-- ---------------------------------------------------------------------------
if is_mac then
  config.mouse_bindings = {
    {
      event  = { Up = { streak = 1, button = 'Left' } },
      mods   = 'SUPER',
      action = act.OpenLinkAtMouseCursor,
    },
    -- Suppress the default down-event so SUPER+click doesn't also extend selection.
    {
      event  = { Down = { streak = 1, button = 'Left' } },
      mods   = 'SUPER',
      action = act.Nop,
    },
  }
end

return config
