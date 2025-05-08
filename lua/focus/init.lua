local M = {}

-- Import the core module
local core = require('focus.core')

function M.setup(opts)
    -- Default options
    opts = opts or {}
    
    -- Create the Focus command
    vim.api.nvim_create_user_command('Focus', function(cmd_opts)
        local duration = nil
        
        -- Check if arguments were provided
        if cmd_opts.args and cmd_opts.args ~= "" then
            -- Try to convert the argument to a number
            local parsed = tonumber(cmd_opts.args)
            if parsed then
                duration = parsed
            else
                vim.api.nvim_echo({{ "Invalid duration: " .. cmd_opts.args .. ". Using default.", "WarningMsg" }}, false, {})
            end
        end
        
        -- Start the focus exercise with the specified duration (or default)
        core.focus_exercise(duration)
    end, { 
        desc = 'Start a focus exercise (optional: time in minutes, e.g., :Focus 2.5 for 2m30s)',
        nargs = '?' -- Makes the argument optional
    })
end

return M