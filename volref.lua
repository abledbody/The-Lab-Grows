local ref_meta = {}

-- Destroys the referenced object.
function ref_meta:destroy()
	if self.on_destroy then
		self:on_destroy()
	end
	rawset(self,"destroyed",true)
	rawset(self,"_target",nil)
end

function ref_meta:__index(key)
	if rawget(self,"destroyed") then
		error("Cannot access destroyed reference.")
	end
	return ref_meta[key] or rawget(self,"_target")[key]
end

function ref_meta:__newindex(key,value)
	if rawget(self,"destroyed") then
		error("Cannot access destroyed reference.")
	end
	rawget(self,"_target")[key] = value
end

return {
	-- Wraps a target in a reference object that can be destroyed.
	volref = function(target)
		return setmetatable({_target = target}, ref_meta)
	end,
	-- Checks if a reference is valid and optionally if it has a key.
	got = function(ref,key)
		return (ref and not rawget(ref,"destroyed")) and ((key and ref[key]) or ref)
	end
}