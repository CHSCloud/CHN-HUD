local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local window = require("common.window")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local rect = require("src.ui.background.rect")
local pedalsData = require("src.data.pedals.pedalsData")

local gear = require("src.hud.pedals.components.gear")
local bars = require("src.hud.pedals.components.bars")
local rpm = require("src.hud.pedals.components.rpm")
local speed = require("src.hud.pedals.components.speed")
local wheel = require("src.hud.pedals.components.wheel")
local abs = require("src.hud.pedals.components.abs")
local tc = require("src.hud.pedals.components.tc")
local drs = require("src.hud.pedals.components.drs")
local brakeBias = require("src.hud.pedals.components.brakeBias")
local p2p = require("src.hud.pedals.components.p2p")
local fuel = require("src.hud.pedals.components.fuel")
local telemetry = require("src.hud.pedals.components.telemetry")

local pedals = {}

---@type pedalsData
local data = nil

function pedals.init()
	data = pedalsData.new()
end

function pedals.onSessionStart()
	data = pedalsData.new()
end

function pedals.windowMain()
	ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
	data.fontBar = 15 * pedalsSettings.store.pedalsScale
	data.fontBarInfinite = 25 * pedalsSettings.store.pedalsScale
	data.fontContentBottom = 13 * pedalsSettings.store.pedalsScale

	data.barSize = vec2(20, 60) * pedalsSettings.store.pedalsScale
	data.barSpace = 4 * pedalsSettings.store.pedalsScale
	data.barLimitSize = vec2(20, 6) * pedalsSettings.store.pedalsScale
	data.barMidleSize = vec2(20, 44) * pedalsSettings.store.pedalsScale
	data.barPaddingMidle = 2 * pedalsSettings.store.pedalsScale
	pedalsData.resetContentPositions(data, data.currentWindowSize)

	if
		pedalsSettings.store.textBarsActive
		and data.contentMidle > 0
		and (
			pedalsSettings.store.clutchActive
			or pedalsSettings.store.brakeActive
			or pedalsSettings.store.throttleActive
			or pedalsSettings.store.handbrakeActive
		)
	then
		data.contentTop = data.contentTop + 8 * pedalsSettings.store.pedalsScale
	end

	data.currentWindowWidth = 0
	data.currentWindowHeight = data.contentMidle + data.contentTop + data.contentBottom
	data.contentMidle = 0

	rect.drawRectRounded(vec2(0, 0), data.currentWindowSize, WindowsColor, 10 * pedalsSettings.store.pedalsScale, 20)

	if pedalsSettings.store.telemetryActive and pedalsSettings.store.telemetryPos == 1 then
		telemetry.drawTelemetry(data)
		data.currentWindowWidth = pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale
	end

	if pedalsSettings.store.gearActive then
		gear.drawGear(data)
	else
		data.fontGear = 0
	end

	if pedalsSettings.store.speedActive then
		speed.drawSpeed(data)
	end
	if pedalsSettings.store.gearActive or pedalsSettings.store.speedActive then
		data.currentWindowWidth = data.currentWindowWidth + 60 * pedalsSettings.store.pedalsScale
	end

	data.currentWindowWidth = data.currentWindowWidth + 7 * pedalsSettings.store.pedalsScale + data.barSpace

	if pedalsSettings.store.clutchActive then
		bars.drawClutch(data)
	end

	if pedalsSettings.store.brakeActive then
		bars.drawBrake(data)
	end

	if pedalsSettings.store.throttleActive then
		bars.drawAccelerator(data)
	end

	if pedalsSettings.store.handbrakeActive then
		bars.drawHandbrake(data)
	end

	data.currentWindowWidth = data.currentWindowWidth + 7 * pedalsSettings.store.pedalsScale

	if pedalsSettings.store.wheelActive then
		wheel.drawWheel(data)
	end

	if pedalsSettings.store.absActive and CAR.absModes ~= 0 then
		abs.drawABS(data)
	end

	if pedalsSettings.store.brakeBiasActive then
		brakeBias.drawBrakeBias(data)
	end

	if pedalsSettings.store.fuelActive then
		fuel.drawFuel(data)
	end

	if pedalsSettings.store.tractionControlActive and CAR.tractionControlModes ~= 0 then
		tc.drawTC(data)
	end

	if pedalsSettings.store.drsActvationActive and CAR.drsPresent then
		drs.drawDRSActivation(data)
	end

	if pedalsSettings.store.p2pActive and CAR.kersPresent then
		p2p.drawP2p(data)
	end

	if pedalsSettings.store.rpmActive then
		rpm.drawRpm(data)
	end

	if pedalsSettings.store.telemetryActive and pedalsSettings.store.telemetryPos == 2 then
		telemetry.drawTelemetry(data)
		data.currentWindowWidth = data.currentWindowWidth + pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale
	end

	if data.contentPositions[1][2] ~= vec2(0, 0) or data.contentPositions[2][2] ~= vec2(0, 0) or data.contentPositions[5][2] ~= vec2(0, 0) then
		data.contentTop = math.max(data.contentPositions[1][2].y, data.contentPositions[2][2].y, data.contentPositions[5][2].y)
	else
		data.contentTop = 0
	end

	if data.contentPositions[3][2] ~= vec2(0, 0) or data.contentPositions[4][2] ~= vec2(0, 0) or data.contentPositions[6][2] ~= vec2(0, 0) then
		data.contentBottom = math.max(data.contentPositions[3][2].y, data.contentPositions[4][2].y, data.contentPositions[6][2].y)
	else
		data.contentBottom = 0
	end

	local windowWidth = data.currentWindowWidth
	local telemetryWidth = 0
	if pedalsSettings.store.telemetryActive then
		windowWidth = data.currentWindowWidth - pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale
		telemetryWidth = pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale
	end
	if
		windowWidth < (data.contentPositions[1][2].x + data.contentPositions[2][2].x + data.contentPositions[5][2].x)
		or windowWidth < (data.contentPositions[3][2].x + data.contentPositions[4][2].x + data.contentPositions[6][2].x)
	then
		data.currentWindowWidth = math.max(
			data.contentPositions[1][2].x + data.contentPositions[2][2].x + data.contentPositions[5][2].x,
			data.contentPositions[3][2].x + data.contentPositions[4][2].x + data.contentPositions[6][2].x
		) + telemetryWidth
	end

	data.currentWindowSize = vec2(data.currentWindowWidth, data.currentWindowHeight)

	window.resize(data.currentWindowSize, "CHN Pedals")

	pinCheckBox.main(pedalsSettings.store.pedalsScale, "CHN Pedals", window.getWindow("CHN Pedals"):pinned(), data.currentWindowSize)
end

return pedals
