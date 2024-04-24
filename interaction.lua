require"utils"

local interaction = {}

local Interactable = {
	hovered = function(self,x,y)
		return self.rect:contains(x,y)
	end,
	interact = function(self,verb)
		self.interactions[verb](self)
	end,
}
Interactable.__index = Interactable

function interaction.interactable(rect,interactions)
	local o = {
		rect = rect,
		interactions = interactions,
	}
	setmetatable(o,Interactable)
	return o
end

return interaction