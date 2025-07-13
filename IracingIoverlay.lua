require("lang.language")
require("settings.settings")
local config = require("common.config")

function script.windowMain()
    ui.pushDWriteFont("Font/Montserrat-Bold.ttf") -- Fonte do texto

    -- Posições dos textos das barras:
    local posyTextBars = 26 * HudScale
    local posyInfiniteBars = 20 * HudScale

    -- Fonte dos textos:
    local fontFuel = 13 * HudScale -- Tamanho da fonte dos textos do acelerador e freio
    local fontBar = 14 * HudScale -- Tamanho da fonte dos textos do acelerador e freio
    local fontBarInfinite = 22 * HudScale -- Tamanho da fonte dos símbolos de infinito
    local fontGear = 40 * HudScale -- Tamanho da fonte do texto de marcha
    local fontSpeed = 17 * HudScale -- Tamanho da fonte do texto de velocidade

    local currentWindowWidth = vec2(0, 0) -- Comprimento da tela
    local currentWindowHeight = vec2(0, 135 * HudScale) -- Altura da tela
    
    local gearBackgroundSize = vec2(70 * HudScale, currentWindowHeight.y) -- Tamanho do background do texto de velocidade e marcha
    local wheelBackgroundSize = vec2(70 * HudScale, currentWindowHeight.y) -- Tamanho do background do eixo do roda
    local absBackgroundSize = vec2(80 * HudScale, currentWindowHeight.y) -- Tamanho do background do ABS
    local barSize = vec2(17, 65) * HudScale -- Tamanho das barras
    local barSpace = 3 * HudScale --Comprimento do padding das barras

    -- Marcha:
    ui.drawRectFilled(currentWindowWidth, currentWindowWidth + gearBackgroundSize, rgbm(0, 0, 0, 0.30), 0)
    local gear = tostring(CAR.gear);
    if gear == "0" then
      gear = "N";
    elseif gear == "-1" then
      gear = "R";
    end
    ui.setCursor(vec2(20, 50):scale(HudScale))
    ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(HudScale), false, rgbm(255, 255, 255, 1))

    -- Brake Bias:
    -- Text Brake Bias
    ui.setCursor(vec2(20 * HudScale, currentWindowHeight.y - 19 * HudScale))
    ui.dwriteTextAligned(string.format("%.1f", CAR.brakeBias*100), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(30, 30):scale(HudScale), false, rgbm(255, 255, 255, 1))
    -- BrakeBias Image
    ui.setCursor(vec2(2 * HudScale, currentWindowHeight.y - 20 * HudScale))
    ui.image("assets/BrakeBias.png", vec2(19, 19):scale(HudScale), ui.ImageFit.Fit)
    --

    -- Velocidade:
    local speed
    if(SelectedSpeed == 1) then
      speed = string.format("%d", math.floor(CAR.speedKmh))
    else
      speed = string.format("%d", math.floor(CAR.speedKmh * 0.621371))
    end
    ui.setCursor(vec2(20, 80):scale(HudScale))
    ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(30, 30):scale(HudScale), false, rgbm(255, 255, 255, 1))   
    currentWindowWidth = currentWindowWidth + vec2(gearBackgroundSize.x)
    --

    -- Embreagem
    if ClutchActive then
      local posBar = currentWindowWidth + vec2(0, 45 * HudScale)
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(barSpace + barSize.x, currentWindowHeight.y), rgbm(0, 0, 0, 0.30), 0)

      ui.drawRectFilled(posBar, posBar + barSize, rgbm(0.2, 0.2, 0.2, 0.6))
      ui.drawRectFilled(posBar + vec2(0, (CAR.clutch * barSize.y)), posBar + barSize,  rgbm(0, 0, 255, 1))
      -- Texto da embreagem:
      if (100 - CAR.clutch * 100) < 98.99 then
        ui.setCursor(vec2(currentWindowWidth.x, posyTextBars))
        ui.dwriteTextAligned(string.format("%.0f", 100 - CAR.clutch * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(17, 30):scale(HudScale), false, rgbm(255, 255, 255, 1))
      else 
        ui.setCursor(vec2(currentWindowWidth.x, posyInfiniteBars))
        ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(17, 30):scale(HudScale), false, rgbm(0, 0, 255, 1))
      end
      currentWindowWidth = currentWindowWidth + vec2(barSize.x + barSpace)
    end
    --

    -- Freio: 
    if BrakeActive then
      posBar = currentWindowWidth + vec2(0, 45 * HudScale)
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(barSpace + barSize.x, currentWindowHeight.y), rgbm(0, 0, 0, 0.30), 0)
      -- Texto do freio:
      if (CAR.brake * 100) < 98.99 then
        ui.setCursor(vec2(currentWindowWidth.x, posyTextBars))
        ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(17, 30):scale(HudScale), false, rgbm(255, 255, 255, 1))
      else 
        ui.setCursor(vec2(currentWindowWidth.x, posyInfiniteBars))
        ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(17, 30):scale(HudScale), false, rgbm(255, 0, 0, 1))
      end
      -- Barras freio:
      ui.drawRectFilled(posBar, posBar + barSize, rgbm(0.2, 0.2, 0.2, 0.6))
      ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.brake * barSize.y)), posBar + barSize,  rgbm(255, 0, 0, 1))
      currentWindowWidth = currentWindowWidth + vec2(barSize.x + barSpace)
    end
    --

    -- Acelerador:
    if AcceleratorActive then
      posBar = currentWindowWidth + vec2(0, 45 * HudScale)
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(barSpace + barSize.x, currentWindowHeight.y), rgbm(0, 0, 0, 0.30), 0)
      -- Texto do acelerador:
      if (CAR.gas * 100) < 98.99 then
        ui.setCursor(vec2(currentWindowWidth.x, posyTextBars))
        ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(17, 30):scale(HudScale), false, rgbm(255, 255, 255, 1))
      else 
        ui.setCursor(vec2(currentWindowWidth.x, posyInfiniteBars))
        ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(17, 30):scale(HudScale), false, rgbm(0, 255, 0, 1))
      end
      -- Barras acelerador:
      ui.drawRectFilled(posBar, posBar + barSize, rgbm(0.2, 0.2, 0.2, 0.6))
      ui.drawRectFilled(posBar + vec2(0, barSize.y - (CAR.gas * barSize.y)), posBar + barSize, rgbm(0, 255, 0, 1))
      currentWindowWidth = currentWindowWidth + vec2(barSize.x + barSpace)
    end
    --

    -- Volante:
    if WheelActive then
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + wheelBackgroundSize, rgbm(0, 0, 0, 0.30), 0)
      ui.beginRotation()
      ui.setCursor(vec2(currentWindowWidth.x + 5, 40 * HudScale))
      ui.image("assets/Wheel.png", vec2(60, 72):scale(HudScale), ui.ImageFit.Fit)
      ui.endRotation(90 -CAR.steer)
      currentWindowWidth = currentWindowWidth + vec2(wheelBackgroundSize.x)
    end
    --

    -- ABS:
    if ABSActive and CAR.absModes ~= 0 then
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + absBackgroundSize, rgbm(0, 0, 0, 0.30), 0)
      ui.setCursor(vec2(currentWindowWidth.x, 35 * HudScale))
      if CAR.absInAction then
        ui.image("assets/ABS.png", vec2(80,80):scale(HudScale), rgbm(255, 0, 0, 1),ui.ImageFit.Fit)
      else
        ui.image("assets/ABS.png", vec2(80,80):scale(HudScale), ui.ImageFit.Fit)
      end
        currentWindowWidth = currentWindowWidth + vec2(absBackgroundSize.x)
    end
    --

    -- Fuel:
    -- Fuel Imagem
    if currentWindowWidth.x <= (gearBackgroundSize.x ) then
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2(35, currentWindowHeight.y), rgbm(0, 0, 0, 0.30), 0)
      currentWindowWidth = currentWindowWidth + vec2(35)
    elseif currentWindowWidth.x <= (gearBackgroundSize.x + (barSize.x + barSpace)) then
      ui.drawRectFilled(currentWindowWidth, currentWindowWidth + vec2((barSize.x + barSpace + 3), currentWindowHeight.y), rgbm(0, 0, 0, 0.30), 0)
      currentWindowWidth = currentWindowWidth + vec2((barSize.x + barSpace + 3))
    end
    if CAR.fuel <= 5 then
      ui.setCursor(vec2(currentWindowWidth.x - 55 * HudScale, currentWindowHeight.y - 19 * HudScale))
      ui.image("assets/Fuel.png", vec2(16, 15), rgbm(255, 0, 0, 1), ui.ImageFit.Fit)
    elseif CAR.fuel < 10 then
      ui.setCursor(vec2(currentWindowWidth.x - 55 * HudScale, currentWindowHeight.y - 19 * HudScale))
      ui.image("assets/Fuel.png", vec2(16, 15):scale(HudScale), rgbm(255, 255, 0, 1), ui.ImageFit.Fit)
    elseif CAR.fuel < 100 then
      ui.setCursor(vec2(currentWindowWidth.x - (59 * HudScale), currentWindowHeight.y - (19 * HudScale)))
      ui.image("assets/Fuel.png", vec2(16, 15):scale(HudScale), rgbm(255, 255, 255, 1), ui.ImageFit.Fit)
    else
      ui.setCursor(vec2(currentWindowWidth.x - 62 * HudScale, currentWindowHeight.y - 19 * HudScale))
      ui.image("assets/Fuel.png", vec2(16, 15):scale(HudScale), rgbm(255, 255, 255, 1), ui.ImageFit.Fit)
    end
    -- Text Fuel
    ui.setCursor(vec2(currentWindowWidth.x - 67 * HudScale, currentWindowHeight.y - 20 * HudScale))
    if CAR.fuel <= 5 then
      ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(HudScale), false, rgbm(255, 0, 0, 1))
    elseif CAR.fuel < 10 then
      ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(HudScale), false, rgbm(255, 255, 0, 1))
    else
      ui.dwriteTextAligned(string.format("%.2f", CAR.fuel), fontFuel, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(HudScale), false, rgbm(255, 255, 255, 1))
    end
    --

    config.resize(currentWindowWidth + currentWindowHeight, "Irancing Overlay")
end
