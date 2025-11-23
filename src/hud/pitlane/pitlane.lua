local pitlaneSettings = require("src.settings.tabs.pitLaneSettings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local pitlane = {}

function pitlane.windowMain()
  local currentWindowWidth = 150 * pitlaneSettings.store.pitlaneScale
  local currentWindowHeight = 70 * pitlaneSettings.store.pitlaneScale
  local currentWindowSize

  local posLimit = vec2(-10,5)
  local fontLimit = 16 * pitlaneSettings.store.pitlaneScale
  local posSpeedLimit = vec2(6, 22)
  local fontSpeedLimit = 30 * pitlaneSettings.store.pitlaneScale

  local posYou = vec2(63,5)
  local fontYou = 17 * pitlaneSettings.store.pitlaneScale
  local posSpeedYou = vec2(80, 22)
  local fontSpeedYou = 30 * pitlaneSettings.store.pitlaneScale 
  local fontSlowDown = 15 * pitlaneSettings.store.pitlaneScale

  local kmh_string
  local limitPit_string
  local speedrgb

  if SIM.focusedCar == 0 then
      ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
      if CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane or SettingsActive then
        if CAR.speedKmh > CAR.speedLimiter + 1 then
          currentWindowHeight = 100 * pitlaneSettings.store.pitlaneScale
        end
        --Background:
        if pitlaneSettings.store.optionPlate == "default" then
          ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, 70 * pitlaneSettings.store.pitlaneScale), WindowsColor, 10 * pitlaneSettings.store.pitlaneScale)
          ui.drawRectFilled(vec2(5, 5):scale(pitlaneSettings.store.pitlaneScale), vec2(75, 65):scale(pitlaneSettings.store.pitlaneScale), COLOR.WHITE, 5 * pitlaneSettings.store.pitlaneScale)
          ui.drawRect(vec2(7, 7):scale(pitlaneSettings.store.pitlaneScale), vec2(73, 63):scale(pitlaneSettings.store.pitlaneScale), COLOR.BLACK, 4 * pitlaneSettings.store.pitlaneScale, ui.CornerFlags.All, 1.5 * pitlaneSettings.store.pitlaneScale)
        elseif pitlaneSettings.store.optionPlate == "alert" then

          currentWindowWidth = 135 * pitlaneSettings.store.pitlaneScale
          ui.drawRectFilled(vec2(0, 0):scale(pitlaneSettings.store.pitlaneScale), vec2(135, 70):scale(pitlaneSettings.store.pitlaneScale), WindowsColor, 35 * pitlaneSettings.store.pitlaneScale, ui.CornerFlags.All)
          ui.drawCircleFilled(vec2(35,35):scale(pitlaneSettings.store.pitlaneScale), 34 * pitlaneSettings.store.pitlaneScale, COLOR.WHITE, 40 * pitlaneSettings.store.pitlaneScale)
          ui.drawCircle(vec2(35,35):scale(pitlaneSettings.store.pitlaneScale), 30 * pitlaneSettings.store.pitlaneScale, COLOR.RED, 40 * pitlaneSettings.store.pitlaneScale, 5 * pitlaneSettings.store.pitlaneScale)

          posLimit = vec2(-15,10)
          fontLimit = 13 * pitlaneSettings.store.pitlaneScale
          posSpeedLimit = vec2(0,22)
          fontSpeedLimit = 23 * pitlaneSettings.store.pitlaneScale

          posYou = vec2(45,5)
          posSpeedYou = vec2(62, 22)
          fontSpeedYou = 25 * pitlaneSettings.store.pitlaneScale

          fontSlowDown = 12 * pitlaneSettings.store.pitlaneScale
        end
        
        ui.setCursor(posLimit:scale(pitlaneSettings.store.pitlaneScale))
        ui.dwriteTextAligned(language.get("LIMIT"), fontLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(pitlaneSettings.store.pitlaneScale), false, COLOR.BLACK)
        ui.setCursor(posYou:scale(pitlaneSettings.store.pitlaneScale))
        ui.dwriteTextAligned(language.get("YOU"), fontYou, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(pitlaneSettings.store.pitlaneScale), false, COLOR.YELLOW_DARK)

        if(not (CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane) and SettingsActive) then
          kmh_string = "--"
          limitPit_string = "--"
          speedrgb = COLOR.WHITE
          currentWindowHeight = 70 * pitlaneSettings.store.pitlaneScale
        else 
          -- SPEED
          if(SelectedSpeed == "Km/h") then
            kmh_string = string.format("%.0f", CAR.speedKmh)
            limitPit_string = string.format("%.0f", CAR.speedLimiter)
          else
            kmh_string = string.format("%.0f", CAR.speedKmh * 0.621371)
            limitPit_string = string.format("%.0f", CAR.speedLimiter * 0.621371)
          end
          -- RGB SPEED
          if CAR.speedKmh <= CAR.speedLimiter then
            speedrgb = COLOR.WHITE
          elseif CAR.speedKmh > CAR.speedLimiter + 1 then
            if (5 * Timer) % 2 >= 1 then 
              ui.drawRectFilled(vec2(10, 75):scale(pitlaneSettings.store.pitlaneScale), vec2(currentWindowWidth - 10 * pitlaneSettings.store.pitlaneScale, currentWindowHeight), rgbm.from0255(50, 0, 0, 0.85), 10 * pitlaneSettings.store.pitlaneScale)
              ui.setCursor(vec2(0,75):scale(pitlaneSettings.store.pitlaneScale))
              ui.dwriteTextAligned(language.get("SLOW_DOWN"), fontSlowDown, ui.Alignment.Center, ui.Alignment.Center, vec2(currentWindowWidth, 25 * pitlaneSettings.store.pitlaneScale), false, rgbm.from0255(230, 0, 0, 1))
            end
            speedrgb = COLOR.RED
          end
        end
        ui.setCursor(posSpeedYou:scale(pitlaneSettings.store.pitlaneScale))
        ui.dwriteTextAligned(kmh_string, fontSpeedYou, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40):scale(pitlaneSettings.store.pitlaneScale), false, speedrgb)

        ui.setCursor(posSpeedLimit:scale(pitlaneSettings.store.pitlaneScale))
        ui.dwriteTextAligned(limitPit_string, fontSpeedLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(69, 40):scale(pitlaneSettings.store.pitlaneScale), false, COLOR.BLACK)
    end 
  end

  currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)

  config.resize(currentWindowSize, "Pit Lane")
  
  pinCheckBox.main(pitlaneSettings.store.pitlaneScale, "Pit Lane", config.getWindow("Pit Lane"):pinned(), currentWindowSize)
end

return pitlane