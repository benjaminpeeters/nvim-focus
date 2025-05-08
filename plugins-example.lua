-- Example of how to add the focus plugin to your plugins.lua
-- Copy this entry to your plugins table in /home/bpeeters/MEGA/config/nvim/lua/ben/plugins.lua

-- For testing from local repo:
{
    dir = "/home/bpeeters/repo/nvim-focus",  -- Path to local plugin directory
    config = function()
        require("focus").setup()
    end,
},

-- Once published to GitHub, replace with:
-- {
--     "benjaminpeeters/nvim-focus",
--     config = function()
--         require("focus").setup()
--     end,
-- },