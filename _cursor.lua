--[[pod_format="raw",created="2024-04-20 04:24:34",modified="2024-04-23 22:47:18",revision=442]]
local locations = require"locations"
local player = require"player"

local _cursor = {}

local point_cursor = --[[pod_type="gfx"]]unpod("b64:bHo0AKIAAACgAAAA8JFweHUAQyAeJgTw--87DxTwDQwPFvANDg8X8AwMHfAMDxQNDw0O8AoPEw8NHQ7wCg4LDQsN8AkPEw8UC00L8AYMDh0PEgMPFQ0O8AUPEw4LDg8VDg0DDfAGHgMdAx3wBg8SDxQDDz8NAw8VC-AHDgMKDQ8UDQMJ8AYJDxMOAy0O8AcJDgsdDw4N8AguCy3wBxkOHQ8-DfAICQsNC-AKCQ4w")
local grabbable_cursor = --[[pod_type="gfx"]]unpod("b64:bHo0ALwAAAC6AAAA8IxweHUAQyAWGgTwlw8U8AYPFtALDxQPFzAPDg8W0A8UDR8XEB4PFsALDA4dEA4PDtALDS4AHg8U0AoMDQ4PDg4JDg8MwA8TDA0eCR4MwAsKHgMMDxoPFQ4PDHAMMA0ODAMOAw8aAwxwDA4KEA4MDgwODz8FHHAKDT4DDC4TDoAKDA4NHgoDCg4PFQ4CkA8TDQwNHA4MAwweDKAaDB0A8Aw_wAoICg0MDQ4NCQ7QCAocPvAACh0O8AIKDDA=")
local grabbing_cursor = --[[pod_type="gfx"]]unpod("b64:bHo0AJMAAACRAAAA8CBweHUAQyAOEwTwOy8XDXANLg8OHg8WQA8MHxYCHxUDDg1ADxQPFg8VDxYOBQ8aDhsA8AQTAw4PFh4DHg0wDQ4DDxQODxUOEgDwODAPFA0PFh8VDg8-HxUOMB8UHxYPFQMPFgMOAkAfFA8VHxYTDA4PFFAbHA0uYAsPExwODQ8ODGAPEwsMDS5wDwwLHpAPEwsw")
local look_cursor = --[[pod_type="gfx"]]unpod("b64:bHo0ALsAAAC9AAAA8XFweHUAQyARCwRgPxyQDgYPKw4dHhYOMAYODz0PMg8YDzQPHQ8xDygPMQ89FgcQFg85DxgfIw8PBg4fIg8nDzEWABYODycPIg8jDw8PNBYPJw8jDyIPGA85DiYPLA8nDxgPGQ8pDzIWDA8jDxkPNA8gDQ4WDg8zDxgfIg8zFg8nHy0AcQ8dDgAWDyZvAFAiDxgOBiIA8BQPJw8mHiAWDx0PJg8xDxgPJg8dDyAMDx0ODUBmDQ4GDpA2UA==")
local screwdriver_cursor = --[[pod_type="gfx"]]unpod("b64:bHo0AGkAAACZAAAA8QVweHUAQyAsLgTw-----Q8z8BsPOgYAFzIMAAkGAGEfM-AaDy8GAAgMABExBgAROjgA8gkaDzECAQLwGBgSAQLwFhgBAgECAfAWARgIABIoBwAaAg8A8AEBGBIB8BdI8BgBCBfwGggA")
window{cursor=point_cursor}

local was_lmb,was_rmb

function _cursor.update()
	local mouse_x,mouse_y,mb = mouse()
	local lmb,rmb = mb&1 ~= 0,mb&2 ~= 0
	local hovered_interactable = nil
	for object in locations.all_objects() do
		local interactable = object.interactable
		hovered_interactable = interactable:hovered(mouse_x,mouse_y) and interactable or hovered_interactable
	end
	local cursor = hovered_interactable and
		(lmb and grabbing_cursor or grabbable_cursor)
		or point_cursor
	window{cursor=cursor}
	if lmb and not was_lmb then
		if hovered_interactable then
			player.go_to_interact{interactable = hovered_interactable, verb = "take"}
		else
			player.set_dest(mouse_x)
		end
	end
	was_lmb,was_rmb = lmb,rmb
end

return _cursor