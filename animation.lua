--[[pod_format="raw",created="2024-04-23 02:07:01",modified="2024-04-23 22:47:18",revision=531]]
local animation = {}

local state_meta = {
	__call = function(state,dt)
		local anim = state.anim
		state.t += dt/anim[state.f].t
		while state.t >= 1 do
			state.t -= 1
			state.f += 1
			if state.f > #anim then
				state.f = 1
				if anim.on_end then anim.on_end() end
			end
			local frame = anim[state.f]
			if frame.on_enter then frame.on_enter(state) end
			if anim.every_frame then anim.every_frame(state) end
		end
	end,
}

function animation.play(anim,state)
	local state = state or {
		t = 0,
		f = 1,
		anim = anim,
	}
	setmetatable(state,state_meta)
	local frame = anim[state.f]
	if frame.on_enter then frame.on_enter(state) end
	if anim.every_frame then anim.every_frame(state) end
	if anim.on_enter then anim.on_enter(state) end
	return state,frame
end

function animation.sprite_string(start,len,t)
	local frames = {}
	for i = 0,len-1 do
		add(frames,{
			spr = i+start,
			t = t,
		})
	end
	return frames
end

return animation