QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)
sharedItems = QBCore.Shared.Items
local Player = QBCore.Functions.GetPlayerData()
local PlayerJob = QBCore.Functions.GetPlayerData().job
local onDuty = false
local zonesTable = {} -- Table for target zones

-- FUNCTIONS --
local function ToggleDuty()
    onDuty = not onDuty
    TriggerServerEvent('QBCore:ToggleDuty')
end

local function DestroyBusinessZones()
    for k,v in pairs(zonesTable) do
        exports['qb-target']:RemoveZone(v)
    end
end

local function CreateBusinessZones()
    for k, v in pairs(Config.Locations) do
        if k ~= 'Registers' and k ~= 'Duty' and k ~= 'Stashes' and k ~= 'Trays' and k ~= 'Sink' then
            for r, s in pairs(Config.Locations[k]) do
                BusinessZone = exports['qb-target']:AddBoxZone(Config.Job..k..r, s.coords, s.length, s.width, {
                    name = Config.Job..k..r,
                    heading = s.heading,
                    debugPoly = Config.DebugPoly,
                    minZ = s.coords.z - 1,
                    maxZ = s.coords.z + 1,
                    }, {
                        options = {
                            {
                                type = 'client',
                                event = 'rs-'..Config.Job..':client:Open'..k,
                                icon = s.info.icon,
                                label = s.info.label,
                                job = Config.Job
                            },
                        },
                    distance = 2.0
                })

                table.insert(BusinessZone, zonesTable)
            end
        elseif k == 'Registers' then
            for r, s in pairs(Config.Locations['Registers']) do
                RegistersZones = exports['qb-target']:AddBoxZone('Register '..Config.Job..r, s.coords, s.length, s.width, {
                    name = 'Register '..Config.Job..r,
                    heading = s.heading,
                    debugPoly = Config.DebugPoly,
                    minZ = s.coords.z - 1,
                    maxZ = s.coords.z + 1,
                    }, {
                        options = {
                            {
                                type = 'client',
                                event = s.info.event,
                                icon = s.info.icon,
                                label = s.info.label,
                                job = Config.Job
                            },
                        },
                    distance = 2.0
                })
            end

            table.insert(RegistersZones, zonesTable)

        elseif k == 'Duty' then
            for r, s in pairs(Config.Locations['Duty']) do
                DutyZones = exports['qb-target']:AddBoxZone('Duty '..Config.Job..r, s.coords, s.length, s.width, {
                    name = 'Duty '..Config.Job..r,
                    heading = s.heading,
                    debugPoly = Config.DebugPoly,
                    minZ = s.coords.z - 1,
                    maxZ = s.coords.z + 1,
                    }, {
                        options = {
                            {
                                event = Config.Job..':Duty',
                                icon = s.info.icon,
                                label = s.info.label,
                                job = Config.Job
                            },
                        },
                    distance = 2.0
                })
            end

            table.insert(DutyZones, zonesTable)

        elseif k == 'Stashes' then
            for r, s in pairs(Config.Locations['Stashes']) do
                StashZones = exports['qb-target']:AddBoxZone('Stash '..Config.Job..r, s.coords, s.length, s.width, {
                    name = 'Stash '..Config.Job..r,
                    heading = s.heading,
                    debugPoly = Config.DebugPoly,
                    minZ = s.coords.z - 1,
                    maxZ = s.coords.z + 1,
                    }, {
                        options = {
                            {
                                event = Config.Job..':shop',
                                icon = 'fas fa-laptop',
                                label = 'Order Ingredients',
                                job = Config.Job,
                            },
                            {  event = Config.Job..':storage',
                                icon = 'fas fa-box',
                                label = 'Open Storage',
                                job = Config.Job,
                            },
                        },
                    distance = 2.0
                })
            end

            table.insert(StashZones, zonesTable)

        elseif k == 'Trays' then
            for r, s in pairs(Config.Locations['Trays']) do
                CounterZones = exports['qb-target']:AddBoxZone('Tray '..Config.Job..r, s.coords, s.length, s.width, {
                    name = 'Tray '..Config.Job..r,
                    heading = s.heading,
                    debugPoly = Config.DebugPoly,
                    minZ = s.coords.z - 1,
                    maxZ = s.coords.z + 1,
                    }, {
                        options = {
                            {
                                action = function()
                                    TriggerEvent('rs-'..Config.Job..':OpenTray', r)
                                end,
                                icon = s.info.icon,
                                label = s.info.label,
                            },
                        },
                    distance = 2.0
                })
            end

            table.insert(CounterZones, zonesTable)

        elseif k == 'Sink' then
            for r, s in pairs(Config.Locations['Sink']) do
                SinkZones = exports['qb-target']:AddBoxZone('Sink '..Config.Job..r, s.coords, s.length, s.width, {
                    name = 'Sink '..Config.Job..r,
                    heading = s.heading,
                    debugPoly = Config.DebugPoly,
                    minZ = s.coords.z - 1,
                    maxZ = s.coords.z + 1,
                    }, {
                        options = {
                            {
                                type = 'client',
                                event = 'rs-'..Config.Job..'WashHands',
                                icon = s.info.icon,
                                label = s.info.label,
                                job = Config.Job
                            },
                        },
                    distance = 2.0
                })
            end

            table.insert(SinkZones, zonesTable)
        end
    end
