---@diagnostic disable: undefined-field
local language = {}

local settings = ac.storage{
    currentLanguage = "en"
}

local translations = {}
local function loadTranslations()
    local file_path = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\lang\\" .. settings.currentLanguage .. ".json"

    if io.fileExists(file_path) then
        local content = io.load(file_path)
        if content then
            translations = JSON.parse(content)
        end
    end
end

function language.setlanguage(key)
    settings.currentLanguage = key
    loadTranslations()
end

function language.get(key)
    return translations[key]
end

function language.getCurrentLanguage()
    return settings.currentLanguage
end

loadTranslations()

return language