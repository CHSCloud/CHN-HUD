local language = require("language.language")
local utils = require("common.utils")
local slider = require("src.ui.selectors.slider")
local tab = require("src.ui.buttons.tab")
local button = require("src.ui.buttons.button")
local droplist = require("src.ui.selectors.droplist")
local droplistWithRemove = require("src.ui.selectors.droplistWithRemove")
local toggleButton = require("src.ui.buttons.toggleButton")
local pedalsSettings = {}

local defaultValues = {
	pedalsScale = 1,
	gearActive = true,
	speedActive = true,
	wheelActive = true,
	absActive = true,

	throttleActive = true,
	brakeActive = true,

	brakeBiasActive = true,
	brakebiasPos = 3,

	p2pActive = false,
	p2pLenght = 0.65,
	p2pPos = 6,

	clutchActive = true,
	handbrakeActive = false,
	textBarsActive = false,

	tractionControlActive = false,
	tractionControlPos = 2,

	fuelActive = true,
	fuelOption = 1,
	fuelPos = 4,

	pedalLimitsLines = true,
	rpmActive = true,
	wheelType = 1,

	rpmPos = 5,
	rpmType = 1,
	rpmProcessType = 1,
	numLights = 9,
	barLength = 0.55,
	manualRpmActive = false,
	rpmMin = CAR.rpmLimiter * 0.80,
	rpmMax = CAR.rpmLimiter * 0.98,

	drsActvationActive = false,
	drsPos = 1,

	telemetryActive = true,
	telemetryLenght = 250,
	telemetryPeriod = 300,
	telemetryPos = 1,
	telemetryInverted = false,
	telemetryThrottle = true,
	telemetryBrake = true,
	telemetryAbs = false,
	telemetryClucth = false,
	telemetryHandbrake = false,
}

pedalsSettings.store = ac.storage(defaultValues)

local positionsKeysBorders = {}
local positionsKeysCenter = {}

local positionsBorders = {}
local positionsCenters = {}
local positionsTelemetry = {}

local fuelOptions = {}

local wheelsLabels = {
	language.get("SIMPLE"),
}

Wheels = {
	"",
}

local function resetToDefault()
	for key, value in pairs(defaultValues) do
		pedalsSettings.store[key] = value
	end
end

local function invertPositionBorder(oldPos, newPos, keyPos)
	for key, value in pairs(positionsKeysBorders) do
		if key ~= keyPos then
			if value == newPos then
				pedalsSettings.store[key] = oldPos
				positionsKeysBorders[key] = oldPos
			end
		end
	end
end

local function invertPositionCenter(oldPos, newPos, keyPos)
	for key, value in pairs(positionsKeysCenter) do
		if key ~= keyPos then
			if value == newPos then
				pedalsSettings.store[key] = oldPos
				positionsKeysCenter[key] = oldPos
			end
		end
	end
end

local function findWheels()
	local dir = ac.getFolder(ac.FolderID.ACAppsLua) .. "\\CHN-HUD\\assets\\pedals\\wheels"
	table.clear(Wheels)
	table.clear(wheelsLabels)
	table.insert(Wheels, "")
	table.insert(wheelsLabels, language.get("SIMPLE"))
	io.scanDir(dir, function(fileName)
		table.insert(Wheels, fileName)
		table.insert(wheelsLabels, string.sub(fileName:gsub("%.%w+$", ""), 1, 25))
	end)
end

local function selectNewWheel()
	os.openFileDialog({
		title = language.get("SELECT_WHEEL"),
		defaultFolder = ac.getFolder(ac.FolderID.Root),
		fileTypes = {
			{
				name = language.get("IMAGES") .. " (.png, .jpg, .jpeg, .webp)",
				mask = "*.png;*.jpg;*.jpeg;*.webp",
			},
		},
		addAllFilesFileType = true,
		flags = bit.bor(os.DialogFlags.PathMustExist, os.DialogFlags.FileMustExist),
	}, function(err, filename)
		if err or not filename or filename == "" then
			return
		end

		local sourceFile = io.open(filename, "rb")

		if not sourceFile then
			return
		end

		local content = sourceFile:read("*a")
		sourceFile:close()

		local name = filename:match("([^\\/]+)$")
		local newWheel = io.open(ac.getFolder(ac.FolderID.ACAppsLua) .. "\\CHN-HUD\\assets\\pedals\\wheels\\" .. name, "wb")
		if newWheel then
			newWheel:write(content)
			newWheel:close()
			findWheels()
			pedalsSettings.store.wheelType = table.indexOf(wheelsLabels, string.sub(name:gsub("%.%w+$", ""), 1, 25)) or 1
		end
	end)
