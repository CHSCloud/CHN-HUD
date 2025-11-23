local simpleCheckbox = {}

--- @param label string
--- @param key boolean
--- @param xOffset number
--- @param yOffset number
--- @return boolean
function simpleCheckbox.main(label, key, xOffset, yOffset)
    ui.setCursor(vec2(xOffset, yOffset))
    if ui.checkbox(label, key) then
        return not key
    end
    return key
end

return simpleCheckbox