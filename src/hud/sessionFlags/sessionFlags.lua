local sessionFlagsSettings = require("src.settings.tabs.sessionFlagsSettings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local window = require("common.window")
local sessionFlagsData = require("src.data.sessionFlags.sessionFlagsData")

local flags = require("src.hud.sessionFlags.render.flags")

local sessionFlags = {}

---@type sessionFlagsData
local data = sessionFlagsData.new()

function sessionFlags.windowMain()
    if data.currentTime > SIM.currentSessionTime then
        data.currentTime = 0
    end
    data.currentWindowSize = vec2(140, 155) * sessionFlagsSettings.store.sessionFlagsScale
    data.fontSize1 = 13 * sessionFlagsSettings.store.sessionFlagsScale
    data.fontSize2 = 10 * sessionFlagsSettings.store.sessionFlagsScale
    data.rounding = 10 * sessionFlagsSettings.store.sessionFlagsScale
    data.posFlag = vec2(15, 0) * sessionFlagsSettings.store.sessionFlagsScale
    if (SIM.currentSessionTime) % 2 >= 1 and (data.currentTime - SIM.currentSessionTime) < -2000 then 
        data.lenght = data.lenght + data.add
        if data.lenght == 100 then
            data.add = 0.5
        elseif data.lenght == 110 then
            data.currentTime = SIM.currentSessionTime
            data.add = -0.5
        end
    end

    data.flagLenght = vec2(data.lenght, data.lenght) * sessionFlagsSettings.store.sessionFlagsScale
    --Bandeira branca window
    if SettingsActive then
        flags.drawFlag(data, "assets/flags/whiteFlag.png", language.get("WHITE_FLAG"), language.get("WHITE_FLAG"))

    --Bandeira Azul
    elseif SIM.raceFlagType == ac.FlagType.FasterCar then
        flags.drawFlag(data, "assets/flags/blueFlag.png", language.get("FASTEST_CAR_APPROACHING"), language.get("BLUE_FLAG"), 88, 132)
    
    --Bandeira Amarela
    elseif SIM.raceFlagType == ac.FlagType.Caution then
        flags.drawFlag(data, "assets/flags/yellowFlag.png", language.get("CAUTION"), language.get("YELLOW_FLAG"))

    --Bandeira branca
    elseif SIM.raceFlagType == ac.FlagType.OneLapLeft then
        flags.drawFlag(data, "assets/flags/whiteFlag.png", language.get("FINAL_LAP"), language.get("WHITE_FLAG"))

    --Bandeira quadriculada
    elseif SIM.raceFlagType == ac.FlagType.Finished then
        flags.drawFlag(data, "assets/flags/finish.png", language.get("END_OF_SESSION"), language.get("CHECKERED_FLAG"))

    --Bandeira preta
    elseif SIM.raceFlagType == ac.FlagType.Stop then
        flags.drawFlag(data, "assets/flags/blackFlag.png", language.get("WARNING_ISSUED"), language.get("BLACK_FLAG"))

    --Bandeira preta e branca
    elseif SIM.raceFlagType == ac.FlagType.ReturnToPits then
        flags.drawFlag(data, "assets/flags/penalty.png", language.get("PENALTY"), language.get("PENALTY_FLAG"), 80, 125, 5)

    -- Bandeira verde
    elseif SIM.raceFlagType == ac.FlagType.Start and SIM.timeToSessionStart > -20000 then
        flags.drawFlag(data, "assets/flags/greenFlag.png", language.get("GO_GO_GO"), language.get("GREEN_FLAG"))
    end

    window.resize(data.currentWindowSize, "Session Flags")
    pinCheckBox.main(1, "Session Flags", window.getWindow("Session Flags"):pinned(), data.currentWindowSize)
end

return sessionFlags
