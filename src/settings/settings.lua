local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pitLaneSettings = require("src.settings.tabs.pitLaneSettings")
local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local sessionFlagsSettings = require("src.settings.tabs.sessionFlagsSettings")
local deltaBarSettings = require("src.settings.tabs.deltaBarSettings")
local mapSettings = require("src.settings.tabs.mapSettings")
local leaderboardSettings = require("src.settings.tabs.leaderboardSettings")
local tyresSettings = require("src.settings.tabs.tyresSettings")

local toggleButton = require("src.ui.buttons.toggleButton")
local button = require("src.ui.buttons.button")
local slider = require("src.ui.selectors.slider")

local language = require("language.language")
local window = require("common.window")
local droplist = require("src.ui.selectors.droplist")

local settings = {}

local defaultValues = {
    optionLanguage = 1,
    selectedSpeed = 1,
    selectedTemperature = 1,
    selectedFuel = 1,
    transparancy = 0.85,
    windowsColor = rgbm.from0255(18, 21, 29, 0.85)
}
settings.store = ac.storage(defaultValues)

COLOR = {
    RED = rgbm.from0255(255, 0, 0, 1),
    RED_DARK = rgbm.from0255(200, 0, 0, 1),
    GREEN = rgbm.from0255(90, 212, 51, 1),
    BLUE = rgbm.from0255(0, 89, 208, 1),
    BLUE_SKY = rgbm.from0255(0, 191, 255, 1),
    YELLOW = rgbm.from0255(255, 255, 0, 1),
    YELLOW_DARK = rgbm.from0255(255, 203, 0, 1),
    WHITE = rgbm.from0255(255, 255, 255, 1),
    BLACK = rgbm.from0255(0, 0, 0, 1),
    GRAY = rgbm.from0255(119, 118, 124, 0.3),
    GRAY_BG = rgbm.from0255(55, 55, 63, 0.85),
    WHITE_LINE = rgbm.from0255(255, 255, 255, 0.8)
}

local tabPin = false
SettingsActive = false
WindowsColor = settings.store.windowsColor
SelectedSpeed = settings.store.selectedSpeed
SelectedTemperature = settings.store.selectedTemperature
SelectedFuel = settings.store.selectedFuel

if settings.store.optionLanguage ~= language.getCurrentLanguage() then
    language.setlanguage(settings.store.optionLanguage)
end

local isLatestVersion = true
local onlineVersion = nil
local isTabUpdateActive = false
local function verifyVersion()
    if onlineVersion == nil then
        local manifest = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\manifest.ini")
        local currentVersion = ''
        if manifest ~= nil then
            currentVersion = manifest:get('ABOUT', 'VERSION', '')
            if currentVersion == '' then
                return
            end
            web.get("https://www.overtake.gg/downloads/chn-hud.78851/", function(err, response)
                if err or response.status ~= 200 then return end

                local html = response.body

                onlineVersion = string.match(html, 'CHN HUD ([%d%.]+)')
                if onlineVersion ~= nil then
                    if onlineVersion ~= currentVersion then
                        isLatestVersion = false
                        isTabUpdateActive = true
                    end
                end
            end)
        end
    end
end
verifyVersion()

