local window = {}

local defaultValues = {
	pinAllApps = false,
}

window.store = ac.storage(defaultValues)

local pinStorage = ac.storage({
	["CHN Settings"] = false,
	["CHN Pedals"] = false,
	["CHN Pit Lane"] = false,
	["CHN Session Laps"] = false,
	["CHN Starting Lights"] = false,
	["CHN Session Flags"] = false,
	["CHN Delta Bar"] = false,
	["CHN Map"] = false,
	["CHN Leaderboard"] = false,
	["CHN Tyres"] = false,
})

local windowNames = {
	"CHN Settings",
	"CHN Pedals",
	"CHN Pit Lane",
	"CHN Session Laps",
	"CHN Starting Lights",
	"CHN Session Flags",
	"CHN Delta Bar",
	"CHN Map",
	"CHN Leaderboard",
	"CHN Tyres",
}

---@Credits This function was inspired by the "settings.init()" function from CMRT Complete HUD.
function window.init()
	local all = ac.getAppWindows()
	local win
	for i = 1, #all do
		for j = 1, #windowNames do
			if all[i] ~= nil and all[i].title == windowNames[j] then
				if all[i].name ~= nil then
					win = ac.accessAppWindow(all[i].name)
					if win ~= nil then
						if all[i].title ~= "CHN Settings" then
							win:setPinned(pinStorage[all[i].title])
						end
						window[windowNames[j]] = win
					end
				end
			end
		end
	end
end

--- @param name string
function window.getWindow(name)
	local data = window[name]
	if data == nil then
		return nil
	end
	return data
end

--- @param size vec2
--- @param nameWindow string
function window.resize(size, nameWindow)
	local window = window.getWindow(nameWindow)
	if window == nil then
		return
	end
	local ui_info = ac.getUI()
	window:resize(size * ui_info.uiScale)
end

--- @param mousePos vec2
--- @param x1 number
--- @param x2 number
--- @param y1 number
--- @param y2 number
--- @return boolean
function window.isMouseInWindow(mousePos, x1, x2, y1, y2)
	if mousePos.x < x1 then
		return false
	end
	if mousePos.x > x2 then
		return false
	end
	if mousePos.y < y1 then
		return false
	end
	if mousePos.y > y2 then
		return false
	end
	return true
end

--- @param nameWindow string
--- @return boolean | nil
function window.pinWindow(nameWindow)
	local win = window.getWindow(nameWindow)
	if win == nil then
		return nil
	end
	local pin = win:pinned()
	pinStorage[nameWindow] = not pin
	win:setPinned(not pin)
	window.store.pinAllApps = false
	return not pin
end

--- @param pin boolean
function window.pinAllApps(pin)
	window.store.pinAllApps = pin
	for _, name in ipairs(windowNames) do
		if name ~= "CHN Settings" then
			window.getWindow(name):setPinned(pin)
		end
	end
end

return window
