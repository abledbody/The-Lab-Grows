--[[pod_format="raw",created="2024-04-20 04:09:45",modified="2024-04-23 02:20:09",revision=527]]
local utils = require"utils"
local vec = require"vectors"
local interaction = require"interaction"

local items = {}

local scene_item = {
	draw = function(self)
		local master = self.item.master
		local draw_pos = self.pos+master.sprite_offset
		spr(master.scene_sprite,draw_pos[1],draw_pos[2])
	end,
}
scene_item.__index = scene_item

local item_data = {
	screwdriver = {
		scene_sprite = 192,
		sprite_offset = vec(-5,-1),
		inventory_sprite = 132,
		interaction_rect = utils.rect(vec(-6,-3),vec(11,6))
	}
}

function items.new(key,data)
	local master = item_data[key]
	return {
		master = master,
		data = data,
	}
end

function items.make_scene_item(item,pos)
	local interaction_rect = item.master.interaction_rect
	local rect_pos = pos+interaction_rect.pos
	local size = interaction_rect.size
	local o = {
		item = item,
		pos = vec(pos),
		interactable = interaction.interactable(utils.rect(rect_pos,size)),
	}
	setmetatable(o,scene_item)
	return o
end

return items