#!/bin/bash
# Initialize the git repository and set up GitHub

echo "Initializing git repository for nvim-focus..."
cd "$(dirname "$0")" || exit
git init
git add .
git commit -m "Initial commit: Focus plugin for Neovim"

echo ""
echo "Next steps:"
echo "1. Create a new GitHub repository at https://github.com/new"
echo "2. Name it 'nvim-focus'"
echo "3. Run the following commands to push to GitHub:"
echo ""
echo "   git remote add origin git@github.com:benjaminpeeters/nvim-focus.git"
echo "   git push -u origin main"
echo ""
echo "4. Update your Neovim configuration to use the plugin:"
echo "   Edit: /home/bpeeters/MEGA/config/nvim/lua/ben/plugins.lua"
echo "   Add: "
echo '   {
        "benjaminpeeters/nvim-focus", 
        config = function() 
            require("focus").setup() 
        end
    }'
echo ""
echo "5. Once published, you can remove the current :Focus command from:"
echo "   /home/bpeeters/MEGA/config/nvim/lua/ben/init.lua"