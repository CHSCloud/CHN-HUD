local sessionFlagsSettings = require("src.settings.tabs.sessionFlagsSettings")

local flags = {}

---@param data sessionFlagsData
---@param path string
---@param title string
---@param description string
---@param titleY? number
---@param descY? number
---@param cursorX? number
function flags.drawFlag(data, path, title, description, titleY, descY, cursorX)
	titleY = titleY or 80
	descY = descY or 125
	cursorX = cursorX or 10

	ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
	ui.drawRectFilled(vec2(0, 0), data.currentWindowSize, WindowsColor, data.rounding)
	ui.setCursor(data.posFlag)
	ui.image(path, data.flagLenght)
	ui.setCursor(vec2(cursorX, titleY):scale(sessionFlagsSettings.store.sessionFlagsScale))
	ui.dwriteTextAligned(
		title,
		data.fontSize1,
		ui.Alignment.Start,
		ui.Alignment.End,
		vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale),
		true,
		COLOR.WHITE
	)
	ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
	ui.setCursor(vec2(cursorX, descY):scale(sessionFlagsSettings.store.sessionFlagsScale))
	ui.dwriteTextAligned(
		description,
		data.fontSize2,
		ui.Alignment.Start,
		ui.Alignment.Center,
		vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale),
		true,
		COLOR.WHITE
	)
end

return flags
