require("src.settings.settings")
local language = require("lang.language")
local pitlane = {}

function pitlane.windowMain()
  if(SIM.focusedCar == 0) then
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONTE DO TEXTO
    if CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane or SettingsActive then
      ui.drawRectFilled(vec2(0, 0), vec2(150, 70), WindowsColor, 10)
      ui.drawRectFilled(vec2(5, 5), vec2(75, 65), rgbm.from0255(255, 255, 255, 1), 5)
      ui.drawRectFilled(vec2(7, 7), vec2(73, 63), rgbm.from0255(0, 0, 0, 1), 5)
      ui.drawRectFilled(vec2(9, 9), vec2(71, 61), rgbm.from0255(255, 255, 255, 1), 5)

      

      ui.setCursor(vec2(-35,5))
      ui.dwriteTextAligned(language.get("LIMIT"), 17, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, rgbm.from0255(0, 0, 0, 1))
      ui.setCursor(vec2(37,5))
      ui.dwriteTextAligned(language.get("YOU"), 17, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, rgbm.from0255(255, 203, 0, 1))

      if(SettingsActive and not (CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane)) then
        kmh_string = "--"
        limitPit_string = "--"
      else 
        -- SPEED
        if(SelectedSpeed == 1) then
          kmh_string = string.format("%.0f", CAR.speedKmh)
          limitPit_string = string.format("%.0f", CAR.speedLimiter)
        else
          kmh_string = string.format("%.0f", CAR.speedKmh * 0.621371)
          limitPit_string = string.format("%.0f", CAR.speedLimiter * 0.621371)
        end

        -- RGB SPEED
        if CAR.speedKmh <= CAR.speedLimiter then
          speedrgb = rgbm.from0255(255, 255, 255, 1)
        elseif CAR.speedKmh > CAR.speedLimiter + 1 then
          ui.drawRectFilled(vec2(10, 75), vec2(140, 100), rgbm.from0255(50, 0, 0, 0.85), 10)
          ui.setCursor(vec2(0,75))
          ui.dwriteTextAligned(language.get("SLOW_DOWN"), 15, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25), false, rgbm.from0255(230, 0, 0, 1))
          speedrgb = rgbm.from0255(255, 0, 0, 1)
        end
      end

      ui.setCursor(vec2(80, 22))
      ui.dwriteTextAligned(kmh_string, 30, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40), false, speedrgb)

      ui.setCursor(vec2(7,22))
      ui.dwriteTextAligned(limitPit_string, 30, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40), false, rgbm.from0255(0, 0, 0, 1))

    end
  end    
end

return pitlane