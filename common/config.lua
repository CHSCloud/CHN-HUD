local config = {}

local windows = {}

local configStorage = ac.storage{
    ["Pedals"] = false,
    ["Pit Lane"] = false,
    ["Session Laps"] = false
}


local windowNames = {
    "Pedals",
    "Pit Lane",
    "Session Laps"
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
                        window:setPinned(configStorage[all[i].title])
                        windows[windowNames[j]] = window
                    end
                end
            end
        end
    end
end

function config.getWindow(name)
    local data = windows[name]
    if data == nil then 
        return nil 
    end
    return data
end

function config.resize(size, nameWindow)
    local window = config.getWindow(nameWindow)
    if window == nil then 
        return 
    end
    local ui_info = ac.getUI()
    window:resize(size * ui_info.uiScale)
end

function config.isMouseInWindow(mousePos, windowSize)
    if mousePos.x < 0 then return false end
    if mousePos.x > windowSize.x then return false end
    if mousePos.y < 0 then return false end
    if mousePos.y > windowSize.y then return false end
    return true
end

function config.pinWindow(nameWindow, windowSize)
    local win = config.getWindow(nameWindow)
    if config.isMouseInWindow(ui.mouseLocalPos(), windowSize) and ui.mouseClicked(ui.MouseButton.Right) and  win ~= nil then
        local pin = win:pinned()
        configStorage[nameWindow] = not pin
        win:setPinned(not pin)
    end
end


config.init()

return config
