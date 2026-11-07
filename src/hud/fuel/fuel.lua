local window = require("common.window")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local language = require("language.language")
local fuelSettings = require("src.settings.tabs.fuelSettings")
local fuelData = require("src.data.fuel.fuelData")
local rect = require("src.ui.background.rect")

local fuel = {}

---@type fuelData
local data

function fuel.init()
	data = fuelData.new()
end

function fuel.onSessionStart()
	data = fuelData.new()
end

---@Credits This function was inspired by the "on_game_close" function from CMRT Complete HUD
function fuel.onGameClone()
    local fuelPerLap = ac.getCar(0).fuelPerLap
    if fuelPerLap > 0 then
        local fuelPerLapStored = ac.storage(ac.getTrackName() .. ac.getCarID(0) .. "fuelPerLap", nil)
        ---@diagnostic disable-next-line: undefined-field
        fuelPerLapStored:set(fuelPerLap)
    end
end

---@param pos vec2
---@param input string
---@param output string
local function infoFuel(pos, input, output)
    rect.drawRectRounded(
        pos, 
        vec2(pos.x + ui.measureDWriteText(input, data.fontContent).x + 10 * fuelSettings.store.fuelScale, pos.y + 20 * fuelSettings.store.fuelScale), 
        COLOR.WHITE, 
        5 * fuelSettings.store.fuelScale, 
        20
    )
    
    ui.setCursor(pos + vec2(5):scale(fuelSettings.store.fuelScale))
    ui.dwriteTextAligned(
        input,
        data.fontContent,
        ui.Alignment.Start,
        ui.Alignment.Center,
        vec2(data.windowWidth, 20 * fuelSettings.store.fuelScale),
        false,
        COLOR.BLACK
    )

    ui.setCursor(pos + vec2(ui.measureDWriteText(input, data.fontContent).x + 15 * fuelSettings.store.fuelScale))
    ui.dwriteTextAligned(
        output,
        data.fontContent,
        ui.Alignment.Start,
        ui.Alignment.Center,
        vec2(data.windowWidth, 20 * fuelSettings.store.fuelScale),
        false,
        COLOR.WHITE
    )
    
end

function fuel.windowMain()
    data.windowWidth = 130 * fuelSettings.store.fuelScale
    data.windowHeight = 105 * fuelSettings.store.fuelScale
    data.fontTitle = 14 * fuelSettings.store.fuelScale
    data.fontContent = 12 * fuelSettings.store.fuelScale
    rect.drawRectRounded(vec2(0, 0), vec2(data.windowWidth, data.windowHeight), WindowsColor, 8 * fuelSettings.store.fuelScale, 20)

    ui.setCursor(vec2((data.windowWidth - ui.measureDWriteText(language.get("FUEL"), data.fontTitle).x) / 2 - 10 * fuelSettings.store.fuelScale, 2 * fuelSettings.store.fuelScale))
    ui.image("assets/pedals/Fuel.png", vec2(18, 18):scale(fuelSettings.store.fuelScale), COLOR.WHITE, ui.ImageFit.Fit)
    ui.setCursor(vec2(11, 1):scale(fuelSettings.store.fuelScale))
    ui.dwriteTextAligned(
        language.get("FUEL"),
        data.fontTitle,
        ui.Alignment.Center,
        ui.Alignment.Center,
        vec2(data.windowWidth, 20 * fuelSettings.store.fuelScale),
        false,
        COLOR.WHITE
    )
    
    ui.drawLine(vec2(0, 25 * fuelSettings.store.fuelScale), vec2(data.windowWidth, 25 * fuelSettings.store.fuelScale), COLOR.WHITE, 2 * fuelSettings.store.fuelScale)

    infoFuel(vec2(10 * fuelSettings.store.fuelScale, 30 * fuelSettings.store.fuelScale), "Fuel", string.format("%.1fL", math.max(0, CAR.fuel)))

    if CAR.fuelPerLap == 0 then
        if data.fuelPerLap == 0 then
            infoFuel(vec2(10 * fuelSettings.store.fuelScale, 55 * fuelSettings.store.fuelScale), "Fuel/Lap", "N/A")
            infoFuel(vec2(10 * fuelSettings.store.fuelScale, 80 * fuelSettings.store.fuelScale), "Laps Left", "N/A")
        else
            infoFuel(vec2(10 * fuelSettings.store.fuelScale, 55 * fuelSettings.store.fuelScale), "Fuel/Lap", string.format("%.1fL", data.fuelPerLap))
            infoFuel(vec2(10 * fuelSettings.store.fuelScale, 80 * fuelSettings.store.fuelScale), "Laps Left", string.format("%.1f", CAR.fuel / data.fuelPerLap))
        end
    else
        infoFuel(vec2(10 * fuelSettings.store.fuelScale, 55 * fuelSettings.store.fuelScale), "Fuel/Lap", string.format("%.1fL", CAR.fuelPerLap))
        infoFuel(vec2(10 * fuelSettings.store.fuelScale, 80 * fuelSettings.store.fuelScale), "Laps Left", string.format("%.1f", CAR.fuel / CAR.fuelPerLap))
    end
end

return fuel
