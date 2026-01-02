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
local trackSections = {} -- Nomes da pista

local canvas = nil
local canvasZoom = nil
local canvasSize = vec2(600, 600)-- Tamanho do Canvas
local canvasCenter = vec2(canvasSize.x / 2, canvasSize.y / 2) -- Centro do canvas
local canvasScale -- Escala final do mapa
local angle -- Ângulo do mapa
local offset = vec2(0,0) -- Offset do mapa

local padding = 40 -- Limite do mapa

-- Tamnho da janela
local baseWindowSize = vec2(300, 300)
local currentWindowSize = baseWindowSize
local windowCenter = currentWindowSize / 2

-- Tamanho da pista
local trackLength
-- Centros da pista
local trackCenterX
local trackCenterY
local isTrackConnected = true

local startTrack -- Inicio da pista
local endTrack -- Fim da pista
local dirTrack -- Direção da pista
local isClockwise = false -- Sentido de orintação da pista

local transparancy = 0

-- Inicializa todos os parâmetros do mapa
local function initMap()
    -- Calculando todos os pontos do mapa
    totalPoints = config.remapInterval(SIM.trackLengthM, 0, 4000, 0, 500)

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
        local left = ac.trackCoordinateToWorld(vec3(-1, 0, sector))
        local center = ac.trackCoordinateToWorld(vec3(0, 0, sector))
        local right = ac.trackCoordinateToWorld(vec3(1, 0, sector))
        table.insert(sectors, {
            left = vec2(left.x, left.z),
            center = vec2(center.x, center.z),
            right = vec2(right.x, right.z)
        })
    end

    -- Armazenando DRS
    local drsINI = ac.INIConfig.trackData("drs_zones.ini")
    if drsINI ~= nil then
        for name, data in pairs(drsINI['sections']) do
            local dataStart = data['START']
            local dataFinal = data['END']
            
            local startLeft = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(dataStart[1])))
            local startCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataStart[1])))
            local startRight = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(dataStart[1])))

            local finalLeft = ac.trackCoordinateToWorld(vec3(-1, 0, tonumber(dataFinal[1])))
            local finalCenter = ac.trackCoordinateToWorld(vec3(0, 0, tonumber(dataFinal[1])))
            local finalRight = ac.trackCoordinateToWorld(vec3(1, 0, tonumber(dataFinal[1])))
            if dataStart[1] ~= nil and dataFinal[1] ~= nil then
                table.insert(drs, {
                    startLeft = vec2(startLeft.x, startLeft.z),
                    startCenter = vec2(startCenter.x, startCenter.z),
                    startRight = vec2(startRight.x, startRight.z),

                    finalLeft = vec2(finalLeft.x, finalLeft.z),
                    finalCenter = vec2(finalCenter.x, finalCenter.z),
                    finalRight = vec2(finalRight.x, finalRight.z)
                })
            end
        end
    end

    -- Verificando sentido da pista
    local sum = 0
    for i = 1, totalPoints do
        local currentPoint = ac.trackCoordinateToWorld(vec3(0, 0, i / totalPoints))
        local nextPoint = ac.trackCoordinateToWorld(vec3(0, 0, ((i + 1) % totalPoints) / totalPoints))
        sum = sum + (currentPoint.x * nextPoint.z - nextPoint.x * currentPoint.z)
    end
    if sum > 0 then 
        isClockwise = true 
    end

    -- Carregando seções do mapa
    trackSections = mapSettings.loadSectionsINI()

    -- Comprimento da pista
    trackLength = math.distance(minPos, maxPos)
    
    -- Verificando se a pista é conectada:
    startTrack = ac.trackCoordinateToWorld(vec3(0, 0, 0))
    endTrack = ac.trackCoordinateToWorld(vec3(0, 0, 0.01))
    local distance = math.distance(startTrack, endTrack)
    if distance > 60 then 
        isTrackConnected = false
    end
    
    -- Centros da pista
    trackCenterX = (minPos.x + maxPos.x) / 2
    trackCenterY = (minPos.y + maxPos.y) / 2

    -- Direção da pista
    local dirTrack3d = (endTrack - startTrack):normalize()
    dirTrack = vec2(dirTrack3d.x, dirTrack3d.z)

    -- Canvas normal
    canvas = ui.ExtraCanvas(canvasSize, 1, render.AntialiasingMode.None)
    canvas:setName("CANVAS")

    -- Canvas de zoom
    canvasZoom = ui.ExtraCanvas(canvasSize, 1, render.AntialiasingMode.None)
    canvasZoom:setName("CANVAS_ZOOM")
