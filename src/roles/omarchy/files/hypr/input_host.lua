-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
--
-- Default layout is br (ABNT2) for the built-in keyboard and anything else
-- plugged in. Hyprland has no if/else on device presence, so the Bluetooth
-- keyboard (Logitech MX Keys, wants US intl.) gets its own hl.device()
-- override below, scoped by device name — the standard way to get a
-- per-keyboard layout. Find a device's exact name via `hyprctl devices`.
hl.config({
  input = {
    kb_layout = "br",
  },
})

hl.device({
  name = "mx-keys-keyboard",
  kb_layout = "us",
  kb_variant = "intl",
  kb_model = "logitech_base",
  kb_options = "compose:ralt",
})
