require("src.settings.settings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local sessionflags = {}



function sessionflags.windowMain()
    --Bandeira branca config
    if SettingsActive then
        ui.drawRectFilled(vec2(0, 0), vec2(110, 150), WindowsColor, 10)
        ui.setCursor(vec2(5,0))
        ui.image("assets/flags/whiteFlag.png", vec2(100, 100))
        ui.setCursor(vec2(10, 80))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(105, 50), true, COLOR.WHITE)
        ui.setCursor(vec2(10, 125))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(105, 25), true, COLOR.WHITE)
    --Bandeira Azul
    elseif SIM.raceFlagType == ac.FlagType.FasterCar then
        ui.drawRectFilled(vec2(0, 0), vec2(110, 150), WindowsColor, 10)
        ui.setCursor(vec2(5,0))
        ui.image("assets/flags/blueFlag.png", vec2(100, 100))
        ui.setCursor(vec2(10, 80))
        ui.dwriteTextAligned(language.get("FASTER_CAR"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(105, 50), true, COLOR.WHITE)
        ui.setCursor(vec2(10, 125))
        ui.dwriteTextAligned(language.get("BLUE_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(105, 25), true, COLOR.WHITE)
    --Bandeira Amarela
    elseif SIM.raceFlagType == ac.FlagType.Caution then
        ui.drawRectFilled(vec2(0, 0), vec2(110, 150), WindowsColor, 10)
        ui.setCursor(vec2(5,0))
        ui.image("assets/flags/yellowFlag.png", vec2(100, 100))
        ui.setCursor(vec2(10, 80))
        ui.dwriteTextAligned(language.get("CAUTION"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(105, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 125))
        ui.dwriteTextAligned(language.get("YELLOW_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(105, 25), COLOR.WHITE)
    --Bandeira branca
    elseif SIM.raceFlagType == ac.FlagType.OneLapLeft then
        ui.drawRectFilled(vec2(0, 0), vec2(110, 150), WindowsColor, 10)
        ui.setCursor(vec2(5,0))
        ui.image("assets/flags/whiteFlag.png", vec2(100, 100))
        ui.setCursor(vec2(10, 80))
        ui.dwriteTextAligned(language.get("ONE_LAP_LEFT"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(105, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 125))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(105, 25), COLOR.WHITE)
    --Bandeira quadriculada
    elseif SIM.raceFlagType == ac.FlagType.Finished then
        ui.drawRectFilled(vec2(0, 0), vec2(110, 150), WindowsColor, 10)
        ui.setCursor(vec2(5,0))
        ui.image("assets/flags/finish.png", vec2(100, 100))
        ui.setCursor(vec2(10, 75))
        ui.dwriteTextAligned(language.get("FINISHED"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(105, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 122))
        ui.dwriteTextAligned(language.get("CHECKERED_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(105, 25), COLOR.WHITE)
    --Bandeira preta
    elseif SIM.raceFlagType == ac.FlagType.Stop then
        ui.drawRectFilled(vec2(0, 0), vec2(110, 150), WindowsColor, 10)
        ui.setCursor(vec2(5,0))
        ui.image("assets/flags/blackFlag.png", vec2(100, 100))
        ui.setCursor(vec2(10, 80))
        ui.dwriteTextAligned(language.get("STOP"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(105, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 125))
        ui.dwriteTextAligned(language.get("BLACK_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(105, 25), COLOR.WHITE)
    --Bandeira preta e branca
    elseif SIM.raceFlagType == ac.FlagType.ReturnToPits then
        ui.drawRectFilled(vec2(0, 0), vec2(110, 150), WindowsColor, 10)
        ui.setCursor(vec2(5,0))
        ui.image("assets/flags/penalty.png", vec2(100, 100))
        ui.setCursor(vec2(10, 79))
        ui.dwriteTextAligned(language.get("RETURN_TO_PITS"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(105, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 125))
        ui.dwriteTextAligned(language.get("PENALTY_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(105, 25), COLOR.WHITE)
    end

end

return sessionflags