end

-- Desenha o mapa
--- @param thickness number -- Espessura do traço
--- @param color rgbm -- Cor do traço
local function drawMap(thickness, color)
    for i, point in ipairs(mapPoints) do
        local offsetX = (point.x - trackCenterX) * canvasScale
        local offsetY = (point.y - trackCenterY) * canvasScale

        local rotatePos = config.rotateVec(vec2(offsetX, offsetY), angle)

        local finalX = canvasCenter.x + rotatePos.x
        local finalY = canvasCenter.y + rotatePos.y
        
        ui.pathLineTo(vec2(finalX, finalY))
    end
    ui.pathStroke(color, isTrackConnected, thickness)
end

-- Desenha setores
--- @param thickness number -- Espessura do setor
--- @param color rgbm -- Cor do setor
local function drawSectors(thickness, color)
    for i, sector in ipairs(sectors) do
        if i > 1 then
            -- Posição do setor
            local left = config.rotateVec(vec2((sector.left.x - trackCenterX) * canvasScale, (sector.left.y - trackCenterY) * canvasScale), angle)
            local center = config.rotateVec(vec2((sector.center.x - trackCenterX) * canvasScale, (sector.center.y - trackCenterY) * canvasScale), angle)
            local right = config.rotateVec(vec2((sector.right.x - trackCenterX) * canvasScale, (sector.right.y - trackCenterY) * canvasScale), angle)
            
            -- Direção do setor
            local dir = (right - left):normalize()
            ui.drawLine(center + dir * thickness + canvasCenter, center - dir * thickness + canvasCenter, color, 6)
        end
    end
end

-- Desenha a bandeira de largada
--- @param thickness number -- Espessura da bandeira
local function drawStartFlag(thickness) 
    -- Posição do setor
    local left = config.rotateVec(vec2((sectors[1].left.x - trackCenterX) * canvasScale, (sectors[1].left.y - trackCenterY) * canvasScale), angle)
    local center = config.rotateVec(vec2((sectors[1].center.x - trackCenterX) * canvasScale, (sectors[1].center.y - trackCenterY) * canvasScale), angle)
    local right = config.rotateVec(vec2((sectors[1].right.x - trackCenterX) * canvasScale, (sectors[1].right.y - trackCenterY) * canvasScale), angle)
    
    -- Direção do setor
    local dir = (right - left):normalize()
    local init = center + dir * thickness + canvasCenter
    local final = center - dir * thickness + canvasCenter
    local flagLenght = config.rotateVec(dirTrack * thickness / 2, angle)
    ui.drawImageQuad("assets/checkered.png", init + flagLenght, final + flagLenght, final - flagLenght, init - flagLenght)

end

-- Desenha um jogador
--- @param car ac.StateCar -- Cara a ser desenhado
--- @param lenght number -- Tamanho do círculo
--- @param colorInternal rgbm -- Cor do círculo interno
--- @param colorExternal rgbm -- Cor do círculo extero
--- @param center vec2 -- Centro do mapa
--- @param scale number -- Escala do mapa
local function drawPLayer(car, lenght, colorInternal, colorExternal, center, scale)
    local posX = (car.position.x - trackCenterX) * scale
    local posY = (car.position.z - trackCenterY) * scale
    local rotatedPos = config.rotateVec(vec2(posX, posY), angle)
    rotatedPos = center + rotatedPos + offset
    ui.drawCircleFilled(rotatedPos, lenght, colorInternal, 20)
    ui.drawCircle(rotatedPos, lenght, colorExternal, 20, lenght / 5)
    ui.setCursor(rotatedPos - vec2(lenght,lenght))
    ui.dwriteTextAligned(tostring(car.racePosition), lenght, ui.Alignment.Center, ui.Alignment.Center, vec2(lenght, lenght) * 2, false, colorExternal)
end

