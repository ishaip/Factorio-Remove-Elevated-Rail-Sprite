-- Settings for Invisible Stone Furnaces mod

data:extend({
    {
        type = "bool-setting",
        name = "invisible-stone-furnaces-enabled",
        setting_type = "runtime-global",
        default_value = true,
        order = "a-a"
    },
    {
        type = "bool-setting", 
        name = "invisible-stone-furnaces-show-on-hover",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "a-b"
    }
})