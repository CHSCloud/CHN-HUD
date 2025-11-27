require("src.settings.settings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local sessionflags = {}

function sessionflags.windowMain()
    --Bandeira branca config
    if SettingsActive then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/whiteFlag.png", vec2(110, 110))
        ui.setCursor(vec2(10, 77))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), true, COLOR.WHITE)
        ui.setCursor(vec2(10, 120))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), true, COLOR.WHITE)
    --Bandeira Azul
    elseif SIM.raceFlagType == ac.FlagType.FasterCar then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/blueFlag.png", vec2(110, 110))
        ui.setCursor(vec2(10, 85))
        ui.dwriteTextAligned(language.get("FASTEST_CAR_APPROACHING"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), true, COLOR.WHITE)
        ui.setCursor(vec2(10, 128))
        ui.dwriteTextAligned(language.get("BLUE_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), true, COLOR.WHITE)
    --Bandeira Amarela
    elseif SIM.raceFlagType == ac.FlagType.Caution then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/yellowFlag.png", vec2(110, 110))
        ui.setCursor(vec2(10, 77))
        ui.dwriteTextAligned(language.get("CAUTION"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 120))
        ui.dwriteTextAligned(language.get("YELLOW_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), COLOR.WHITE)
    --Bandeira branca
    elseif SIM.raceFlagType == ac.FlagType.OneLapLeft then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/whiteFlag.png", vec2(110, 110))
        ui.setCursor(vec2(10, 77))
        ui.dwriteTextAligned(language.get("FINAL_LAP"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 120))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), COLOR.WHITE)
    --Bandeira quadriculada
    elseif SIM.raceFlagType == ac.FlagType.Finished then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/finish.png", vec2(110, 110))
        ui.setCursor(vec2(7, 77))
        ui.dwriteTextAligned(language.get("END_OF_SESSION"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), COLOR.WHITE)
        ui.setCursor(vec2(7, 120))
        ui.dwriteTextAligned(language.get("CHECKERED_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), COLOR.WHITE)
    --Bandeira preta
    elseif SIM.raceFlagType == ac.FlagType.Stop then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/blackFlag.png", vec2(110, 110))
        ui.setCursor(vec2(10, 77))
        ui.dwriteTextAligned(language.get("WARNING_ISSUED"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 120))
        ui.dwriteTextAligned(language.get("BLACK_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), COLOR.WHITE)
    --Bandeira preta e branca
    elseif SIM.raceFlagType == ac.FlagType.ReturnToPits then
        ui.drawRectFilled(vec2(0, 0), vec2(130, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/penalty.png", vec2(110, 110))
        ui.setCursor(vec2(5, 77))
        ui.dwriteTextAligned(language.get("PENALTY"), 13, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), COLOR.WHITE)
        ui.setCursor(vec2(5, 120))
        ui.dwriteTextAligned(language.get("PENALTY_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), COLOR.WHITE)
    -- Bandeira verde
    elseif SIM.raceFlagType == ac.FlagType.Start and SIM.currentSessionTime < 20000 then
        ui.drawRectFilled(vec2(0, 0), vec2(135, 150), WindowsColor, 10)
        ui.setCursor(vec2(10,-5))
        ui.image("assets/flags/greenFlag.png", vec2(110, 110))
        ui.setCursor(vec2(10, 77))
        ui.dwriteTextAligned(language.get("GO_GO_GO"), 14, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50), COLOR.WHITE)
        ui.setCursor(vec2(10, 120))
        ui.dwriteTextAligned(language.get("GREEN_FLAG"), 10, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25), COLOR.WHITE)
    end
end

return sessionflags