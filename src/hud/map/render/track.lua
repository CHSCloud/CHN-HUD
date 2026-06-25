local config = require("common.config")
local track = {}

-- Desenha a pista
--- @param data mapData
--- @param thickness number -- Espessura do traço
--- @param color rgbm -- Cor do traço
function track.drawTrack(data, thickness, color)
    for _, point in ipairs(data.mapPoints) do
        local offsetX = (point.x - data.trackCenterX) * data.canvasScale
        local offsetY = (point.y - data.trackCenterY) * data.canvasScale

        local rotatePos = config.rotateVec(vec2(offsetX, offsetY), data.angle)

        local finalX = data.canvasCenter.x + rotatePos.x
        local finalY = data.canvasCenter.y + rotatePos.y
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    ui.pathStroke(color, data.isTrackConnected, thickness)
end

return track