local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local types = {}

---@param data pitLaneData
function types.default(data)
    data.currentWindowWidth = 150 * pitLaneSettings.store.pitLaneScale
    data.posLimit = vec2(-10,5)
    data.fontLimit = 16 * pitLaneSettings.store.pitLaneScale
    data.posSpeedLimit = vec2(6, 22)
    data.fontSpeedLimit = 30 * pitLaneSettings.store.pitLaneScale
    data.posYou = vec2(63,5)
    data.posSpeedYou = vec2(80, 22)
    data.fontSpeedYou = 30 * pitLaneSettings.store.pitLaneScale 
    data.fontSlowDown = 15 * pitLaneSettings.store.pitLaneScale
    
    ui.drawRectFilled(vec2(0, 0), vec2(data.currentWindowWidth, 70 * pitLaneSettings.store.pitLaneScale), WindowsColor, 10 * pitLaneSettings.store.pitLaneScale)
    ui.drawRectFilled(vec2(5, 5):scale(pitLaneSettings.store.pitLaneScale), vec2(75, 65):scale(pitLaneSettings.store.pitLaneScale), COLOR.WHITE, 5 * pitLaneSettings.store.pitLaneScale)
    ui.drawRect(vec2(7, 7):scale(pitLaneSettings.store.pitLaneScale), vec2(73, 63):scale(pitLaneSettings.store.pitLaneScale), COLOR.BLACK, 4 * pitLaneSettings.store.pitLaneScale, ui.CornerFlags.All, 1.5 * pitLaneSettings.store.pitLaneScale)
end

---@param data pitLaneData
function types.alert(data)
    data.currentWindowWidth = 135 * pitLaneSettings.store.pitLaneScale
    data.posLimit = vec2(-15,10)
    data.fontLimit = 13 * pitLaneSettings.store.pitLaneScale
    data.posSpeedLimit = vec2(0,22)
    data.fontSpeedLimit = 23 * pitLaneSettings.store.pitLaneScale
    data.posYou = vec2(45,5)
    data.posSpeedYou = vec2(62, 22)
    data.fontSpeedYou = 25 * pitLaneSettings.store.pitLaneScale
    data.fontSlowDown = 12 * pitLaneSettings.store.pitLaneScale

    ui.drawRectFilled(vec2(0, 0):scale(pitLaneSettings.store.pitLaneScale), vec2(135, 70):scale(pitLaneSettings.store.pitLaneScale), WindowsColor, 35 * pitLaneSettings.store.pitLaneScale, ui.CornerFlags.All)
    ui.drawCircleFilled(vec2(35,35):scale(pitLaneSettings.store.pitLaneScale), 34 * pitLaneSettings.store.pitLaneScale, COLOR.WHITE, 40 * pitLaneSettings.store.pitLaneScale)
    ui.drawCircle(vec2(35,35):scale(pitLaneSettings.store.pitLaneScale), 31 * pitLaneSettings.store.pitLaneScale, COLOR.RED, 40 * pitLaneSettings.store.pitLaneScale, 5 * pitLaneSettings.store.pitLaneScale)
end

return types