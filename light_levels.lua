--[[pod_format="raw",created="2024-04-19 04:27:30",modified="2024-04-23 02:14:58",revision=811]]
local light_levels = {}

local normal = fetch"pal/0.pal"

poke4(0x5000, get(normal))

local levels = {
	[-1] = {
		 0, 8, 9, 2, 3, 3, 6, 6,
		 7, 8, 9,31,31,11,20,34,
		29,29, 1,10,62,10,11,20,
		32,24,13,20, 6,28,29,29,
		16,32,51,52,34,35,29,57,
		47,40,34,28,28,44,56,56,
		54,61,38,49,50,54,47,28,
		43,61,56,46, 7,28,61,20,
	}
}

function light_levels.set(level)
	if level == 0 then
		for i = 0,63 do
			pal(i,i)
			palt(0,true)
		end
	else
		local level_colors = levels[level]
		for i = 1,#level_colors do
			pal(i-1,level_colors[i])
			palt(0,true)
		end
	end
end

return light_levels