-- We need to define globals for Factorio API at the top
local rails_hidden_globally = false
local hidden_rails = {}

-- Function to hide or show elevated rail sprites
local function apply_rail_visibility()
    -- Reset all rail visibility first
    for _, rail_data in pairs(hidden_rails) do
        if rail_data.rail and rail_data.rail.valid then
            rendering.set_visible(rail_data.rail_rendering_id, true)
        end
    end
    hidden_rails = {}
    
    if not rails_hidden_globally then
        return -- Rails should be fully visible
    end
    
    -- Find all elevated rails on all surfaces
    for _, surface in pairs(game.surfaces) do
        local elevated_rails = surface.find_entities_filtered{type = "straight-rail"}
        
        for _, rail in pairs(elevated_rails) do
            -- Check if it's an elevated rail
            if rail.name:find("elevated") then
                -- Get the main rail rendering ID (the bridge/elevated part)
                local rail_sprites = rendering.get_all_ids("entity", rail)
                for _, sprite_id in pairs(rail_sprites) do
                    local sprite = rendering.get_sprite(sprite_id)
                    -- Only hide the elevated part, not the track itself
                    if sprite and sprite:find("elevated") then
                        rendering.set_visible(sprite_id, false)
                        table.insert(hidden_rails, {rail = rail, rail_rendering_id = sprite_id})
                    end
                end
            end
        end
        
        -- Also handle curved elevated rails
        local curved_rails = surface.find_entities_filtered{type = "curved-rail"}
        for _, rail in pairs(curved_rails) do
            if rail.name:find("elevated") then
                local rail_sprites = rendering.get_all_ids("entity", rail)
                for _, sprite_id in pairs(rail_sprites) do
                    local sprite = rendering.get_sprite(sprite_id)
                    if sprite and sprite:find("elevated") then
                        rendering.set_visible(sprite_id, false)
                        table.insert(hidden_rails, {rail = rail, rail_rendering_id = sprite_id})
                    end
                end
            end
        end
    end
end

local function hide_elevated_rails()
    apply_rail_visibility()
end

local function show_elevated_rails()
    -- Reset rail visibility
    for _, rail_data in pairs(hidden_rails) do
        if rail_data.rail and rail_data.rail.valid then
            rendering.set_visible(rail_data.rail_rendering_id, true)
        end
    end
    hidden_rails = {}
end

local function toggle_elevated_rail_visibility()
    rails_hidden_globally = not rails_hidden_globally
    
    if rails_hidden_globally then
        hide_elevated_rails()
        game.print({"message.elevated-rail-hidden"})
    else
        show_elevated_rails()
        game.print({"message.elevated-rail-visible"})
    end
    
    -- Update shortcut button state for all players
    for _, player in pairs(game.players) do
        player.set_shortcut_toggled("toggle-elevated-rail-transparency", rails_hidden_globally)
    end
end

-- Handle newly built elevated rails
local function on_built_entity(event)
    if rails_hidden_globally and event.created_entity and event.created_entity.valid then
        local entity = event.created_entity
        if (entity.type == "straight-rail" or entity.type == "curved-rail") and entity.name:find("elevated") then
            -- Hide the elevated part of newly built rails
            local rail_sprites = rendering.get_all_ids("entity", entity)
            for _, sprite_id in pairs(rail_sprites) do
                local sprite = rendering.get_sprite(sprite_id)
                if sprite and sprite:find("elevated") then
                    rendering.set_visible(sprite_id, false)
                    table.insert(hidden_rails, {rail = entity, rail_rendering_id = sprite_id})
                end
            end
        end
    end
end

-- Clean up references when elevated rails are destroyed
local function on_entity_destroyed(event)
    -- Remove any invalid references
    for i = #hidden_rails, 1, -1 do
        if not hidden_rails[i].rail or not hidden_rails[i].rail.valid then
            table.remove(hidden_rails, i)
        end
    end
end

-- Register event handlers
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name == "toggle-elevated-rail-transparency" then
        toggle_elevated_rail_visibility()
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    -- Update shortcut state for new players
    local player = game.get_player(event.player_index)
    if player then
        player.set_shortcut_toggled("toggle-elevated-rail-transparency", rails_hidden_globally)
    end
end)

-- Handle built entities
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.script_raised_built, on_built_entity)

-- Handle destroyed entities  
script.on_event(defines.events.on_entity_died, on_entity_destroyed)
script.on_event(defines.events.on_player_mined_entity, on_entity_destroyed)
script.on_event(defines.events.on_robot_mined_entity, on_entity_destroyed)
script.on_event(defines.events.script_raised_destroy, on_entity_destroyed)

-- Refresh all rail visibility when mod settings change
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    apply_rail_visibility()
end)

-- Initialize when the game loads or the mod configuration changes
script.on_configuration_changed(function()
    apply_rail_visibility()
end)

-- Initialize when a save is loaded
script.on_load(function()
    -- Re-apply the rail visibility state
    if rails_hidden_globally then
        apply_rail_visibility()
    end
end)
