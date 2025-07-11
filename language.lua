Language = {}

local settings = ac.storage{
    currentLanguage = "pt-br"
}
local translations = {}

function Language.loadTranslations()
    local file_path = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\IracingIoverlay\\lang\\" .. settings.currentLanguage .. ".json"
    print("CARLOS")
    if io.fileExists(file_path) then
        local content = io.load(file_path)
        if content then
            translations = JSON.parse(content)
            return true
        end
    end
    return false
end

function Language.setLanguage(key)
    settings.currentLanguage = key
end

function Language.get(key)
    return translations[key]
end

Language.loadTranslations()