end

RegisterNetEvent(Config.Job..':shop')
AddEventHandler(Config.Job..':shop', function()
    TriggerServerEvent('inventory:server:OpenInventory','shop', Config.Job, Config.Items)

end)

RegisterNetEvent(Config.Job..':storage', function()
    print (Config.Job)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', Config.Job, {
        maxweight = 250000,
        slots = 40,
    })
    TriggerEvent('inventory:client:SetCurrentStash', Config.Job)
end)





RegisterNetEvent(Config.Job..":Duty")
AddEventHandler(Config.Job..":Duty", function()
    TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent('rs-'..Config.Job..':OpenTray', function(stashID)
    print('BusinessTray_'..Config.Job..'_'..stashID)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", 'BusinessTray_'..Config.Job..'_'..stashID, {maxweight = Config.Trays.MaxWeight, slots = Config.Trays.MaxSlots})
    TriggerEvent("inventory:client:SetCurrentStash", 'BusinessTray_'..Config.Job..'_'..stashID)
end)

RegisterNetEvent('rs-'..Config.Job..':OpenStash', function(stashID)
    print('BusinessStash_'..Config.Job..stashID)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", 'BusinessStash_'..Config.Job..'_'..stashID, {maxweight = Config.Stashes.MaxWeight, slots = Config.Stashes.MaxSlots})
    TriggerEvent("inventory:client:SetCurrentStash", 'BusinessStash_'..Config.Job..'_'..stashID)
end)

RegisterNetEvent('rs-'..Config.Job..'WashHands', function()
    QBCore.Functions.Progressbar("wash_hands", 'Washing your hands...', (Config.Times.WashHands * 1000), false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mp_arresting",
		anim = "a_uncuff",
		flags = 49,
	}, {}, {}, function()
        QBCore.Functions.Notify('You washed your hands!', 'success', 5000)
	end, function()
		QBCore.Functions.Notify("Canceled...", "error")
	end)
end)

local function CreateDutyZones()
    for k,v in pairs(Config.Business.BusinessPoly.Zones) do
        local InstallZones = PolyZone:Create(v.zone, {
            name = "Zone" .. Config.Job..k,
            minZ = v.minZ,
            maxZ = v.maxZ,
            debugPoly = Config.DebugPoly
        })
        InstallZones:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if PlayerJob.name == Config.Job then
                    ToggleDuty()
                end
            else
                if PlayerJob.name == Config.Job then
                    ToggleDuty()
                end
            end
        end)
    end
end

local function RemoveBusinessBlips()
    RemoveBlip(businessBlip)
end

local function CreateBusinessBlip()
    local businessBlipInfo = Config.Business.Blip

    local businessBlip = AddBlipForCoord(businessBlipInfo.coords.x, businessBlipInfo.coords.y, businessBlipInfo.coords.z)
    SetBlipSprite(businessBlip, businessBlipInfo.sprite)
    SetBlipScale(businessBlip, businessBlipInfo.size)
    SetBlipDisplay(businessBlip, 4)
    SetBlipColour(businessBlip, businessBlipInfo.color)
    SetBlipAsShortRange(businessBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Business.Name)
    EndTextCommandSetBlipName(businessBlip)
end

RegisterNetEvent('rs-'..Config.Job..':client:MakeItem', function(data)
    local Item = data.item
    local Required = data.required
    local ItemID = data.itemID
    local Emote = data.craftemote

    QBCore.Functions.TriggerCallback('rs-'..Config.Job..':server:HasItems', function(hasItems)
        if hasItems then
            TriggerEvent('animations:client:EmoteCommandStart', {Emote})
            exports['ps-ui']:Circle(function(success)
                if success then
                    QBCore.Functions.Progressbar('business_food', 'Making a '..sharedItems[Item].label, (Config.Times.Food * 1000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function()
                        ClearPedTasks(PlayerPedId())
                        QBCore.Functions.TriggerCallback('rs-'..Config.Job..':server:GetItem', function(isMade)
                            if isMade then
                                QBCore.Functions.Notify('You made a '..sharedItems[Item].label..'!', 'success', 5000)
                            end
                        end, Item, Required)
                    end, function()
                        ClearPedTasks(PlayerPedId())
                        QBCore.Functions.Notify('Canceled...', 'error', 2000)
                    end)
                else
                    QBCore.Functions.Notify('Nice, you spilled the drink. Make another!', 'error', 5000)
                end
            end, Config.Minigame.Circles, Config.Minigame.Time)
        else
            QBCore.Functions.Notify('You don\'t have the required items!', 'error', 5000)
        end
    end, Required)   -- quake
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    if JobInfo.name == Config.Job and PlayerJob.name ~= Config.Job then
        if JobInfo.onduty then
            TriggerServerEvent("QBCore:ToggleDuty")
            onDuty = false
        end
    end
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

-- PLAYER LOAD / UNLOAD --
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded',  function()
    Player = QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    PlayerGang = QBCore.Functions.GetPlayerData().gang

    if Player.job.onduty then
	    if Player.job.name == Config.Job then
		TriggerServerEvent("QBCore:ToggleDuty")
	    end
	end

    CreateBusinessZones()
    CreateBusinessBlip()
    if Config.Business.AutoDuty then
        CreateDutyZones()
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == Config.Job then
    	onDuty = duty
    end
end)


RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DestroyBusinessZones()
    RemoveBusinessBlips()
end)

