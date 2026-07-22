local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local sessionLapsData = require("src.data.sessionLaps.sessionLapsData")
local utils = require("common.utils")
local sectors = {}


---@param data sessionLapsData
---@param sectorNumber number
local function drawSector(data, sectorNumber)
    data.currentWindowHeight = data.currentWindowHeight + 5
    ui.drawRectFilled(vec2(3, data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale), vec2(23,data.currentWindowHeight + 20):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.WHITE, 3)
    ui.setCursor(vec2(3, data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
    ui.dwriteTextAligned("S".. tostring(sectorNumber + 1), 12 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Center, ui.Alignment.Center, vec2(20,20):scale(sessionLapsSettings.store.sessionLapsScale),false, COLOR.BLACK)
    
    ui.setCursor(vec2(35, data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale))
    if data.sectorsTime[sectorNumber] == -1 then
        ui.dwriteTextAligned("--:--.---", 12 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(100,20):scale(sessionLapsSettings.store.sessionLapsScale),false, COLOR.WHITE)
    else
        local minutes = data.sectorsTime[sectorNumber] / 60E3
        local seconds = (minutes % 1) * 60
        local milliseconds = math.round((seconds % 1) * 1000)
        ui.dwriteTextAligned(string.format("%d:%02d.%03d", minutes, seconds, milliseconds), 12 * sessionLapsSettings.store.sessionLapsScale, ui.Alignment.Start, ui.Alignment.Center, vec2(100,20):scale(sessionLapsSettings.store.sessionLapsScale),false, COLOR.WHITE)
    end

    for i = 1, sessionLapsSettings.store.numberDivisions do
        local isPassed = false
        local color
        if not data.showLastDivisions then
            if CAR.currentSector > sectorNumber then
                isPassed = true
            elseif CAR.currentSector == sectorNumber then
                local divisions = data.sectorsDivisions[sectorNumber]
                local currentDiv = divisions[i]
                local firstDiv
                if sectorNumber == 0 then
                    firstDiv = divisions[1]
                else
                    firstDiv = data.sectorsDivisions[sectorNumber - 1][sessionLapsSettings.store.numberDivisions]
                end

                if CAR.splinePosition >= firstDiv and currentDiv < firstDiv then
                    isPassed = false
                else
                    isPassed = (CAR.splinePosition >= currentDiv)
                end
            end
            if isPassed and not (CAR.currentSector == 0 and CAR.splinePosition > SIM.lapSplits[1])then
                if data.currentSectorsDivisionsTime[sectorNumber][i] == -1 then
                    data.currentSectorsDivisionsTime[sectorNumber][i] = sessionLapsData.getTimeOfDivision(data, sectorNumber, i)

                    local minutes = data.currentSectorsDivisionsTime[sectorNumber][i] / 60E3
                    local seconds = (minutes % 1) * 60
                    local milliseconds = math.round((seconds % 1) * 1000)
                    
                    ac.log("Atual recebe: " .. string.format("%d:%02d.%03d", minutes, seconds, milliseconds))
                end
                if CAR.lapCount == 0 then
                    color = COLOR.WHITE
                else
                    if data.currentSectorsDivisionsTime[sectorNumber][i] < data.lastSectorsDivisionsTime[sectorNumber][i] then
                        color = COLOR.GREEN
                    else
                        color = COLOR.RED
                    end
                end
            else
                color = COLOR.GRAY_BG
            end
        else
            if CAR.lapCount == 1 then
                color = COLOR.WHITE
            else
                if data.currentSectorsDivisionsTime[sectorNumber][i] < data.lastSectorsDivisionsTime[sectorNumber][i] then
                    color = COLOR.GREEN
                else
                    color = COLOR.RED
                end
            end

            if sectorNumber == 0 and i == 1 and CAR.splinePosition >= data.sectorsDivisions[sectorNumber][i] then
                data.showLastDivisions = false
                ac.log("COPIOU PARA O LAST")
                for i = 0, #SIM.lapSplits - 1 do
                    utils.copyTable(data.currentSectorsDivisionsTime[i], data.lastSectorsDivisionsTime[i])
                end
                sessionLapsData.resetCurrentDivision(data, sessionLapsSettings.store.numberDivisions - 1)
                data.currentSectorsDivisionsTime[sectorNumber][i] = sessionLapsData.getTimeOfDivision(data, sectorNumber, i)
            end
        end

        -- Renderização visual do círculo
        local x = 110 + (i * (100 / (sessionLapsSettings.store.numberDivisions + 1)))
        ui.drawCircleFilled(
            vec2(x, data.currentWindowHeight + 10):scale(sessionLapsSettings.store.sessionLapsScale), 
            3 * sessionLapsSettings.store.sessionLapsScale, 
            color, 
            10
        )
    end

    data.currentWindowHeight = data.currentWindowHeight + 20
end


---@param data sessionLapsData
function sectors.drawSectors(data)
    ui.drawRectFilled(vec2(5, data.currentWindowHeight):scale(sessionLapsSettings.store.sessionLapsScale), vec2(235, data.currentWindowHeight + 1):scale(sessionLapsSettings.store.sessionLapsScale), COLOR.WHITE, 1)
    
    if CAR.currentSector == 1  and data.sectorsTime[CAR.currentSector] ~= -1 then
        sessionLapsData.resetSectors(data)
    end

    if data.lastSectorTime ~= CAR.previousSectorTime and CAR.previousSectorTime ~= 0 then
        data.sectorsTime[(CAR.currentSector - 1) % 3] = CAR.previousSectorTime
        data.lastSectorTime = CAR.previousSectorTime
    elseif CAR.lastSplits[2] ~= nil and CAR.previousSectorTime == 0 then
        data.sectorsTime[(CAR.currentSector - 1) % 3] = CAR.lastSplits[2]
        data.lastSectorTime = CAR.lastSplits[2]
    end
    if data.lastLapNumber ~= CAR.lapCount then
        data.lastLapNumber = CAR.lapCount 
        data.showLastDivisions = true
    end

    for sector = 0, #SIM.lapSplits - 1 do
        drawSector(data, sector)
    end

    data.currentWindowHeight = data.currentWindowHeight + 5

    --[[
    ac.log("Posicao: ".. string.format("%.2f",CAR.splinePosition))
    ac.log("splits ".. tostring(SIM.lapSplits))
    ac.log("Tempo do setor ".. tostring(CAR.previousSectorTime))
    ac.log("Setor Atual ".. tostring(CAR.currentSector))
    ac.log("Tempos dos setores ".. tostring(CAR.currentSplits))]]
end

return sectors