require("src.settings.settings")
local config = require("common.config")
local pedals = {}

local currentWindowSize = vec2(0, 0)

function pedals.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- Fonte do texto
    local paddingTop = 7 * WindowPedalsScale
    if not TextBarsActive then paddingTop = 17 * WindowPedalsScale end

    local currentWindowWidth = 0
    local currentWindowHeight = 90 * WindowPedalsScale - paddingTop -- Altura da tela
    if BrakeBiasActive or FuelActive then currentWindowHeight = 107 * WindowPedalsScale - paddingTop end -- Altura da tela
    --RGB's
    barBackgroundColor = rgbm.from0255(55, 55, 63, 0.85)

    -- Posições dos textos das barras:
    local posyTextBars = -2 * WindowPedalsScale 
    local posyInfiniteBars = -10 * WindowPedalsScale 

    -- Fonte dos textos:
    local fontFuel = 13 * WindowPedalsScale -- Tamanho da fonte dos textos do acelerador e freio
    local fontBar = 15 * WindowPedalsScale -- Tamanho da fonte dos textos do acelerador e freio
    local fontBarInfinite = 25 * WindowPedalsScale -- Tamanho da fonte dos símbolos de infinito
    local fontGear = 40 * WindowPedalsScale -- Tamanho da fonte do texto de marcha
    local fontSpeed = 20 * WindowPedalsScale -- Tamanho da fonte do texto de velocidade

    local gearBackgroundWidth = 70 * WindowPedalsScale -- Tamanho do background do texto de velocidade e marcha
    local wheelBackgroundSize = vec2(65 * WindowPedalsScale, currentWindowHeight) -- Tamanho do background do eixo do roda
    local absBackgroundSize = vec2(80 * WindowPedalsScale, currentWindowHeight) -- Tamanho do background do ABS
    
    local barSize = vec2(20, 60) * WindowPedalsScale -- Tamanho das barras
    local barSpace = 4 * WindowPedalsScale --Comprimento do padding das barras

    -- Barras no modo de limites:
    local barLimitSize = vec2(20, 6) * WindowPedalsScale -- Tamanho do limite das barras
    local barMidleSize = vec2(20, 44) * WindowPedalsScale -- Tamanho do meio barras
    local barPaddingMidle = 2 * WindowPedalsScale --Comprimento do padding das barras
    
    ui.drawRectFilled(vec2(0, 0), currentWindowSize, WindowsColor, 10 * WindowPedalsScale)
    
    -- Marcha:
    currentWindowWidth = currentWindowWidth + gearBackgroundWidth
    local gear = tostring(CAR.gear);
    if gear == "0" then
      gear = "N";
    elseif gear == "-1" then
      gear = "R";
    end
    ui.setCursor(vec2(20, 28 - paddingTop/WindowPedalsScale):scale(WindowPedalsScale))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 203, 0, 1))
    --

    -- Velocidade:
    local speed
    if(SelectedSpeed == 1) then
      speed = string.format("%.0f", CAR.speedKmh)
    else
      speed = string.format("%.0f", CAR.speedKmh * 0.621371)
    end
    ui.setCursor(vec2(11, 58 - paddingTop / WindowPedalsScale):scale(WindowPedalsScale))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
    --

    -- Brake Bias:
    if BrakeBiasActive then
      -- Text Brake Bias
      ui.setCursor(vec2(20 * WindowPedalsScale, currentWindowHeight - 19 * WindowPedalsScale))
      ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias * 100), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(30, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
      -- BrakeBias Image
      ui.setCursor(vec2(2 * WindowPedalsScale, currentWindowHeight - 21 * WindowPedalsScale))
      ui.image("assets/BrakeBias.png", vec2(19, 19):scale(WindowPedalsScale), ui.ImageFit.Fit)
    end
    --

    -- Embreagem
    local posBar = vec2(currentWindowWidth, 23 * WindowPedalsScale - paddingTop)
    if ClutchActive then
      -- Texto da embreagem:
      if TextBarsActive then
        if (100 - CAR.clutch * 100) < 98.99 then
          ui.setCursor(vec2(currentWindowWidth, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", 100 - CAR.clutch * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(0, 89, 208, 1))
        end
      end

      if PedalLimitsLines then
        ui.drawRectFilled(posBar, posBar + barLimitSize, barBackgroundColor)

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
          barBackgroundColor
        )

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle) + barLimitSize, 
          barBackgroundColor
        )
        
        if CAR.clutch == 0 then
          ui.drawRectFilled(posBar, posBar + barLimitSize, rgbm.from0255(0, 89, 208, 1))
        end
        if CAR.clutch < 1 then
          ui.drawRectFilled(
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y),
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y) + barLimitSize, 
            rgbm.from0255(0, 89, 208, 1)
          )
        end
        ui.drawRectFilled(posBar + vec2(0, barLimitSize.y + barPaddingMidle + (CAR.clutch * barMidleSize.y)), posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, rgbm.from0255(0, 89, 208, 1))
      else
        ui.drawRectFilled(posBar, posBar + barSize, barBackgroundColor)
        ui.drawRectFilled(posBar + vec2(0, (CAR.clutch * barSize.y)), posBar + barSize,  rgbm.from0255(0, 89, 208, 1))
      end
      currentWindowWidth = currentWindowWidth + barSize.x + barSpace
    end
    --

    -- Freio: 
    if BrakeActive then
      posBar = vec2(currentWindowWidth, 23 * WindowPedalsScale - paddingTop)
      -- Texto do freio:
      if TextBarsActive then
        if (CAR.brake * 100) < 98.99 then
          ui.setCursor(vec2(currentWindowWidth, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(200, 0, 0, 1))
        end
      end
      
      -- Barras freio:
      if PedalLimitsLines then
        ui.drawRectFilled(posBar, posBar + barLimitSize, barBackgroundColor)

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
          barBackgroundColor
        )

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle) + barLimitSize, 
          barBackgroundColor
        )
        if CAR.brake > 0 then
          ui.drawRectFilled(
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y),
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y) + barLimitSize, 
            rgbm.from0255(200, 0, 0, 1)
          )
        end
        if CAR.brake == 1 then
          ui.drawRectFilled(posBar, posBar + barLimitSize, rgbm.from0255(200, 0, 0, 1))
        end
        ui.drawRectFilled(posBar + vec2(0, barLimitSize.y + barPaddingMidle + barMidleSize.y - (CAR.brake * barMidleSize.y)), posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, rgbm.from0255(200, 0, 0, 1))
      else
        ui.drawRectFilled(posBar, posBar + barSize, barBackgroundColor)
        ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.brake * barSize.y)), posBar + barSize,  rgbm.from0255(200, 0, 0, 1))
      end
      currentWindowWidth = currentWindowWidth + barSize.x + barSpace
    end
    --

    -- Acelerador:
    if AcceleratorActive then
      posBar = vec2(currentWindowWidth, 23 * WindowPedalsScale - paddingTop)
      -- Texto do acelerador:
      if TextBarsActive then
        if (CAR.gas * 100) < 98.99 then
          ui.setCursor(vec2(currentWindowWidth, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(90, 212, 51, 1))
        end
      end
      -- Barras acelerador:
      if PedalLimitsLines then
        ui.drawRectFilled(posBar, posBar + barLimitSize, barBackgroundColor)

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
          barBackgroundColor
        )

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle) + barLimitSize, 
          barBackgroundColor
        )
        if CAR.gas > 0 then
          ui.drawRectFilled(
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y),
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y) + barLimitSize, 
            rgbm.from0255(90, 212, 51, 1)
          )
        end
        if CAR.gas == 1 then
          ui.drawRectFilled(posBar, posBar + barLimitSize, rgbm.from0255(90, 212, 51, 1))
        end
        ui.drawRectFilled(posBar + vec2(0, barLimitSize.y + barPaddingMidle + barMidleSize.y - (CAR.gas * barMidleSize.y)), posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, rgbm.from0255(90, 212, 51, 1))
      else
        ui.drawRectFilled(posBar, posBar + barSize, barBackgroundColor)
        ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.gas * barSize.y)), posBar + barSize, rgbm.from0255(90, 212, 51, 1))
      end
      currentWindowWidth = currentWindowWidth + barSize.x + barSpace
    end
    --

    -- Freio de mão:
    if HandbrakeActive then
      posBar = vec2(currentWindowWidth, 23 * WindowPedalsScale - paddingTop)
      -- Texto do freio de mão:
      if TextBarsActive then
        if CAR.handbrake < 1 then
          ui.setCursor(vec2(currentWindowWidth, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.handbrake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 0, 1))
        end
      end
      -- Barras Freio de mão:
      if PedalLimitsLines then
        ui.drawRectFilled(posBar, posBar + barLimitSize, barBackgroundColor)

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, 
          barBackgroundColor
        )

        ui.drawRectFilled(
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle), 
          posBar + vec2(0, barLimitSize.y + barMidleSize.y + 2 * barPaddingMidle) + barLimitSize, 
          barBackgroundColor
        )
        if CAR.handbrake > 0 then
          ui.drawRectFilled(
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y),
            posBar + vec2(0, barLimitSize.y + 2 * barPaddingMidle + barMidleSize.y) + barLimitSize, 
            rgbm.from0255(255, 255, 0, 1)
          )
        end
        if CAR.handbrake == 1 then
          ui.drawRectFilled(posBar, posBar + barLimitSize, rgbm.from0255(255, 255, 0, 1))
        end
        ui.drawRectFilled(posBar + vec2(0, barLimitSize.y + barPaddingMidle + barMidleSize.y - (CAR.handbrake * barMidleSize.y)), posBar + vec2(0, barLimitSize.y + barPaddingMidle) + barMidleSize, rgbm.from0255(255, 255, 0, 1))
      else
        ui.drawRectFilled(posBar, posBar + barSize, barBackgroundColor)
        ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.handbrake * barSize.y)), posBar + barSize, rgbm.from0255(255, 255, 0, 1))
      end
      currentWindowWidth = currentWindowWidth + barSize.x + barSpace
    end
    --

    currentWindowWidth = currentWindowWidth + 6 * WindowPedalsScale
    -- Volante:
    if WheelActive then
      ui.beginRotation()
      ui.setCursor(vec2(currentWindowWidth - 4, 18 * WindowPedalsScale - paddingTop))
      ui.image("assets/Wheel1.png", vec2(65, 72):scale(WindowPedalsScale), ui.ImageFit.Fit)
      ui.endRotation(90 - CAR.steer)
      currentWindowWidth = currentWindowWidth + wheelBackgroundSize.x
    end
    --

    -- ABS:
    if ABSActive and CAR.absModes ~= 0 then
      ui.setCursor(vec2(currentWindowWidth - 1, 13 * WindowPedalsScale - paddingTop))
      if CAR.absInAction then
        ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), rgbm(255, 0, 0, 1),ui.ImageFit.Fit)
      else
        ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), barBackgroundColor, ui.ImageFit.Fit)
      end
        currentWindowWidth = currentWindowWidth + absBackgroundSize.x
    end
    --
    
    -- Combustível:
    if FuelActive then
      ui.setCursor(vec2(currentWindowWidth - 48 * WindowPedalsScale, currentWindowHeight - 19 * WindowPedalsScale))

      if CAR.fuel < 5.005 then
        ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, rgbm.from0255(200, 0, 0, 1))
        ui.setCursor(vec2(currentWindowWidth - 53 * WindowPedalsScale, currentWindowHeight - 18.5 * WindowPedalsScale))
        ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(200, 0, 0, 1), ui.ImageFit.Fit)

      elseif CAR.fuel < 9.995 then
        ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 203, 0, 1))
        ui.setCursor(vec2(currentWindowWidth - 53 * WindowPedalsScale, currentWindowHeight - 18.5 * WindowPedalsScale))
        ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(255, 203, 0, 1), ui.ImageFit.Fit)

      else
        ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))

        if CAR.fuel < 99.995 then
          ui.setCursor(vec2(currentWindowWidth - (58 * WindowPedalsScale), currentWindowHeight - (18.5 * WindowPedalsScale)))
          ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(255, 255, 255, 1), ui.ImageFit.Fit)

        else
          ui.setCursor(vec2(currentWindowWidth - 61 * WindowPedalsScale, currentWindowHeight - 18.5 * WindowPedalsScale))
          ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(255, 255, 255, 1), ui.ImageFit.Fit)
        end
      end
    end
    --
    currentWindowSize = vec2(currentWindowWidth, currentWindowHeight)
    config.resize(currentWindowSize, "HUD CHN")
end

return pedals