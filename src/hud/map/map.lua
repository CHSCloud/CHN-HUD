local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local mapSettings = require("src.settings.tabs.mapSettings")

local map = {}

local minPos = vec2(math.huge, math.huge) -- Posição mínima da pista
local maxPos = vec2(-math.huge, -math.huge) -- Posição máxima da pista
local totalPoints -- Total de pontos do mapa
local mapPoints = {} -- Pontos do mapa
local sectors = {} -- Setores da pista
local drs = {} -- DRS da pista

-- Centros da tela
local screenCenterX
local screenCenterY
local centerScreen

-- Dimensões da pista
local trackLength

-- Centros da pista
local trackCenterX
local trackCenterY

-- Área de desenho do mapa
local drawAreaLenght

-- Escala final do mapa
local finalScale

local padding -- Limite do mapa

local transparancy = 0

--- @param vec vec2
--- @param angleDeg number
--- @return vec2
local function rotateVec(vec, angleDeg)
    local rad = math.rad(angleDeg)
    local sin = math.sin(rad)
    local cos = math.cos(rad)
    return vec2(vec.x * cos - vec.y * sin, vec.x * sin + vec.y * cos)
end

local function initMap()
    totalPoints = config.remapInterval(SIM.trackLengthM, 0, 4000, 0, 450)

    -- Armazenando pontos do mapa
    for i = 0, 1, 1 / totalPoints do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, i))
        local posWorld2D = vec2(posWorld.x, posWorld.z)
        table.insert(mapPoints, posWorld2D)

        -- Definindo limites do mapa
        if posWorld2D.x < minPos.x then minPos.x = posWorld2D.x end
        if posWorld2D.y < minPos.y then minPos.y = posWorld2D.y end
        if posWorld2D.x > maxPos.x then maxPos.x = posWorld2D.x end
        if posWorld2D.y > maxPos.y then maxPos.y = posWorld2D.y end
    end

    -- Armazenando sectores
    for i, sector in ipairs(SIM.lapSplits) do
        local start = ac.trackCoordinateToWorld(vec3(0, 0, sector - 0.002))
        local final = ac.trackCoordinateToWorld(vec3(0, 0, sector + 0.002))
        table.insert(sectors, {
            start = vec2(start.x, start.z),
            final = vec2(final.x, final.z)
        })
    end

    -- Armazenando DRS
    local ini = ac.INIConfig.trackData("drs_zones.ini")
    if ini ~= nil then
        local sections = ini['sections']
        for name, data in pairs(sections) do
            local dataStart = data['START']
            local dataFinal = data['END']
            
            local start1 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataStart[1]) - 0.002))
            local final1 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataStart[1]) + 0.002))
            local start2 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataFinal[1]) - 0.002))
            local final2 = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataFinal[1]) + 0.002))
            if dataStart[1] ~= nil and dataFinal[1] ~= nil then
                table.insert(drs, {
                    start1 = vec2(start1.x, start1.z),
                    final1 = vec2(final1.x, final1.z),
                    start2 = vec2(start2.x, start2.z),
                    final2 = vec2(final2.x, final2.z)
                })
            end
        end
    end

    -- Comprimento da pista
    trackLength = config.calculateDistance(minPos, maxPos)

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

        local rotatePos = rotateVec(vec2(offsetX, offsetY), mapSettings.store.angle)

        local finalX = screenCenterX + rotatePos.x
        local finalY = screenCenterY + rotatePos.y
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    ui.pathStroke(color, true, thickness)
end

--- @param thickness number
--- @param color rgbm
local function drawSectors(thickness, color)
    for i, sector in ipairs(sectors) do
        local rotatePosInit = rotateVec(vec2((sector.start.x - trackCenterX) * finalScale, (sector.start.y - trackCenterY) * finalScale), mapSettings.store.angle)
        local init = vec2(math.floor(screenCenterX + rotatePosInit.x), math.floor(screenCenterY + rotatePosInit.y))

        local rotatePosFinal = rotateVec(vec2((sector.final.x - trackCenterX) * finalScale, (sector.final.y - trackCenterY) * finalScale), mapSettings.store.angle)
        local final = vec2(math.floor(screenCenterX + rotatePosFinal.x), math.floor(screenCenterY + rotatePosFinal.y))
        if i == 1 then
            ui.drawLine(init, final, COLOR.RED, thickness)
        else 
            ui.drawLine(init, final, color, thickness)
        end
    end
end