end

---@param wheelType number
local function removeWheel(wheelType)
	local fileName = Wheels[wheelType]
	io.deleteFile(ac.getFolder(ac.FolderID.ACAppsLua) .. "\\CHN-HUD\\assets\\pedals\\wheels\\" .. fileName)
	table.remove(Wheels, wheelType)
	table.remove(wheelsLabels, wheelType)
	pedalsSettings.store.wheelType = 1
end

function pedalsSettings.init()
	findWheels()
end

-- Desenha a seção de outros
--- @param pos vec2
local function drawOthers(pos)
	ui.dwriteDrawText(language.get("OTHERS"), 12, vec2(pos.x - 5, pos.y), COLOR.WHITE)

	pos.y = pos.y + 25
	if toggleButton.main("fuel", pos, pedalsSettings.store.fuelActive, language.get("FUEL")) then
		pedalsSettings.store.fuelActive = not pedalsSettings.store.fuelActive
	end
	if pedalsSettings.store.fuelActive then
		local old = pedalsSettings.store.fuelPos
		pedalsSettings.store.fuelPos = droplist.main(
			"##fuelPos",
			"|  " .. language.get("POSITION"),
			vec2(pos.x + ui.measureDWriteText(language.get("FUEL"), 12).x + 60, pos.y - 4),
			utils.findLenghtLongestString(positionsBorders, 12).x + 40,
			pedalsSettings.store.fuelPos,
			positionsBorders,
			droplist.PosText.Start
		)
		if pedalsSettings.store.fuelPos ~= old then
			invertPositionBorder(old, pedalsSettings.store.fuelPos, "fuelPos")
		end

		pedalsSettings.store.fuelOption = droplist.main(
			"##fuelOption",
			"",
			vec2(pos.x + ui.measureDWriteText(language.get("FUEL"), 12).x + 260, pos.y - 4),
			utils.findLenghtLongestString(positionsBorders, 12).x + 40,
			pedalsSettings.store.fuelOption,
			fuelOptions,
			droplist.PosText.Start
		)

	end
	pos.y = pos.y + 30
	if toggleButton.main("brakeBias", pos, pedalsSettings.store.brakeBiasActive, language.get("BRAKE_BIAS")) then
		pedalsSettings.store.brakeBiasActive = not pedalsSettings.store.brakeBiasActive
	end
	if pedalsSettings.store.brakeBiasActive then
		local old = pedalsSettings.store.brakebiasPos
		pedalsSettings.store.brakebiasPos = droplist.main(
			"##brakebiasPos",
			"|  " .. language.get("POSITION"),
			vec2(pos.x + ui.measureDWriteText(language.get("BRAKE_BIAS"), 12).x + 60, pos.y - 3),
			utils.findLenghtLongestString(positionsBorders, 12).x + 40,
			pedalsSettings.store.brakebiasPos,
			positionsBorders,
			droplist.PosText.Start
		)
		if pedalsSettings.store.brakebiasPos ~= old then
			invertPositionBorder(old, pedalsSettings.store.brakebiasPos, "brakebiasPos")
		end
	end

	pos.y = pos.y + 30
	if toggleButton.main("tc", pos, pedalsSettings.store.tractionControlActive, language.get("TC")) then
		pedalsSettings.store.tractionControlActive = not pedalsSettings.store.tractionControlActive
	end

	if CAR.tractionControlModes == 0 then
		ui.setCursor(vec2(pos.x + ui.measureDWriteText(language.get("TC"), 12).x + 55, pos.y))
		ui.dwriteTextAligned(language.get("ALERT_TC"), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(250, 20), false, COLOR.RED)
	else
		if pedalsSettings.store.tractionControlActive then
			local old = pedalsSettings.store.tractionControlPos
			pedalsSettings.store.tractionControlPos = droplist.main(
				"##tractionControlPos",
				"|  " .. language.get("POSITION"),
				vec2(pos.x + ui.measureText(language.get("TC")).x + 85, pos.y - 3),
				utils.findLenghtLongestString(positionsBorders, 12).x + 40,
				pedalsSettings.store.tractionControlPos,
				positionsBorders,
				droplist.PosText.Start
			)
			if pedalsSettings.store.tractionControlPos ~= old then
				invertPositionBorder(old, pedalsSettings.store.tractionControlPos, "tractionControlPos")
			end
		end
	end

	pos.y = pos.y + 30
	if toggleButton.main("drs", pos, pedalsSettings.store.drsActvationActive, "DRS") then
		pedalsSettings.store.drsActvationActive = not pedalsSettings.store.drsActvationActive
	end

	if not CAR.drsPresent then
		ui.setCursor(vec2(pos.x + ui.measureDWriteText("DRS", 12).x + 18, pos.y))
		ui.dwriteTextAligned(language.get("ALERT_DRS"), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(250, 20), false, COLOR.RED)
	else
		if pedalsSettings.store.drsActvationActive then
			local old = pedalsSettings.store.drsPos
			pedalsSettings.store.drsPos = droplist.main(
				"##drsPos",
				"|  " .. language.get("POSITION"),
				vec2(pos.x + ui.measureText("DRS").x + 85, pos.y - 3),
				utils.findLenghtLongestString(positionsBorders, 12).x + 40,
				pedalsSettings.store.drsPos,
				positionsBorders,
				droplist.PosText.Start
			)
			if pedalsSettings.store.drsPos ~= old then
				invertPositionBorder(old, pedalsSettings.store.drsPos, "drsPos")
			end
		end
	end

	return pos
