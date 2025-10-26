require("src.settings.settings")
local language = require("lang.language")
local config = require("common.config")
local pitlane = {}

function pitlane.windowMain()
  local currentWindowWidth = 0
  local currentWindowHeight = 70 * WindowPitScale

  local posLimit = vec2(-10,5)
  local fontLimit = 17 * WindowPitScale
  local posSpeedLimit = vec2(6, 22)
  local fontSpeedLimit = 30 * WindowPitScale

  local posYou = vec2(63,5)
  local fontYou = 17 * WindowPitScale
  local posSpeedYou = vec2(80, 22)
  local fontSpeedYou = 30 * WindowPitScale

  local fontSlowDown = 15 * WindowPitScale
  if SIM.focusedCar == 0 then
      ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONTE DO TEXTO
      if CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane or SettingsActive then
        if CAR.speedKmh > CAR.speedLimiter + 1 then
          currentWindowHeight = 100 * WindowPitScale
        end
        --Background:
        if OptionPlate == "default" then
          currentWindowWidth = 150 * WindowPitScale
          ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, 70 * WindowPitScale), WindowsColor, 10 * WindowPitScale)
          ui.drawRectFilled(vec2(5, 5):scale(WindowPitScale), vec2(75, 65):scale(WindowPitScale), rgbm.from0255(255, 255, 255, 1), 5 * WindowPitScale)
          ui.drawRectFilled(vec2(7, 7):scale(WindowPitScale), vec2(73, 63):scale(WindowPitScale), rgbm.from0255(0, 0, 0, 1), 5 * WindowPitScale)
          ui.drawRectFilled(vec2(9, 9):scale(WindowPitScale), vec2(71, 61):scale(WindowPitScale), rgbm.from0255(255, 255, 255, 1), 5 * WindowPitScale) 
        elseif OptionPlate == "alert" then

          currentWindowWidth = 135 * WindowPitScale
          ui.image("assets/backgroundpit.png", vec2(currentWindowWidth, 70 * WindowPitScale), WindowsColor, ui.ImageFit.Fit)
          ui.setCursor(vec2(1, 1):scale(WindowPitScale))
          ui.image("assets/alertlimitrpm.png", vec2(68,68):scale(WindowPitScale), rgbm.from0255(255, 255, 255, 1), ui.ImageFit.Fit)
          posLimit = vec2(-15,10)
          fontLimit = 13 * WindowPitScale
          posSpeedLimit = vec2(0,22)
          fontSpeedLimit = 23 * WindowPitScale

          posYou = vec2(50,5)
          posSpeedYou = vec2(67, 22)
          fontSpeedYou = 28 * WindowPitScale

          fontSlowDown = 12 * WindowPitScale
        end
        
        ui.setCursor(posLimit:scale(WindowPitScale))
        ui.dwriteTextAligned(language.get("LIMIT"), fontLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(WindowPitScale), false, rgbm.from0255(0, 0, 0, 1))
        ui.setCursor(posYou:scale(WindowPitScale))
        ui.dwriteTextAligned(language.get("YOU"), fontYou, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(WindowPitScale), false, rgbm.from0255(255, 203, 0, 1))

        if(not (CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane) and SettingsActive) then
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
            ui.drawRectFilled(vec2(10, 75):scale(WindowPitScale), vec2(currentWindowWidth - 10 * WindowPitScale, currentWindowHeight), rgbm.from0255(50, 0, 0, 0.85), 10 * WindowPitScale)
            ui.setCursor(vec2(0,75):scale(WindowPitScale))
            ui.dwriteTextAligned(language.get("SLOW_DOWN"), fontSlowDown, ui.Alignment.Center, ui.Alignment.Center, vec2(currentWindowWidth, 25 * WindowPitScale), false, rgbm.from0255(230, 0, 0, 1))
            speedrgb = rgbm.from0255(255, 0, 0, 1)
          end
        end
        ui.setCursor(posSpeedYou:scale(WindowPitScale))
        ui.dwriteTextAligned(kmh_string, fontSpeedYou, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40):scale(WindowPitScale), false, speedrgb)

        ui.setCursor(posSpeedLimit:scale(WindowPitScale))
        ui.dwriteTextAligned(limitPit_string, fontSpeedLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(69, 40):scale(WindowPitScale), false, rgbm.from0255(0, 0, 0, 1))
    end 
  end
  config.resize(vec2(currentWindowWidth, currentWindowHeight), "Pit Lane")
end

return pitlane