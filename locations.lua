--[[pod_format="raw",created="2024-04-19 03:02:39",modified="2024-04-23 22:47:18",revision=45]]
local player = require"player"
local items = require"items"
local vec = require"vectors"

local locations = {}

local rooms = {}
rooms[1] = {
	bg_sprite = {
		sprite = 65,
		pos = vec(30,54),
	},
	fg_sprite = {
		sprite = 66,
		pos = vec(32,178),
	},
	floor_planes = {
		{
			y = 76,
			l = 88,
			r = 410,
		},
	},
	entry_points = {
		{
			x = 240,
			floor_plane_index = 1,
		}
	},
}
rooms[1].objects = {
	items.new"screwdriver":into_scene(vec(64,171),rooms[1]),
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
	for object in all(room.objects) do
		if object.draw then
			object:draw()
		end
	end
end

function locations.all_objects()
	return all(room.objects)
end

return locations