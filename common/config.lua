
local config = {}

local windows = {}

local defaultValues = {
    pinAllApps = false
}

config.store = ac.storage(defaultValues)

local pinStorage = ac.storage{
    ["Settings CHN"] = false,
    ["Pedals"] = false,
    ["Pit Lane"] = false,
    ["Session Laps"] = false,
    ["Starting Lights"] = false,
    ["Session Flags"] = false,
    ["Map"] = false
}

local windowNames = {
    "Settings CHN",
    "Pedals",
    "Pit Lane",
    "Session Laps",
    "Starting Lights",
    "Session Flags",
    "Map"
}

function config.init()
    local all = ac.getAppWindows()
    local window
    for i=1, #all do
        for j=1, #windowNames do
            if all[i] ~= nil and all[i].title == windowNames[j] then
                if all[i].name ~= nil then
                    window = ac.accessAppWindow(all[i].name)
                    if window ~= nil then
                        if all[i].title ~= "Settings CHN" then
                            window:setPinned(pinStorage[all[i].title])
                        end
                        windows[windowNames[j]] = window
                    end
                end
            end
        end
    end
end

--- @param value number
--- @param inMin number
--- @param inMax number
--- @param outMin number
--- @param outMax number
--- @return number
function config.remapIntervalWithLimits(value, inMin, inMax, outMin, outMax)
    local output = outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
    if output > outMax then
        output = outMax
    elseif output < outMin then
        output = outMin
    end
    return output
end

--- @param value number
--- @param inMin number
--- @param inMax number
--- @param outMin number
--- @param outMax number
--- @return number
function config.remapInterval(value, inMin, inMax, outMin, outMax)
    return (outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin))
end

--- @param vec vec2 -- Vetor a ser rotacionado
--- @param angleDeg number -- Ângulo em graus
--- @return vec2
function config.rotateVec(vec, angleDeg)
    local rad = math.rad(angleDeg)
    local sin = math.sin(rad)
    local cos = math.cos(rad)
    return vec2(vec.x * cos - vec.y * sin, vec.x * sin + vec.y * cos)
end

--- @param vec vec2
--- @return vec2
function config.floorVec(vec)
    return vec2(math.floor(vec.x), math.floor(vec.y))
end


---@param value number
---@param places number
---@return number
function config.decimal(value, places)
    local factor = 10 ^ places
    return math.floor(value * factor) / factor
end

--- @param from table
--- @param to table
function config.copyTable(from, to)
    for k, v in pairs(from) do
        to[k] = v
    end
end

--- @param name string
function config.getWindow(name)
    local data = windows[name]
    if data == nil then 
        return nil 
    end
    return data
end

--- @param size vec2
--- @param nameWindow string
function config.resize(size, nameWindow)
    local window = config.getWindow(nameWindow)
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
function config.isMouseInWindow(mousePos, x1, x2, y1, y2)
    if mousePos.x < x1 then return false end
    if mousePos.x > x2 then return false end
    if mousePos.y < y1 then return false end
    if mousePos.y > y2 then return false end
    return true
end

--- @param nameWindow string
--- @return boolean | nil
function config.pinWindow(nameWindow)
    local win = config.getWindow(nameWindow)
    if win == nil then return nil end
    local pin = win:pinned()
    pinStorage[nameWindow] = not pin
    win:setPinned(not pin)
    config.store.pinAllApps = false
    return not pin
end

--- @param pin boolean
function config.pinAllApps(pin)
    config.store.pinAllApps = pin
    for index, name in ipairs(windowNames) do
        if name ~= "Settings CHN" then
            config.getWindow(name):setPinned(pin)
        end
    end
end

config.init()

return config