end

-- Desenha a seção de RPM
local function drawRPM(pos)
	local copyPos = pos + vec2(300, 0)
	--pedalsSettings.store.rpmPos = 5
	local rpmLabels = {
		language.get("SHIFT_LIGHTS"),
		language.get("BAR"),
	}
	local processCircleType = {
		language.get("DEFAULT"),
		language.get("TOTAL"),
	}

	ui.dwriteDrawText("RPM", 12, vec2(pos.x - 5, pos.y), COLOR.WHITE)

	pos.y = pos.y + 25
	if toggleButton.main("rpm", vec2(pos.x, pos.y), pedalsSettings.store.rpmActive, "") then
		pedalsSettings.store.rpmActive = not pedalsSettings.store.rpmActive
	end

	if pedalsSettings.store.rpmActive then
		local exampleRPpedalsSettingsX = pos.x + 70
		local exampleRPpedalsSettingsY = pos.y + 20
		pos.y = pos.y + 30

		local old = pedalsSettings.store.rpmPos
		pedalsSettings.store.rpmPos = droplist.main(
			"##rpmPos",
			language.get("POSITION"),
			vec2(pos.x, pos.y),
			utils.findLenghtLongestString(positionsCenters, 12).x + 160,
			pedalsSettings.store.rpmPos,
			positionsCenters,
			droplist.PosText.Start
		)
		if pedalsSettings.store.rpmPos ~= old then
			invertPositionCenter(old, pedalsSettings.store.rpmPos, "rpmPos")
		end

		pos.y = pos.y + 30

		pedalsSettings.store.rpmType =
			droplist.main("##rpmType", language.get("TYPE"), vec2(pos.x, pos.y + 5), 160, pedalsSettings.store.rpmType, rpmLabels, droplist.PosText.Start)

		if pedalsSettings.store.rpmType == 1 then
			pos.y = pos.y + 40
			pedalsSettings.store.rpmProcessType = droplist.main(
				"##progress",
				language.get("PROGRESS"),
				vec2(pos.x, pos.y),
				utils.findLenghtLongestString(processCircleType, 12).x + 40,
				pedalsSettings.store.rpmProcessType,
				processCircleType,
				droplist.PosText.Start
			)
			for i = 1, 9 do
				local c1, c2, c3 = COLOR.GREEN, COLOR.GREEN, COLOR.GREEN

				if pedalsSettings.store.rpmProcessType == 1 then
					if i > 7 then
						c1, c2, c3 = COLOR.GRAY_BG, COLOR.GRAY_BG, COLOR.RED_DARK
					elseif i > 4 then
						c1, c2, c3 = COLOR.GRAY_BG, COLOR.YELLOW, COLOR.YELLOW
					end
				else
					c2, c3 = COLOR.YELLOW, COLOR.RED_DARK
					if i > 7 then
						c1, c2 = COLOR.GRAY_BG, COLOR.GRAY_BG
					elseif i > 4 then
						c1 = COLOR.GRAY_BG
					end
				end

				ui.drawCircleFilled(vec2(exampleRPpedalsSettingsX, exampleRPpedalsSettingsY - 30), 5, c1, 20)
				ui.drawCircleFilled(vec2(exampleRPpedalsSettingsX, exampleRPpedalsSettingsY - 15), 5, c2, 20)
				ui.drawCircleFilled(vec2(exampleRPpedalsSettingsX, exampleRPpedalsSettingsY), 5, c3, 20)
				exampleRPpedalsSettingsX = exampleRPpedalsSettingsX + 11
			end

			pos.y = pos.y + 30
			pedalsSettings.store.numLights = math.floor(
				slider.main(
					language.get("NUM_LIGHTS"),
					string.format("%i", pedalsSettings.store.numLights),
					vec2(pos.x, pos.y + 10),
					135,
					pedalsSettings.store.numLights,
					6,
					25,
					slider.PosText.Start
				)
			)
		elseif pedalsSettings.store.rpmType == 2 then
			pos.y = pos.y + 35

			ui.drawRectFilled(
				vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35),
				vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 25),
				COLOR.GRAY_BG,
				10
			)
			ui.drawRectFilled(
				vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 35),
				vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.45), exampleRPpedalsSettingsY - 25),
				COLOR.GREEN,
				10
			)
			ui.drawRectFilled(
				vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20),
				vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY - 10),
				COLOR.GRAY_BG,
				10
			)
			ui.drawRectFilled(
				vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 20),
				vec2(exampleRPpedalsSettingsX - 5 + (98 * 0.75), exampleRPpedalsSettingsY - 10),
				COLOR.YELLOW,
				10
			)
			ui.drawRectFilled(
				vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5),
				vec2(exampleRPpedalsSettingsX + 93, exampleRPpedalsSettingsY + 5),
				COLOR.GRAY_BG,
				10
			)
			ui.drawRectFilled(
				vec2(exampleRPpedalsSettingsX - 5, exampleRPpedalsSettingsY - 5),
				vec2(exampleRPpedalsSettingsX - 5 + 98, exampleRPpedalsSettingsY + 5),
				COLOR.RED,
				10
			)

			pedalsSettings.store.barLength = slider.main(
				language.get("PERCENTAGE"),
				string.format("%.0f", (pedalsSettings.store.barLength + 0.05) * 100) .. "%",
				vec2(pos.x, pos.y + 10),
				130,
				pedalsSettings.store.barLength,
				0.25,
				0.95,
				slider.PosText.Start
			)
		end

		pos.y = pos.y + 40
		if toggleButton.main("rpmManual", vec2(pos.x, pos.y), pedalsSettings.store.manualRpmActive, language.get("MANUAL_RPM")) then
			pedalsSettings.store.manualRpmActive = not pedalsSettings.store.manualRpmActive
		end
		if pedalsSettings.store.manualRpmActive then
			pos.y = pos.y + 20
			pedalsSettings.store.rpmMin = slider.main(
				language.get("MIN"),
				string.format("%.0f", pedalsSettings.store.rpmMin) .. " rpm",
				vec2(pos.x, pos.y + 10),
				150,
				pedalsSettings.store.rpmMin,
				CAR.rpmMinimum,
				CAR.rpmLimiter,
				slider.PosText.Start
			)

			pos.y = pos.y + 30
			pedalsSettings.store.rpmMax = slider.main(
				language.get("MAX"),
				string.format("%.0f", pedalsSettings.store.rpmMax) .. " rpm",
				vec2(pos.x, pos.y + 10),
				150,
				pedalsSettings.store.rpmMax,
				CAR.rpmMinimum,
				CAR.rpmLimiter,
				slider.PosText.Start
			)
		else
			pedalsSettings.store.rpmMin = CAR.rpmLimiter * 0.80
			pedalsSettings.store.rpmMax = CAR.rpmLimiter * 0.98
		end

		--
	end

	ui.dwriteDrawText("P2P", 12, vec2(copyPos.x - 5, copyPos.y), COLOR.WHITE)
	copyPos.y = copyPos.y + 25
	if toggleButton.main("battery", vec2(copyPos.x, copyPos.y), pedalsSettings.store.p2pActive, "") then
		pedalsSettings.store.p2pActive = not pedalsSettings.store.p2pActive
	end
	if CAR.kersPresent then
		if pedalsSettings.store.p2pActive then
			local old = pedalsSettings.store.p2pPos
			copyPos.y = copyPos.y + 30
			pedalsSettings.store.p2pPos = droplist.main(
				"##p2pPos",
				language.get("POSITION"),
				vec2(copyPos.x, copyPos.y - 3),
				utils.findLenghtLongestString(positionsCenters, 12).x + 160,
				pedalsSettings.store.p2pPos,
				positionsCenters,
				droplist.PosText.Start
			)
			if pedalsSettings.store.p2pPos ~= old then
				invertPositionCenter(old, pedalsSettings.store.p2pPos, "p2pPos")
			end

			copyPos.y = copyPos.y + 30
			pedalsSettings.store.p2pLenght = slider.main(
				language.get("LENGHT"),
				string.format("%.0f", (pedalsSettings.store.p2pLenght + 0.05) * 100) .. "%",
				vec2(copyPos.x, copyPos.y + 10),
				130,
				pedalsSettings.store.p2pLenght,
				0.25,
				0.95,
				slider.PosText.Start
			)
		end
	else
		ui.setCursor(vec2(copyPos.x + ui.measureDWriteText("P2P", 12).x + 30, copyPos.y))
		ui.dwriteTextAligned(language.get("ALERT_P2P"), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(180, 20), false, COLOR.RED)
	end
