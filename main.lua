local plugin_label = 'azmodan_farm'

local gui          = require 'gui'
local settings     = require 'core.settings'
local task_manager = require 'core.task_manager'
local tracker      = require 'core.tracker'

local local_player, player_position
local debounce_time = nil
local debounce_timeout = 1

-- Initialize the timer variable in the tracker
if tracker.last_chest_opened == nil then tracker.last_chest_opened = 0 end

local function update_locals()
    local_player = get_local_player()
    player_position = local_player and local_player:get_position()
end

local function main_pulse()
    if not local_player then return end
    
    -- Handle Sigil Purge Hotkey
    if gui.elements.drop_sigil_keybind:get_state() == 1 then
        if debounce_time ~= nil and debounce_time + debounce_timeout > get_time_since_inject() then return end
        gui.elements.drop_sigil_keybind:set(false)
        tracker.drop_sigils = true
        task_manager.execute_tasks()
    end

    settings:update_settings()
    
    -- Check if module is enabled and keybind is active
    if (not settings.enabled or not settings.get_keybind_state()) and not tracker.drop_sigils then return end

    if local_player:is_dead() then
        revive_at_checkpoint()
    else
        -- 20-SECOND TIMER LOGIC
        -- This logic ensures tasks only execute if 20 seconds have passed since the last chest open
        local current_time = get_time_since_inject()
        local time_since_chest = current_time - tracker.last_chest_opened
        
        if time_since_chest >= 20 then
            task_manager.execute_tasks()
        end
    end
end

local function render_pulse()
    -- Only show the overlay if the module is active
    if not (settings.get_keybind_state()) then return end
    if not local_player or not settings.enabled then return end
    
    -- Positioning: 1/4 from the left top corner
    local screen_width = 1920 
    if graphics.get_screen_width then screen_width = graphics.get_screen_width() end
    local status_pos = vec2:new(screen_width / 4, 25)

    -- Status Overlay
    graphics.text_2d("AZMODAN BOT: ACTIVE", status_pos, 18, color_green(255))

    -- Current Task Display
    local current_task = task_manager.get_current_task()
    if current_task then
        local px, py, pz = player_position:x(), player_position:y(), player_position:z()
        local draw_pos = vec3:new(px, py - 2, pz + 3)
        graphics.text_3d("Current Task: " .. current_task.name, draw_pos, 14, color_white(255))
    end
end

on_update(function()
    update_locals()
    main_pulse()
end)

on_render_menu(function ()
    gui.render()
end)

on_render(render_pulse)
