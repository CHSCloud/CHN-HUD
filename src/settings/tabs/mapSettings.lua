local mapSettings = {}
local config = require("common.config")
local language = require("lang.language")

local defaultValues = {
    mapScale = 1,
    angle = 0
}


mapSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        mapSettings.store[key] = value
    end
end

function mapSettings.mapSettings()
    local initPos = 55

    -- Escala:
    ui.setCursor(vec2(15, initPos))
    ui.header(language.get("SIZE"))
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    mapSettings.store.mapScale = ui.slider("##Size", mapSettings.store.mapScale, 0.7, 3, string.format("%.2f", mapSettings.store.mapScale))
    initPos = initPos + 20

    
    ui.setCursor(vec2(15, initPos))
    ui.header("Angle")
    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))
    mapSettings.store.angle = ui.slider("##Angle", mapSettings.store.angle, 0, 360, string.format("%.0f", mapSettings.store.angle))

    initPos = initPos + 40
    ui.setCursor(vec2(20, initPos))
    if ui.button(language.get("RESET_DEFAULT")) then
        resetToDefault()
    end

end

return mapSettings