local function geral()
    if (tabPin) then
        tabPin = false
    end

    local initPos = 80
    settings.store.optionLanguage = droplist.main("##Language", language.get("LANGUAGE"), vec2(15, initPos), 160,
        settings.store.optionLanguage, language.languages)
    if settings.store.optionLanguage ~= language.getCurrentLanguage() then
        tabPin = true
        language.setlanguage(settings.store.optionLanguage)
    end

    initPos = initPos + 38
    ui.drawLine(vec2(10, initPos), vec2(WindowSettingsSize.x - 18, initPos), COLOR.WHITE_LINE, 2)

    initPos = initPos + 34
    settings.store.selectedSpeed = droplist.main("##Speed", language.get("SPEED"), vec2(20, initPos), 150,
        settings.store.selectedSpeed, { "Km/h", "Mph" })
    SelectedSpeed = settings.store.selectedSpeed

    initPos = initPos + 55
    settings.store.selectedTemperature = droplist.main("##Temperature", language.get("TEMPERATURE"), vec2(20, initPos), 150,
        settings.store.selectedTemperature, { "Celsius", "Fahrenheit" })
    SelectedTemperature = settings.store.selectedTemperature

    initPos = initPos + 55
    settings.store.selectedFuel = droplist.main("##Fuel", language.get("FUEL"), vec2(20, initPos), 150,
        settings.store.selectedFuel, { language.get("LITERS"), language.get("GALLONS") })
    SelectedFuel = settings.store.selectedFuel

    initPos = initPos + 38
    ui.drawLine(vec2(10, initPos), vec2(WindowSettingsSize.x - 18, initPos), COLOR.WHITE_LINE, 2)

    initPos = initPos + 20
    ui.setCursor(vec2(300, initPos + 20))

    -- Checkbox Pin All Apps
    if toggleButton.main("pin", vec2(300, initPos), window.store.pinAllApps, language.get("PIN_ALL_APPS")) then
        window.store.pinAllApps = not window.store.pinAllApps
        window.pinAllApps(window.store.pinAllApps)
    end

    -- Seção de Cores
    ui.dwriteDrawText(language.get("SELECT_COLOR"), 12, vec2(15, initPos), COLOR.WHITE)

    ui.pushItemWidth(150)

    initPos = initPos + 20
    ui.setCursor(vec2(20, initPos))

    ui.colorPicker(language.get('COLOR'), settings.store.windowsColor,
        ui.ColorPickerFlags.PickerHueBar + ui.ColorPickerFlags.NoInputs)

    initPos = initPos + 150

    -- Slider de Transparência
    settings.store.transparancy = slider.main(language.get("TRANSPARENCY"),
        string.format("%.0f", settings.store.transparancy * 100) .. "%", vec2(20, initPos + 10), 200,
        settings.store.transparancy, 0, 1)

    -- Atualiza a cor final combinando RGB do picker + Alpha do slider
    settings.store.windowsColor = rgbm(settings.store.windowsColor.r, settings.store.windowsColor.g,
        settings.store.windowsColor.b, settings.store.transparancy)

    initPos = initPos + 40

    if button.main(vec2(20, initPos), language.get("RESET_COLOR")) then
        settings.store.windowsColor = rgbm.from0255(18, 21, 29, 0.85)
        settings.store.transparancy = 0.85
    end
end

function settings.windowOpenSettings()
    SettingsActive = true
end

function settings.windowCloseSettings()
    SettingsActive = false
end

