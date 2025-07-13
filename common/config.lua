Config = {}

local windows = {}

local windowNames = {
    "HUD"
}

function Config.init()
    local all = ac.getAppWindows()
    for i=1, #all do
        for j=1, #windowNames do
            if all[i] ~= nil and all[i].title == windowNames[j] then
                if all[i].name ~= nil then
                    windows[windowNames[j]] = ac.accessAppWindow(all[i].name)
                end
            end
        end
    end
end

function Config.getWindow(name)
    local data = windows[name]
    if data == nil then 
        return nil 
    end
    return data
end

function Config.resize(size, nameWindow)
    local window = Config.getWindow(nameWindow)
    if window == nil then 
        return 
    end
    local ui_info = ac.getUI()
    window:resize(size * ui_info.uiScale)
end

Config.init()
