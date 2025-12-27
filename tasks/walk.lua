local plugin_label = 'azmodan_farm' 
local utils = require "core.utils"

local task = {
    name = 'walk', 
    status = 'idle'
}

-- Target fight center
local fight_center = vec3:new(-217.622, 616.873, 22)

-- Ensure your path table contains coordinates from Zarbinzet to the Boss
local path = {
    vec3:new(-238.117, 386.241, 52.762), 
    -- ... (Keep your full path coordinates here)
    vec3:new(-218.126, 616.616, 22.000), 
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
    -- Trigger if we are far from the boss center (>25 units)
    -- Removing the zone check allows recovery if pushed into adjacent areas
    return utils.distance_to(fight_center) > 25 and 
           get_azmodan_enemy() == nil
end

function task.Execute()
    -- Disable Orbwalker 'Clear' mode to ensure the bot priorities movement
    if orbwalker.get_orb_mode() == 3 then
        orbwalker.set_clear_toggle(false)
    end

    local closest_distance = nil
    local closest_key = nil
    for key, point in pairs(path) do
        local dist = utils.distance_to(point)
        if closest_distance == nil or dist < closest_distance then
            closest_distance = dist
            closest_key = key
        end
    end

    -- Pathfind back by moving to the next point in your coordinate trail
    if path[closest_key + 2] ~= nil then
        pathfinder.request_move(path[closest_key + 2])
    elseif path[closest_key + 1] ~= nil then
        pathfinder.request_move(path[closest_key + 1])
    end
end

return task
