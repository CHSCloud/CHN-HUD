Language = {}

local settings = ac.storage{
    currentLanguage = "en"
}

local translations = {}

function Language.loadTranslations()
    local file_path = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\lang\\" .. settings.currentLanguage .. ".json"

    if io.fileExists(file_path) then
        local content = io.load(file_path)
        if content then
            translations = JSON.parse(content)
        end
    end
end

function Language.setLanguage(key)
    settings.currentLanguage = key
end

function Language.get(key)
    return translations[key]
end

function Language.getCurrentLanguage()
    return settings.currentLanguage
end
Language.loadTranslations()