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
    data.currentWindowSize = vec2(300, 300):scale(tyresSettings.store.tyresScale)

    ui.drawRectFilled(vec2(0,0), data.currentWindowSize, WindowsColor, 20 * tyresSettings.store.tyresScale)
    
    ui.setCursor(vec2(15,20):scale(tyresSettings.store.tyresScale))
    ui.dwriteTextAligned(tostring(ac.getTyresName(CAR.index)), 15 * tyresSettings.store.tyresScale, ui.Alignment.Start, ui.Alignment.Center, vec2(35,20):scale(tyresSettings.store.tyresScale))

    ui.setCursor(vec2(data.currentWindowSize.x - 210 * tyresSettings.store.tyresScale, 20 * tyresSettings.store.tyresScale))
    ui.dwriteTextAligned(language.get("IDEAL") .. ": " ..  tostring(data.optThermal.min) .. "ºC ~ " .. tostring(data.optThermal.max) .. "ºC", 13 * tyresSettings.store.tyresScale, ui.Alignment.End, ui.Alignment.Center, vec2(200,20):scale(tyresSettings.store.tyresScale), false, COLOR.WHITE)

    wheels.drawWheelInfo(data, vec2(30, 90):scale(tyresSettings.store.tyresScale), 0)

    wheels.drawWheelInfo(data, vec2(175, 90):scale(tyresSettings.store.tyresScale), 1)

    wheels.drawWheelInfo(data, vec2(30, 200):scale(tyresSettings.store.tyresScale), 2)

    wheels.drawWheelInfo(data, vec2(175, 200):scale(tyresSettings.store.tyresScale), 3)

    window.resize(data.currentWindowSize, "Tyres")
    pinCheckBox.main(tyresSettings.store.tyresScale, "Tyres", window.getWindow("Tyres"):pinned(), data.currentWindowSize)
end

return tyres