end

local function general()
	-- Layout
	local initPos = 90

	initPos = initPos + 20
	pedalsSettings.store.pedalsScale = slider.main(
		language.get("SIZE"),
		string.format("%.2f", pedalsSettings.store.pedalsScale),
		vec2(20, initPos),
		250,
		pedalsSettings.store.pedalsScale,
		0.7,
		3
	)

	initPos = initPos + 35
	ui.drawLine(vec2(10, initPos), vec2(WindowSettingsSize.x - 18, initPos), COLOR.WHITE_LINE, 2)

	-- DIREÇÃO
	initPos = initPos + 10

	ui.dwriteDrawText(language.get("STEERING"), 12, vec2(15, initPos), COLOR.WHITE)

	initPos = initPos + 25
	if toggleButton.main("gear", vec2(20, initPos), pedalsSettings.store.gearActive, language.get("GEAR")) then
		pedalsSettings.store.gearActive = not pedalsSettings.store.gearActive
	end

	initPos = initPos + 25
	if toggleButton.main("speed", vec2(20, initPos), pedalsSettings.store.speedActive, language.get("SPEED")) then
		pedalsSettings.store.speedActive = not pedalsSettings.store.speedActive
	end

	initPos = initPos + 25
	if toggleButton.main("abs", vec2(20, initPos), pedalsSettings.store.absActive, language.get("ABS")) then
		pedalsSettings.store.absActive = not pedalsSettings.store.absActive
	end
	-- Alerta do ABS
	if CAR.absModes == 0 then
		ui.setCursor(vec2(20 + ui.measureDWriteText("ABS", 12).x + 53, initPos))
		ui.dwriteTextAligned(language.get("ALERT_ABS"), 12, ui.Alignment.Center, ui.Alignment.Center, vec2(180, 20), false, COLOR.RED)
	end

	initPos = initPos + 25
	if toggleButton.main("wheel", vec2(20, initPos), pedalsSettings.store.wheelActive, language.get("WHEEL")) then
		pedalsSettings.store.wheelActive = not pedalsSettings.store.wheelActive
	end
	if pedalsSettings.store.wheelActive then
		local isRemoved
		pedalsSettings.store.wheelType, isRemoved = droplistWithRemove.main(
			"##wheelType",
			"",
			vec2(110, initPos - 3),
			utils.findLenghtLongestString(wheelsLabels, 12).x + 50,
			pedalsSettings.store.wheelType,
			wheelsLabels,
			droplistWithRemove.PosText.Start,
			{ language.get("SIMPLE"), "Iracing" }
		)

		if isRemoved then
			removeWheel(pedalsSettings.store.wheelType)
		end

		if button.main(vec2(20, initPos + 35), language.get("UPLOAD_WHEEL")) then
			selectNewWheel()
		end
	end

	initPos = initPos + 75
	ui.drawLine(vec2(10, initPos), vec2(WindowSettingsSize.x - 18, initPos), COLOR.WHITE_LINE, 2)

	-- OUTROS
	drawOthers(vec2(420, 120))

	-- RPM
	drawRPM(vec2(20, 320))

	-- Botão Reset
	initPos = initPos + 70
	if button.main(vec2(20, initPos), language.get("RESET_DEFAULT")) then
		resetToDefault()
	end
