--[[pod_format="raw",created="2024-04-19 01:03:44",modified="2024-04-23 22:47:18",revision=126]]
local vec_meta

local function vec(...)
	local args = {...}
	local vector
	if type(args[1]) == "table" then
		vector = {}
		for i,x in ipairs(args[1]) do
			vector[i] = x
		end
	else
		vector = {...}
	end
	setmetatable(vector,vec_meta)
	return vector
end

local function element_transform(lhs,transform,rhs)
	local vector = vec()
	rhs = rhs or {}
	for i,x in ipairs(lhs) do
		vector[i] = transform(x,rhs[i])
	end
	return vector
end

vec_meta = {
	__call = function(orig)
		return element_transform(orig,function(x) return x end)
	end,
	
	__unm = function(orig)
		return element_transform(orig,function(x) return -x end)
	end,
	
	__add = function(lhs,rhs)
		return element_transform(lhs,function(lhs,rhs) return lhs+(rhs or 0) end,rhs)
	end,
	
	__sub = function(lhs,rhs)
		return element_transform(lhs,function(lhs,rhs) return lhs-(rhs or 0) end,rhs)
	end,
	
	__mul = function(lhs,rhs)
		if type(lhs) == "number" then
			return element_transform(rhs,function(rhs) return lhs*rhs end)
		elseif type(rhs) == "number" then
			return element_transform(lhs,function(lhs) return lhs*rhs end)
		else error"Vectors can only be multiplied with numbers." end
	end,
	
	__div = function(lhs,rhs)
		if type(rhs) == "number" then
			return element_transform(lhs,function(lhs) return lhs/rhs end)
		else error"Vectors can only be divided by numbers." end
	end,
	
	__eq = function(lhs,rhs)
		if #lhs ~= #rhs then return false end
		for i,x in ipairs(lhs) do
			if x ~= rhs[i] then return false end
		end
		return true
	end,
	
	__tostring = function(self)
		local str = "["
		for i,x in ipairs(self) do
			str = str..string.format("%.2f",x)
			if i < #self then
				str = str..","
			end
		end
		return str.."]"
	end,
	
	dot = function(lhs,rhs)
		if #lhs ~= #rhs then
			error("Can't dot product a vector of length "..#lhs.." with one of length "..#rhs)
		end
		local sum = 0
		for i,x in ipairs(lhs) do
			sum += x*rhs[i]
		end
		return sum
	end,
	
	mag = function(self)
		local sum = 0
		for x in all(self) do
			sum += x*x
		end
		return sqrt(sum)
	end,
	
	norm = function(self,mag)
		local is_zero = true
		for i,x in ipairs(self) do
			if x ~= 0 then
				is_zero = false
				break
			end
		end
		if is_zero then return self end
		mag = mag or self:mag()
		return self/mag
	end,
	
	atan2 = function(self)
		assert(#self >= 2,"Vector must have at least 2 elements to get atan2.")
		return atan2(self[1],self[2])
	end,
	
	proj = function(lhs,rhs,prenorm)
		local rhs_norm = prenorm and rhs or rhs:norm()
		return lhs:dot(rhs_norm)*rhs_norm
	end,
	
	rej = function(lhs,rhs,prenorm)
		return lhs-lhs:proj(rhs,prenorm)
	end,
}
vec_meta.__index = vec_meta

return vec