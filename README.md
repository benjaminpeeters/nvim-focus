# nvim-focus

A Neovim plugin that implements a visual focus exercise inspired by neuroscience research to boost alertness and concentration. The plugin displays a moving dot against a black background, helping engage your visual focus systems to prime your brain for concentrated work.

## Neuroscience Background

This plugin is inspired by Dr. Andrew Huberman's neuroscience research and recommendations from the [Huberman Lab Podcast](https://www.hubermanlab.com/). Dr. Huberman, a Professor of Neurobiology and Ophthalmology at Stanford University, explains how visual focus directly impacts cognitive performance:

> "The best way to get better at focusing is to use the mechanisms of focus that you were born with. And the key principle here is that mental focus follows visual focus."
> — Dr. Andrew Huberman

### How It Works

The science behind this approach is well-established:

1. **Visual-Cognitive Connection**: Your overt visual focus (what you're explicitly looking at) drives your cognitive focus. By deliberately training your visual focus, you enhance cognitive focus.

2. **Neurochemical Release**: When you narrow your visual attention onto a specific moving object and maintain this focus, your brain releases neurochemicals that increase alertness and arousal.

3. **Reduced Perceived Effort**: Brief visual focus exercises make subsequent cognitive work require less perceived effort, making it easier to enter states of deep concentration.

## Features

- Creates a distraction-free environment with a black screen
- Displays a smoothly moving dot with a Lissajous pattern for optimal visual tracking
- Configurable duration for the exercise (default: 1.5 minutes)
- Automatic restoration of your previous buffer and settings when done
- Designed based on neuroscience research on visual attention and cognitive focus
- Completely keyboard-driven workflow that integrates seamlessly with Neovim

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

## When to Use

This tool is particularly effective when:

- Starting your work session to prime your brain for focused work
- Transitioning between different tasks or projects
- After a break to regain focus
- When you feel mental fatigue but need to continue working
- Before important cognitive tasks requiring sustained attention

## Commands

| Command           | Description                                        |
|-------------------|----------------------------------------------------|
| `:Focus [time]`   | Start a focus exercise with optional time in minutes |

## Keybindings

| Key       | Description                        |
|-----------|------------------------------------|
| `<Ctrl-C>` | Exit focus mode before time expires |

## Research References

For those interested in the science behind visual focus exercises:

- [Focus Toolkit: Tools to Improve Your Focus & Concentration - Huberman Lab](https://www.hubermanlab.com/episode/focus-toolkit-tools-to-improve-your-focus-and-concentration)
- [How to Focus to Change Your Brain - Huberman Lab](https://www.hubermanlab.com/episode/how-to-focus-to-change-your-brain)
- [The Science of Vision, Eye Health & Seeing Better - Huberman Lab](https://www.hubermanlab.com/episode/the-science-of-vision-eye-health-and-seeing-better)

## License

[GNU Affero General Public License v3.0 (AGPL-3.0)](https://www.gnu.org/licenses/agpl-3.0.en.html)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

