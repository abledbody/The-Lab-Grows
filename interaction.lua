local volref,got
do local ref = require"volref" volref,got = ref.volref,ref.got end

local interaction = {}

local Interactable = {
	hovered = function(self,x,y)
		return self.rect:contains(x,y)
	end,
	interact = function(self,verb)
		if not got(self) then return end
		local callback = self.interactions[verb]
		if not callback then return end
		callback(self)
	end,
}
Interactable.__index = Interactable

function interaction.interactable(rect,interactions)
	local o = {
		rect = rect,
		interactions = interactions,
	}
	setmetatable(o,Interactable)
	return volref(o)
end

return interaction