local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local language = require("lang.language")

local components = {}

---@param data pitLaneData
function components.title(data)
    ui.setCursor(data.posLimit:scale(pitLaneSettings.store.pitLaneScale))
    ui.dwriteTextAligned(language.get("LIMIT"), data.fontLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(pitLaneSettings.store.pitLaneScale), false, COLOR.BLACK)
    ui.setCursor(data.posYou:scale(pitLaneSettings.store.pitLaneScale))
    ui.dwriteTextAligned(language.get("YOU"), data.fontYou, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(pitLaneSettings.store.pitLaneScale), false, COLOR.YELLOW_DARK)
end

---@param data pitLaneData
function components.slowDown(data)
    ui.drawRectFilled(vec2(10, 75):scale(pitLaneSettings.store.pitLaneScale), vec2(data.currentWindowWidth - 10 * pitLaneSettings.store.pitLaneScale, data.currentWindowHeight), rgbm.from0255(50, 0, 0, 0.85), 10 * pitLaneSettings.store.pitLaneScale)
    ui.setCursor(vec2(0,75):scale(pitLaneSettings.store.pitLaneScale))
    ui.dwriteTextAligned(language.get("SLOW_DOWN"), data.fontSlowDown, ui.Alignment.Center, ui.Alignment.Center, vec2(data.currentWindowWidth, 25 * pitLaneSettings.store.pitLaneScale), false, rgbm.from0255(230, 0, 0, 1))
end

---@param data pitLaneData
function components.speed(data)
    ui.setCursor(data.posSpeedYou:scale(pitLaneSettings.store.pitLaneScale))
    ui.dwriteTextAligned(data.kmhString, data.fontSpeedYou, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40):scale(pitLaneSettings.store.pitLaneScale), false, data.speedrgb)

    ui.setCursor(data.posSpeedLimit:scale(pitLaneSettings.store.pitLaneScale))
    ui.dwriteTextAligned(data.limitPitString, data.fontSpeedLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(69, 40):scale(pitLaneSettings.store.pitLaneScale), false, COLOR.BLACK)
end

return components