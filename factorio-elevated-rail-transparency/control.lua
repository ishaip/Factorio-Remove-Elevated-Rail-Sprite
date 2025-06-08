local rails_hidden_globally = false
local overlay_ids = {}

local function apply_rail_transparency()
    -- Clear existing overlays
    for _, overlay_id in pairs(overlay_ids) do
        if overlay_id and overlay_id.valid then
            overlay_id.destroy()
        end
    end
    overlay_ids = {}
    
    if not rails_hidden_globally then
        return -- Rails should be fully visible
    end
    
    local transparency = settings.global["sprite_transparent"].value
    
    -- Find all elevated rails on all surfaces
    for _, surface in pairs(game.surfaces) do
        local elevated_rails = surface.find_entities_filtered{type = "straight-rail"}
        
        for _, rail in pairs(elevated_rails) do
            -- Check if it's an elevated rail
            if rail.name:find("elevated") then
                -- Create a semi-transparent overlay to reduce visibility
                local overlay = rendering.draw_sprite{
                    sprite = "utility/white",
                    target = rail,
                    surface = surface,
                    x_scale = 2,
                    y_scale = 2,
                    render_layer = "object",
                    tint = {r = 1, g = 1, b = 1, a = 1 - transparency}
                }
                table.insert(overlay_ids, overlay)
            end
        end
        
        -- Also handle curved elevated rails
        local curved_rails = surface.find_entities_filtered{type = "curved-rail"}
        for _, rail in pairs(curved_rails) do
            if rail.name:find("elevated") then
                local overlay = rendering.draw_sprite{
                    sprite = "utility/white",
                    target = rail,
                    surface = surface,
                    x_scale = 2,
                    y_scale = 2,
                    render_layer = "object",
                    tint = {r = 1, g = 1, b = 1, a = 1 - transparency}
                }
                table.insert(overlay_ids, overlay)
            end
        end
    end
end

local function hide_elevated_rails()
    apply_rail_transparency()
end

local function show_elevated_rails()
    -- Clear all overlays to show rails again
    for _, overlay_id in pairs(overlay_ids) do
        if overlay_id and overlay_id.valid then
            overlay_id.destroy()
        end
    end
    overlay_ids = {}
end

local function toggle_elevated_rail_visibility()
    rails_hidden_globally = not rails_hidden_globally
    
    if rails_hidden_globally then
        hide_elevated_rails()
        game.print("Elevated rails hidden")
    else
        show_elevated_rails()
        game.print("Elevated rails visible")
    end
    
    -- Update shortcut button state for all players
    for _, player in pairs(game.players) do
        player.set_shortcut_toggled("toggle-elevated-rail-transparency", rails_hidden_globally)
    end
end

-- Update overlays when new elevated rails are built
local function on_built_entity(event)
    if rails_hidden_globally and event.created_entity and event.created_entity.valid then
        local entity = event.created_entity
        if (entity.type == "straight-rail" or entity.type == "curved-rail") and entity.name:find("elevated") then
            local transparency = settings.global["sprite_transparent"].value
            local overlay = rendering.draw_sprite{
                sprite = "utility/white",
                target = entity,
                surface = entity.surface,
                x_scale = 2,
                y_scale = 2,
                render_layer = "object",
                tint = {r = 1, g = 1, b = 1, a = 1 - transparency}
            }
            table.insert(overlay_ids, overlay)
        end
    end
end

-- Clean up overlays when elevated rails are destroyed
local function on_entity_destroyed(event)
    -- Remove any invalid overlays
    for i = #overlay_ids, 1, -1 do
        if not overlay_ids[i].valid then
            table.remove(overlay_ids, i)
        end
    end
end

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

-- Handle runtime setting changes
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "sprite_transparent" and rails_hidden_globally then
        apply_rail_transparency()
    end
end)