end

local function pedals()
	-- PEDAIS
	local initPos = 80
	local posXStyle = 180
	initPos = initPos + 10
	ui.dwriteDrawText(language.get("PEDALS"), 12, vec2(15, initPos), COLOR.WHITE)

	initPos = initPos + 25
	if toggleButton.main("throttle", vec2(20, initPos), pedalsSettings.store.throttleActive, language.get("THROTTLE")) then
		pedalsSettings.store.throttleActive = not pedalsSettings.store.throttleActive
	end

	local posYTelemetry = initPos
	ui.setCursor(vec2(posXStyle - 5, initPos - 25))
	ui.dwriteDrawText(language.get("PEDAL_STYLE"), 12, vec2(posXStyle - 5, initPos - 25), COLOR.WHITE)
	if toggleButton.main("percentagePedals", vec2(posXStyle, initPos), pedalsSettings.store.textBarsActive, language.get("PERCENTAGE_PEDALS")) then
		pedalsSettings.store.textBarsActive = not pedalsSettings.store.textBarsActive
	end

	initPos = initPos + 25
	if toggleButton.main("limitLines", vec2(posXStyle, initPos), pedalsSettings.store.pedalLimitsLines, language.get("LIMIT_LINES")) then
		pedalsSettings.store.pedalLimitsLines = not pedalsSettings.store.pedalLimitsLines
	end

	ui.setCursor(vec2(20, initPos))
	if toggleButton.main("brake", vec2(20, initPos), pedalsSettings.store.brakeActive, language.get("BRAKE")) then
		pedalsSettings.store.brakeActive = not pedalsSettings.store.brakeActive
	end

	initPos = initPos + 25
	if toggleButton.main("clutch", vec2(20, initPos), pedalsSettings.store.clutchActive, language.get("CLUTCH")) then
		pedalsSettings.store.clutchActive = not pedalsSettings.store.clutchActive
	end

	initPos = initPos + 25
	if toggleButton.main("handbrake", vec2(20, initPos), pedalsSettings.store.handbrakeActive, language.get("HANDBRAKE")) then
		pedalsSettings.store.handbrakeActive = not pedalsSettings.store.handbrakeActive
	end
	--
