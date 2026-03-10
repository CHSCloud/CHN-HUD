local sessionFlagsSettings = require("src.settings.tabs.sessionFlagsSettings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local sessionFlags = {}

local add = -1
local lenght = 110
local currentTime = 0
function sessionFlags.windowMain()
    if currentTime > SIM.currentSessionTime then
        currentTime = 0
    end
    local currentWindowSize = vec2(140, 155) * sessionFlagsSettings.store.sessionFlagsScale
    local fontSize1 = 13 * sessionFlagsSettings.store.sessionFlagsScale
    local fontSize2 = 10 * sessionFlagsSettings.store.sessionFlagsScale
    local rounding = 10 * sessionFlagsSettings.store.sessionFlagsScale
    local posFlag = vec2(15, 0) * sessionFlagsSettings.store.sessionFlagsScale
    if (SIM.currentSessionTime) % 2 >= 1 and (currentTime - SIM.currentSessionTime) < -2000 then 
        lenght = lenght + add
        if lenght == 100 then
            add = 0.5
        elseif lenght == 110 then
            currentTime = SIM.currentSessionTime
            add = -0.5
        end
    end

    local flagLenght = vec2(lenght, lenght) * sessionFlagsSettings.store.sessionFlagsScale
    --Bandeira branca config
    if SettingsActive then
        ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/whiteFlag.png", flagLenght)
        ui.setCursor(vec2(10, 80):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale), true, COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(10, 125):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale), true, COLOR.WHITE)

    --Bandeira Azul
    elseif SIM.raceFlagType == ac.FlagType.FasterCar then
       ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/blueFlag.png", flagLenght)
        ui.setCursor(vec2(10, 88):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("FASTEST_CAR_APPROACHING"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale), true, COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(10, 132):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("BLUE_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale), true , COLOR.WHITE)
    
    --Bandeira Amarela
    elseif SIM.raceFlagType == ac.FlagType.Caution then
        ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/yellowFlag.png", flagLenght)
        ui.setCursor(vec2(10, 80):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("CAUTION"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(10, 125):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("YELLOW_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)

    --Bandeira branca
    elseif SIM.raceFlagType == ac.FlagType.OneLapLeft then
        ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/whiteFlag.png", flagLenght)
        ui.setCursor(vec2(10, 80):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("FINAL_LAP"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(10, 125):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("WHITE_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)

    --Bandeira quadriculada
    elseif SIM.raceFlagType == ac.FlagType.Finished then
       ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/finish.png", flagLenght)
        ui.setCursor(vec2(10, 80):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("END_OF_SESSION"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(10, 125):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("CHECKERED_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)

    --Bandeira preta
    elseif SIM.raceFlagType == ac.FlagType.Stop then
        ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/blackFlag.png", flagLenght)
        ui.setCursor(vec2(10, 80):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("WARNING_ISSUED"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(10, 125):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("BLACK_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)

    --Bandeira preta e branca
    elseif SIM.raceFlagType == ac.FlagType.ReturnToPits then
        ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/penalty.png", flagLenght)
        ui.setCursor(vec2(5, 80):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("PENALTY"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(5, 125):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("PENALTY_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)

    -- Bandeira verde
    elseif SIM.raceFlagType == ac.FlagType.Start and SIM.timeToSessionStart > -20000 then
        ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, rounding)
        ui.setCursor(posFlag)
        ui.image("assets/flags/greenFlag.png", flagLenght)
        ui.setCursor(vec2(10, 80):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("GO_GO_GO"), fontSize1, ui.Alignment.Start, ui.Alignment.End, vec2(130, 50):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)
        ui.pushDWriteFont("fonts/Montserrat-SemiBold.ttf")
        ui.setCursor(vec2(10, 125):scale(sessionFlagsSettings.store.sessionFlagsScale))
        ui.dwriteTextAligned(language.get("GREEN_FLAG"), fontSize2, ui.Alignment.Start, ui.Alignment.Center, vec2(130, 25):scale(sessionFlagsSettings.store.sessionFlagsScale),true , COLOR.WHITE)
    end
    config.resize(currentWindowSize, "Session Flags")
    pinCheckBox.main(1, "Session Flags", config.getWindow("Session Flags"):pinned(), currentWindowSize)
end

return sessionFlags
