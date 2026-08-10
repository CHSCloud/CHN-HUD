local window = require("common.window")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local deltaBarSettings = require("src.settings.tabs.deltaBarSettings")
local deltaBarData = require("src.data.deltaBar.deltaBarData")

local deltaBar = {}

---@type deltaBarData
local data

function deltaBar.windowMain()
	ac.onSessionStart(function()
		data = deltaBarData.new()
		deltaBarData.clean(data)
	end)

	--Limites e Tamanhos
	local limitBarDeltaBackground = vec2(500, 25):scale(deltaBarSettings.store.deltaBarScale)
	local limitBackgroundText = vec2(90, 40):scale(deltaBarSettings.store.deltaBarScale)

	local limitColorOnBackground = 5 * deltaBarSettings.store.deltaBarScale
	local limitBarDeltaBackground_limitBackgroundText = 2 * deltaBarSettings.store.deltaBarScale

	--Tamanho Fonte Texto Delta
	local fontTextDelta = 30 * deltaBarSettings.store.deltaBarScale

	--Bordas Arredondadas
	local cornerBarDeltaBackground = 8 * deltaBarSettings.store.deltaBarScale
	local cornerColorBarDelta = 8 * deltaBarSettings.store.deltaBarScale
	local cornerBackgroundText = 8 * deltaBarSettings.store.deltaBarScale

	--Cores Barra Delta
	local verde = { r = 102, g = 213, b = 79 }
	local branco = { r = 255, g = 255, b = 255 }
	local vermelho = { r = 226, g = 9, b = 38 }

	local barEnd = limitBarDeltaBackground.x / 2
	-- Atualiza previousLapSamples quando uma volta anterior nova existir
	if CAR.previousLapTimeMs and CAR.previousLapTimeMs > 0 and CAR.previousLapTimeMs ~= data.lastPreviousLapTimeMs then
		data.previousLapSamples = data.currentLapSamples
		data.currentLapSamples = {}
		data.lastPreviousLapTimeMs = CAR.previousLapTimeMs
	end

	-- Amostragem da volta atual por posição (splinePosition de 0..1)
	local pos = CAR.splinePosition or 0
	local idx = math.floor(pos * data.sampleResolution + 0.5)
	if CAR.lapTimeMs and data.currentLapSamples[idx] == nil then
		data.currentLapSamples[idx] = CAR.lapTimeMs
	end

	-- Sempre comparar com a volta anterior na mesma posição, se disponível
	local rawDelta
	if data.previousLapSamples[idx] and data.previousLapSamples ~= {} then
		rawDelta = (CAR.lapTimeMs - data.previousLapSamples[idx]) / 1000
	else
		rawDelta = CAR.performanceMeter or 0
	end
	local rawDeltaMeter = CAR.performanceMeterSpeedDifferenceMs or 0

	-- Aplicar suavização exponencial
	data.smoothedDelta = data.smoothingAlpha * rawDelta + (1 - data.smoothingAlpha) * data.smoothedDelta
	data.smoothedDeltaMeter = data.smoothingAlpha * rawDeltaMeter + (1 - data.smoothingAlpha) * data.smoothedDeltaMeter

	local delta = data.smoothedDelta
	local deltaMeter = data.smoothedDeltaMeter

	--Background Barra Delta
	ui.drawRectFilled(vec2(0, 0), limitBarDeltaBackground, WindowsColor, cornerBarDeltaBackground)
	--Background Texto Delta
	ui.drawRectFilled(
		vec2(barEnd - limitBackgroundText.x / 2, limitBarDeltaBackground_limitBackgroundText + limitBarDeltaBackground.y),
		vec2(barEnd + limitBackgroundText.x / 2, limitBarDeltaBackground_limitBackgroundText + limitBackgroundText.y + limitBarDeltaBackground.y),
		WindowsColor,
		cornerBackgroundText
	)

	--Degradê Color da Barra
	local barColorPercent = math.clamp(deltaMeter / 2, -1, 1)
	local barColor = rgbm.from0255(
		branco.r + barColorPercent * (branco.r - vermelho.r),
		branco.g + barColorPercent * (branco.g - vermelho.g),
		branco.b + barColorPercent * (branco.b - vermelho.b)
	)
	if barColorPercent > 0 then
		barColor = rgbm.from0255(
			branco.r - barColorPercent * (branco.r - verde.r),
			branco.g - barColorPercent * (branco.g - verde.g),
			branco.b - barColorPercent * (branco.b - verde.b)
		)
	end

	local barEndPercent = math.clamp(delta / 2, -1, 1)
	local barCalculetorEnd = barEnd - barEndPercent * barEnd
	--Barra Arredondado no Lado Esquerdo
	if barCalculetorEnd < barEnd then
		ui.drawRectFilled(
			vec2(barCalculetorEnd + limitColorOnBackground, limitColorOnBackground),
			vec2(barEnd + limitColorOnBackground, limitBarDeltaBackground.y - limitColorOnBackground),
			barColor,
			cornerColorBarDelta,
			ui.CornerFlags.Left
		)
	end

	--Barra Arredondado no Lado Direito
	if barCalculetorEnd > barEnd then
		ui.drawRectFilled(
			vec2(barEnd - limitColorOnBackground, limitColorOnBackground),
			vec2(barCalculetorEnd - limitColorOnBackground, limitBarDeltaBackground.y - limitColorOnBackground),
			barColor,
			cornerColorBarDelta,
			ui.CornerFlags.Right
		)
	end

	-- Delta Texto
	local deltaText = string.format("%.2f", delta)
	if math.abs(delta) > 1000 then
		deltaText = "inf"
	elseif math.abs(delta) > 100 then
		deltaText = string.format("%.0f", delta)
	elseif math.abs(delta) > 10 then
		deltaText = string.format("%.1f", delta)
	end

	-- +
	if delta > 0 then
		deltaText = "+" .. deltaText
	end

	--Degradê Color do Texto
	local textEndPercent = math.clamp(delta / 0.02, -1, 1)
	local textColor = rgbm.from0255(
		branco.r + textEndPercent * (branco.r - verde.r),
		branco.g + textEndPercent * (branco.g - verde.g),
		branco.b + textEndPercent * (branco.b - verde.b)
	)
	if textEndPercent >= 0 then
		textColor = rgbm.from0255(
			branco.r - textEndPercent * (branco.r - vermelho.r),
			branco.g - textEndPercent * (branco.g - vermelho.g),
			branco.b - textEndPercent * (branco.b - vermelho.b)
		)
	end

	--Chamando Texto Delta
	ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
	ui.setCursor(vec2(barEnd - limitBackgroundText.x / 2, limitBarDeltaBackground_limitBackgroundText + limitBarDeltaBackground.y))
	ui.dwriteTextAligned(deltaText, fontTextDelta, ui.Alignment.Center, ui.Alignment.Center, limitBackgroundText, false, textColor)
	ui.popDWriteFont()

	window.resize(vec2(500, 70):scale(deltaBarSettings.store.deltaBarScale), "Delta Bar")
	pinCheckBox.main(
		deltaBarSettings.store.deltaBarScale,
		"Delta Bar",
		window.getWindow("Delta Bar"):pinned(),
		vec2(500, 70):scale(deltaBarSettings.store.deltaBarScale)
	)
end

return deltaBar