---@param car ac.StateCar
---@param lenght number
---@param color rgbm
local function drawPLayer(car, lenght, color)
    local posX = (car.position.x - trackCenterX) * finalScale
    local posY = (car.position.z - trackCenterY) * finalScale
    local rotatedPos = rotateVec(vec2(posX, posY), mapSettings.store.angle)
    rotatedPos = centerScreen + rotatedPos
    ui.drawCircleFilled(rotatedPos, lenght / 1.5, color, 20)
    ui.drawCircle(rotatedPos, lenght / 1.5, COLOR.BLACK, 20, 3 * mapSettings.store.mapScale)
    ui.setCursor(rotatedPos - vec2(lenght,lenght)/2)
    ui.dwriteTextAligned(tostring(car.racePosition), 15 * mapSettings.store.mapScale, ui.Alignment.Center, ui.Alignment.Center, vec2(lenght, lenght), false, COLOR.BLACK)
end

--- @param lenght number
local function drawPLayers(lenght)
    for i, car in ac.iterateCars.leaderboard() do
        if car.index ~= SIM.focusedCar then
            drawPLayer(car, lenght, mapSettings.store.colorEnemies)
        end
    end
    local car = ac.getCar(SIM.focusedCar)
    if car == nil then return end
    drawPLayer(car, lenght, mapSettings.store.colorPlayer)
end

--- @param thickness number
local function drawDRS(thickness)
    for i, data in pairs(drs) do
        local rotatePosInit = rotateVec(vec2((data.start1.x - trackCenterX) * finalScale, (data.start1.y - trackCenterY) * finalScale), mapSettings.store.angle)
        local init = vec2(math.floor(screenCenterX + rotatePosInit.x), math.floor(screenCenterY + rotatePosInit.y))

        local rotatePosFinal = rotateVec(vec2((data.final1.x - trackCenterX) * finalScale, (data.final1.y - trackCenterY) * finalScale), mapSettings.store.angle)
        local final = vec2(math.floor(screenCenterX + rotatePosFinal.x), math.floor(screenCenterY + rotatePosFinal.y))
        ui.drawLine(init, final, mapSettings.store.colorDRS, thickness)

        rotatePosInit = rotateVec(vec2((data.start2.x - trackCenterX) * finalScale, (data.start2.y - trackCenterY) * finalScale), mapSettings.store.angle)
        init = vec2(math.floor(screenCenterX + rotatePosInit.x), math.floor(screenCenterY + rotatePosInit.y))

        rotatePosFinal = rotateVec(vec2((data.final2.x - trackCenterX) * finalScale, (data.final2.y - trackCenterY) * finalScale), mapSettings.store.angle)
        final = vec2(math.floor(screenCenterX + rotatePosFinal.x), math.floor(screenCenterY + rotatePosFinal.y))
        ui.drawLine(init, final, mapSettings.store.colorDRS, thickness)
    end
end

function map.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    local currenWindowSize = vec2(500, 500):scale(mapSettings.store.mapScale)
    padding = 10 * mapSettings.store.mapScale
    local thickness = 8 * mapSettings.store.mapScale

    -- Animação do Background
    if config.isMouseInWindow(ui.mouseLocalPos(), 0, ui.windowSize().x, 0, ui.windowSize().y) then
        if transparancy < 0.85 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy + 0.1
            end
        end
        ui.drawRectFilled(vec2(0, 0), currenWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
    else
        if transparancy > 0 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy - 0.1
            end
             ui.drawRectFilled(vec2(0, 0), currenWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
        else
            transparancy = 0
        end
    end

    screenCenterX = currenWindowSize.x / 2
    screenCenterY = currenWindowSize.y / 2
    centerScreen = vec2(screenCenterX, screenCenterY)

    drawAreaLenght = currenWindowSize.y - (padding * 2)
    finalScale = drawAreaLenght / trackLength

    -- Desenha borda
    drawMap((mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2) * mapSettings.store.mapScale, mapSettings.store.colorBorder)
    -- Desenha pista
    drawMap(mapSettings.store.trackLenght * mapSettings.store.mapScale, mapSettings.store.colorTrack)
    -- Desenha DRS
    drawDRS(mapSettings.store.trackLenght * mapSettings.store.mapScale)
    -- Desenha setores
    drawSectors(mapSettings.store.trackLenght * mapSettings.store.mapScale, mapSettings.store.colorSectors)
    -- Desenha jogadores
    drawPLayers(thickness * 3)
    
    config.resize(currenWindowSize, "Map")
    pinCheckBox.main(mapSettings.store.mapScale * 1.5, "Map", config.getWindow("Map"):pinned(), currenWindowSize)
end

initMap()

return map