local tyresSettings = require("src.settings.tabs.tyresSettings")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local window = require("common.window")
local language = require("language.language")

local tyresData = require("src.data.tyres.tyresData")

local wheels = require("src.hud.tyres.components.wheels")

local tyres = {}

local data = tyresData.new()
tyresData.loadTyresData(data)

function tyres.windowMain()
    data.wheels = CAR.wheels
    ui.drawRectFilled(vec2(0,0), data.currentWindowSize, WindowsColor, 20 * tyresSettings.store.tyresScale)
    data.currentWindowSize = vec2(300, 250):scale(tyresSettings.store.tyresScale)
    data.wheelsPos = vec2(0, 35):scale(tyresSettings.store.tyresScale)

    if tyresSettings.store.tyresNameActive then
        data.currentWindowSize.y = 285 * tyresSettings.store.tyresScale
        data.wheelsPos = vec2(0, 70):scale(tyresSettings.store.tyresScale)
        ui.setCursor(vec2(15, 15):scale(tyresSettings.store.tyresScale))
        ui.dwriteTextAligned(tostring(ac.getTyresName(CAR.index)), 15 * tyresSettings.store.tyresScale, ui.Alignment.Start, ui.Alignment.Center, vec2(35,20):scale(tyresSettings.store.tyresScale))
    end

    if tyresSettings.store.idealTempActive then
        data.currentWindowSize.y = 285 * tyresSettings.store.tyresScale
        data.wheelsPos = vec2(0, 70):scale(tyresSettings.store.tyresScale)
        local tempString
        if SelectedTemperature == 1 then
            tempString = string.format("%s: %dºC ~ %dºC", 
                language.get("IDEAL"), 
                tostring(data.optThermal.min), 
                tostring(data.optThermal.max)
            )
        else
            tempString = string.format("%s: %dºF ~ %dºF", 
                language.get("IDEAL"), 
                tostring(data.optThermal.min * 9/5 + 32), 
                tostring(data.optThermal.max * 9/5 + 32)
            )
        end
        ui.setCursor(vec2(data.currentWindowSize.x - 210 * tyresSettings.store.tyresScale,15 * tyresSettings.store.tyresScale))
        ui.dwriteTextAligned(tempString, 13 * tyresSettings.store.tyresScale, ui.Alignment.End, ui.Alignment.Center, vec2(200,20):scale(tyresSettings.store.tyresScale), false, COLOR.WHITE)
    end

    wheels.drawWheelInfo(data, vec2(30 * tyresSettings.store.tyresScale, data.wheelsPos.y), 0)

    wheels.drawWheelInfo(data, vec2(175 * tyresSettings.store.tyresScale, data.wheelsPos.y), 1)

    wheels.drawWheelInfo(data, vec2(30 * tyresSettings.store.tyresScale, data.wheelsPos.y + 130 * tyresSettings.store.tyresScale), 2)

    wheels.drawWheelInfo(data, vec2(175 * tyresSettings.store.tyresScale, data.wheelsPos.y + 130 * tyresSettings.store.tyresScale), 3)

    window.resize(data.currentWindowSize, "Tyres")
    pinCheckBox.main(tyresSettings.store.tyresScale, "Tyres", window.getWindow("Tyres"):pinned(), data.currentWindowSize)
end

return tyres