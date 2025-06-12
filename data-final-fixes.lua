-- Create empty sprite definitions - try both custom and core empty sprites
local empty_sprite = {
    filename = "__core__/graphics/empty.png",
    width = 1,
    height = 1,
    frame_count = 1,
    line_length = 1
}

local empty_animation = {
    filename = "__core__/graphics/empty.png",
    width = 1,
    height = 1,
    frame_count = 1,
    line_length = 1,
    animation_speed = 1
}

-- Create empty animation layers for multi-layer animations
local empty_layers = {
    {
        filename = "__core__/graphics/empty.png",
        width = 1,
        height = 1,
        frame_count = 1,
        line_length = 1
    }
}

local function make_furnace_invisible(furnace_prototype)
    -- Handle all possible animation properties comprehensively
    
    -- Main animation (most common)
    if furnace_prototype.animation then
        furnace_prototype.animation = empty_animation
    end
    
    -- Idle and working animations
    if furnace_prototype.idle_animation then
        furnace_prototype.idle_animation = empty_animation
    end
    
    if furnace_prototype.working_animation then
        furnace_prototype.working_animation = empty_animation
    end
    
    -- Always draw animation
    if furnace_prototype.always_draw then
        furnace_prototype.always_draw = empty_animation
    end
    
    -- Graphics set (newer Factorio versions)
    if furnace_prototype.graphics_set then
        if furnace_prototype.graphics_set.animation then
            furnace_prototype.graphics_set.animation = empty_animation
        end
        if furnace_prototype.graphics_set.idle_animation then
            furnace_prototype.graphics_set.idle_animation = empty_animation
        end
        if furnace_prototype.graphics_set.working_animation then
            furnace_prototype.graphics_set.working_animation = empty_animation
        end
        if furnace_prototype.graphics_set.working_visualisations then
            furnace_prototype.graphics_set.working_visualisations = {}
        end
    end
    
    -- Picture property (static image)
    if furnace_prototype.picture then
        furnace_prototype.picture = empty_sprite
    end
    
    -- Shadow animations
    if furnace_prototype.shadow then
        furnace_prototype.shadow = empty_animation
    end
    
    -- Working visualizations (fire, smoke, etc.)
    if furnace_prototype.working_visualisations then
        furnace_prototype.working_visualisations = {}
    end
    
    -- Fire animation specifically
    if furnace_prototype.fire then
        furnace_prototype.fire = empty_animation
    end
    
    -- Fire glow
    if furnace_prototype.fire_glow then
        furnace_prototype.fire_glow = empty_animation
    end
    
    -- Light (might show glow even if sprite is invisible)
    if furnace_prototype.energy_source and furnace_prototype.energy_source.light then
        furnace_prototype.energy_source.light = nil
    end
    
    -- Smoke (remove smoke effects)
    if furnace_prototype.smoke then
        furnace_prototype.smoke = {}
    end
    
    -- Handle layered animations
    if furnace_prototype.layers then
        furnace_prototype.layers = empty_layers
    end
    
    -- Handle any potential sprite sheets
    if furnace_prototype.sprite then
        furnace_prototype.sprite = empty_sprite
    end
    
    if furnace_prototype.sprites then
        furnace_prototype.sprites = {empty_sprite}
    end
end

-- Apply invisibility to stone furnaces
local furnaces_processed = 0

for furnace_name, furnace_prototype in pairs(data.raw["furnace"] or {}) do
    if furnace_name == "stone-furnace" then
        log("Processing stone furnace - found properties:")
        if furnace_prototype.animation then log("- has animation") end
        if furnace_prototype.idle_animation then log("- has idle_animation") end
        if furnace_prototype.working_animation then log("- has working_animation") end
        if furnace_prototype.graphics_set then log("- has graphics_set") end
        if furnace_prototype.working_visualisations then log("- has working_visualisations") end
        if furnace_prototype.fire then log("- has fire") end
        if furnace_prototype.picture then log("- has picture") end
        
        make_furnace_invisible(furnace_prototype)
        furnaces_processed = furnaces_processed + 1
        log("Made furnace invisible: " .. furnace_name)
    end
end

log("Invisible Stone Furnaces mod processed " .. furnaces_processed .. " furnace prototypes")