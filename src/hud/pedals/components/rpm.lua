local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")

local rpm = {}

---@param data pedalsData
function rpm.drawRpm(data)
    local rpmStart = CAR.rpmLimiter * 0.80
    local rpmFinal = CAR.rpmLimiter * 0.98
    local rpmRange = rpmFinal - rpmStart

    if pedalsSettings.store.rpmType == 1 then
        local area = 0
        local spaceCircles
        local space
        local center
        local posY
        if pedalsSettings.store.rpmPos == 5 then
            space = data.currentWindowWidth * 0.95 - data.contentPositions[1][2].x - data.contentPositions[1][1].x - data.contentPositions[2][2].x
            if space < 75 * pedalsSettings.store.pedalsScale then
                data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
                space = data.currentWindowWidth * 0.95 - data.contentPositions[1][2].x - data.contentPositions[1][1].x - data.contentPositions[2][2].x
            end

            if space == data.currentWindowWidth * 0.95 then
                center = data.currentWindowWidth / 2
            else
                center = data.contentPositions[1][1].x + data.contentPositions[1][2].x +
                (data.currentWindowWidth - data.contentPositions[1][1].x -data.contentPositions[1][2].x - data.contentPositions[2][2].x) / 2
            end
            posY = data.contentPositions[pedalsSettings.store.rpmPos][1].y + 10 * pedalsSettings.store.pedalsScale
        else
            space = data.currentWindowWidth * 0.95 - data.contentPositions[3][2].x - data.contentPositions[3][1].x - data.contentPositions[4][2].x
            if space < 75 * pedalsSettings.store.pedalsScale then
                data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
                space = data.currentWindowWidth * 0.95 - data.contentPositions[3][2].x - data.contentPositions[3][1].x - data.contentPositions[4][2].x
            end
            if space == data.currentWindowWidth * 0.95 then
                center = data.currentWindowWidth / 2
            else
                center = data.contentPositions[3][2].x + data.contentPositions[3][1].x +
                (data.currentWindowWidth - data.contentPositions[3][1].x - data.contentPositions[3][2].x - data.contentPositions[4][2].x) / 2
            end
            posY = data.contentPositions[pedalsSettings.store.rpmPos][1].y - 10 * pedalsSettings.store.pedalsScale
        end

        area = space / data.currentWindowWidth
        spaceCircles = math.min(
        (data.currentWindowWidth * area) / (pedalsSettings.store.numLights * pedalsSettings.store.pedalsScale), 18)
        pedalsData.setPositionContentCenter(data, pedalsSettings.store.rpmPos,
            vec2(space, 20 * pedalsSettings.store.pedalsScale))

        local initPos = center -
        (((pedalsSettings.store.numLights - 1) * spaceCircles) / 2) * pedalsSettings.store.pedalsScale
        local level = 0
        if CAR.rpm >= rpmStart then
            level = ((pedalsSettings.store.numLights * (CAR.rpm - rpmStart)) / rpmRange) + 1
        end
        local color = COLOR.GREEN
        if pedalsSettings.store.rpmProcessType == 1 then
            for i = 1, pedalsSettings.store.numLights, 1 do
                if (CAR.rpm >= rpmFinal * 0.98) then
                    level = pedalsSettings.store.numLights
                    if (8 * TIMER) % 2 >= 1 then
                        color = COLOR.GRAY_BG
                    else
                        color = COLOR.RED
                    end
                elseif i > level then
                    color = COLOR.GRAY_BG
                elseif i >= pedalsSettings.store.numLights * 0.78 then
                    color = COLOR.RED_DARK
                elseif i >= pedalsSettings.store.numLights * 0.45 then
                    color = COLOR.YELLOW
                end
                ui.drawCircleFilled(vec2(initPos, posY), (spaceCircles * 0.45) * pedalsSettings.store.pedalsScale, color,
                    20 * pedalsSettings.store.pedalsScale)
                initPos = initPos + spaceCircles * pedalsSettings.store.pedalsScale
            end
        elseif pedalsSettings.store.rpmProcessType == 2 then
            if (CAR.rpm >= CAR.rpmLimiter * 0.96) then
                level = pedalsSettings.store.numLights
                if (8 * TIMER) % 2 >= 1 then
                    color = COLOR.GRAY_BG
                else
                    color = COLOR.RED_DARK
                end
            elseif (CAR.rpm >= CAR.rpmLimiter * 0.95) then
                color = COLOR.RED_DARK
            elseif (CAR.rpm >= CAR.rpmLimiter * 0.90) then
                color = COLOR.YELLOW
            end

            for i = 1, pedalsSettings.store.numLights, 1 do
                if i > level then
                    color = COLOR.GRAY_BG
                end
                ui.drawCircleFilled(vec2(initPos, posY), (spaceCircles * 0.45) * pedalsSettings.store.pedalsScale, color,
                    20 * pedalsSettings.store.pedalsScale)
                initPos = initPos + spaceCircles * pedalsSettings.store.pedalsScale
            end
        end
    elseif pedalsSettings.store.rpmType == 2 then
        local width
        local space
        local initPosX
        local center
        local initPosY
        if pedalsSettings.store.rpmPos == 5 then
            space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x
            width = space * pedalsSettings.store.barLength
            if space < 75 * pedalsSettings.store.pedalsScale then
                data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
                space = data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x
                width = space * pedalsSettings.store.barLength
            end

            center = data.contentPositions[1][2].x +
            (data.currentWindowWidth - data.contentPositions[1][2].x - data.contentPositions[2][2].x) / 2
            pedalsData.setPositionContentCenter(data, pedalsSettings.store.rpmPos,
                vec2(width, 20 * pedalsSettings.store.pedalsScale))
            initPosY = data.contentPositions[1][1].y + 4 * pedalsSettings.store.pedalsScale
        else
            space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x
            width = space * pedalsSettings.store.barLength
            if space < 75 * pedalsSettings.store.pedalsScale then
                data.currentWindowWidth = data.currentWindowWidth + (75 * pedalsSettings.store.pedalsScale - space)
                space = data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x
                width = space * pedalsSettings.store.barLength
            end

            center = data.contentPositions[3][2].x +
            (data.currentWindowWidth - data.contentPositions[3][2].x - data.contentPositions[4][2].x) / 2
            pedalsData.setPositionContentCenter(data, pedalsSettings.store.rpmPos,
                vec2(width, 20 * pedalsSettings.store.pedalsScale))
            initPosY = data.contentPositions[pedalsSettings.store.rpmPos][1].y + 2 * pedalsSettings.store.pedalsScale
        end
        local barHeight = 14 * pedalsSettings.store.pedalsScale
        initPosX = center - (width / 2)
        ui.drawRectFilled(vec2(initPosX, initPosY), vec2(initPosX + width, initPosY + barHeight), COLOR.GRAY_BG,
            10 * pedalsSettings.store.pedalsScale)
        if CAR.rpm >= rpmStart then
            local length = initPosX + ((width * (CAR.rpm - rpmStart)) / rpmRange)
            local color = COLOR.GREEN

            if (CAR.rpm >= rpmFinal) then
                length = initPosX + width
                if (8 * TIMER) % 2 >= 1 then
                    color = COLOR.GRAY_BG
                else
                    color = COLOR.RED_DARK
                end
            elseif (CAR.rpm >= rpmFinal * 0.95) then
                color = COLOR.RED_DARK
            elseif (CAR.rpm >= rpmFinal * 0.90) then
                color = COLOR.YELLOW
            end

            ui.drawRectFilled(vec2(initPosX, initPosY), vec2(length, initPosY + barHeight), color,
                10 * pedalsSettings.store.pedalsScale)
        end
    end
end

return rpm
