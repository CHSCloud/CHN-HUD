local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local mapSettings = require("src.settings.tabs.mapSettings")
local map = {}

local minPos = vec2(math.huge, math.huge) -- Posição mínima da pista
local maxPos = vec2(-math.huge, -math.huge) -- Posição máxima da pista
local totalPoints = 1500 -- Número total de pontos no mapa
local mapPoints = {} -- Pontos do mapa

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


    for i = 0, 1, 1 / totalPoints do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, i))
        local posWorld2D = vec2(posWorld.x, posWorld.z)
        table.insert(mapPoints, posWorld2D)

        if posWorld2D.x < minPos.x then minPos.x = posWorld2D.x end
        if posWorld2D.y < minPos.y then minPos.y = posWorld2D.y end
        if posWorld2D.x > maxPos.x then maxPos.x = posWorld2D.x end
        if posWorld2D.y > maxPos.y then maxPos.y = posWorld2D.y end
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
    local sectors = SIM.lapSplits

    for i, sector in ipairs(sectors) do
        local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, sector - 0.002))
        local pos1 = vec2(posWorld.x, posWorld.z)
        local rotatePosInit = rotateVec(vec2((pos1.x - trackCenterX) * finalScale, (pos1.y - trackCenterY) * finalScale), mapSettings.store.angle)
        local initX = screenCenterX + rotatePosInit.x
        local initY = screenCenterY + rotatePosInit.y

        posWorld = ac.trackCoordinateToWorld(vec3(0, 0, sector + 0.002))
        local pos2 = vec2(posWorld.x, posWorld.z)
        local rotatePosFinal = rotateVec(vec2((pos2.x - trackCenterX) * finalScale, (pos2.y - trackCenterY) * finalScale), mapSettings.store.angle)
        local finalX = screenCenterX + rotatePosFinal.x
        local finalY = screenCenterY + rotatePosFinal.y
        
        ui.pathLineTo(vec2(initX, initY))
        ui.pathLineTo(vec2(finalX, finalY))
        if i == 0 then
            ui.pathStroke(COLOR.RED, false, thickness)
            
        else 
            ui.pathStroke(color, false, thickness)
        end
    end
end

---@param car ac.StateCar
---@param lenght number
---@param color rgbm
local function drawPLayer(car, lenght, color)
    local pos1 = vec2(car.position.x, car.position.z)
    local posX = (pos1.x - trackCenterX) * finalScale
    local posY = (pos1.y - trackCenterY) * finalScale
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
            drawPLayer(car, lenght, COLOR.WHITE)
        end
    end
    local car = ac.getCar(SIM.focusedCar)
    if car == nil then return end
    drawPLayer(car, lenght, COLOR.YELLOW)
end

--- @param thickness number
--- @param color rgbm
local function drawDRS(thickness, color)
    local ini = ac.INIConfig.trackData("drs_zones.ini")
    if ini ~= nil then
        local sections = ini['sections']
        for section_name, section_data in pairs(sections) do
            -- we don't really care about the order we put them in
            local data_zstart     = section_data['START']
            local data_zdetection = section_data['DETECTION']
            local data_zend       = section_data['END']

            local zstart = nil
            local zdetection = nil
            local zend = nil
            if data_zstart     ~= nil then zstart     = data_zstart[1]     end
            if data_zdetection ~= nil then zdetection = data_zdetection[1] end
            if data_zend       ~= nil then zend       = data_zend[1]       end

            if zstart     ~= nil then zstart     = stringify.parse(zstart)     end
            if zdetection ~= nil then zdetection = stringify.parse(zdetection) end
            if zend       ~= nil then zend       = stringify.parse(zend)       end

            local posWorld = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(zstart) - 0.002))
            local pos1 = vec2(posWorld.x, posWorld.z)
            local rotatePosInit = rotateVec(vec2((pos1.x - trackCenterX) * finalScale, (pos1.y - trackCenterY) * finalScale), mapSettings.store.angle)
            local initX = screenCenterX + rotatePosInit.x
            local initY = screenCenterY + rotatePosInit.y

            posWorld = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(zstart) + 0.002))
            local pos2 = vec2(posWorld.x, posWorld.z)
            local rotatePosFinal = rotateVec(vec2((pos2.x - trackCenterX) * finalScale, (pos2.y - trackCenterY) * finalScale), mapSettings.store.angle)
            local finalX = screenCenterX + rotatePosFinal.x
            local finalY = screenCenterY + rotatePosFinal.y
            
            ui.pathLineTo(vec2(initX, initY))
            ui.pathLineTo(vec2(finalX, finalY))
            ui.pathStroke(color, false, thickness)

            posWorld = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(zend) - 0.002))
            local pos1 = vec2(posWorld.x, posWorld.z)
            local rotatePosInit = rotateVec(vec2((pos1.x - trackCenterX) * finalScale, (pos1.y - trackCenterY) * finalScale), mapSettings.store.angle)
            local initX = screenCenterX + rotatePosInit.x
            local initY = screenCenterY + rotatePosInit.y

            posWorld = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(zend) + 0.002))
            local pos2 = vec2(posWorld.x, posWorld.z)
            local rotatePosFinal = rotateVec(vec2((pos2.x - trackCenterX) * finalScale, (pos2.y - trackCenterY) * finalScale), mapSettings.store.angle)
            local finalX = screenCenterX + rotatePosFinal.x
            local finalY = screenCenterY + rotatePosFinal.y
            
            ui.pathLineTo(vec2(initX, initY))
            ui.pathLineTo(vec2(finalX, finalY))
            ui.pathStroke(color, false, thickness)
        end
    end
end



function map.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    local currenWindowSize = vec2(500, 500):scale(mapSettings.store.mapScale)
    padding = 10 * mapSettings.store.mapScale
    local thickness = 8 * mapSettings.store.mapScale

    
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

    drawMap(mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2, mapSettings.store.colorBorder)
    drawMap(mapSettings.store.trackLenght, mapSettings.store.colorTrack)
    drawDRS(mapSettings.store.trackLenght, COLOR.GREEN)
    drawSectors(mapSettings.store.trackLenght, mapSettings.store.colorSectors)
    drawPLayers(thickness * 3)
    
    config.resize(currenWindowSize, "Map")
    pinCheckBox.main(mapSettings.store.mapScale * 1.5, "Map", config.getWindow("Map"):pinned(), currenWindowSize)
end

initMap()

return map