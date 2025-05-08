# nvim-focus

A Neovim plugin for mindfulness and concentration exercises. It displays a moving dot against a black background to help you focus.

## Features

- Creates a distraction-free environment with a black screen
- Displays a smoothly moving dot to focus your attention
- Configurable duration
- Automatic restoration of your previous buffer and settings when done
- Helps improve concentration and mindfulness

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "benjaminpeeters/nvim-focus",
    config = function()
        require("focus").setup()
    end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    "benjaminpeeters/nvim-focus",
    config = function()
        require("focus").setup()
    end
}
```

## Usage

Start a focus exercise with the default duration (1.5 minutes):

```
:Focus
```

Specify a custom duration in minutes (can use decimal values):

```
:Focus 2.5  -- 2 minutes and 30 seconds
```

## Commands

| Command           | Description                                        |
|-------------------|----------------------------------------------------|
| `:Focus [time]`   | Start a focus exercise with optional time in minutes |

## Keybindings

| Key       | Description                        |
|-----------|------------------------------------|
| `<Ctrl-C>` | Exit focus mode before time expires |

## License

MIT