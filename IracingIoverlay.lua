STORAGE_SIZE = ac.storage("Size", 1)
Size = STORAGE_SIZE:get()

STORAGE_WHEEL = ac.storage("Wheel", false)
Wheel = STORAGE_WHEEL:get()

STORAGE_ABS = ac.storage("ABS", false)
ABS = STORAGE_ABS:get()

-- Tamanho base para a janela
STORAGE_WIDTH = ac.storage("WIDTH", 202)
STORAGE_HEIGHT = ac.storage("HEIGHT", 110)
BaseWindowWidth = STORAGE_WIDTH:get()
BaseWindowHeight = STORAGE_HEIGHT:get()
--
local barWidth = 17 -- Largura das barras de freio e acelerador


-- Posições das das barras:
local posXAceleratorBar = 100 -- Posição X da barra de acelerador 
local posxBrakeBar = posXAceleratorBar - 20 -- Posição X da barra de freio
local posyBars = 106 -- Posição Y de ambas as barras

-- Posições dos textos das barras:
local posxTextBars = (posXAceleratorBar - 43) * Size -- Posição X dos textos do acelerador e freio
local posyTextBars = 26 * Size
local posyInfiniteBars = 20 * Size
local posxTextRight = -10 * Size -- Posição X dos textos de marcha e velocidade

-- Fonte dos textos:
local fontBar = 14 * Size -- Tamanho da fonte dos textos do acelerador e freio
local fontBarInfinite = 22 * Size -- Tamanho da fonte dos símbolos de infinito
local fontGear = 35 * Size -- Tamanho da fonte do texto de marcha
local fontSpeed = 15 * Size -- Tamanho da fonte do texto de velocidade

OldWindowWidth = BaseWindowWidth
OldWindowHeight = BaseWindowHeight
NewWindowWidth = BaseWindowWidth
NewWindowHeight = BaseWindowHeight


function script.windowMain()
    STORAGE_WIDTH:set(BaseWindowWidth)
    STORAGE_ABS:set(BaseWindowHeight)
    SIM = ac.getSim()
    CAR = ac.getCar(SIM.focusedCar)
    ui.pushDWriteFont("Font/Montserrat-Bold.ttf") -- Fonte do texto

    if CAR == nil then
        ac.debug("Focused driver error");
    else
        ui.beginScale()

        -- BackGround
        ui.drawRectFilled(vec2(0, 0), vec2(BaseWindowWidth, BaseWindowHeight), rgbm(0, 0, 0, 0.30), 0)

        if Wheel then
          -- Volante:
          BaseWindowWidth = 202
          ui.beginRotation()
          ui.setCursor(vec2(125, 30))
          ui.image("Icons/Wheel.png", vec2(60, 72), ui.ImageFit.Fit)
          ui.endRotation(-CAR.steer + 90)
          --
        end

        if ABS then
          -- ABS:
          if Wheel then
            BaseWindowWidth = 272
            ui.setCursor(vec2(190, 25))
          else
            BaseWindowWidth = 202
            ui.setCursor(vec2(120, 25))
          end
          if CAR.absInAction then
            ui.image("Icons/ABSactive.png", vec2(70, 82), ui.ImageFit.Fit)
          else
            ui.image("Icons/ABS.png", vec2(70, 82), ui.ImageFit.Fit)
          end
        end

        if not ABS and not Wheel then
          BaseWindowWidth = 120
        end

        STORAGE_WIDTH:set(BaseWindowWidth)
        -- Barras do acelerador:
        ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - 60), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - CAR.gas * 60), rgbm(107 / 255, 228 / 255, 96 / 255, 1), barWidth)

        -- Barras do freio:
        ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - 60), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - CAR.brake * 60), rgbm(226 / 255, 12 / 255, 50 / 255, 1), barWidth)

        ui.endPivotScale(Size, vec2(0, 0)) -- Escala da janela


        -- Texto do acelerador:
        if (CAR.gas * 100) < 98.99 then
          ui.setCursor(vec2(posxTextBars, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30):scale(Size), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posxTextBars, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(85, 30):scale(Size), false, rgbm(107 / 255, 228 / 255, 96 / 255, 1))
        end
        -- 

        -- Texto do freio:
        if (CAR.brake * 100) < 98.99 then
          ui.setCursor(vec2(posxTextBars, posyTextBars))
          ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), fontBar, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30):scale(Size), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posxTextBars, posyInfiniteBars))
          ui.dwriteTextAligned("∞", fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30):scale(Size), false, rgbm(226 / 255, 12 / 255, 50 / 255, 1))
        end
        --

        -- Texto das marchas:
        local gear = tostring(CAR.gear);
        if gear == "0" then
          gear = "N";
        elseif gear == "-1" then
         gear = "R";
        end
        ui.setCursor(vec2(posxTextRight, 30 * Size))
        ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(86, 50):scale(Size), false, rgbm(255, 255, 255, 1))
        --
        
        -- Velocidade Km/h:
        local speed = string.format("%d", math.floor(CAR.speedKmh))
        ui.setCursor(vec2(posxTextRight, 60 * Size))
        ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(88, 50):scale(Size), false, rgbm(255, 255, 255, 1))   
        --
    end
end

function script.Ioverlay_Settings()
    Size = ui.slider('##Size', Size, 1, 3, string.format("%.2f", Size), nil);
  
    STORAGE_SIZE:set(Size)
    STORAGE_WHEEL:set(Wheel)
    STORAGE_ABS:set(ABS)

    if ui.checkbox("Wheel", Wheel) then
      Wheel = not Wheel
    end

    if ui.checkbox("ABS", ABS) then
      ABS = not ABS
    end

    local iniFile = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\IracingIoverlay\\manifest.ini")

    NewWindowHeight = BaseWindowHeight * Size
    NewWindowWidth = BaseWindowWidth * Size

    if NewWindowHeight ~= OldWindowHeight or NewWindowWidth ~= OldWindowWidth then
      iniFile:setAndSave("WINDOW_...", "SIZE", " " .. tostring(NewWindowWidth) .. ", " .. tostring(NewWindowHeight))
      OldWindowHeight = NewWindowHeight
      OldWindowWidth = NewWindowWidth
    end
  end