-- Desenha todos os jogadores
local function drawPlayers()
    local scale
    local center
    local enemiesLenght 
    local focusedCarLenght
    if not mapSettings.store.focus then
        local ratio = (baseWindowSize.y * mapSettings.store.mapScale) / canvasSize.y
        scale = canvasScale * ratio
        center = windowCenter
        enemiesLenght = mapSettings.store.enemiesLenght * mapSettings.store.mapScale
        focusedCarLenght = mapSettings.store.focusedCarLenght * mapSettings.store.mapScale
    else 
        scale = canvasScale
        center = canvasCenter
        local ratio = canvasSize.y / (baseWindowSize.y * mapSettings.store.mapScale)
        enemiesLenght = mapSettings.store.enemiesLenght * ratio * mapSettings.store.mapScale
        focusedCarLenght = mapSettings.store.focusedCarLenght * ratio * mapSettings.store.mapScale
    end
    for i, car in ac.iterateCars.leaderboard() do
        if car.index ~= SIM.focusedCar then
            if car.isInPitlane then
                drawPLayer(car, enemiesLenght / 1.5, mapSettings.store.colorEnemies - rgbm(0, 0, 0, 0.2),mapSettings.store.colorExternalEnemies - rgbm(0, 0, 0, 0.2), center, scale)
                
            else 
                drawPLayer(car, enemiesLenght, mapSettings.store.colorEnemies, mapSettings.store.colorExternalEnemies, center, scale)
            end
        end
    end
    local car = ac.getCar(SIM.focusedCar)
    if car == nil then return end
    if car.isInPitlane then
        drawPLayer(car, focusedCarLenght / 1.5, mapSettings.store.colorFocusedCar - rgbm(0, 0, 0, 0.2), mapSettings.store.colorExternalFocusedCar, center, scale)
    else 
        drawPLayer(car, focusedCarLenght, mapSettings.store.colorFocusedCar, mapSettings.store.colorExternalFocusedCar, center, scale)
    end
end

-- Desenha DRS
--- @param thickness number -- Espessura do DRS
local function drawDRS(thickness)
    for i, data in pairs(drs) do
        -- Início
        local left = config.rotateVec(vec2((data.startLeft.x - trackCenterX) * canvasScale, (data.startLeft.y - trackCenterY) * canvasScale), angle)
        local center = config.rotateVec(vec2((data.startCenter.x - trackCenterX) * canvasScale, (data.startCenter.y - trackCenterY) * canvasScale), angle)
        local right = config.rotateVec(vec2((data.startRight.x - trackCenterX) * canvasScale, (data.startRight.y - trackCenterY) * canvasScale), angle)
        
        local dir = (right - left):normalize()
        local init = center + dir * thickness
        init = init + canvasCenter
        local final = center - dir * thickness
        final = final + canvasCenter
        ui.drawLine(init, final, mapSettings.store.colorDRS, 6)

        -- Final
        left = config.rotateVec(vec2((data.finalLeft.x - trackCenterX) * canvasScale, (data.finalLeft.y - trackCenterY) * canvasScale), angle)
        center = config.rotateVec(vec2((data.finalCenter.x - trackCenterX) * canvasScale, (data.finalCenter.y - trackCenterY) * canvasScale), angle)
        right = config.rotateVec(vec2((data.finalRight.x - trackCenterX) * canvasScale, (data.finalRight.y - trackCenterY) * canvasScale), angle)
        
        dir = (right - left):normalize()
        init = center + dir * thickness
        init = init + canvasCenter
        final = center - dir * thickness
        final = final + canvasCenter
        ui.drawLine(init, final, mapSettings.store.colorDRS, 6)
    end
end

-- Aumamenta janela com base no retângulo do texto
--- @param initRect vec2 -- Coordenadas iniciais
--- @param finalRect vec2 -- Coordenadas finais
local function resizeWithText(initRect, finalRect) 
    if initRect.x < 0 and math.abs(initRect.x) > offset.x then
        currentWindowSize.x = currentWindowSize.x - offset.x +  math.abs(initRect.x)
        offset.x = math.abs(initRect.x)
    end
    if finalRect.x > currentWindowSize.x - offset.x then
        currentWindowSize.x = finalRect.x + offset.x
    end
    if initRect.y < 0 and math.abs(initRect.y) > offset.y then
        currentWindowSize.y = currentWindowSize.y - offset.y + math.abs(initRect.y)
        offset.y = math.abs(initRect.y)
    end
    if finalRect.y > currentWindowSize.y - offset.y then
        currentWindowSize.y = finalRect.y + offset.y
    end
