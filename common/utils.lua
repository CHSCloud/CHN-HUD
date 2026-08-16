local utils = {}

--- @param value number
--- @param inMin number
--- @param inMax number
--- @param outMin number
--- @param outMax number
--- @return number
function utils.remapIntervalWithLimits(value, inMin, inMax, outMin, outMax)
	local output = outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
	return math.clamp(output, outMin, outMax)
end

--- @param value number
--- @param inMin number
--- @param inMax number
--- @param outMin number
--- @param outMax number
--- @return number
function utils.remapInterval(value, inMin, inMax, outMin, outMax)
	return (outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin))
end

--- @param vec vec2 -- Vetor a ser rotacionado
--- @param angleDeg number -- Ângulo em graus
--- @return vec2
function utils.rotateVec(vec, angleDeg)
	local rad = math.rad(angleDeg)
	local sin = math.sin(rad)
	local cos = math.cos(rad)
	return vec2(vec.x * cos - vec.y * sin, vec.x * sin + vec.y * cos)
end

--- @param vec vec2
--- @return vec2
function utils.floorVec(vec)
	return vec2(math.floor(vec.x), math.floor(vec.y))
end

---@param value number
---@param places number
---@return number
function utils.decimal(value, places)
	local factor = 10 ^ places
	return math.floor(value * factor) / factor
end

--- @param text string
--- @return string, number
function utils.findLongestWord(text)
	local longest = ""
	local count = -1
	for word in text:gmatch("[^\n]+") do
		if #word > #longest then
			longest = word
		end
		count = count + 1
	end

	return longest, count
end

--- @param table table
--- @param fontSize number
--- @return vec2
function utils.findLenghtLongestString(table, fontSize)
	local max = vec2(0, 0)
	for _, value in ipairs(table) do
		local size = ui.measureDWriteText(value, fontSize)
		if size.x > max.x then
			max = size
		end
	end
	return max
end

--- @param from table
--- @param to table
function utils.copyTable(from, to)
	for k, v in pairs(from) do
		to[k] = v
	end
end

---@param from rgbm
---@param to rgbm
---@param transition number
function utils.colorLerp(from, to, transition)
	return rgbm(
		math.lerp(from.r, to.r, transition),
		math.lerp(from.g, to.g, transition),
		math.lerp(from.b, to.b, transition),
		math.lerp(from.mult, to.mult, transition)
	)
end

---@param last number
---@param current number
---@param smooth number
---@return number
function utils.smoothValue(last, current, smooth)
	return last + (current - last) * smooth
end

return utils
