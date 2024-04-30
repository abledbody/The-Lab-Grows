--[[pod_format="raw",created="2024-04-20 04:09:45",modified="2024-04-23 02:20:09",revision=527]]
local utils = require"utils"
local vec = require"vectors"
local interaction = require"interaction"
local volref = require"volref".volref

local items = {}

local scene_item = {
	draw = function(self)
		local master = self.item.master
		local draw_pos = self.pos+master.scene_sprite.offset
		spr(master.scene_sprite.index,draw_pos[1],draw_pos[2])
	end,
}
scene_item.__index = scene_item

local item = {
	into_scene = function(self,pos,room)
		local interaction_rect = self.master.interaction_rect
		local rect_pos = pos+interaction_rect.pos
		local size = interaction_rect.size
		local o = {
			item = self,
			pos = vec(pos),
		}
		setmetatable(o,scene_item)
		local ref = volref(o)
		o.interactable = interaction.interactable(
			utils.rect(rect_pos,size),
			{
				take = function()
					ref:destroy()
					note(nil,2,32,nil,nil,9)
				end,
			}
		)
		return ref
	end
}
item.__index = item

local item_data = {
	screwdriver = {
		scene_sprite = {index = 192,offset = vec(-5,-1)},
		inventory_sprite = {index = 132,offset = vec(5,5)},
		interaction_rect = utils.rect(vec(-6,-3),vec(11,6))
	}
}

function items.new(key,data)
	local master = item_data[key]
	local o = {
		master = master,
		data = data,
	}
	setmetatable(o,item)
	return volref(o)
end

return items