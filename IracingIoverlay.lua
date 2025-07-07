STORAGE_SIZE = ac.storage("Size", 1)
Size = STORAGE_SIZE:get()

-- Tamanho base para a janela
BaseWindowWidth = 202
BaseWindowHeight = 94
--
barWidth = 17 -- Largura das barras de freio e acelerador
posxBars = 100 -- Move as barras e textos

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
        ui.drawSimpleLine(vec2(posxBars, 85), vec2(posxBars, 85 - 45), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posxBars, 85), vec2(posxBars, 85 - CAR.gas * 45), rgbm(107 / 255, 228 / 255, 96 / 255, 1), barWidth)

        posxAccelerator = posxBars - 43
        if (CAR.gas * 100) < 98.99 then
          ui.setCursor(vec2(posxAccelerator, 23))
          ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), 14, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posxAccelerator, 17))
          ui.dwriteTextAligned("∞", 22, ui.Alignment.Center, ui.Alignment.Start, vec2(85, 30), false, rgbm(107 / 255, 228 / 255, 96 / 255, 1))
        end
        -- 

        -- Barras do freio:
        posxBrake = posxBars - 20 -- Posição X das barras e números do freio
        ui.drawSimpleLine(vec2(posxBrake, 85), vec2(posxBrake, 85 - 45), rgbm(0.2, 0.2, 0.2, 0.6), barWidth)
        ui.drawSimpleLine(vec2(posxBrake, 85), vec2(posxBrake, 85 - CAR.brake * 45), rgbm(226 / 255, 12 / 255, 50 / 255, 1), barWidth)

        posxAccelerator = posxBars - 43
        if (CAR.brake * 100) < 98.99 then
          ui.setCursor(vec2(posxAccelerator, 23))
          ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), 14, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posxAccelerator, 17))
          ui.dwriteTextAligned("∞", 22, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30), false, rgbm(226 / 255, 12 / 255, 50 / 255, 1))
        end
        --

        -- Texto das marchas:
        local gear = tostring(CAR.gear);
        if gear == "0" then
          gear = "N";
        elseif gear == "-1" then
         gear = "R";
        end
        ui.pushDWriteFont("Font/Montserrat-Bold.ttf")
        ui.setCursor(vec2(-10, 8 + 22))
        ui.dwriteTextAligned(gear, 35, ui.Alignment.Center, ui.Alignment.Center, vec2(86, 33), false, rgbm(255, 255, 255, 1))
        ui.popDWriteFont()
        --
        
        -- Velocidade Km/h:
        speed = string.format("%d", math.round(CAR.speedKmh))
        ui.setCursor(vec2(-10, 49 + 22))
        ui.pushDWriteFont("Font/Montserrat-Bold.ttf")
        ui.dwriteTextAligned(speed, 17, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30), false, rgbm(255, 255, 255, 1))   
        --

        ui.endPivotScale(Size, vec2(0, 22)) -- Escala da janela
    end
end

function script.iRacingHUD_Settings(dt)
    Size = ui.slider('##Size', Size, 1, 2, string.format("%.2f", Size - 1), nil);
  
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