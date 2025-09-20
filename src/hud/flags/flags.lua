local language = require("lang.language")
local flags = {}

local fl = ac.FlagType

function flags.windowMain()
    if fl == 1 then
        ui.setCursor(vec2(137, 22))
        ui.image("assets/GreenFlag.png", vec2(65, 72), ui.ImageFit.Fit)
    end

end
return flags