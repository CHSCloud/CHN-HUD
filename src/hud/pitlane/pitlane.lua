require("src.settings.settings")
local language = require("lang.language")
local pitlane = {}

function pitlane.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- Fonte do texto
    if CAR.manualPitsSpeedLimiterEnabled then
      ui.drawRectFilled(vec2(0, 0), vec2(150, 70), rgbm(0, 0, 0, 0.5), 10)
      ui.drawRectFilled(vec2(5, 5), vec2(75, 65), rgbm(1, 1, 1, 1), 5)
      ui.drawRectFilled(vec2(7, 7), vec2(73, 63), rgbm(0, 0, 0, 1), 5)
      ui.drawRectFilled(vec2(9, 9), vec2(71, 61), rgbm(1, 1, 1, 1), 5)

      ui.setCursor(vec2(-35,5))
      ui.dwriteTextAligned(language.get("LIMIT"), 17, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, rgbm(0, 0, 0, 1))
      ui.setCursor(vec2(37,5))
      ui.dwriteTextAligned(language.get("YOU"), 17, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, rgbm(1, 1, 0, 1))

      local speed
      if(SelectedSpeed == 1) then
        speed = string.format("%d", math.floor(CAR.speedKmh))
        limitPit = string.format("%d", CAR.speedLimiter)
      else
        speed = string.format("%d", math.floor(CAR.speedKmh * 0.621371))
        limitPit = string.format("%d", (CAR.speedLimiter* 0.621371))
      end
      ui.setCursor(vec2(80, 22))
      ui.dwriteTextAligned(speed, 30, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40), false, rgbm(1, 1, 1, 1))

      ui.setCursor(vec2(7,22))
      ui.dwriteTextAligned(limitPit, 30, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40), false, rgbm(0, 0, 0, 1))
    end
    
end

return pitlane