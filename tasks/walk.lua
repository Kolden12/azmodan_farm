local plugin_label = 'azmodan_farm' 
local utils = require "core.utils"
local tracker = require "core.tracker"

local task = {
    name = 'walk', 
    status = 'idle'
}

local fight_center = vec3:new(-217.622, 616.873, 22)

-- Ensure this path starts exactly where you land at the Zarbinzet Waypoint
local path = {
    vec3:new(-238.117, 386.241, 52.762), 
    -- ... (Ensure your full coordinate list is here)
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
    -- 1. Check if we are in town or the boss area
    local can_walk = utils.player_in_zone('Hawe_Zarbinzet') or 
                     utils.player_in_zone('Hawe_WorldBoss')
                             
    -- 2. Check if Alfred is still busy
    -- We only walk if NOT stashing, NOT selling, and NOT depositing
    local alfred_busy = tracker.is_stashing or tracker.is_selling or tracker.is_depositing
    
    return can_walk and 
           not alfred_busy and 
           utils.distance_to(fight_center) > 25 and 
           get_azmodan_enemy() == nil
end

function task.Execute()
    -- Reset orbwalker to prioritize movement over combat in town
    if orbwalker.get_orb_mode() == 3 then
        orbwalker.set_clear_toggle(false)
    end
    
    local closest_key = nil
    local min_dist = math.huge
    
    -- Find the nearest breadcrumb in our custom path
    for key, point in pairs(path) do
        local d = utils.distance_to(point)
        if d < min_dist then
            min_dist = d
            closest_key = key
        end
    end
    
    -- Move to the next point in the trail to maintain pathing flow
    local target_point = path[closest_key + 1] or fight_center
    if target_point then
        pathfinder.request_move(target_point)
    end
end

return task