end

local function telemetry()
	local posYTelemetry = 110
	local posXTelemetry = 20
	ui.setCursor(vec2(posXTelemetry - 5, posYTelemetry))
	ui.dwriteDrawText(language.get("TELEMETRY"), 12, vec2(posXTelemetry - 5, posYTelemetry - 25), COLOR.WHITE)
	if toggleButton.main("activeTelemetry", vec2(posXTelemetry, posYTelemetry), pedalsSettings.store.telemetryActive, "") then
		pedalsSettings.store.telemetryActive = not pedalsSettings.store.telemetryActive
	end

	if pedalsSettings.store.telemetryActive then
		posYTelemetry = posYTelemetry + 35
		pedalsSettings.store.telemetryLenght = slider.main(
			language.get("LENGHT"),
			string.format("%.0f", utils.remapInterval(pedalsSettings.store.telemetryLenght, 100, 400, 0, 100)),
			vec2(posXTelemetry, posYTelemetry + 2),
			150,
			pedalsSettings.store.telemetryLenght,
			100,
			400,
			slider.PosText.Start,
			"telemetryLenght"
		)
		posYTelemetry = posYTelemetry + 35
		pedalsSettings.store.telemetryPeriod = slider.main(
			language.get("PERIOD"),
			string.format("%.0f", utils.remapInterval(pedalsSettings.store.telemetryPeriod, 250, 800, 0, 100)),
			vec2(posXTelemetry, posYTelemetry + 2),
			150,
			pedalsSettings.store.telemetryPeriod,
			250,
			800,
			slider.PosText.Start,
			"telemetryPeriod"
		)
		posYTelemetry = posYTelemetry + 35

		pedalsSettings.store.telemetryPos = droplist.main(
			"##telemetryPos",
			language.get("POSITION"),
			vec2(posXTelemetry, posYTelemetry - 4),
			utils.findLenghtLongestString(positionsTelemetry, 12).x + 40,
			pedalsSettings.store.telemetryPos,
			positionsTelemetry,
			droplist.PosText.Start
		)

		posYTelemetry = 90
		posXTelemetry = posXTelemetry + 290
		ui.drawLine(vec2(posXTelemetry - 15, posYTelemetry), vec2(posXTelemetry - 15, posYTelemetry + 170), COLOR.WHITE_LINE, 2)
		posXTelemetry = posXTelemetry + 10
		--ui.dwriteDrawText(language.get("PEDALS"), 12, vec2(posXTelemetry - 5, posYTelemetry - 20), COLOR.WHITE)
		if toggleButton.main("telemetryInverted", vec2(posXTelemetry, posYTelemetry), pedalsSettings.store.telemetryInverted, language.get("INVERT_GRAPH")) then
			pedalsSettings.store.telemetryInverted = not pedalsSettings.store.telemetryInverted
		end
		posYTelemetry = posYTelemetry + 25
		if toggleButton.main("telemetryAbs", vec2(posXTelemetry, posYTelemetry), pedalsSettings.store.telemetryAbs, language.get("SHOW_ABS_TELEMETRY")) then
			pedalsSettings.store.telemetryAbs = not pedalsSettings.store.telemetryAbs
		end

		posYTelemetry = posYTelemetry + 50
	
		ui.dwriteDrawText(language.get("PEDALS"), 12, vec2(posXTelemetry - 5, posYTelemetry - 20), COLOR.WHITE)
		if toggleButton.main("telemetryThrottle", vec2(posXTelemetry, posYTelemetry), pedalsSettings.store.telemetryThrottle, language.get("THROTTLE")) then
			pedalsSettings.store.telemetryThrottle = not pedalsSettings.store.telemetryThrottle
		end
		posYTelemetry = posYTelemetry + 25
		if toggleButton.main("telemetryBrake", vec2(posXTelemetry, posYTelemetry), pedalsSettings.store.telemetryBrake, language.get("BRAKE")) then
			pedalsSettings.store.telemetryBrake = not pedalsSettings.store.telemetryBrake
		end
		posYTelemetry = posYTelemetry + 25
		if toggleButton.main("telemetryClutch", vec2(posXTelemetry, posYTelemetry), pedalsSettings.store.telemetryClucth, language.get("CLUTCH")) then
			pedalsSettings.store.telemetryClucth = not pedalsSettings.store.telemetryClucth
		end
		posYTelemetry = posYTelemetry + 25
		if toggleButton.main("telemetryHandbrake", vec2(posXTelemetry, posYTelemetry), pedalsSettings.store.telemetryHandbrake, language.get("HANDBRAKE")) then
			pedalsSettings.store.telemetryHandbrake = not pedalsSettings.store.telemetryHandbrake
		end
	end
	--