end

-- Altera o tamanho da janela baseado nas seções
local function resizeWindowMap()
    local scale
    local textPosition
    local lenght
    if not mapSettings.store.focus then
        local ratio = (baseWindowSize.y * mapSettings.store.mapScale) / canvasSize.y
        scale = canvasScale * ratio
        lenght = mapSettings.store.sectionsLenght * 2 
        if mapSettings.store.sectionsType == 1 then
            for i = 1, #trackSections, 1 do
                local posRotated
                local textLenght = (vec2(lenght, lenght) / 2) * mapSettings.store.mapScale
                if trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((trackSections[i].center.x - trackCenterX) * scale, (trackSections[i].center.y - trackCenterY) * scale), angle)

                elseif trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((trackSections[i].left.x - trackCenterX) * scale, (trackSections[i].left.y - trackCenterY) * scale), angle)
                    local dir = (trackSections[i].right - trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + mapSettings.store.borderLenght + lenght/4) * mapSettings.store.mapScale

                else
                    posRotated = config.rotateVec(vec2((trackSections[i].right.x - trackCenterX) * scale, (trackSections[i].right.y - trackCenterY) * scale), angle)
                    local dir = (trackSections[i].left - trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + mapSettings.store.borderLenght + lenght/4) * mapSettings.store.mapScale
                end
                textPosition = windowCenter + posRotated
                resizeWithText(textPosition - textLenght, textPosition + textLenght)

                trackSections[i].namePosition = textPosition
            end
        else
            for i = 1, #trackSections, 1 do
                local longestText, count = config.findLongestWord(trackSections[i].name)
                local textLenght = ui.measureDWriteText(longestText, (lenght / 2)* mapSettings.store.mapScale) + vec2(5) * mapSettings.store.mapScale
                textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0,5) * mapSettings.store.mapScale
                local posRotated
                local dir = vec2(0,0)
                if trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((trackSections[i].center.x - trackCenterX) * scale, (trackSections[i].center.y - trackCenterY) * scale), angle)

                elseif trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((trackSections[i].left.x - trackCenterX) * scale, (trackSections[i].left.y - trackCenterY) * scale), angle)
                    dir = (trackSections[i].right - trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, angle)

                else
                    posRotated = config.rotateVec(vec2((trackSections[i].right.x - trackCenterX) * scale, (trackSections[i].right.y - trackCenterY) * scale), angle)
                    dir = (trackSections[i].left - trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, angle)
                end
                local distance
                if dir.x > 0 then
                    distance = config.remapInterval(dir.x, 0, 1, textLenght.x / 20, 1)
                else
                    distance = config.remapInterval(dir.x, -1, 0, 1, textLenght.x / 20)
                end
                local centerText = posRotated + dir * (textLenght.x / (2 * distance) + ((mapSettings.store.trackLenght + mapSettings.store.borderLenght)/2) * mapSettings.store.mapScale)
                textPosition = windowCenter + centerText - textLenght / 2
                resizeWithText(textPosition, textPosition + textLenght)
                
                trackSections[i].namePosition = textPosition
            end
        end
    else 
        scale = canvasScale
        local ratio = canvasSize.y / (baseWindowSize.y * mapSettings.store.mapScale)
        lenght = (mapSettings.store.sectionsLenght * 2) * ratio * mapSettings.store.mapScale
        if mapSettings.store.sectionsType == 1 then
            local textLenght = (vec2(lenght, lenght) / 2)
            for i = 1, #trackSections, 1 do
                local posRotated
                if trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((trackSections[i].center.x - trackCenterX) * scale, (trackSections[i].center.y - trackCenterY) * scale), angle)

                elseif trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((trackSections[i].left.x - trackCenterX) * scale, (trackSections[i].left.y - trackCenterY) * scale), angle)
                    local dir = (trackSections[i].right - trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + mapSettings.store.borderLenght + textLenght.x)

                else
                    posRotated = config.rotateVec(vec2((trackSections[i].right.x - trackCenterX) * scale, (trackSections[i].right.y - trackCenterY) * scale), angle)
                    local dir = (trackSections[i].left - trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, angle)
                    posRotated = posRotated + dir * (mapSettings.store.trackLenght/2 + mapSettings.store.borderLenght + textLenght.x)
                end
                posRotated = canvasCenter + posRotated
                textPosition = posRotated
                trackSections[i].namePosition = textPosition
            end
        else 
            for i = 1, #trackSections, 1 do
                local longestText, count = config.findLongestWord(trackSections[i].name)
                local textLenght = (ui.measureDWriteText(longestText, lenght / 2) + vec2(5))
                textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0,5)
                local posRotated
                local dir = vec2(0,0)
                if trackSections[i].position == 1 then
                    posRotated = config.rotateVec(vec2((trackSections[i].center.x - trackCenterX) * scale, (trackSections[i].center.y - trackCenterY) * scale), angle)

                elseif trackSections[i].position == 2 then
                    posRotated = config.rotateVec(vec2((trackSections[i].left.x - trackCenterX) * scale, (trackSections[i].left.y - trackCenterY) * scale), angle)
                    dir = (trackSections[i].right - trackSections[i].left):normalize()
                    dir = config.rotateVec(dir, angle)

                else
                    posRotated = config.rotateVec(vec2((trackSections[i].right.x - trackCenterX) * scale, (trackSections[i].right.y - trackCenterY) * scale), angle)
                    dir = (trackSections[i].left - trackSections[i].right):normalize()
                    dir = config.rotateVec(dir, angle)
                end
                local distance
                if dir.x > 0 then
                    distance = config.remapInterval(dir.x, 0, 1, textLenght.x / 30, 1)
                else
                    distance = config.remapInterval(dir.x, -1, 0, 1, textLenght.x / 30)
                end
                local centerText = posRotated + dir * (textLenght.x / (2 * distance) + (mapSettings.store.trackLenght + mapSettings.store.borderLenght))
                textPosition = canvasCenter + centerText - textLenght / 2
                
                trackSections[i].namePosition = textPosition
            end
        end
    end
