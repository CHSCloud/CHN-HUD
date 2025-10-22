local config = {}

local windows = {}

local windowNames = {
    "HUD CHN",
    "Pit Lane"
}

function config.init()
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

config.init()

return config