-- RESOURCE START / STOP --
AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      Wait(100)
      CreateBusinessZones()
      CreateBusinessBlip()

    --   QBCore.Functions.GetPlayerData(function(PlayerData)
    --     PlayerJob = PlayerData.job
    --     PlayerGang = PlayerData.gang
    --     onDuty = PlayerJob.onduty
	-- end)


      if Config.Business.AutoDuty then
        CreateDutyZones()
    end
   end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DestroyBusinessZones()
        RemoveBusinessBlips()
    end
end)

RegisterNetEvent(Config.Job..':client:Charge', function(data, outside)
	--Check if player is using /cashregister command
    PlayerJobOnDuty = QBCore.Functions.GetPlayerData().job.onduty
	if not PlayerJobOnDuty then triggerNotify(nil, "Not On Duty", "error") return end
	local newinputs = {} -- Begin qb-input creation here.
	if Config.List then -- If nearby player list is wanted:
		--Retrieve a list of nearby players from server
		local p = promise.new() QBCore.Functions.TriggerCallback(Config.Job..':MakePlayerList', function(cb) p:resolve(cb) end)   -- first function call
		local onlineList = Citizen.Await(p)
		local nearbyList = {}
		--Convert list of players nearby into one qb-input understands + add distance info
		for _, v in pairs(QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), Config.PaymentRadius)) do
			local dist = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(PlayerPedId()))
			for i = 1, #onlineList do
				if onlineList[i].value == GetPlayerServerId(v) then
					if v ~= PlayerId() or Config.Debug then
						nearbyList[#nearbyList+1] = { value = onlineList[i].value, text = onlineList[i].text..' ('..math.floor(dist+0.05)..'m)' }
					end
				end
			end
		end
		--If list is empty(no one nearby) show error and stop
		if not nearbyList[1] then
           triggerNotify(nil, "No Customers nearby, Switching to manual mode", "error")
           newinputs[#newinputs+1] = { type = 'text', isRequired = true, name = 'citizen', text = "# Customer ID #" }
        else
            newinputs[#newinputs+1] = { text = " ", name = "citizen", type = "select", options = nearbyList }
        end

	else -- If Config.List is false, create input text box for ID's
		newinputs[#newinputs+1] = { type = 'text', isRequired = true, name = 'citizen', text = "# Customer ID #" }
	end
	--Continue adding payment options to qb-input
	newinputs[#newinputs+1] = { type = 'radio', name = 'billtype', text = "Payment Type", options = { { value = "cash", text = "Cash" }, { value = "bank", text = "Card" } } }
	newinputs[#newinputs+1] = { type = 'number', isRequired = true, name = 'price', text = "Amount To Charge" }
	--Grab Player Job name or Gang Name if needed
	-- local label = PlayerJob.label
	local gang = false
	-- if data.gang then label = PlayerGang.label gang = true end
	local dialog = exports['qb-input']:ShowInput({ header = "Use cash register", submitText = "Send", inputs = newinputs})
	if dialog then
		if not dialog.citizen or not dialog.price then return end
		TriggerServerEvent(Config.Job..':server:Charge', dialog.citizen, dialog.price, dialog.billtype, data.img, outside, gang) --second function call
	end
end)



RegisterNetEvent(Config.Job..":client:PayPopup", function(amount, biller, billtype, img, billerjob, gang, outside)
	local img = img or ""
	exports['qb-menu']:openMenu({
		{ isMenuHeader = true, header = "Payment", txt = "Accept Payment" },
		{ isMenuHeader = true, header = "", txt = billtype:gsub("^%l", string.upper).." Payment: $"..amount },
		{ icon = "fas fa-circle-check", header = "Yes", txt = "", params = { isServer = true, event = Config.Job..":server:PayPopup", args = { accept = true, amount = amount, biller = biller, billtype = billtype, gang = gang, outside = outside } } },
		{ icon = "fas fa-circle-xmark", header = "No", txt = "", params = { isServer = true, event = Config.Job..":server:PayPopup", args = { accept = false, amount = amount, biller = biller, billtype = billtype, outside = outside } } }, })
end)