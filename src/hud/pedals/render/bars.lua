local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local bars = {}

---@param data pedalsData
---@param value number
---@param color rgbm
---@param posBar vec2
local function drawBarText(data, value, color, posBar)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    if value < 98.99 then
        ui.setCursor(vec2(data.currentWindowWidth, posBar.y - 17 * pedalsSettings.store.pedalsScale))
        ui.dwriteTextAligned(string.format("%.0f", value), data.fontBar, ui.Alignment.Center, ui.Alignment.Start,
            vec2(20, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
    else
        ui.setCursor(vec2(data.currentWindowWidth, posBar.y - 25 * pedalsSettings.store.pedalsScale))
        ui.dwriteTextAligned("∞", data.fontBarInfinite, ui.Alignment.Center, ui.Alignment.Start,
            vec2(20, 30):scale(pedalsSettings.store.pedalsScale), false, color)
    end
end


---@param data pedalsData
---@param posBar vec2
---@param value number
---@param color rgbm
---@param inverted boolean
local function drawBarWithLimits(data, posBar, value, color, inverted)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    ui.drawRectFilled(posBar, posBar + data.barLimitSize, COLOR.GRAY_BG)

    ui.drawRectFilled(
        posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle),
        posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle) + data.barMidleSize,
        COLOR.GRAY_BG
    )

    ui.drawRectFilled(
        posBar + vec2(0, data.barLimitSize.y + data.barMidleSize.y + 2 * data.barPaddingMidle),
        posBar + vec2(0, data.barLimitSize.y + data.barMidleSize.y + 2 * data.barPaddingMidle) + data.barLimitSize,
        COLOR.GRAY_BG
    )

    if inverted then
        if value == 0 then
            ui.drawRectFilled(posBar, posBar + data.barLimitSize, color)
        end
        if value < 1 then
            ui.drawRectFilled(
                posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y),
                posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y) +
                data.barLimitSize,
                color
            )
        end
        ui.drawRectFilled(
            posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle + (value * data.barMidleSize.y)),
            posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle) + data.barMidleSize,
            color
        )
    else
        if value > 0 then
            ui.drawRectFilled(
                posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y),
                posBar + vec2(0, data.barLimitSize.y + 2 * data.barPaddingMidle + data.barMidleSize.y) +
                data.barLimitSize,
                color
            )
        end
        if value == 1 then
            ui.drawRectFilled(posBar, posBar + data.barLimitSize, color)
        end
        ui.drawRectFilled(
            posBar +
            vec2(0, data.barLimitSize.y + data.barPaddingMidle + data.barMidleSize.y - (value * data.barMidleSize.y)),
            posBar + vec2(0, data.barLimitSize.y + data.barPaddingMidle) + data.barMidleSize,
            color
        )
    end
end

---@param data pedalsData
---@param posBar vec2
---@param value number
---@param color rgbm
---@param inverted boolean
local function drawBarSimple(data, posBar, value, color, inverted)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    ui.drawRectFilled(posBar, posBar + data.barSize, COLOR.GRAY_BG)

    if inverted then
        ui.drawRectFilled(posBar + vec2(0, (value * data.barSize.y)), posBar + data.barSize, color)
    else
        ui.drawRectFilled(posBar + vec2(0, data.barSize.y - (value * data.barSize.y)), posBar + data.barSize, color)
    end
end

---@param data pedalsData
function bars.drawClutch(data)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

    if pedalsSettings.store.textBarsActive then
        drawBarText(data, 100 - CAR.clutch * 100, COLOR.BLUE, posBar)
    end

    if pedalsSettings.store.pedalLimitsLines then
        drawBarWithLimits(data, posBar, CAR.clutch, COLOR.BLUE, true)
    else
        drawBarSimple(data, posBar, CAR.clutch, COLOR.BLUE, true)
    end

    data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

---@param data pedalsData
function bars.drawBrake(data)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

    if pedalsSettings.store.textBarsActive then
        drawBarText(data, CAR.brake * 100, COLOR.RED_DARK, posBar)
    end

    if pedalsSettings.store.pedalLimitsLines then
        drawBarWithLimits(data, posBar, CAR.brake, COLOR.RED_DARK, false)
    else
        drawBarSimple(data, posBar, CAR.brake, COLOR.RED_DARK, false)
    end

    data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

---@param data pedalsData
function bars.drawAccelerator(data)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

    if pedalsSettings.store.textBarsActive then
        drawBarText(data, CAR.gas * 100, COLOR.GREEN, posBar)
    end

    if pedalsSettings.store.pedalLimitsLines then
        drawBarWithLimits(data, posBar, CAR.gas, COLOR.GREEN, false)
    else
        drawBarSimple(data, posBar, CAR.gas, COLOR.GREEN, false)
    end

    data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

---@param data pedalsData
function bars.drawHandbrake(data)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    local posBar = vec2(data.currentWindowWidth, 6 * pedalsSettings.store.pedalsScale + data.contentTop)

    if pedalsSettings.store.textBarsActive then
        drawBarText(data, CAR.handbrake * 100, COLOR.YELLOW, posBar)
    end

    if pedalsSettings.store.pedalLimitsLines then
        drawBarWithLimits(data, posBar, CAR.handbrake, COLOR.YELLOW, false)
    else
        drawBarSimple(data, posBar, CAR.handbrake, COLOR.YELLOW, false)
    end

    data.currentWindowWidth = data.currentWindowWidth + data.barSize.x + data.barSpace
end

return bars
