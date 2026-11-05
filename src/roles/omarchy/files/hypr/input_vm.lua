-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
--
-- VM variant of input.lua (see input_host.lua for the real machine): no
-- physical BR ABNT2 keyboard and no Logitech MX Keys Bluetooth device exist
-- here (SPICE/QEMU present a plain virtual keyboard), so just default to us
-- directly instead of carrying over the host's br default + per-device
-- override pair.
hl.config({
  input = {
    kb_layout = "us",
  },
})
