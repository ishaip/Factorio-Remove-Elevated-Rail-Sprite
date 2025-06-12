-- Invisible Stone Furnaces Mod
-- This mod makes stone furnaces invisible while maintaining functionality

-- Optional: Add settings support for toggling visibility
local function on_runtime_mod_setting_changed(event)
    if event.setting == "invisible-stone-furnaces-enabled" then
        -- Handle setting changes if needed
        -- This could be used to toggle furnace visibility at runtime
    end
end

-- Event handlers
script.on_event(defines.events.on_runtime_mod_setting_changed, on_runtime_mod_setting_changed)

-- Initialization
script.on_init(function()
    -- Initialize mod data if needed
    global.invisible_stone_furnaces = global.invisible_stone_furnaces or {}
end)

script.on_load(function()
    -- Load mod data if needed
end)

-- Optional: Commands for debugging or manual control
commands.add_command("toggle-furnace-visibility", "Toggle stone furnace visibility", function(command)
    local player = game.get_player(command.player_index)
    if not player then return end
    
    player.print("Stone furnace visibility is controlled by data modifications. Use mod settings to configure.")
end)