end

-- Desenha nomes da pista
local function drawTrackSections()
    local scale
    local textLenght
    local lenght
    if mapSettings.store.focus then
        scale = canvasSize.y / (baseWindowSize.y * mapSettings.store.mapScale)
        lenght = (mapSettings.store.sectionsLenght * 2) * mapSettings.store.mapScale
    else 
        scale =  mapSettings.store.mapScale
        lenght = mapSettings.store.sectionsLenght * 2
    end
    if mapSettings.store.sectionsType == 1 then
        textLenght = ((vec2(lenght, lenght) / 2)) * scale
        for i = 1, #trackSections, 1 do
            local position = trackSections[i].namePosition + offset
            ui.drawCircleFilled(position, textLenght.x, COLOR.BLACK, 20)
            ui.setCursor(position - textLenght / 2)
            ui.dwriteTextAligned(trackSections[i].number, (lenght / 2) * scale, ui.Alignment.Center, ui.Alignment.Center, textLenght, false, COLOR.WHITE)
        end

    else
        for i = 1, #trackSections, 1 do
            if trackSections[i].name ~= "" then
                local longestText, count = config.findLongestWord(trackSections[i].name)
                local textLenght = ui.measureDWriteText(longestText, (lenght / 2) * scale) + vec2(5) * scale
                textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0,5) * scale
                local position = trackSections[i].namePosition + offset
                ui.drawRectFilled(position, position + textLenght, COLOR.BLACK, 3 * mapSettings.store.mapScale)
                ui.setCursor(position)
                ui.dwriteTextAligned(trackSections[i].name:gsub("\n$", ""), (lenght / 2) * scale, ui.Alignment.Center, ui.Alignment.Center, textLenght, false, COLOR.WHITE)
            end
        end
    end
end

