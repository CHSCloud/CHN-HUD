local settings = ac.storage{
  Size = 1,
  Wheel = true,
  ABS = true,
  BaseWindowWidth = 202,
  BaseWindowHeight = 110
}

ui.pushDWriteFont("Font/Montserrat-Bold.ttf") -- Fonte do texto

-- Largura das barras de freio e acelerador
local barWidth = 17

-- Posições das das barras:
local posXAceleratorBar = 100 -- Posição X da barra de acelerador 
local posxBrakeBar = posXAceleratorBar - 20 -- Posição X da barra de freio
local posyBars = 106 -- Posição Y de ambas as barras

-- Posições dos textos das barras:
local posxTextBars = (posXAceleratorBar - 43) * settings.Size -- Posição X dos textos do acelerador e freio
local posyTextBars = 26 * settings.Size
local posyInfiniteBars = 20 * settings.Size
local posxTextRight = -10 * settings.Size -- Posição X dos textos de marcha e velocidade

-- Fonte dos textos:
local fontBar = 14 * settings.Size -- Tamanho da fonte dos textos do acelerador e freio
local fontBarInfinite = 22 * settings.Size -- Tamanho da fonte dos símbolos de infinito
local fontGear = 35 * settings.Size -- Tamanho da fonte do texto de marcha
local fontSpeed = 15 * settings.Size -- Tamanho da fonte do texto de velocidade

-- Setando largura e altura da janela para posterior redimencionamento:
OldWindowWidth = settings.BaseWindowWidth
OldWindowHeight = settings.BaseWindowHeight
NewWindowWidth = settings.BaseWindowWidth
NewWindowHeight = settings.BaseWindowHeight


function script.windowMain()
    SIM = ac.getSim()
    CAR = ac.getCar(SIM.focusedCar)

    if CAR == nil then
        ac.debug("Focused driver error");
    else
        ui.beginScale()
        -- BackGround
        ui.drawRectFilled(vec2(0, 0), vec2(settings.BaseWindowWidth, settings.BaseWindowHeight), rgbm(0, 0, 0, 0.30), 0)

        if settings.Wheel then
          -- Volante:
          settings.BaseWindowWidth = 202
          ui.beginRotation()
          ui.setCursor(vec2(125, 30))
          ui.image("Icons/Wheel.png", vec2(60, 72), ui.ImageFit.Fit)
          ui.endRotation(-CAR.steer + 90)
          --
        end

        if settings.ABS then
          -- ABS:
          if settings.Wheel then
            settings.BaseWindowWidth = 272
            ui.setCursor(vec2(190, 25))
          else
            settings.BaseWindowWidth = 202
            ui.setCursor(vec2(120, 25))
          end
          if CAR.absInAction then
            ui.image("Icons/ABSactive.png", vec2(70, 82), ui.ImageFit.Fit)
          else
            ui.image("Icons/ABS.png", vec2(70, 82), ui.ImageFit.Fit)
          end
        end

        if not settings.ABS and not settings.Wheel then
          settings.BaseWindowWidth = 120
        end

        -- Barras do acelerador:
        ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - 60), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - CAR.gas * 60), rgbm(107 / 255, 228 / 255, 96 / 255, 1), barWidth)

        -- Barras do freio:
        ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - 60), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - CAR.brake * 60), rgbm(226 / 255, 12 / 255, 50 / 255, 1), barWidth)

        ui.endPivotScale(settings.Size, vec2(0, 0)) -- Escala da janela


        -- Texto do acelerador:
        if (CAR.gas * 100) < 98.99 then
          ui.setCursor(vec2(posxTextBars, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(settings.Size), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posxTextBars, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(85, 30):scale(settings.Size), false, rgbm(107 / 255, 228 / 255, 96 / 255, 1))
        end
        -- 

        -- Texto do freio:
        if (CAR.brake * 100) < 98.99 then
          ui.setCursor(vec2(posxTextBars, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30):scale(settings.Size), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posxTextBars, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30):scale(settings.Size), false, rgbm(226 / 255, 12 / 255, 50 / 255, 1))
        end
        --

        -- Texto das marchas:
        local gear = tostring(CAR.gear);
        if gear == "0" then
          gear = "N";
        elseif gear == "-1" then
         gear = "R";
        end
        ui.setCursor(vec2(posxTextRight, 30 * settings.Size))
        ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(86, 50):scale(settings.Size), false, rgbm(255, 255, 255, 1))
        --
        
        -- Velocidade Km/h:
        local speed = string.format("%d", math.floor(CAR.speedKmh))
        ui.setCursor(vec2(posxTextRight, 60 * settings.Size))
        ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(88, 50):scale(settings.Size), false, rgbm(255, 255, 255, 1))   
        --
    end
end

function script.Ioverlay_Settings()
    settings.Size = ui.slider('Size', settings.Size, 1, 3, string.format("%.2f", settings.Size));

    if ui.checkbox("Wheel", settings.Wheel) then
      settings.Wheel = not settings.Wheel
    end

    if ui.checkbox("ABS", settings.ABS) then
      settings.ABS = not settings.ABS
    end

    NewWindowHeight = settings.BaseWindowHeight * settings.Size
    NewWindowWidth = settings.BaseWindowWidth * settings.Size

    if NewWindowHeight ~= OldWindowHeight or NewWindowWidth ~= OldWindowWidth then
      -- Redimencionando janela:
      local iniFile = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\IracingIoverlay\\manifest.ini")
      iniFile:setAndSave("WINDOW_...", "SIZE", " " .. tostring(NewWindowWidth) .. ", " .. tostring(NewWindowHeight))
      OldWindowHeight = NewWindowHeight
      OldWindowWidth = NewWindowWidth
    end
  end