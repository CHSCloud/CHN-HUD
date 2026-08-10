local mapSettings = require("src.settings.tabs.mapSettings")
local utils = require("common.utils")
local sections = {}

-- Aumamenta janela com base no retângulo do texto
--- @param data mapData
--- @param initRect vec2 -- Coordenadas iniciais
--- @param finalRect vec2 -- Coordenadas finais
local function resizeWithText(data, initRect, finalRect)
	if initRect.x < 0 and math.abs(initRect.x) > data.offset.x then
		data.currentWindowSize.x = data.currentWindowSize.x - data.offset.x + math.abs(initRect.x)
		data.offset.x = math.abs(initRect.x)
	end
	if finalRect.x > data.currentWindowSize.x - data.offset.x then
		data.currentWindowSize.x = finalRect.x + data.offset.x
	end
	if initRect.y < 0 and math.abs(initRect.y) > data.offset.y then
		data.currentWindowSize.y = data.currentWindowSize.y - data.offset.y + math.abs(initRect.y)
		data.offset.y = math.abs(initRect.y)
	end
	if finalRect.y > data.currentWindowSize.y - data.offset.y then
		data.currentWindowSize.y = finalRect.y + data.offset.y
	end
end

-- Altera o tamanho da janela baseado nas seções
--- @param data mapData
function sections.resizeWindowMap(data)
	local scale
	local textPosition
	local lenght
	local borderMap = 2
	if mapSettings.store.borderLenght > 0 then
		borderMap = mapSettings.store.borderLenght
	end
	if not mapSettings.store.focus then
		local ratio = (data.baseWindowSize.y * mapSettings.store.mapScale) / data.canvasSize.y
		scale = data.canvasScale * ratio
		lenght = mapSettings.store.sectionsLenght * 2
		if mapSettings.store.sectionsType == 1 then
			for i = 1, #data.trackSections, 1 do
				local posRotated
				local textLenght = (vec2(lenght, lenght) / 2) * mapSettings.store.mapScale
				if data.trackSections[i].position == 1 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale),
						data.angle
					)
				elseif data.trackSections[i].position == 2 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale),
						data.angle
					)
					local dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
					dir = utils.rotateVec(dir, data.angle)
					posRotated = posRotated + dir * (mapSettings.store.trackLenght / 2 + borderMap + lenght / 4) * mapSettings.store.mapScale
				else
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale),
						data.angle
					)
					local dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
					dir = utils.rotateVec(dir, data.angle)
					posRotated = posRotated + dir * (mapSettings.store.trackLenght / 2 + borderMap + lenght / 4) * mapSettings.store.mapScale
				end
				textPosition = data.windowCenter + posRotated
				resizeWithText(data, textPosition - textLenght, textPosition + textLenght)

				data.trackSections[i].namePosition = textPosition
			end
		else
			for i = 1, #data.trackSections, 1 do
				local longestText, count = utils.findLongestWord(data.trackSections[i].name)
				local textLenght = ui.measureDWriteText(longestText, (lenght / 2) * mapSettings.store.mapScale) + vec2(5) * mapSettings.store.mapScale
				textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0, 5) * mapSettings.store.mapScale
				local posRotated
				local dir = vec2(0, 0)
				if data.trackSections[i].position == 1 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale),
						data.angle
					)
				elseif data.trackSections[i].position == 2 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale),
						data.angle
					)
					dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
					dir = utils.rotateVec(dir, data.angle)
				else
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale),
						data.angle
					)
					dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
					dir = utils.rotateVec(dir, data.angle)
				end
				local distance
				if dir.x > 0 then
					distance = utils.remapInterval(dir.x, 0, 1, textLenght.x / 20, 1)
				else
					distance = utils.remapInterval(dir.x, -1, 0, 1, textLenght.x / 20)
				end
				local centerText = posRotated
					+ dir * (textLenght.x / (2 * distance) + ((mapSettings.store.trackLenght + borderMap) / 2) * mapSettings.store.mapScale)
				textPosition = data.windowCenter + centerText - textLenght / 2
				resizeWithText(data, textPosition, textPosition + textLenght)

				data.trackSections[i].namePosition = textPosition
			end
		end
	else
		scale = data.canvasScale
		local ratio = data.canvasSize.y / (data.baseWindowSize.y * mapSettings.store.mapScale)
		lenght = (mapSettings.store.sectionsLenght * 2) * ratio * mapSettings.store.mapScale
		if mapSettings.store.sectionsType == 1 then
			local textLenght = (vec2(lenght, lenght) / 2)
			for i = 1, #data.trackSections, 1 do
				local posRotated
				if data.trackSections[i].position == 1 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale),
						data.angle
					)
				elseif data.trackSections[i].position == 2 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale),
						data.angle
					)
					local dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
					dir = utils.rotateVec(dir, data.angle)
					posRotated = posRotated + dir * (mapSettings.store.trackLenght / 2 + borderMap + textLenght.x)
				else
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale),
						data.angle
					)
					local dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
					dir = utils.rotateVec(dir, data.angle)
					posRotated = posRotated + dir * (mapSettings.store.trackLenght / 2 + borderMap + textLenght.x)
				end
				posRotated = data.canvasCenter + posRotated
				textPosition = posRotated
				data.trackSections[i].namePosition = textPosition
			end
		else
			for i = 1, #data.trackSections, 1 do
				local longestText, count = utils.findLongestWord(data.trackSections[i].name)
				local textLenght = (ui.measureDWriteText(longestText, lenght / 2) + vec2(5))
				textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0, 5)
				local posRotated
				local dir = vec2(0, 0)
				if data.trackSections[i].position == 1 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].center.x - data.trackCenterX) * scale, (data.trackSections[i].center.y - data.trackCenterY) * scale),
						data.angle
					)
				elseif data.trackSections[i].position == 2 then
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].left.x - data.trackCenterX) * scale, (data.trackSections[i].left.y - data.trackCenterY) * scale),
						data.angle
					)
					dir = (data.trackSections[i].right - data.trackSections[i].left):normalize()
					dir = utils.rotateVec(dir, data.angle)
				else
					posRotated = utils.rotateVec(
						vec2((data.trackSections[i].right.x - data.trackCenterX) * scale, (data.trackSections[i].right.y - data.trackCenterY) * scale),
						data.angle
					)
					dir = (data.trackSections[i].left - data.trackSections[i].right):normalize()
					dir = utils.rotateVec(dir, data.angle)
				end
				local distance
				if dir.x > 0 then
					distance = utils.remapInterval(dir.x, 0, 1, textLenght.x / 30, 1)
				else
					distance = utils.remapInterval(dir.x, -1, 0, 1, textLenght.x / 30)
				end
				local centerText = posRotated + dir * (textLenght.x / (2 * distance) + (mapSettings.store.trackLenght + borderMap))
				textPosition = data.canvasCenter + centerText - textLenght / 2

				data.trackSections[i].namePosition = textPosition
			end
		end
	end
