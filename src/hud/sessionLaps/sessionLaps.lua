local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local rect = require("src.ui.background.rect")
local window = require("common.window")
local sessionLapsData = require("src.data.sessionLaps.sessionLapsData")

local laps = require("src.hud.sessionLaps.components.laps")
local sectors = require("src.hud.sessionLaps.components.sectors")

local sessionLaps = {}

--- @type sessionLapsData
local data

function sessionLaps.init()
	data = sessionLapsData.new()
	data.previousBestlap = 0
	sessionLapsData.resetSectors(data)
	sessionLapsData.setSectorsDivisions(data, sessionLapsSettings.store.numberDivisions - 1)
	data.showLastDivisions = false
end

function sessionLaps.onSessionStart()
	data = sessionLapsData.new()
	data.previousBestlap = 0
	sessionLapsData.resetSectors(data)
	sessionLapsData.setSectorsDivisions(data, sessionLapsSettings.store.numberDivisions - 1)
	data.showLastDivisions = false
end

function sessionLaps.windowMain()
	ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONT TEXT
	data.currentWindowWidth = 240 * sessionLapsSettings.store.sessionLapsScale
	data.currentWindowHeight = 0
	if data.currentNumberDivisions ~= sessionLapsSettings.store.numberDivisions then
		sessionLapsData.setSectorsDivisions(data, sessionLapsSettings.store.numberDivisions - 1)
		data.currentNumberDivisions = sessionLapsSettings.store.numberDivisions
	end
	rect.drawRectRounded(vec2(0, 0), data.currentWindowSize, WindowsColor, 6 * sessionLapsSettings.store.sessionLapsScale, 20)
	-- Volta atual
	if sessionLapsSettings.store.currentLapActive then
		laps.drawCurrent(data)
	end

	-- Última volta
	if sessionLapsSettings.store.lastLapActive then
		laps.drawLast(data)
	end

	-- Melhor volta
	if sessionLapsSettings.store.bestLapActive then
		laps.drawBest(data)
	end

	-- Setores
	if sessionLapsSettings.store.sectorsLapActive then
		sectors.drawSectors(data)
	end

	data.currentWindowSize = vec2(data.currentWindowWidth, data.currentWindowHeight * sessionLapsSettings.store.sessionLapsScale)

	window.resize(data.currentWindowSize, "CHN Session Laps")
	pinCheckBox.main(sessionLapsSettings.store.sessionLapsScale, "CHN Session Laps", window.getWindow("CHN Session Laps"):pinned(), data.currentWindowSize)
end

return sessionLaps
