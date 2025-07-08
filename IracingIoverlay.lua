STORAGE_SIZE = ac.storage("Size", 1)
Size = STORAGE_SIZE:get()

-- Tamanho base para a janela
BaseWindowWidth = 202
BaseWindowHeight = 94
--
local barWidth = 17 -- Largura das barras de freio e acelerador

-- Posições das das barras:
local posXAceleratorBar = 100 -- Posição X da barra de acelerador 
local posxBrakeBar = posXAceleratorBar - 20 -- Posição X da barra de freio
local posyBars = 90 -- Posição Y de ambas as barras

-- Posições dos textos das barras:
local posxTextBars = (posXAceleratorBar - 43) * Size -- Posição X dos textos do acelerador e freio
local posyTextBars = 22 * Size
local posyInfiniteBars = 16 * Size
local posxTextRight = -10 * Size -- Posição X dos textos de marcha e velocidade

-- Fonte dos textos:
ui.pushDWriteFont("Font/Montserrat-Bold.ttf") -- Fonte do texto
local fontBar = 14 * Size -- Tamanho da fonte dos textos do acelerador e freio
local fontBarInfinite = 22 * Size -- Tamanho da fonte dos símbolos de infinito
local fontGear = 35 * Size -- Tamanho da fonte do texto de marcha
local fontSpeed = 15 * Size -- Tamanho da fonte do texto de velocidade

OldWindowWidth = BaseWindowWidth
OldWindowHeight = BaseWindowHeight
NewWindowWidth = BaseWindowWidth
NewWindowHeight = BaseWindowHeight


function script.windowMain(dt)
    SIM = ac.getSim()
    CAR = ac.getCar(SIM.focusedCar)

    if CAR == nil then
        ac.debug("Focused driver error");
    else
        ui.beginScale()

        -- BackGround
        ui.drawRectFilled(vec2(0, 0), vec2(202, 94), rgbm(0, 0, 0, 0.30), 0)
        
        -- Volante:
        ui.beginRotation()
        ui.setCursor(vec2(125, 22))
        ui.image("Icons/Wheel.png", vec2(60, 72), ui.ImageFit.Fit)
        ui.endRotation(-CAR.steer + 90)
        --

        -- Barras do acelerador:
        ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - 50), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posXAceleratorBar, posyBars), vec2(posXAceleratorBar, posyBars - CAR.gas * 50), rgbm(107 / 255, 228 / 255, 96 / 255, 1), barWidth)

        -- Barras do freio:
        ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - 50), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posxBrakeBar, posyBars), vec2(posxBrakeBar, posyBars - CAR.brake * 50), rgbm(226 / 255, 12 / 255, 50 / 255, 1), barWidth)

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
        ui.dwriteTextAligned(gear, fontGear, ui.Alignment.Center, ui.Alignment.Center, vec2(86, 33):scale(Size), false, rgbm(255, 255, 255, 1))
        --
        
        -- Velocidade Km/h:
        local speed = string.format("%d", math.floor(CAR.speedKmh))
        ui.setCursor(vec2(posxTextRight, 60 * Size))
        ui.dwriteTextAligned(speed, fontSpeed, ui.Alignment.Center, ui.Alignment.Center, vec2(88, 30):scale(Size), false, rgbm(255, 255, 255, 1))   
        --
    end
end

function script.Ioverlay_Settings(dt)
    Size = ui.slider('##Size', Size, 1, 3, string.format("%.2f", Size), nil);
  
    STORAGE_SIZE:set(Size)

    local iniFile = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\IracingIoverlay\\manifest.ini")

    NewWindowHeight = BaseWindowHeight * Size
    NewWindowWidth = BaseWindowWidth * Size

    if NewWindowHeight ~= OldWindowHeight or NewWindowWidth ~= OldWindowWidth then
      iniFile:setAndSave("WINDOW_...", "SIZE", " " .. tostring(NewWindowWidth) .. ", " .. tostring(NewWindowHeight))
      OldWindowHeight = NewWindowHeight
      OldWindowWidth = NewWindowWidth
    end
  end