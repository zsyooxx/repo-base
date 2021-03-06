-- https://github.com/tomrus88/BlizzardInterfaceCode/blob/e2c02e9e3de67cc29adec8e5e2ef70b98c7d1031/Interface/AddOns/Blizzard_FlightMap/FM_FlightPathDataProvider.lua

FlightMapFrame = WorldMapFrame -- for the sake of InFlight

-- Map data functions
local MapSizeCache = {} -- [uiMapID] = {left, top, right, bottom, etc}
local function GetCurrentMapContinent(uiMapID)
	local uiMapID = uiMapID -- or WorldMapFrame:GetMapID()
	if uiMapID then
		local continent = MapUtil.GetMapParentInfo(uiMapID, Enum.UIMapType.Continent)
		if continent then
			return continent.mapID
		end
	end
end

function GetMapSize(uiMapID, noLoop)
	local uiMapID = uiMapID or WorldMapFrame:GetMapID()
	if not uiMapID then return end
	
	-- Return cached information if we've looked it up before
	if MapSizeCache[uiMapID] then
		return MapSizeCache[uiMapID]
	end
	
	local instanceID, topleft = C_Map.GetWorldPosFromMapPos(uiMapID, {x = 0, y = 0})
	local instanceID, bottomright = C_Map.GetWorldPosFromMapPos(uiMapID, {x = 1, y = 1})
	if not instanceID then return end
	
	local left, top = topleft.y, topleft.x
	local right, bottom = bottomright.y, bottomright.x
	local width, height = left - right, top - bottom
	
	local continentMapID = GetCurrentMapContinent(uiMapID)
	
	-- Transform coordinates for areas that draw on a different continent than the instance they belong to
	if continentMapID and not noLoop then
		local continentSize = GetMapSize(continentMapID, true)
		if continentSize then
			local relLeft, relRight, relTop, relBottom = C_Map.GetMapRectOnMap(uiMapID, continentMapID)
			left = continentSize.left - continentSize.width * relLeft
			right = continentSize.left - continentSize.width * relRight
			top = continentSize.top - continentSize.height * relTop
			bottom = continentSize.top - continentSize.height * relBottom
		end
	end
	
	local mapSize = {left = left, top = top, right = right, bottom = bottom, width = width, height = height, mapID = uiMapID, continent = continentMapID}
	
	-- Cache result so we don't have to do this again
	MapSizeCache[uiMapID] = mapSize
	
	return mapSize
end

-- Map provider
WorldFlightMapProvider = CreateFromMixins(FlightMap_FlightPathDataProviderMixin)
function WorldFlightMapProvider:OnAdded(...)
	FlightMap_FlightPathDataProviderMixin.OnAdded(self, ...)
	
	UIParent:UnregisterEvent('TAXIMAP_OPENED')
	TaxiFrame:UnregisterAllEvents() -- todo: does this even have any events registered any more?

	self:RegisterEvent('TAXIMAP_OPENED')
	self:RegisterEvent('TAXIMAP_CLOSED')
end

function WorldFlightMapProvider:OnEvent(event, ...)
	if event == 'TAXIMAP_OPENED' then
		if not self:GetMap():IsShown() then
			ToggleWorldMap()
		end

		self:SetTaxiState(true)
		self.taxiMap = GetMapSize(GetTaxiMapID())
		
		local playerMapID = C_Map.GetBestMapForUnit('player')
		local playerMapInfo = C_Map.GetMapInfo(playerMapID)
		self.playerContinent = GetCurrentMapContinent(playerMapID)
		
		if self.playerContinent == 905 and playerMapInfo.mapType > 3 and playerMapInfo.parentMapID then
			self:GetMap():SetMapID(playerMapInfo.parentMapID)
		else
			self:GetMap():SetMapID(self.playerContinent)
		end
		
		self:RefreshAllData()
	elseif event == 'TAXIMAP_CLOSED' then
		self:SetTaxiState(false)

		CloseTaxiMap()
		if self:GetMap():IsShown() then
			ToggleWorldMap()
		end

		self:RemoveAllData()
	end
end

function WorldFlightMapProvider:OnMapChanged()
	local uiMapID = self:GetMap():GetMapID()
	self.worldMap = GetMapSize(uiMapID)
	FlightMap_FlightPathDataProviderMixin.OnMapChanged(self)
end

local e = math.exp(1)

