--[[pod_format="raw",created="2024-04-20 04:24:34",modified="2024-04-23 22:47:18",revision=442]]
local locations = require"locations"
local player = require"player"

local _cursor = {}

local point_cursor = {spr=128,x=0,y=0}
local grabbable_cursor = {spr=129,x=5,y=5}
local grabbing_cursor = {spr=130,x=4,y=4}

local none_cursor = --[[pod_type="gfx"]]unpod("b64:bHo0AAsAAAAKAAAAoHB4dQBDIAEBBAA=")
window{cursor=none_cursor}

local cursor_gfx = point_cursor

local mouse_x,mouse_y
local was_lmb,was_rmb

function _cursor.update()
	local mb
	mouse_x,mouse_y,mb = mouse()
	local lmb,rmb = mb&1 ~= 0,mb&2 ~= 0
	local hovered_interactable = nil
	for object in locations.all_objects() do
		local interactable = object.interactable
		hovered_interactable = interactable:hovered(mouse_x,mouse_y) and interactable or hovered_interactable
	end
	cursor_gfx = hovered_interactable and
		(lmb and grabbing_cursor or grabbable_cursor)
		or point_cursor
	if lmb and not was_lmb then
		if hovered_interactable then
			player.interact{interactable = hovered_interactable, verb = "take"}
		else
			player.set_dest(mouse_x)
		end
	end
	was_lmb,was_rmb = lmb,rmb
end

function _cursor.draw()
	spr(cursor_gfx.spr,mouse_x-cursor_gfx.x,mouse_y-cursor_gfx.y)
end

return _cursor