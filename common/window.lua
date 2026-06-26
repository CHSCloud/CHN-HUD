local window = {}

local defaultValues = {
    pinAllApps = false
}

window.store = ac.storage(defaultValues)

local pinStorage = ac.storage{
    ["Settings CHN"] = false,
    ["Pedals"] = false,
    ["Pit Lane"] = false,
    ["Session Laps"] = false,
    ["Starting Lights"] = false,
    ["Session Flags"] = false,
    ["Delta Bar"] = false,
    ["Map"] = false,
    ["Leaderboard"] = false,
}

local windowNames = {
    "Settings CHN",
    "Pedals",
    "Pit Lane",
    "Session Laps",
    "Starting Lights",
    "Session Flags",
    "Delta Bar",
    "Map",
    "Leaderboard"
}

function window.init()
    local all = ac.getAppWindows()
    local win
    for i=1, #all do
        for j=1, #windowNames do
            if all[i] ~= nil and all[i].title == windowNames[j] then
                if all[i].name ~= nil then
                    win = ac.accessAppWindow(all[i].name)
                    if win ~= nil then
                        if all[i].title ~= "Settings CHN" then
                            win:setPinned(pinStorage[all[i].title])
                        end
                        window[windowNames[j]] = win
                    end
                end
            end
        end
    end
end

--- @param name string
function window.getWindow(name)
    local data = window[name]
    if data == nil then 
        return nil 
    end
    return data
end

--- @param size vec2
--- @param nameWindow string
function window.resize(size, nameWindow)
    local window = window.getWindow(nameWindow)
    if window == nil then 
        return 
    end
    local ui_info = ac.getUI()
    window:resize(size * ui_info.uiScale)
end

--- @param mousePos vec2
--- @param x1 number
--- @param x2 number
--- @param y1 number
--- @param y2 number
--- @return boolean
function window.isMouseInWindow(mousePos, x1, x2, y1, y2)
    if mousePos.x < x1 then return false end
    if mousePos.x > x2 then return false end
    if mousePos.y < y1 then return false end
    if mousePos.y > y2 then return false end
    return true
end

--- @param nameWindow string
--- @return boolean | nil
function window.pinWindow(nameWindow)
    local win = window.getWindow(nameWindow)
    if win == nil then return nil end
    local pin = win:pinned()
    pinStorage[nameWindow] = not pin
    win:setPinned(not pin)
    window.store.pinAllApps = false
    return not pin
end

--- @param pin boolean
function window.pinAllApps(pin)
    window.store.pinAllApps = pin
    for _, name in ipairs(windowNames) do
        if name ~= "Settings CHN" then
            window.getWindow(name):setPinned(pin)
        end
    end
end

window.init()

return window