function WorldFlightMapProvider:AddFlightNode(taxiNodeData)
	if self.taxiMap and self.worldMap and self.worldMap.left then
		-- limit to maps belonging to the same "continent" as the player (should really be the instance ID)
		if self.worldMap.continent == self.playerContinent then
			local taxiX, taxiY = taxiNodeData.position:GetXY()
			local worldTaxiX, worldTaxiY = self.taxiMap.left - taxiX * self.taxiMap.width, self.taxiMap.top - taxiY * self.taxiMap.height
			
			local mapTaxiX = (self.worldMap.left - worldTaxiX) / self.worldMap.width
			local mapTaxiY = (self.worldMap.top - worldTaxiY) / self.worldMap.height
			
			local drawPin = false
			--if self.playerContinent == 905 then -- match against node names for argus because coordinates are useless here (plus the vindicaar moves)
				local taxiNodes = C_TaxiMap.GetTaxiNodesForMap(self.worldMap.mapID)
				for _, landmark in pairs(taxiNodes) do
					if landmark.name == taxiNodeData.name then
						taxiNodeData.position.x = landmark.position.x
						taxiNodeData.position.y = landmark.position.y
						drawPin = true
						break
					end
				end
			--else
			if not drawPin then
				taxiNodeData.position.x = mapTaxiX
				taxiNodeData.position.y = mapTaxiY
				drawPin = true
			end
			
			if drawPin then
				-- for k,v in pairs(taxiNodeData) do print(k, v) end
				-- taxiNodeData.slotIndex
				-- Duplicating all of this from frameXML because we need to raise the frame level of the pins
				local playAnim = taxiNodeData.state ~= Enum.FlightPathState.Unreachable;
				local pin = self:GetMap():AcquirePin("FlightMap_FlightPointPinTemplate", playAnim);
				
				-- For the sake of having other addons treat our buttons like normal taxi map buttons
				_G['TaxiButton' .. taxiNodeData.slotIndex] = pin
				pin:SetID(taxiNodeData.slotIndex)
				
				self.slotIndexToPin[taxiNodeData.slotIndex] = pin;

				pin:SetPosition(taxiNodeData.position:GetXY());
				pin.taxiNodeData = taxiNodeData;
				pin.owner = self;
				pin.linkedPins = {};
				pin:SetFlightPathStyle(taxiNodeData.textureKitPrefix, taxiNodeData.state);
				
				pin:UpdatePinSize(taxiNodeData.state);
				
				pin:UseFrameLevelType("PIN_FRAME_LEVEL_TOPMOST")
				
				--pin:SetScalingLimits(1.25, 0.9625, 1.275)
				
				local initialScaleFactor = e ^ -(0.00000619843198095 * self.worldMap.width)
				pin:SetScalingLimits(1.25, initialScaleFactor, initialScaleFactor * 1.25)
				--pin:SetIgnoreGlobalPinScale(true)
				
				pin:SetShown(taxiNodeData.state ~= Enum.FlightPathState.Unreachable); -- Only show if part of a route, handled in the route building functions
			end
		end
	end
end

function WorldFlightMapProvider:HighlightRouteToPin(pin)
	if self.playerContinent == 905 then return end -- don't draw lines on argus maps (we could if they're on the same zone map)
	
	if not self.linePool then
		self.linePool = CreateLinePool(pin, 'BACKGROUND', -2)
	end

	local taxiSlotIndex = pin.taxiNodeData.slotIndex
	for routeIndex = 1, GetNumRoutes(taxiSlotIndex) do
		local sourceIndex = TaxiGetNodeSlot(taxiSlotIndex, routeIndex, true)
		local destIndex = TaxiGetNodeSlot(taxiSlotIndex, routeIndex, false)

		local startPin = self.slotIndexToPin[sourceIndex]
		local destPin = self.slotIndexToPin[destIndex]

		local Line = self.linePool:Acquire()
		Line:SetNonBlocking(true)
		Line:SetAtlas('_UI-Taxi-Line-horizontal')
		Line:SetThickness(32)
		Line:SetStartPoint('CENTER', startPin)
		Line:SetEndPoint('CENTER', destPin)
		Line:Show()

		-- force show all the pins in the route
		startPin:Show()
		destPin:Show()
	end
end

function WorldFlightMapProvider:RemoveRouteToPin(pin)
	if(self.linePool) then
		self.linePool:ReleaseAll()
	end

	for _, pin in next, self.slotIndexToPin do
		-- update visibility
		pin:SetShown(pin.taxiNodeData.state ~= Enum.FlightPathState.Unreachable)
		--Pin:UpdateState()
	end
end

function WorldFlightMapProvider:ShowBackgroundRoutesFromCurrent()
	-- todo: show initial hoplines to direct routes
end


function WorldFlightMapProvider:OnHide()
	if self:IsTaxiOpen() then
		CloseTaxiMap()
	end
end

function WorldFlightMapProvider:IsTaxiOpen()
	return self.taxiOpen
end

function WorldFlightMapProvider:SetTaxiState(state)
	self.taxiOpen = state
end

WorldMapFrame:AddDataProvider(WorldFlightMapProvider)
