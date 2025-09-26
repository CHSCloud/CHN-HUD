require("src.settings.settings")
local config = require("common.config")
local pedals = {}

function pedals.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- Fonte do texto
    local paddingTop = 7 * WindowPedalsScale
    if not TextBarsActive then paddingTop = 17 * WindowPedalsScale end
    local currentWindowWidth = vec2(0, 0) -- Largura da tela
    local currentWindowHeight = vec2(0, 90 * WindowPedalsScale - paddingTop) -- Altura da tela
    if BrakeBiasActive or FuelActive then currentWindowHeight = vec2(0, 107 * WindowPedalsScale - paddingTop) end -- Altura da tela
    --RGB's
    barBackground = rgbm.from0255(55, 55, 63, 0.85)

    -- Posições dos textos das barras:
    local posyTextBars = -2 * WindowPedalsScale + currentWindowWidth.y
    local posyInfiniteBars = -10 * WindowPedalsScale + currentWindowWidth.y

    -- Fonte dos textos:
    local fontFuel = 13 * WindowPedalsScale -- Tamanho da fonte dos textos do acelerador e freio
    local fontBar = 15 * WindowPedalsScale -- Tamanho da fonte dos textos do acelerador e freio
    local fontBarInfinite = 25 * WindowPedalsScale -- Tamanho da fonte dos símbolos de infinito
    local fontGear = 40 * WindowPedalsScale -- Tamanho da fonte do texto de marcha
    local fontSpeed = 20 * WindowPedalsScale -- Tamanho da fonte do texto de velocidade

    local gearBackgroundSize = vec2(70 * WindowPedalsScale, currentWindowHeight.y) -- Tamanho do background do texto de velocidade e marcha
    local wheelBackgroundSize = vec2(65 * WindowPedalsScale, currentWindowHeight.y) -- Tamanho do background do eixo do roda
    local absBackgroundSize = vec2(80 * WindowPedalsScale, currentWindowHeight.y) -- Tamanho do background do ABS
    
    local barSize = vec2(20, 60) * WindowPedalsScale -- Tamanho das barras
    local barSpace = 4 * WindowPedalsScale --Comprimento do padding das barras
    
    -- Marcha:
    ui.drawRectFilled(currentWindowWidth, currentWindowWidth + gearBackgroundSize, WindowsColor, 0)
    local gear = tostring(CAR.gear);
    if gear == "0" then
      gear = "N";
    elseif gear == "-1" then
      gear = "R";
    end
    ui.setCursor(vec2(20, 28 - paddingTop/WindowPedalsScale):scale(WindowPedalsScale) + currentWindowWidth)
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 203, 0, 1))
    --

    -- Velocidade:
    local speed
    if(SelectedSpeed == 1) then
      speed = string.format("%.0f", CAR.speedKmh)
    else
      speed = string.format("%.0f", CAR.speedKmh * 0.621371)
    end
    ui.setCursor(vec2(11, 58 - paddingTop/WindowPedalsScale):scale(WindowPedalsScale) + currentWindowWidth)
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(50, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))   
    currentWindowWidth = currentWindowWidth + vec2(gearBackgroundSize.x)
    --

    -- Brake Bias:
    if BrakeBiasActive then
      -- Text Brake Bias
      ui.setCursor(vec2(20 * WindowPedalsScale, currentWindowHeight.y + currentWindowWidth.y - 19 * WindowPedalsScale))
      ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias * 100), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(30, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
      -- BrakeBias Image
      ui.setCursor(vec2(2 * WindowPedalsScale, currentWindowHeight.y + currentWindowWidth.y - 21 * WindowPedalsScale))
      ui.image("assets/BrakeBias.png", vec2(19, 19):scale(WindowPedalsScale), ui.ImageFit.Fit)
    end
    --

    -- Embreagem
    local posBar = currentWindowWidth + vec2(0, 23 * WindowPedalsScale - paddingTop)
    if ClutchActive then
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(barSpace + barSize.x, currentWindowHeight.y), WindowsColor, 0)
      -- Texto da embreagem:
      if TextBarsActive then
        if (100 - CAR.clutch * 100) < 98.99 then
          ui.setCursor(vec2(currentWindowWidth.x, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", 100 - CAR.clutch * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth.x, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(0, 89, 208, 1))
        end
      end
      ui.drawRectFilled(posBar, posBar + barSize, barBackground)
      ui.drawRectFilled(posBar + vec2(0, (CAR.clutch * barSize.y)), posBar + barSize,  rgbm.from0255(0, 89, 208, 1))
      currentWindowWidth = currentWindowWidth + vec2(barSize.x + barSpace)
    end
    --

    -- Freio: 
    if BrakeActive then
      posBar = currentWindowWidth + vec2(0, 23 * WindowPedalsScale - paddingTop)
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(barSpace + barSize.x, currentWindowHeight.y), WindowsColor, 0)
      -- Texto do freio:
      if TextBarsActive then
        if (CAR.brake * 100) < 98.99 then
          ui.setCursor(vec2(currentWindowWidth.x, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth.x, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(200, 0, 0, 1))
        end
      end
      -- Barras freio:
      ui.drawRectFilled(posBar, posBar + barSize, barBackground)
      ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.brake * barSize.y)), posBar + barSize,  rgbm.from0255(200, 0, 0, 1))
      currentWindowWidth = currentWindowWidth + vec2(barSize.x + barSpace)
    end
    --

    -- Acelerador:
    if AcceleratorActive then
      posBar = currentWindowWidth + vec2(0, 23 * WindowPedalsScale - paddingTop)
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(barSpace + barSize.x, currentWindowHeight.y), WindowsColor, 0)
      -- Texto do acelerador:
      if TextBarsActive then
        if (CAR.gas * 100) < 98.99 then
          ui.setCursor(vec2(currentWindowWidth.x, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth.x, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm.from0255(90, 212, 51, 1))
        end
      end
      -- Barras acelerador:
      ui.drawRectFilled(posBar, posBar + barSize, barBackground)
      ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.gas * barSize.y)), posBar + barSize, rgbm.from0255(90, 212, 51, 1))
      currentWindowWidth = currentWindowWidth + vec2(barSize.x + barSpace)
    end
    --

    -- Freio de mão:
    if HandbrakeActive then
      posBar = currentWindowWidth + vec2(0, 23 * WindowPedalsScale - paddingTop)
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(barSpace + barSize.x, currentWindowHeight.y), WindowsColor, 0)
      -- Texto do freio de mão:
      if TextBarsActive then
        if CAR.handbrake < 1 then
          ui.setCursor(vec2(currentWindowWidth.x, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.handbrake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(currentWindowWidth.x, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(20, 30):scale(WindowPedalsScale), false, rgbm(255, 255, 0, 1))
        end
      end
      -- Barras Freio de mão:
      ui.drawRectFilled(posBar, posBar + barSize, barBackground)
      ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.handbrake * barSize.y)), posBar + barSize, rgbm.from0255(255, 255, 0, 1))
      currentWindowWidth = currentWindowWidth + vec2(barSize.x + barSpace)
    end
    --

    ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(6 * WindowPedalsScale, currentWindowHeight.y), WindowsColor, 0)
    currentWindowWidth = currentWindowWidth + vec2(6 * WindowPedalsScale)
    -- Volante:
    if WheelActive then
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + wheelBackgroundSize, WindowsColor, 0)
      ui.beginRotation()
      ui.setCursor(vec2(currentWindowWidth.x - 4, 18 * WindowPedalsScale + currentWindowWidth.y - paddingTop))
      ui.image("assets/Wheel1.png", vec2(65, 72):scale(WindowPedalsScale), ui.ImageFit.Fit)
      ui.endRotation(90 - CAR.steer)
      currentWindowWidth = currentWindowWidth + vec2(wheelBackgroundSize.x)
    end
    --

    -- ABS:
    if ABSActive and CAR.absModes ~= 0 then
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + absBackgroundSize, WindowsColor, 0)
      ui.setCursor(vec2(currentWindowWidth.x - 1, 13 * WindowPedalsScale + currentWindowWidth.y - paddingTop))
      if CAR.absInAction then
        ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), rgbm(255, 0, 0, 1),ui.ImageFit.Fit)
      else
        ui.image("assets/ABS.png", vec2(80,80):scale(WindowPedalsScale), barBackground, ui.ImageFit.Fit)
      end
        currentWindowWidth = currentWindowWidth + vec2(absBackgroundSize.x)
    end
    --
    
    -- Combustível:
    if FuelActive then
      if currentWindowWidth.x <= (gearBackgroundSize.x + (barSize.x + barSpace) * 2) and BrakeBiasActive then
        ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2((gearBackgroundSize.x + (barSize.x + barSpace) * 2) - currentWindowWidth.x, currentWindowHeight.y), WindowsColor, 0)
        currentWindowWidth = currentWindowWidth + vec2((gearBackgroundSize.x + (barSize.x + barSpace) * 2) - currentWindowWidth.x)
      end

      ui.setCursor(vec2(currentWindowWidth.x - 48 * WindowPedalsScale, currentWindowHeight.y + currentWindowWidth.y - 19 * WindowPedalsScale))
      if CAR.fuel < 5.005 then
        ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, rgbm.from0255(200, 0, 0, 1))
        ui.setCursor(vec2(currentWindowWidth.x - 53 * WindowPedalsScale, currentWindowHeight.y + currentWindowWidth.y - 18.5 * WindowPedalsScale))
        ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(200, 0, 0, 1), ui.ImageFit.Fit)
      elseif CAR.fuel < 9.995 then
        ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 203, 0, 1))
        ui.setCursor(vec2(currentWindowWidth.x - 53 * WindowPedalsScale, currentWindowHeight.y + currentWindowWidth.y - 18.5 * WindowPedalsScale))
        ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(255, 203, 0, 1), ui.ImageFit.Fit)
      else
        ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(50, 30):scale(WindowPedalsScale), false, rgbm.from0255(255, 255, 255, 1))
        if CAR.fuel < 99.995 then
          ui.setCursor(vec2(currentWindowWidth.x - (59 * WindowPedalsScale), currentWindowHeight.y  + currentWindowWidth.y - (18.5 * WindowPedalsScale)))
          ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(255, 255, 255, 1), ui.ImageFit.Fit)
        else
          ui.setCursor(vec2(currentWindowWidth.x - 61 * WindowPedalsScale, currentWindowHeight.y + currentWindowWidth.y - 18.5 * WindowPedalsScale))
          ui.image("assets/Fuel.png", vec2(16, 15):scale(WindowPedalsScale), rgbm.from0255(255, 255, 255, 1), ui.ImageFit.Fit)
        end
      end
    end
    --

    config.resize(currentWindowWidth + currentWindowHeight, "HUD CHN")
end

return pedals