local vec = require"vectors"

local comment = {}

local seconds_per_character = 0.05

local comments = {}

function comment.new(text,parent,offset,color)
	local c = {
		text = text,
		parent = parent,
		offset = offset-vec(#text*2.5,3),
		color = color or 37,
		t = #text*seconds_per_character,
	}
	add(comments,c)
	return c
end

function comment.update()
	for i = #comments,1,-1 do
		local c = comments[i]
		c.t -= dt
		if c.t <= 0 then
			deli(comments,i)
		end
	end
end

function comment.draw()
	for c in all(comments) do
		local x = mid(0,c.parent.position[1]+c.offset[1],480-#c.text*5)
		local y = mid(0,c.parent.position[2]+c.offset[2],264)
		print(c.text,x,y,c.color)
	end
end

return comment