function map.windowMain()
    if mapSettings.store.resetSectionsINI then
        trackSections = mapSettings.resetSectionsINI()
    end
    if mapSettings.store.trackSectionsEdited then
        trackSections = mapSettings.loadSectionsINI()
    end

    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    offset = vec2(0,0)
    currentWindowSize = vec2(300, 300)
    currentWindowSize = currentWindowSize:scale(mapSettings.store.mapScale)
    windowCenter = currentWindowSize / 2
    canvasScale = (canvasSize.y - (padding * 2)) / trackLength
    if mapSettings.store.focus then
        trackCenterX = CAR.position.x
        trackCenterY = CAR.position.z
        angle = math.deg(math.atan2(CAR.look.z, -CAR.look.x) + math.pi / 2)
    else
        trackCenterX = (minPos.x + maxPos.x) / 2
        trackCenterY = (minPos.y + maxPos.y) / 2
        if isClockwise then
            angle = math.deg(-math.atan2(dirTrack.y, dirTrack.x) + math.pi) + mapSettings.store.angle
        else
            angle = math.deg(-math.atan2(dirTrack.y, dirTrack.x)) + mapSettings.store.angle
        end
    end

    if mapSettings.store.sectionsTrackActive then
        resizeWindowMap()
    end

    -- Desenha borda
    if canvas == nil then return end
    canvas:clear()
    canvas:update(function ()
        drawMap(mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2, mapSettings.store.colorBorder)
        -- Desenha pista
        drawMap(mapSettings.store.trackLenght, mapSettings.store.colorTrack)
        -- Desenha DRS
        if mapSettings.store.drsActive then
            drawDRS(mapSettings.store.trackLenght / 1.8)
        end
        -- Desenha setores
        if mapSettings.store.sectorsActive then
            drawSectors(mapSettings.store.trackLenght / 1.8, mapSettings.store.colorSectors)
        end

        -- Desenha bandeira de largada
        drawStartFlag((mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2) / 1.3)
    end)


    -- Animação do Background
    if config.isMouseInWindow(ui.mouseLocalPos(), 0, ui.windowSize().x, 0, ui.windowSize().y) then
        if transparancy < 0.85 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy + 0.1
            end
        end
        ui.drawRectFilled(vec2(0, 0), currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
    else
        if transparancy > 0 then
            if 20 * Timer % 6 >= 1 then
                transparancy = transparancy - 0.1
            end
             ui.drawRectFilled(vec2(0, 0), currentWindowSize, rgbm(WindowsColor.r,WindowsColor.g,WindowsColor.b, transparancy), 20 * mapSettings.store.mapScale)
        else
            transparancy = 0
        end
    end
    
    if mapSettings.store.focus then
        if canvasZoom == nil then return end
        local zoomScaled = mapSettings.store.zoom * mapSettings.store.mapScale
        if mapSettings.store.sectionsTrackActive then
            canvas:update(function ()
                drawTrackSections()
                drawPlayers()
            end)
        else
            canvas:update(function ()
                drawPlayers()
            end)
        end
        canvasZoom:updateWithShader({
            textures = {canvas = canvas},
            values = {zoom = currentWindowSize.x / (2 * (2 * zoomScaled + currentWindowSize.x))},
            shader = [[
                SamplerState mapSample {
                    Filter = MIN_MAG_MIP_LINEAR;
                    AddressU = Wrap;
                    AddressV = Wrap;
                };

                float remap(float v, float inMin, float inMax, float outMin, float outMax) {
                    return outMin + (v - inMin) * (outMax - outMin) / (inMax - inMin);
                }

                float4 main(PS_IN pin) {
                    float4 mapCanvas = canvas.Sample(mapSample, pin.Tex);
                    float distanceDromCenter = clamp(distance(float2(0.5f, 0.5f), pin.Tex), zoom - 0.05f, zoom);
                    return lerp(mapCanvas, float4(0,0,0,0), remap(distanceDromCenter, zoom - 0.05f, zoom, 0, 1));
                }
            ]]
        })
    
        ui.drawImage(canvasZoom, -zoomScaled, currentWindowSize.x + zoomScaled)
    else
        offset = config.floorVec(offset)
        ui.drawImage(canvas, offset, baseWindowSize * mapSettings.store.mapScale + offset)
        if mapSettings.store.sectionsTrackActive then
            drawTrackSections()
        end
        drawPlayers()
    end
    config.resize(currentWindowSize, "Map")
    pinCheckBox.main(mapSettings.store.mapScale * 1.5, "Map", config.getWindow("Map"):pinned(), currentWindowSize)
end

initMap()

return map