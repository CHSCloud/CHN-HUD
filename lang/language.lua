---@diagnostic disable: undefined-field
local language = {}

local settings = ac.storage{
    currentLanguage = "en"
}

local translations = {}

function language.setlanguage(key)
    local file_path = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\lang\\" .. key .. ".json"

    if io.fileExists(file_path) then
        local content = io.load(file_path)
        if content then
            translations = JSON.parse(content)
        end
    end
    
    settings.currentLanguage = key
end

function language.get(key)
    return translations[key]
end

function language.getCurrentLanguage()
    return settings.currentLanguage
end

language.loadTranslations()

return language