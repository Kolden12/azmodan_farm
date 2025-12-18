local gui = require 'gui'

local settings = {
    plugin_label = gui.plugin_label,
    plugin_version = gui.plugin_version,
    enabled = false,
    path_angle = 10,
    use_evade = false,
    aggresive_movement = false,
}

function settings.get_keybind_state()
    local toggle_key = gui.elements.keybind_toggle:get_key();
    local toggle_state = gui.elements.keybind_toggle:get_state();

    -- If not using keybind, skip
    if not settings.use_keybind then
        return true
    end

    if settings.use_keybind and toggle_key ~= 0x0A and toggle_state == 1 then
        return true
    end
    return false
end


function settings:update_settings()
    settings.enabled = gui.elements.main_toggle:get()
end

return settings