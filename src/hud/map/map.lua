local window = require("common.window")
local utils = require("common.utils")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local mapSettings = require("src.settings.tabs.mapSettings")
local mapData = require("src.data.map.mapData")

local drs = require("src.hud.map.components.drs")
local sections = require("src.hud.map.components.sections")
local sectors = require("src.hud.map.components.sectors")
local players = require("src.hud.map.components.players")
local track = require("src.hud.map.components.track")

local map = {}

---@type mapData
local data = mapData.new()
mapData.initMap(data)

function map.windowMain()
	if mapSettings.store.resetSectionsINI then
		data.trackSections = mapSettings.resetSectionsINI()
	end
	if mapSettings.store.trackSectionsEdited then
		data.trackSections = mapSettings.loadSectionsINI()
	end

	ui.pushDWriteFont("fonts/Montserrat-Bold.ttf")
	data.offset = vec2(0, 0)
	data.currentWindowSize = vec2(300, 300)
	data.currentWindowSize = data.currentWindowSize:scale(mapSettings.store.mapScale)
	data.windowCenter = data.currentWindowSize / 2
	data.canvasScale = (data.canvasSize.y - (data.padding * 2)) / data.trackLength
	if mapSettings.store.focus then
		data.trackCenterX = CAR.position.x
		data.trackCenterY = CAR.position.z
		data.angle = math.deg(math.atan2(CAR.look.z, -CAR.look.x) + math.pi / 2)
	else
		data.trackCenterX = (data.minPos.x + data.maxPos.x) / 2
		data.trackCenterY = (data.minPos.y + data.maxPos.y) / 2
		if mapSettings.isClockwise then
			data.angle = math.deg(-math.atan2(data.dirTrack.y, data.dirTrack.x) + math.pi) + mapSettings.store.angle
		else
			data.angle = math.deg(-math.atan2(data.dirTrack.y, data.dirTrack.x)) + mapSettings.store.angle
		end
	end

	if mapSettings.store.sectionsTrackActive then
		sections.resizeWindowMap(data)
	end

	-- Desenha borda
	if data.canvas == nil then
		return
	end
	data.canvas:clear()
	data.canvas:update(function()
		track.drawTrack(data, mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2, mapSettings.store.colorBorder)
		-- Desenha pista
		track.drawTrack(data, mapSettings.store.trackLenght, mapSettings.store.colorTrack)
		-- Desenha DRS
		if mapSettings.store.drsActive then
			drs.drawDRS(data, mapSettings.store.trackLenght / 1.8)
		end
		-- Desenha setores
		if mapSettings.store.sectorsActive then
			sectors.drawSectors(data, mapSettings.store.trackLenght / 1.8, mapSettings.store.colorSectors)
		end

		-- Desenha bandeira de largada
		if mapSettings.store.borderLenght < 0 then
			sectors.drawStartFlag(data, (mapSettings.store.trackLenght + 6) / 1.3)
		else
			sectors.drawStartFlag(data, (mapSettings.store.trackLenght + mapSettings.store.borderLenght * 2) / 1.3)
		end
	end)

	-- Animação do Background
	if window.isMouseInWindow(ui.mouseLocalPos(), 0, ui.windowSize().x, 0, ui.windowSize().y) then
		if data.transparancy < 0.85 then
			if 20 * TIMER % 6 >= 1 then
				data.transparancy = data.transparancy + 0.1
			end
		end
		ui.drawRectFilled(
			vec2(0, 0),
			data.currentWindowSize,
			rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, data.transparancy),
			20 * mapSettings.store.mapScale
		)
	else
		if data.transparancy > 0 then
			if 20 * TIMER % 6 >= 1 then
				data.transparancy = data.transparancy - 0.1
			end
			ui.drawRectFilled(
				vec2(0, 0),
				data.currentWindowSize,
				rgbm(WindowsColor.r, WindowsColor.g, WindowsColor.b, data.transparancy),
				20 * mapSettings.store.mapScale
			)
		else
			data.transparancy = 0
		end
	end

	if mapSettings.store.focus then
		if data.canvasZoom == nil then
			return
		end
		local zoomScaled = mapSettings.store.zoom * mapSettings.store.mapScale
		if mapSettings.store.sectionsTrackActive then
			data.canvas:update(function()
				sections.drawTrackSections(data)
				players.drawPlayers(data)
			end)
		else
			data.canvas:update(function()
				players.drawPlayers(data)
			end)
		end
		data.canvasZoom:updateWithShader({
			textures = { canvas = data.canvas },
			values = {
				zoom = data.currentWindowSize.x / (2 * (2 * zoomScaled + data.currentWindowSize.x)),
			},
			shader = [[
                SamplerState mapSample {
                    Filter = MIN_MAG_MIP_LINEAR;
                    AddressU = Wrap;
                    AddressV = Wrap;
                };

                float remap(float v, float inMin, float inMax, float outMin, float outMax) {
                    return outMin + (v - inMin) * (outMax - outMin) / (inMax - inMin);
                }

                float4 main(PS_IN pin) {
                    float4 mapCanvas = canvas.Sample(mapSample, pin.Tex);
                    float distanceDromCenter = clamp(distance(float2(0.5f, 0.5f), pin.Tex), zoom - 0.05f, zoom);
                    return lerp(mapCanvas, float4(0,0,0,0), remap(distanceDromCenter, zoom - 0.05f, zoom, 0, 1));
                }
            ]],
		})

		ui.drawImage(data.canvasZoom, -zoomScaled, data.currentWindowSize.x + zoomScaled)
	else
		data.offset = utils.floorVec(data.offset)
		ui.drawImage(data.canvas, data.offset, data.baseWindowSize * mapSettings.store.mapScale + data.offset)
		if mapSettings.store.sectionsTrackActive then
			sections.drawTrackSections(data)
		end
		players.drawPlayers(data)
	end
	window.resize(data.currentWindowSize, "Map")
	pinCheckBox.main(mapSettings.store.mapScale * 1.5, "Map", window.getWindow("Map"):pinned(), data.currentWindowSize)
end

return map
