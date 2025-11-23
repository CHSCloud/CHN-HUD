require("src.settings.settings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local sessionflags = {}

function sessionflags.windowMain()

    if SIM.raceFlagType == ac.FlagType.FasterCar then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 120), WindowsColor, 10 * WindowPitScale)
        ui.setCursor(vec2(0,15))
        ui.image("assets/blueFlag.png", vec2(160, 90))
    end
    if SIM.raceFlagType == ac.FlagType.Caution then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 120), WindowsColor, 10 * WindowPitScale)
        ui.setCursor(vec2(0,15))
        ui.image("assets/yellowFlag.png", vec2(160, 90))
    end
    if SIM.raceFlagType == ac.FlagType.Finished then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 120), WindowsColor, 10 * WindowPitScale)
        ui.setCursor(vec2(0,15))
        ui.image("assets/finish.png", vec2(160, 90))
    end
    if SIM.raceFlagType == ac.FlagType.OneLapLeft then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 120), WindowsColor, 10 * WindowPitScale)
        ui.setCursor(vec2(0,15))
        ui.image("assets/whiteFlag.png", vec2(160, 90))
    end
    if SIM.raceFlagType == ac.FlagType.Stop then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 120), WindowsColor, 10 * WindowPitScale)
        ui.setCursor(vec2(0,15))
        ui.image("assets/blackFlag.png", vec2(160, 90))
    end
    if SIM.raceFlagType == ac.FlagType.ReturnToPits then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 120), WindowsColor, 10 * WindowPitScale)
        ui.setCursor(vec2(0,15))
        ui.image("assets/penalty.png", vec2(160, 90))
    end

end

return sessionflags