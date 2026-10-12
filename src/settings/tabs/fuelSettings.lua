local language = require("language.language")
local button = require("src.ui.buttons.button")
local slider = require("src.ui.selectors.slider")

local fuelSettings = {}

local defaultValues = {
	fuelScale = 1,
}

fuelSettings.store = ac.storage(defaultValues)

local function resetToDefault()
	for key, value in pairs(defaultValues) do
		fuelSettings.store[key] = value
	end
end

function fuelSettings.fuelSettings()
	local initPos = 75

	-- Escala:
	fuelSettings.store.fuelScale = slider.main(
		language.get("SIZE"),
		string.format("%.2f", fuelSettings.store.fuelScale),
		vec2(20, initPos),
		250,
		fuelSettings.store.fuelScale,
		0.7,
		2
	)

	initPos = initPos + 40

	if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
		resetToDefault()
	end
end

return fuelSettings