end

-- Desenha nomes da pista
--- @param data mapData
function sections.drawTrackSections(data)
	local scale
	local textLenght
	local lenght
	if mapSettings.store.focus then
		scale = data.canvasSize.y / (data.baseWindowSize.y * mapSettings.store.mapScale)
		lenght = (mapSettings.store.sectionsLenght * 2) * mapSettings.store.mapScale
	else
		scale = mapSettings.store.mapScale
		lenght = mapSettings.store.sectionsLenght * 2
	end
	if mapSettings.store.sectionsType == 1 then
		textLenght = (vec2(lenght, lenght) / 2) * scale
		for i = 1, #data.trackSections, 1 do
			local position = data.trackSections[i].namePosition + data.offset
			ui.drawCircleFilled(position, textLenght.x, mapSettings.store.sectionsBgColor, 20)
			ui.setCursor(position - textLenght / 2)
			ui.dwriteTextAligned(
				data.trackSections[i].number,
				(lenght / 2) * scale,
				ui.Alignment.Center,
				ui.Alignment.Center,
				textLenght,
				false,
				mapSettings.store.sectionsTextColor
			)
		end
	else
		for i = 1, #data.trackSections, 1 do
			if data.trackSections[i].name ~= "" then
				local longestText, count = utils.findLongestWord(data.trackSections[i].name)
				local textLenght = ui.measureDWriteText(longestText, (lenght / 2) * scale) + vec2(5) * scale
				textLenght = textLenght + vec2(0, textLenght.y * count) + vec2(0, 5) * scale
				local position = data.trackSections[i].namePosition + data.offset
				ui.drawRectFilled(position, position + textLenght, mapSettings.store.sectionsBgColor, 3 * mapSettings.store.mapScale)
				ui.setCursor(position)
				ui.dwriteTextAligned(
					data.trackSections[i].name:gsub("\n$", ""),
					(lenght / 2) * scale,
					ui.Alignment.Center,
					ui.Alignment.Center,
					textLenght,
					false,
					mapSettings.store.sectionsTextColor
				)
			end
		end
	end
end

return sections
