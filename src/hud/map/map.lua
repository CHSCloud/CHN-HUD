local config = require("common.config")
local mapSettings = require("src.settings.tabs.mapSettings")
local map = {}

local minPos = vec2(math.huge, math.huge) -- Posição mínima da pista
local maxPos = vec2(-math.huge, -math.huge) -- Posição máxima da pista
local totalPoints = 500 -- Número total de pontos no mapa
local mapPoints = {} -- Pontos do mapa

-- Centros da tela
local screenCenterX
local screenCenterY

-- Dimensões da pista
local trackWidth
local trackHeight
-- Centros da pista
local trackCenterX
local trackCenterY

-- Área de desenho do mapa
local drawAreaW
local drawAreaH

-- Escala final do mapa
local finalScale

local padding -- Limite do mapa

local function initMap()
    for i = 0, 1, 1 / totalPoints do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, i))
        local posWorld2D = vec2(posWorld.x, posWorld.z)
        table.insert(mapPoints, posWorld2D)

        if posWorld2D.x < minPos.x then minPos.x = posWorld2D.x end
        if posWorld2D.y < minPos.y then minPos.y = posWorld2D.y end
        if posWorld2D.x > maxPos.x then maxPos.x = posWorld2D.x end
        if posWorld2D.y > maxPos.y then maxPos.y = posWorld2D.y end
    end

    -- Dimensões finais da pista
    trackWidth = maxPos.x - minPos.x
    trackHeight = maxPos.y - minPos.y

    -- Centros da pista
    trackCenterX = (minPos.x + maxPos.x) / 2
    trackCenterY = (minPos.y + maxPos.y) / 2
end

--- @param thickness number
--- @param color rgbm
local function drawMap(thickness, color)
    for i, point in ipairs(mapPoints) do
        local offsetX = (point.x - trackCenterX) * finalScale
        local offsetY = (point.y - trackCenterY) * finalScale
        
        local finalX = screenCenterX + offsetX
        local finalY = screenCenterY + offsetY
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    ui.pathStroke(color, true, thickness)
end

--- @param thickness number
--- @param color rgbm
local function drawSectors(thickness, color)
    local sectors = SIM.lapSplits
    for i, sector in ipairs(sectors) do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, sector - 0.003))
        local pos1 = vec2(posWorld.x, posWorld.z)
        local initX = screenCenterX + (pos1.x - trackCenterX) * finalScale
        local initY = screenCenterY + (pos1.y - trackCenterY) * finalScale

        posWorld = ac.trackCoordinateToWorld(vec3(0, 0, sector + 0.003))
        local pos2 = vec2(posWorld.x, posWorld.z)
        local finalX = screenCenterX + (pos2.x - trackCenterX) * finalScale
        local finalY = screenCenterY + (pos2.y - trackCenterY) * finalScale

        ui.pathLineTo(vec2(initX, initY))
        ui.pathLineTo(vec2(finalX, finalY))
        if i == 0 then
            ui.pathStroke(COLOR.GREEN, false, thickness)
            
        else 
            ui.pathStroke(color, false, thickness)
        end
    end
end

function map.windowMain()
    local currenWindowSize = vec2(500, 500):scale(mapSettings.store.mapScale)
    padding = 40 * mapSettings.store.mapScale
    local thickness = 8 * mapSettings.store.mapScale

    -- Background
    ui.drawRectFilled(vec2(0, 0), currenWindowSize, WindowsColor, 20 * mapSettings.store.mapScale)

    screenCenterX = currenWindowSize.x / 2
    screenCenterY = currenWindowSize.y / 2

    drawAreaW = currenWindowSize.x - (padding * 2)
    drawAreaH = currenWindowSize.y - (padding * 2)

    local scaleX = drawAreaW / trackWidth
    local scaleY = drawAreaH / trackHeight
    finalScale = math.min(scaleX, scaleY)

    ui.beginRotation()
    drawMap(thickness * 2, COLOR.WHITE)
    drawMap(thickness, COLOR.BLACK)
    drawSectors(thickness * 2, COLOR.RED)
    ui.endRotation(mapSettings.store.angle)
    
    config.resize(currenWindowSize, "Map")
end

initMap()

return map