require("src.settings.settings")
local language = require("lang.language")
local pitlane = {}

function pitlane.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- Fonte do texto
    if CAR.isInPitlane then
      ui.drawRectFilled(vec2(0, 0), vec2(270, 90), rgbm(0, 0, 0, 0.8), 5)
      ui.setCursor(vec2(55,5))
      ui.dwriteTextAligned(language.get("IN_PIT_LANE"), 25, ui.Alignment.Center, ui.Alignment.Start, vec2(150, 25), false, rgbm(1, 1, 0, 1))
      ui.setCursor(vec2(10,40))
      ui.dwriteTextAligned(language.get("PIT_SPEED_LIMIT"), 15, ui.Alignment.Start, ui.Alignment.Start, vec2(165, 25), false, rgbm(1, 1, 1, 1))
      ui.setCursor(vec2(10,60))
      ui.dwriteTextAligned(language.get("CURRENT_SPEED"), 15, ui.Alignment.Start, ui.Alignment.Start, vec2(165, 25), false, rgbm(1, 1, 1, 1))

      local speed
      if(SelectedSpeed == 1) then
        speed = string.format("%d km/h", math.floor(CAR.speedKmh))
        limitPit = string.format("%d km/h", CAR.speedLimiter)
      else
        speed = string.format("%d mph", math.floor(CAR.speedKmh * 0.621371))
        limitPit = string.format("%d mph", (CAR.speedLimiter* 0.621371))
      end
      ui.setCursor(vec2(180, 60))
      ui.dwriteTextAligned(speed, 15, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30), false, rgbm(1, 1, 1, 1))

      ui.setCursor(vec2(180,40))
      ui.dwriteTextAligned(limitPit, 15, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30), false, rgbm(1, 1, 1, 1))
    end
    
end

return pitlane