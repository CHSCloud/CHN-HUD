local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local pitLane = {}

function pitLane.windowMain()
  local currentWindowWidth = 150 * pitLaneSettings.store.pitLaneScale
  local currentWindowHeight = 70 * pitLaneSettings.store.pitLaneScale
  local currentWindowSize

  local posLimit = vec2(-10,5)
  local fontLimit = 16 * pitLaneSettings.store.pitLaneScale
  local posSpeedLimit = vec2(6, 22)
  local fontSpeedLimit = 30 * pitLaneSettings.store.pitLaneScale

  local posYou = vec2(63,5)
  local fontYou = 17 * pitLaneSettings.store.pitLaneScale
  local posSpeedYou = vec2(80, 22)
  local fontSpeedYou = 30 * pitLaneSettings.store.pitLaneScale 
  local fontSlowDown = 15 * pitLaneSettings.store.pitLaneScale

  local kmh_string
  local limitPit_string
  local speedrgb

  if SIM.focusedCar == 0 then
      ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
      if CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane or SettingsActive then
        if CAR.speedKmh > CAR.speedLimiter + 1 then
          currentWindowHeight = 100 * pitLaneSettings.store.pitLaneScale
        end
        --Background:
        if pitLaneSettings.store.optionPlate == "default" then
          ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, 70 * pitLaneSettings.store.pitLaneScale), WindowsColor, 10 * pitLaneSettings.store.pitLaneScale)
          ui.drawRectFilled(vec2(5, 5):scale(pitLaneSettings.store.pitLaneScale), vec2(75, 65):scale(pitLaneSettings.store.pitLaneScale), COLOR.WHITE, 5 * pitLaneSettings.store.pitLaneScale)
          ui.drawRect(vec2(7, 7):scale(pitLaneSettings.store.pitLaneScale), vec2(73, 63):scale(pitLaneSettings.store.pitLaneScale), COLOR.BLACK, 4 * pitLaneSettings.store.pitLaneScale, ui.CornerFlags.All, 1.5 * pitLaneSettings.store.pitLaneScale)
        elseif pitLaneSettings.store.optionPlate == "alert" then

          currentWindowWidth = 135 * pitLaneSettings.store.pitLaneScale
          ui.drawRectFilled(vec2(0, 0):scale(pitLaneSettings.store.pitLaneScale), vec2(135, 70):scale(pitLaneSettings.store.pitLaneScale), WindowsColor, 35 * pitLaneSettings.store.pitLaneScale, ui.CornerFlags.All)
          ui.drawCircleFilled(vec2(35,35):scale(pitLaneSettings.store.pitLaneScale), 34 * pitLaneSettings.store.pitLaneScale, COLOR.WHITE, 40 * pitLaneSettings.store.pitLaneScale)
          ui.drawCircle(vec2(35,35):scale(pitLaneSettings.store.pitLaneScale), 31 * pitLaneSettings.store.pitLaneScale, COLOR.RED, 40 * pitLaneSettings.store.pitLaneScale, 5 * pitLaneSettings.store.pitLaneScale)

          posLimit = vec2(-15,10)
          fontLimit = 13 * pitLaneSettings.store.pitLaneScale
          posSpeedLimit = vec2(0,22)
          fontSpeedLimit = 23 * pitLaneSettings.store.pitLaneScale

          posYou = vec2(45,5)
          posSpeedYou = vec2(62, 22)
          fontSpeedYou = 25 * pitLaneSettings.store.pitLaneScale

          fontSlowDown = 12 * pitLaneSettings.store.pitLaneScale
        end
        
        ui.setCursor(posLimit:scale(pitLaneSettings.store.pitLaneScale))
        ui.dwriteTextAligned(language.get("LIMIT"), fontLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(pitLaneSettings.store.pitLaneScale), false, COLOR.BLACK)
        ui.setCursor(posYou:scale(pitLaneSettings.store.pitLaneScale))
        ui.dwriteTextAligned(language.get("YOU"), fontYou, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(pitLaneSettings.store.pitLaneScale), false, COLOR.YELLOW_DARK)

        if(not (CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane) and SettingsActive) then
          kmh_string = "--"
          limitPit_string = "--"
          speedrgb = COLOR.WHITE
          currentWindowHeight = 70 * pitLaneSettings.store.pitLaneScale
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
              ui.drawRectFilled(vec2(10, 75):scale(pitLaneSettings.store.pitLaneScale), vec2(currentWindowWidth - 10 * pitLaneSettings.store.pitLaneScale, currentWindowHeight), rgbm.from0255(50, 0, 0, 0.85), 10 * pitLaneSettings.store.pitLaneScale)
              ui.setCursor(vec2(0,75):scale(pitLaneSettings.store.pitLaneScale))
              ui.dwriteTextAligned(language.get("SLOW_DOWN"), fontSlowDown, ui.Alignment.Center, ui.Alignment.Center, vec2(currentWindowWidth, 25 * pitLaneSettings.store.pitLaneScale), false, rgbm.from0255(230, 0, 0, 1))
            end
            speedrgb = COLOR.RED
          end
        end
        ui.setCursor(posSpeedYou:scale(pitLaneSettings.store.pitLaneScale))
        ui.dwriteTextAligned(kmh_string, fontSpeedYou, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40):scale(pitLaneSettings.store.pitLaneScale), false, speedrgb)

        ui.setCursor(posSpeedLimit:scale(pitLaneSettings.store.pitLaneScale))
        ui.dwriteTextAligned(limitPit_string, fontSpeedLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(69, 40):scale(pitLaneSettings.store.pitLaneScale), false, COLOR.BLACK)
    end 
  end

  currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)

  config.resize(currentWindowSize, "Pit Lane")
  
  pinCheckBox.main(pitLaneSettings.store.pitLaneScale, "Pit Lane", config.getWindow("Pit Lane"):pinned(), currentWindowSize)
end

return pitLane
