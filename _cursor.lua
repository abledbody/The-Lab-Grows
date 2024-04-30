--[[pod_format="raw",created="2024-04-20 04:24:34",modified="2024-04-23 22:47:18",revision=442]]
local locations = require"locations"
local player = require"player"
local got = require"volref".got

local _cursor = {}

local point_cursor = {spr=128,x=0,y=0}
local grabbable_cursor = {spr=129,x=5,y=5}
local grabbing_cursor = {spr=130,x=4,y=4}
local eye_cursor = {spr=131,x=8,y=5}

local none_cursor = --[[pod_type="gfx"]]unpod("b64:bHo0AAsAAAAKAAAAoHB4dQBDIAEBBAA=")
window{cursor=none_cursor}

local cursor_gfx = point_cursor

local mouse_x,mouse_y
local was_lmb,was_rmb

function _cursor.update()
	local mb
	mouse_x,mouse_y,mb = mouse()
	local lmb,rmb = mb&1 ~= 0,mb&2 ~= 0
	local hovered_object = nil
	for object in locations.all_objects() do
		local interactable = got(object,"interactable")
		hovered_object = interactable and interactable:hovered(mouse_x,mouse_y) and object or hovered_object
	end
	if hovered_object then
		local interactions = hovered_object.interactable.interactions
		cursor_gfx = hovered_object and (
				interactions.take and (lmb and grabbing_cursor or grabbable_cursor)
				or interactions.look and eye_cursor
			)
			or point_cursor
		
		if lmb and not was_lmb then
			if interactions.take then
				player.interact{target = hovered_object, verb = "take"}
			elseif interactions.look then
				player.interact{target = hovered_object, verb = "look"}
			end
		end
	else
		cursor_gfx = point_cursor
		if lmb and not was_lmb then
			player.set_dest(mouse_x)
		end
	end
	was_lmb,was_rmb = lmb,rmb
end

function _cursor.draw()
	spr(cursor_gfx.spr,mouse_x-cursor_gfx.x,mouse_y-cursor_gfx.y)
end

return _cursor