-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and resolutions possible: hyprctl monitors all

-- Main monitor (29", 2560x1080)
hl.monitor({ output = "DP-1", mode = "2560x1080@60", position = "0x0", scale = 1 })

-- Laptop screen (1366x768)
hl.monitor({ output = "eDP-1", mode = "1366x768@60", position = "2560x0", scale = 1 })
