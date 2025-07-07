STORAGE_SIZE = ac.storage("Size", 1)
Size = STORAGE_SIZE:get()

STORAGE_MPH = ac.storage("MPH", false)
MphFlag = STORAGE_MPH:get()

BaseWindowWidth = 202
BaseWindowHeight = 72 + 22

OldWindowWidth = BaseWindowWidth
OldWindowHeight = BaseWindowHeight
NewWindowWidth = OldWindowWidth
NewWindowHeight = OldWindowHeight

function script.windowMain(dt)
    SIM = ac.getSim()
    CAR = ac.getCar(SIM.focusedCar)

    if CAR == nil then
        ac.debug("focused driver error");
    else
        ui.beginScale()

        -- BackGround
        ui.drawRectFilled(vec2(0, 0), vec2(203, 95), rgbm(0, 0, 0, 0.30), 0)
        
        -- Volante:
        ui.beginRotation()
        ui.setCursor(vec2(125, 22))
        ui.image("Icons/Wheel.png", vec2(60, 72), ui.ImageFit.Fit)
        ui.endRotation(-CAR.steer + 90)
        --

        -- Barras do acelerador:
        posX_Barras = 100 -- Move as barras e textos
        larguraBarras = 17 -- Largura das barras de freio e acelerador
        ui.drawSimpleLine(vec2(posX_Barras, 85), vec2(posX_Barras, 85 - 45), rgbm(0.2, 0.2, 0.2, 0.6), larguraBarras)
        ui.drawSimpleLine(vec2(posX_Barras, 85), vec2(posX_Barras, 85 - CAR.gas * 45), rgbm(107 / 255, 228 / 255, 96 / 255, 1), larguraBarras)

        posX_textoAcelerador = posX_Barras - 43
        if (CAR.gas * 100) < 98.99 then
          ui.setCursor(vec2(posX_textoAcelerador, 23))
          ui.dwriteTextAligned(string.format("%.0f", CAR.gas * 100), 14, ui.Alignment.Center, ui.Alignment.Start, vec2(86, 30), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posX_textoAcelerador, 17))
          ui.dwriteTextAligned("∞", 22, ui.Alignment.Center, ui.Alignment.Start, vec2(85, 30), false, rgbm(107 / 255, 228 / 255, 96 / 255, 1))
        end
        -- 

        -- Barras do freio:
        posX_freio = posX_Barras - 20 -- Posição X freio
        ui.drawSimpleLine(vec2(posX_freio, 85), vec2(posX_freio, 85 - 45), rgbm(0.2, 0.2, 0.2, 0.6), larguraBarras)
        ui.drawSimpleLine(vec2(posX_freio, 85), vec2(posX_freio, 85 - CAR.brake * 45), rgbm(226 / 255, 12 / 255, 50 / 255, 1), larguraBarras)

         posX_textoAcelerador = posX_Barras - 43
        if (CAR.brake * 100) < 98.99 then
          ui.setCursor(vec2(posX_textoAcelerador, 23))
          ui.dwriteTextAligned(string.format("%.0f", CAR.brake * 100), 14, ui.Alignment.Center, ui.Alignment.Start, vec2(45, 30), false, rgbm(255, 255, 255, 1))
        else 
          ui.setCursor(vec2(posX_textoAcelerador, 17))
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

        ui.endPivotScale(Size, vec2(0, 22)) -- Escala background
    end
end

function script.iRacingHUD_Settings(dt)
    min = 1
    max = 2
    Size = ui.slider('##Size', Size, min, max, string.format("%.2f", Size - 1), nil);
  
    STORAGE_SIZE:set(Size)
    STORAGE_MPH:set(MphFlag)
  
    local iniFile = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\iRacingGearHUD\\manifest.ini")
  
    NewWindowHeight = BaseWindowHeight * Size
    NewWindowWidth = BaseWindowWidth * Size
  
    if NewWindowHeight ~= OldWindowHeight or NewWindowWidth ~= OldWindowWidth then
      iniFile:setAndSave("WINDOW_...", "SIZE", " " .. tostring(NewWindowWidth) .. ", " .. tostring(NewWindowHeight))
      OldWindowHeight = NewWindowHeight
      OldWindowWidth = NewWindowWidth
    end
  end