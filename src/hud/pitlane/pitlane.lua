require("src.settings.settings")
local language = require("lang.language")
local pitlane = {}
local config = require("common.config")

function pitlane.windowMain()
  local currentWindowWidth = 150 *WindowPitScale
  local currentWindowHeight = 100 *WindowPitScale

  if(SIM.focusedCar == 0) then
      ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONTE DO TEXTO
      if CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane then
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, 70 * WindowPitScale), WindowsColor, 10 * WindowPitScale)
        ui.drawRectFilled(vec2(5, 5):scale(WindowPitScale), vec2(75, 65):scale(WindowPitScale), rgbm.from0255(255, 255, 255, 1), 5 * WindowPitScale)
        ui.drawRectFilled(vec2(7, 7):scale(WindowPitScale), vec2(73, 63):scale(WindowPitScale), rgbm.from0255(0, 0, 0, 1), 5 * WindowPitScale)
        ui.drawRectFilled(vec2(9, 9):scale(WindowPitScale), vec2(71, 61):scale(WindowPitScale), rgbm.from0255(255, 255, 255, 1), 5 * WindowPitScale) 

        

        ui.setCursor(vec2(-35,5):scale(WindowPitScale))
        ui.dwriteTextAligned(language.get("LIMIT"), 17 * WindowPitScale, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25):scale(WindowPitScale), false, rgbm.from0255(0, 0, 0, 1))
        ui.setCursor(vec2(37,5):scale(WindowPitScale))
        ui.dwriteTextAligned(language.get("YOU"), 17 * WindowPitScale, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25):scale(WindowPitScale), false, rgbm.from0255(255, 203, 0, 1))

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
          ui.drawRectFilled(vec2(10, 75):scale(WindowPitScale), vec2(140, 100):scale(WindowPitScale), rgbm.from0255(50, 0, 0, 0.85), 10 * WindowPitScale)
          ui.setCursor(vec2(0,75):scale(WindowPitScale))
          ui.dwriteTextAligned(language.get("SLOW_DOWN"), 15 * WindowPitScale, ui.Alignment.Center, ui.Alignment.Center, vec2(150, 25):scale(WindowPitScale), false, rgbm.from0255(230, 0, 0, 1))
          speedrgb = rgbm.from0255(255, 0, 0, 1)
        end

        ui.setCursor(vec2(80, 22):scale(WindowPitScale))
        ui.dwriteTextAligned(kmh_string, 30 * WindowPitScale, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40):scale(WindowPitScale), false, speedrgb)

        ui.setCursor(vec2(7,22):scale(WindowPitScale))
        ui.dwriteTextAligned(limitPit_string, 30 * WindowPitScale, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40):scale(WindowPitScale), false, rgbm.from0255(0, 0, 0, 1))
      
      end
    end 
  end
  config.resize(vec2(currentWindowWidth, currentWindowHeight), "Pit Lane")
end

return pitlane