function settings.windowMain()
    WindowSettingsSize = ui.windowSize()
    
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
    ui.drawRectFilled(vec2(0, 0), WindowSettingsSize + ui.windowContentSize(), rgbm.from0255(18, 21, 29, 0.85), 0)
    ui.tabBar('##ID', function()
        ui.tabItem(language.get("GENERAL"), tabPin and ui.TabItemFlags.SetSelected, geral)
        ui.tabItem(language.get("PEDALS"), pedalsSettings.pedalsSettings)
        ui.tabItem(language.get("PIT_LANE"), pitLaneSettings.pitLaneSettings)
        ui.tabItem(language.get("SESSION_LAPS"), sessionLapsSettings.sessionLapsSettings)
        ui.tabItem(language.get("STARTING_LIGHTS"), startingLightsSettings.startingLightsSettings)
        ui.tabItem(language.get("SESSION_FLAGS"), sessionFlagsSettings.sessionFlagsSettings)
        ui.tabItem(language.get("DELTA_BAR"), deltaBarSettings.deltaBarSettings)
        ui.tabItem(language.get("MAP"), mapSettings.mapSettings)
        ui.tabItem(language.get("LEADERBOARD"), leaderboardSettings.leaderboardSettings)
        ui.tabItem(language.get("TYRES"), tyresSettings.tyresSettings)
    end)


    local posResize
    if not isLatestVersion and isTabUpdateActive and onlineVersion ~= nil then
        ui.drawRectFilled(vec2(0, WindowSettingsSize.y - 35) + vec2(0, ui.getScrollY()),
            WindowSettingsSize + vec2(0, ui.getScrollY()), COLOR.WHITE)

        ui.setCursor(vec2(20, WindowSettingsSize.y - 35) + vec2(0, ui.getScrollY()))
        ui.dwriteTextAligned(language.get("NEW_UPDATE"), 20, ui.Alignment.Start, ui.Alignment.Center,
            vec2(WindowSettingsSize.x, 35), false, COLOR.BLACK)
        local linkPosX = 20 + ui.measureDWriteText(language.get("NEW_UPDATE"), 20).x

        if window.isMouseInWindow(ui.mouseLocalPos(), linkPosX + 10, linkPosX + ui.measureDWriteText("CHN HUD " .. onlineVersion, 20).x + 10, WindowSettingsSize.y - 30 + ui.getScrollY(), WindowSettingsSize.y + ui.getScrollY()) then
            ui.setMouseCursor(ui.MouseCursor.Hand)
            ui.setCursor(vec2(linkPosX + 10, WindowSettingsSize.y - 30) + vec2(0, ui.getScrollY()))
            ui.dwriteTextHyperlink("CHN HUD " .. onlineVersion, 20, COLOR.RED)
            if ui.mouseClicked(ui.MouseButton.Left) then
                os.openURL("https://www.overtake.gg/downloads/chn-hud.78851/")
            end
        else
            ui.setCursor(vec2(linkPosX + 10, WindowSettingsSize.y - 30) + vec2(0, ui.getScrollY()))
            ui.dwriteTextHyperlink("CHN HUD " .. onlineVersion, 20, COLOR.BLACK)
        end

        if window.isMouseInWindow(ui.mouseLocalPos(), WindowSettingsSize.x - 38, WindowSettingsSize.x - 12, WindowSettingsSize.y - 28 + ui.getScrollY(), WindowSettingsSize.x - 2 + ui.getScrollY()) then
            ui.setMouseCursor(ui.MouseCursor.Hand)
            ui.drawRectFilled(WindowSettingsSize - vec2(38, 30) + vec2(0, ui.getScrollY()),
                WindowSettingsSize - vec2(12, 4) + vec2(0, ui.getScrollY()), COLOR.RED_DARK, 5)
            ui.drawLine(WindowSettingsSize - vec2(33, 25) + vec2(0, ui.getScrollY()),
                WindowSettingsSize - vec2(17, 9) + vec2(0, ui.getScrollY()), COLOR.WHITE, 2)
            ui.drawLine(WindowSettingsSize - vec2(33, 9) + vec2(0, ui.getScrollY()),
                WindowSettingsSize - vec2(17, 25) + vec2(0, ui.getScrollY()), COLOR.WHITE, 2)
            if ui.mouseClicked(ui.MouseButton.Left) then
                isTabUpdateActive = false
            end
        else
            ui.drawRectFilled(WindowSettingsSize - vec2(38, 30) + vec2(0, ui.getScrollY()),
                WindowSettingsSize - vec2(12, 4) + vec2(0, ui.getScrollY()), COLOR.GRAY_BG, 5)
            ui.drawLine(WindowSettingsSize - vec2(33, 25) + vec2(0, ui.getScrollY()),
                WindowSettingsSize - vec2(17, 9) + vec2(0, ui.getScrollY()), COLOR.WHITE, 2)
            ui.drawLine(WindowSettingsSize - vec2(33, 9) + vec2(0, ui.getScrollY()),
                WindowSettingsSize - vec2(17, 25) + vec2(0, ui.getScrollY()), COLOR.WHITE, 2)
        end
        posResize = WindowSettingsSize - vec2(45, 65) + vec2(0, ui.getScrollY())
    else
        posResize = WindowSettingsSize - vec2(45, 45) + vec2(0, ui.getScrollY())
    end

    if window.isMouseInWindow(ui.mouseLocalPos(), posResize.x - 5, posResize.x + 25, posResize.y - 5, posResize.y + 25) then
        ui.setMouseCursor(ui.MouseCursor.Hand)
        if ui.mouseClicked(ui.MouseButton.Left) then
            local settingsINI = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\CHN-HUD\\manifest.ini")
            if settingsINI ~= nil then
                local size = settingsINI:get("WINDOW_0", "SIZE", nil)
                if size ~= nil then
                    local sizeSplit = string.split(size[1], ",")
                    window.resize(vec2(tonumber(sizeSplit[1]), tonumber(sizeSplit[2])), "Settings CHN")
                end
            end
        end
    end
    ui.drawLine(posResize + vec2(10), posResize + vec2(20), COLOR.WHITE, 2)
    ui.drawLine(posResize + vec2(20), posResize + vec2(20, 10), COLOR.WHITE, 2)
    ui.drawLine(posResize + vec2(0, 20), posResize + vec2(10, 20), COLOR.WHITE, 2)
    ui.drawLine(posResize + vec2(0, 10), posResize + vec2(0, 20), COLOR.WHITE, 2)
end

return settings
