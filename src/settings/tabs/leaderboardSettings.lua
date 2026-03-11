local language = require("lang.language")
local toggleButton = require("src.ui.toggleButton")
local button = require("src.ui.button")
local slider = require("src.ui.slider")

local leaderboardSettings = {}

local defaultValues = {
    leaderboardScale = 1,

    numDrivers = 10,

    tyreActive = true,

    lapCountActive = true,

    lastLapActive = true,

    statusActive = true,

    focusedCarActive = true
}

leaderboardSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        leaderboardSettings.store[key] = value
    end
end

---comment
---@param pos vec2
local function drawContents(pos)
    if toggleButton.main("tyresToggle", pos, leaderboardSettings.store.tyreActive, "Tyres") then
        leaderboardSettings.store.tyreActive = not leaderboardSettings.store.tyreActive
    end
    pos.y = pos.y + 25

    if toggleButton.main("lapsToggle", pos, leaderboardSettings.store.lapCountActive, "Lap count") then
        leaderboardSettings.store.lapCountActive = not leaderboardSettings.store.lapCountActive
    end
    pos.y = pos.y + 25
        
    if toggleButton.main("lastLapToggle", pos, leaderboardSettings.store.lastLapActive, "Last lap time") then
        leaderboardSettings.store.lastLapActive = not leaderboardSettings.store.lastLapActive
    end
    pos.y = pos.y + 25
        
    if toggleButton.main("statusToggle", pos, leaderboardSettings.store.statusActive, "Tyres") then
        leaderboardSettings.store.statusActive = not leaderboardSettings.store.statusActive
    end
    pos.y = pos.y + 40

    if toggleButton.main("focusedCarToggle", pos, leaderboardSettings.store.focusedCarActive, "Always display Focused Car") then
        leaderboardSettings.store.focusedCarActive = not leaderboardSettings.store.focusedCarActive
    end
    pos.y = pos.y + 25

    return pos.y
end

function leaderboardSettings.leaderboardSettings()
    local posY = 75

    -- Escala:
    leaderboardSettings.store.leaderboardScale = slider.main(language.get("SIZE"), string.format("%.2f", leaderboardSettings.store.leaderboardScale), vec2(20, posY), 250, leaderboardSettings.store.leaderboardScale, 0.7, 2)
    posY = posY + 50

    -- Número de players no placar:
    leaderboardSettings.store.numDrivers = math.floor(slider.main("Num of drivers", string.format("%i", leaderboardSettings.store.numDrivers), vec2(20, posY), 250, leaderboardSettings.store.numDrivers, 1, 20))

    posY = posY + 40
    posY = drawContents(vec2(20, posY))

    posY = posY + 40


    if button.main(vec2(20, posY), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end 
end


return leaderboardSettings