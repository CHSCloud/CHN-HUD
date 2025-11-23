require("src.settings.settings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local pitlane = {}

function pitlane.windowMain()
  local currentWindowWidth = 150 * WindowPitScale
  local currentWindowHeight = 70 * WindowPitScale
  local currentWindowSize

  local posLimit = vec2(-10,5)
  local fontLimit = 16 * WindowPitScale
  local posSpeedLimit = vec2(6, 22)
  local fontSpeedLimit = 30 * WindowPitScale

  local posYou = vec2(63,5)
  local fontYou = 17 * WindowPitScale
  local posSpeedYou = vec2(80, 22)
  local fontSpeedYou = 30 * WindowPitScale 
  local fontSlowDown = 15 * WindowPitScale

  local kmh_string
  local limitPit_string
  local speedrgb

  if SIM.focusedCar == 0 then
      ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONTE DO TEXTO
      if CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane or SettingsActive then
        if CAR.speedKmh > CAR.speedLimiter + 1 then
          currentWindowHeight = 100 * WindowPitScale
        end
        --Background:
        if OptionPlate == "default" then
          ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, 70 * WindowPitScale), WindowsColor, 10 * WindowPitScale)
          ui.drawRectFilled(vec2(5, 5):scale(WindowPitScale), vec2(75, 65):scale(WindowPitScale), COLOR.WHITE, 5 * WindowPitScale)
          ui.drawRect(vec2(7, 7):scale(WindowPitScale), vec2(73, 63):scale(WindowPitScale), COLOR.BLACK, 4 * WindowPitScale, ui.CornerFlags.All, 1.5 * WindowPitScale)
        elseif OptionPlate == "alert" then

          currentWindowWidth = 135 * WindowPitScale
          ui.drawRectFilled(vec2(0, 0):scale(WindowPitScale), vec2(135, 70):scale(WindowPitScale), WindowsColor, 35 * WindowPitScale, ui.CornerFlags.All)
          ui.drawCircleFilled(vec2(35,35):scale(WindowPitScale), 34 * WindowPitScale, COLOR.WHITE, 40 * WindowPitScale)
          ui.drawCircle(vec2(35,35):scale(WindowPitScale), 30 * WindowPitScale, COLOR.RED, 40 * WindowPitScale, 5 * WindowPitScale)

          posLimit = vec2(-15,10)
          fontLimit = 13 * WindowPitScale
          posSpeedLimit = vec2(0,22)
          fontSpeedLimit = 23 * WindowPitScale

          posYou = vec2(45,5)
          posSpeedYou = vec2(62, 22)
          fontSpeedYou = 25 * WindowPitScale

          fontSlowDown = 12 * WindowPitScale
        end
        
        ui.setCursor(posLimit:scale(WindowPitScale))
        ui.dwriteTextAligned(language.get("LIMIT"), fontLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(WindowPitScale), false, COLOR.BLACK)
        ui.setCursor(posYou:scale(WindowPitScale))
        ui.dwriteTextAligned(language.get("YOU"), fontYou, ui.Alignment.Center, ui.Alignment.Center, vec2(100, 25):scale(WindowPitScale), false, COLOR.YELLOW_DARK)

        if(not (CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane) and SettingsActive) then
          kmh_string = "--"
          limitPit_string = "--"
          speedrgb = COLOR.WHITE
          currentWindowHeight = 70 * WindowPitScale
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
              ui.drawRectFilled(vec2(10, 75):scale(WindowPitScale), vec2(currentWindowWidth - 10 * WindowPitScale, currentWindowHeight), rgbm.from0255(50, 0, 0, 0.85), 10 * WindowPitScale)
              ui.setCursor(vec2(0,75):scale(WindowPitScale))
              ui.dwriteTextAligned(language.get("SLOW_DOWN"), fontSlowDown, ui.Alignment.Center, ui.Alignment.Center, vec2(currentWindowWidth, 25 * WindowPitScale), false, rgbm.from0255(230, 0, 0, 1))
            end
            speedrgb = COLOR.RED
          end
        end
        ui.setCursor(posSpeedYou:scale(WindowPitScale))
        ui.dwriteTextAligned(kmh_string, fontSpeedYou, ui.Alignment.Center, ui.Alignment.Center, vec2(65, 40):scale(WindowPitScale), false, speedrgb)

        ui.setCursor(posSpeedLimit:scale(WindowPitScale))
        ui.dwriteTextAligned(limitPit_string, fontSpeedLimit, ui.Alignment.Center, ui.Alignment.Center, vec2(69, 40):scale(WindowPitScale), false, COLOR.BLACK)
    end 
  end

  currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)
  config.resize(currentWindowSize, "Pit Lane")

  if config.isMouseInWindow(ui.mouseLocalPos(), 0, currentWindowWidth + (PinCheckLenght + 2) * WindowPedalsScale, 0, currentWindowHeight)then
      config.resize(currentWindowSize + vec2((PinCheckLenght + 2) * WindowPitScale), "Pit Lane")
      pinCheckBox.main(vec2(currentWindowWidth + 2 * WindowPitScale, 10 * WindowPitScale), WindowPitScale, "Pit Lane", config.getWindow("Pit Lane"):pinned())
  end
end

return pitlane