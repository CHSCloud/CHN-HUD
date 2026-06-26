local language = {}

local languageSettings = ac.storage {
    currentLanguage = 1
}

language.languages = {
    "English",
    "Português - Brasil",
    "Español"
}

local codes = {
    "en",
    "pt-br",
    "es"
}

local translations = {}

local function loadTranslations()
    local file_path = ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\language\\languages\\" .. codes[languageSettings.currentLanguage] .. ".json"

    if io.fileExists(file_path) then
        local content = io.load(file_path)
        if content then
            translations = JSON.parse(content)
        end
    end
end

function language.setlanguage(key)
    languageSettings.currentLanguage = key
    loadTranslations()
end

function language.get(key)
    return translations[key]
end

function language.getCurrentLanguage()
    return languageSettings.currentLanguage
end

loadTranslations()

return language