end

function pedalsSettings.pedalsSettings()
	positionsBorders = {
		language.get("TOP_LEFT"),
		language.get("TOP_RIGHT"),
		language.get("BOTTOM_LEFT"),
		language.get("BOTTOM_RIGHT"),
	}
	positionsCenters = {
		[5] = language.get("TOP_CENTER"),
		[6] = language.get("BOTTOM_CENTER"),
	}
	positionsTelemetry = {
		language.get("LEFT"),
		language.get("RIGHT"),
	}

	positionsKeysBorders = {
		brakebiasPos = pedalsSettings.store.brakebiasPos,
		fuelPos = pedalsSettings.store.fuelPos,
		tractionControlPos = pedalsSettings.store.tractionControlPos,
		drsPos = pedalsSettings.store.drsPos,
	}
	positionsKeysCenter = {
		rpmPos = pedalsSettings.store.rpmPos,
		p2pPos = pedalsSettings.store.p2pPos,
	}

	fuelOptions = {
		"Default",
		"Fuel per Lap",
		"Est. Laps"
	}
	local id = "pedalsTab"
	tab.tabStart(id, vec2(5, 52))
	tab.item(id, language.get("GENERAL"), general)
	tab.item(id, "Pedals configuration", pedals)
	tab.item(id, language.get("TELEMETRY"), telemetry)
	tab.tabEnd(id)
end

-- Executando funções de inicialização
ac.onFolderChanged(ac.getFolder(ac.FolderID.ACAppsLua) .. "\\CHN-HUD\\assets\\pedals\\wheels\\", nil, true, function(files)
	findWheels()
	if pedalsSettings.store.wheelType > #wheelsLabels then
		pedalsSettings.store.wheelType = 1
	end
end)

return pedalsSettings
