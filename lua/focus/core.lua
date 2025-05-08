local M = {}

-- Function to create a focus screen with a moving dot
-- @param duration_in_minutes: Optional duration in minutes (can be decimal like 1.5 for 1m30s)
function M.focus_exercise(duration_in_minutes)
    -- Set default duration if not provided (1.5 minutes = 90 seconds)
    duration_in_minutes = duration_in_minutes or 1.5
    
    -- Convert duration to milliseconds
    local duration_ms = math.floor(duration_in_minutes * 60 * 1000)
    
    -- Save current buffer information to restore later
    local current_buf = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()
    local current_win_view = vim.fn.winsaveview()
    local current_buf_name = vim.api.nvim_buf_get_name(current_buf)
    
    -- Save the current cursor position
    local current_cursor = vim.api.nvim_win_get_cursor(current_win)
    
    -- Create a new buffer for the focus screen
    local focus_buf = vim.api.nvim_create_buf(false, true)
    
    -- Ensure the buffer is modifiable
    vim.api.nvim_buf_set_option(focus_buf, 'modifiable', true)
    vim.api.nvim_buf_set_option(focus_buf, 'readonly', false)
    
    -- Get terminal dimensions
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    
    -- Animation parameters
    -- local dot = "◎"  -- Bullseye character
    -- local dot = "●"  -- Solid circle character
    local dot = "⊙"  -- Circle with dot character
    local dot_pos_row = math.floor(height / 2)  -- Start in the center
    local dot_pos_col = math.floor(width / 2)   -- Start in the center
    local angle = 0  -- Starting angle for circular movement
    
    -- Use larger radius for more exploration from center
    local radius_row = math.min(math.floor(height / 2), 14)  -- Vertical radius
    local radius_col = math.min(math.floor(width / 3), 20)  -- Horizontal radius
    
    -- Calculate margin to prevent the dot from hitting the edges
    local margin = 2
    local min_row = margin
    local max_row = height - margin
    local min_col = margin 
    local max_col = width - margin - 1  -- Account for character width
    
    -- Use longer periods for slower, smoother movement
    local period_x = 30 -- Seconds for a full horizontal cycle (slower)
    local period_y = 35 -- Seconds for a full vertical cycle (slower)
    
    -- Function to update dot position
    local function update_dot_position(elapsed_ms)
        -- Convert elapsed time to seconds
        local elapsed_s = elapsed_ms / 1000
        
        -- Calculate base position for center of movement
        -- Offset the center to the left by about 20% of width
        local center_row = height / 2
        local center_col = (width / 2) - (width / 5)
        
        -- Calculate angles based on actual elapsed time for smooth movement
        local angle_x = (elapsed_s % period_x) / period_x * (2 * math.pi)
        local angle_y = (elapsed_s % period_y) / period_y * (2 * math.pi)
        
        -- Calculate new position with Lissajous pattern for smoother movement
        dot_pos_row = center_row + radius_row * math.sin(angle_y)
        dot_pos_col = center_col + radius_col * math.cos(angle_x)
        
        -- Keep within bounds
        dot_pos_row = math.max(min_row, math.min(max_row, dot_pos_row))
        dot_pos_col = math.max(min_col, math.min(max_col, dot_pos_col))
    end
    
    -- Function to redraw the buffer with the dot at its current position
    local function update_buffer()
        -- Ensure the buffer is still valid
        if not vim.api.nvim_buf_is_valid(focus_buf) then
            return false
        end
        
        -- Make sure the buffer is modifiable
        pcall(vim.api.nvim_buf_set_option, focus_buf, 'modifiable', true)
        
        -- Create empty lines for the buffer
        local lines = {}
        for i = 1, height do
            if i == math.floor(dot_pos_row) then
                -- The row that contains the dot
                local padding = math.floor(dot_pos_col)
                local line = string.rep(" ", padding) .. dot .. string.rep(" ", width - padding - 1)
                table.insert(lines, line)
            else
                -- Empty lines
                table.insert(lines, "")
            end
        end
        
        -- Update the buffer content
        pcall(vim.api.nvim_buf_set_lines, focus_buf, 0, -1, false, lines)
        
        -- Force redraw
        vim.cmd("redraw")
        
        return true
    end
    
    -- Initial setup of the buffer with empty content
    local lines = {}
    for i = 1, height do
        table.insert(lines, "")
    end
    pcall(vim.api.nvim_buf_set_lines, focus_buf, 0, -1, false, lines)
    
    -- Save current UI settings
    local save_mode = vim.o.modifiable
    local save_number = vim.wo.number
    local save_relativenumber = vim.wo.relativenumber
    local save_signcolumn = vim.wo.signcolumn
    local save_colorcolumn = vim.wo.colorcolumn
    
    -- Try to set the buffer to the current window
    local success = pcall(vim.api.nvim_set_current_buf, focus_buf)
    if not success then
        -- If we couldn't set the buffer, return early
        vim.api.nvim_echo({{ "Failed to create focus view", "ErrorMsg" }}, false, {})
        return
    end
    
    -- Set up the buffer options
    vim.api.nvim_buf_set_option(focus_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(focus_buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(focus_buf, 'swapfile', false)
    
    -- Set colors: black background and white foreground
    vim.cmd("hi FocusBg guibg=#000000 guifg=#FFFFFF ctermbg=black ctermfg=white")
    vim.cmd("hi EndOfBuffer guibg=#000000 guifg=#000000 ctermbg=black ctermfg=black")
    vim.cmd("hi NonText guibg=#000000 guifg=#000000 ctermbg=black ctermfg=black")
    vim.cmd("setlocal winhl=Normal:FocusBg,EndOfBuffer:EndOfBuffer,NonText:NonText")
    
    -- Turn off all visual indicators
    vim.opt.fillchars = "eob: "  -- Hide end-of-buffer ~
    vim.opt.showbreak = ""       -- Hide line break symbol
    vim.opt.list = false         -- Don't show invisible characters
    
    -- Turn off line numbers and any distractions
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.colorcolumn = ""
    
    -- Store original cursor settings and completely hide cursor
    local save_guicursor = vim.o.guicursor
    
    -- Try multiple methods to hide cursor
    vim.cmd("hi Cursor blend=100")  -- Make cursor transparent
    vim.cmd("set guicursor=a:Cursor/lCursor")
    vim.opt.guicursor = "a:Cursor/lCursor"
    
    -- Additional cursor hiding for terminal
    vim.cmd("set t_ve=")  -- Should hide the cursor in terminal mode
    
    -- Force initial redraw
    update_buffer()
    
    -- Animation variables
    local timer = nil
    local start_time = vim.loop.now()
    local animation_interval = 80  -- Slightly more frequent updates for smoother animation
    
    -- Keep track of last position to avoid redraws when not needed
    local last_row = -1
    local last_col = -1
    
    -- Add a variable to track if we're stopping early
    local stopping = false
    
    -- Function to clean up and exit focus mode
    local function cleanup_focus()
        if stopping then return end
        stopping = true
        
        -- Stop the timer
        if timer then
            timer:stop()
            timer:close()
        end
        
        -- Check if the focus buffer still exists
        if vim.api.nvim_buf_is_valid(focus_buf) then
            -- Check if the original buffer still exists
            if vim.api.nvim_buf_is_valid(current_buf) then
                -- Switch back to the original buffer
                pcall(vim.api.nvim_set_current_buf, current_buf)
                
                -- Try to restore view
                pcall(vim.fn.winrestview, current_win_view)
                
                -- Also try to restore cursor position
                pcall(vim.api.nvim_win_set_cursor, current_win, current_cursor)
            else
                -- If the original buffer doesn't exist anymore, try loading it by name
                if current_buf_name and current_buf_name ~= "" then
                    vim.cmd("edit " .. vim.fn.fnameescape(current_buf_name))
                    
                    -- After loading, try to restore cursor position
                    pcall(vim.fn.winrestview, current_win_view)
                end
            end
            
            -- Try to delete the focus buffer
            pcall(vim.api.nvim_buf_delete, focus_buf, { force = true })
        end
        
        -- Restore cursor
        vim.cmd("hi Cursor blend=0")  -- Make cursor visible again
        vim.opt.guicursor = save_guicursor
        vim.cmd("set t_ve&")  -- Restore terminal cursor
        
        -- Restore settings (safely)
        vim.wo.number = save_number
        vim.wo.relativenumber = save_relativenumber
        vim.wo.signcolumn = save_signcolumn
        vim.wo.colorcolumn = save_colorcolumn
        
        -- Restore other visual settings
        vim.opt.fillchars = nil  -- Reset to default
        vim.opt.showbreak = nil  -- Reset to default
        vim.opt.list = nil       -- Reset to default
    end
    
    -- Set up Ctrl+C handler
    vim.keymap.set('n', '<C-c>', function()
        cleanup_focus()
    end, { buffer = focus_buf, nowait = true })
    
    -- Setup recursive animation timer
    timer = vim.loop.new_timer()
    timer:start(0, animation_interval, vim.schedule_wrap(function()
        -- Check if we're stopping early or exceeded the duration
        if stopping then
            return
        end
        
        local elapsed = vim.loop.now() - start_time
        if elapsed >= duration_ms then
            -- Clean up and exit when time is up
            cleanup_focus()
            return
        end
        
        -- Update dot position based on elapsed time
        update_dot_position(elapsed)
        
        -- Only update the buffer if the position changed significantly
        local new_row = math.floor(dot_pos_row)
        local new_col = math.floor(dot_pos_col)
        
        if new_row ~= last_row or new_col ~= last_col then
            -- Record this position
            last_row = new_row
            last_col = new_col
            
            -- Update the buffer with the new dot position
            if not update_buffer() then
                -- If buffer update failed, stop the animation
                timer:stop()
                timer:close()
            end
        end
    end))
end

return M