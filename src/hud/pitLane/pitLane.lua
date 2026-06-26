local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local window = require("common.window")

local init = require("src.hud.pitLane.render.init")
local components = require("src.hud.pitLane.render.components")

local pitLane = {}
---@type pitLaneData
local data = require("src.data.pitLane.pitLaneData")

function pitLane.windowMain()
  data.currentWindowHeight = 70 * pitLaneSettings.store.pitLaneScale
  data.fontYou = 17 * pitLaneSettings.store.pitLaneScale

  if SIM.focusedCar == 0 then
      ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
      if CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane or SettingsActive then
        if CAR.speedKmh > CAR.speedLimiter + 1 then
          data.currentWindowHeight = 100 * pitLaneSettings.store.pitLaneScale
        end

        if pitLaneSettings.store.optionPlate == 1 then
          init.default(data)
        elseif pitLaneSettings.store.optionPlate == 2 then
          init.alert(data) 
        end
        
        components.title(data)

        if(not (CAR.manualPitsSpeedLimiterEnabled or CAR.isInPitlane) and SettingsActive) then
          data.kmhString = "--"
          data.limitPitString = "--"
          data.speedrgb = COLOR.WHITE
          data.currentWindowHeight = 70 * pitLaneSettings.store.pitLaneScale

        else 
          -- SPEED
          if(SelectedSpeed == 1) then
            data.kmhString = string.format("%.0f", CAR.speedKmh)
            data.limitPitString = string.format("%.0f", CAR.speedLimiter)
          else
            data.kmhString = string.format("%.0f", CAR.speedKmh * 0.621371)
            data.limitPitString = string.format("%.0f", CAR.speedLimiter * 0.621371)
          end
          -- RGB SPEED
          if CAR.speedKmh <= CAR.speedLimiter then
            data.speedrgb = COLOR.WHITE
          elseif CAR.speedKmh > CAR.speedLimiter + 1 then
            if (5 * Timer) % 2 >= 1 then 
              components.slowDown(data)
            end
            data.speedrgb = COLOR.RED
          end
        end
        components.speed(data)
    end 
  end

  data.currentWindowSize = vec2(data.currentWindowWidth, data.currentWindowHeight)

  window.resize(data.currentWindowSize, "Pit Lane")
  
  pinCheckBox.main(pitLaneSettings.store.pitLaneScale, "Pit Lane", window.getWindow("Pit Lane"):pinned(), data.currentWindowSize)
end

return pitLane
