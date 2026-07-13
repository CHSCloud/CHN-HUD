local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local sessionLapsData = require("src.data.sessionLaps.sessionLapsData")
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

    drawSector(data, 0)

    drawSector(data, 1)

    drawSector(data, 2)

    data.currentWindowHeight = data.currentWindowHeight + 5

    ac.log("Posicao: ".. string.format("%.2f",CAR.splinePosition))
    ac.log("splits ".. tostring(SIM.lapSplits))
    ac.log("Tempo do setor ".. tostring(CAR.previousSectorTime))
    ac.log("Setor Atual ".. tostring(CAR.currentSector))
    ac.log("Tempos dos setores ".. tostring(CAR.currentSplits))
end

return sectors