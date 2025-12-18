local plugin_label = 'azmodan_farm'
local plugin_version = '1.0.0'

local gui = {}

local function create_checkbox(value, key)
    return checkbox:new(value, get_hash(plugin_label .. '_' .. key))
end

gui.plugin_label = plugin_label
gui.plugin_version = plugin_version


gui.elements = {
    main_tree = tree_node:new(0),
    main_toggle = create_checkbox(false, 'main_toggle')
}
function gui.render()
    if not gui.elements.main_tree:push('Azmodan Farm | Leoric | v' .. gui.plugin_version) then return end
    gui.elements.main_toggle:render('Enable', 'Enable azmodan farm')
    gui.elements.main_tree:pop()
end

return gui