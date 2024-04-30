--[[pod_format="raw",created="2024-04-19 03:02:39",modified="2024-04-23 22:47:18",revision=45]]
local player = require"player"
local items = require"items"
local vec = require"vectors"
local volref,got
do local ref = require"volref" volref,got = ref.volref,ref.got end
local interaction = require"interaction"
local utils = require"utils"

local locations = {}

local rooms = {}
rooms[1] = {
	bg_sprite = {
		sprite = 65,
		pos = vec(30,61),
	},
	fg_sprite = {
		sprite = 66,
		pos = vec(31,93),
	},
	floor_planes = {
		{
			y = 206,
			l = 88,
			r = 410,
			light_zones = {
				{ l = 88, r = 200, level = 0 },
				{ l = 200, r = 410, level = -1 },
			},
		},
	},
	entry_points = {
		{
			x = 376,
			floor_plane_index = 1,
		}
	},
}
rooms[1].objects = {
	items.new"screwdriver":into_scene(vec(54,181),rooms[1]),
	volref({
		interactable = interaction.interactable(
			utils.rect(vec(65,154),vec(21,19)),
			{
				look = function()
					return "I can see my reflection in this box. I don't recognize it."
				end,
			}
		),
	}),
}
local room = rooms[1]

local function draw_layer(layer)
	spr(layer.sprite,layer.pos[1],layer.pos[2])
end

function locations.set_room(room_index,entry_point_index)
	room = rooms[room_index]
	local entry_point = room.entry_points[entry_point_index]
	assert(entry_point)
	local floor_plane = room.floor_planes[entry_point.floor_plane_index]
	player.enter_room(floor_plane,entry_point.x)
end

function locations.draw_bg()
	draw_layer(room.bg_sprite)
end

function locations.draw_fg()
	draw_layer(room.fg_sprite)
end

function locations.draw_objects()
	for i = #room.objects,1,-1 do
		local object = got(room.objects[i])
		if object then
			if object.draw then
				object:draw()
			end
		else
			deli(room.objects,i)
		end
	end
end

function locations.all_objects()
	return all(room.objects)
end

return locations