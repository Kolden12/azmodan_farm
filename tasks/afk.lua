local plugin_label = 'azmodan_farm' -- change to your plugin name
local explorerlite = require "core.explorerlite"

local status_enum = {
    IDLE = 'idle'
}
local task = {
    name = 'afk', -- change to your choice of task name
    status = status_enum['IDLE'],
    debounce_time = -1,
    debounce_timeout = 60
}

local function get_azmodan_enemy()
    local player_pos = get_player_position()
    local enemies = target_selector.get_near_target_list(player_pos, 15)
    for _, enemy in pairs(enemies) do
        if enemy.get_skin_name(enemy) == 'Azmodan_EventBoss' then
            return enemy
        end
    end
    return nil
end

function task.shouldExecute()
    return true
end

function task.Execute()
    local azmodan = get_azmodan_enemy()
    local current_zone = get_current_world():get_current_zone_name()
    if azmodan ~= nil then
        explorerlite:set_custom_target(azmodan:get_position())
        explorerlite:move_to_target()
    elseif current_zone == 'Hawe_Zarbinzet' then
        if task.debounce_time + task.debounce_timeout > get_time_since_inject() then return end
        local center_position = vec3:new(-217.6220703125, 616.873046875, 22)
        explorerlite:set_custom_target(center_position)
        explorerlite:move_to_target()
    end
end

return task