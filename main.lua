--[[pod_format="raw",created="2024-04-18 05:27:43",modified="2024-04-23 22:47:18",revision=2337]]
include"require.lua"

dt = 1/60

local _cursor = require"_cursor"
local player = require"player"
local locations = require"locations"
local light_levels = require"light_levels"

locations.set_room(1,1)

function _update()
	_cursor.update()
	player.update()
end

function _draw()
	cls()
	locations.draw_bg()
	player.draw()
	locations.draw_objects()
	locations.draw_fg()
	--print(string.format("%.1f",stat(1)*100),0,0,37)
end

note(nil,0,32,nil,nil,10)