local config = require("common.config")
local mapSettings = require("src.settings.tabs.mapSettings")
local map = {}

local minPos = vec2(math.huge, math.huge) -- Posição mínima da pista
local maxPos = vec2(-math.huge, -math.huge) -- Posição máxima da pista
local totalPoints = 500 -- Número total de pontos no mapa
local mapPoints = {} -- Pontos do mapa

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
end

function map.windowMain()
    local currenWindowSize = vec2(500, 500):scale(mapSettings.store.mapScale)
    local padding = 40 * mapSettings.store.mapScale -- Reduzi um pouco para aproveitar espaço
    local thickness = 5 * mapSettings.store.mapScale

    -- 1. Desenhar o fundo
    ui.drawRectFilled(vec2(0, 0), currenWindowSize, rgbm(0, 0, 0, 0.5), 40)

    -- 2. Calcular dimensões da pista e da área de desenho
    local trackWidth = maxPos.x - minPos.x
    local trackHeight = maxPos.y - minPos.y
    
    local drawAreaW = currenWindowSize.x - (padding * 2)
    local drawAreaH = currenWindowSize.y - (padding * 2)

    -- 3. Calcular a escala (O SEGREDO ESTÁ AQUI)
    -- Descobrimos quanto teríamos que reduzir para caber na largura e na altura
    local scaleX = drawAreaW / trackWidth
    local scaleY = drawAreaH / trackHeight
    
    -- Usamos a MENOR escala para garantir que a pista caiba inteira sem distorcer
    local finalScale = math.min(scaleX, scaleY)

    -- 4. Calcular os centros para centralizar o mapa
    local trackCenterX = (minPos.x + maxPos.x) / 2
    local trackCenterY = (minPos.y + maxPos.y) / 2
    
    local screenCenterX = currenWindowSize.x / 2
    local screenCenterY = currenWindowSize.y / 2

    ui.beginRotation()
    ui.pathClear()
    
    for i, point in ipairs(mapPoints) do
        local offsetX = (point.x - trackCenterX) * finalScale
        local offsetY = (point.y - trackCenterY) * finalScale
        
        local finalX = screenCenterX + offsetX
        local finalY = screenCenterY + offsetY
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    
    ui.pathStroke(COLOR.WHITE, true, thickness)
    ui.endRotation(mapSettings.store.angle)
    config.resize(currenWindowSize, "Map")
end

initMap()

return map