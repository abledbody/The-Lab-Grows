--[[pod_format="raw",created="2024-04-19 00:08:05",modified="2024-04-23 02:14:37",revision=1078]]
local vec = require"vectors"

local utils = {}

function utils.move_towards(x,t,s)
	local delta = t-x
	return x+sgn(delta)*min(s,abs(delta))
end

local rect = {
	contains = function(self,x,y)
		local l,t = unpack(self.pos)
		local r,b = unpack(self.pos+self.size)
		return x >= l and x <= r and y >= t and y <= b
	end,
}
rect.__index = rect

function utils.rect(pos,size)
	local o = {
		pos = vec(pos),
		size = vec(size),
	}
	setmetatable(o,rect)
	return o
end

return utils