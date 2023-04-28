QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Server:UpdateObject', function() if source ~= '' then return false end QBCore = exports['qb-core']:GetCoreObject() end)
local sharedItems = QBCore.Shared.Items
local Accounts = {}

-- Get Item
QBCore.Functions.CreateCallback('rs-'..Config.Job..':server:GetItem',function(source, cb, item, required)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local callback = false
    local idk = 0

    for k, v in pairs(required) do
        if Player.Functions.RemoveItem(v.item, v.amount) then
            idk = idk + 1
            TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[v.item], 'remove', v.amount)
            if idk >= #required then
                if Player.Functions.AddItem(item, 1) then
                    TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[item], 'add', 1)
                    callback = true
                end
            end
        else
            callback = false
            return
        end

        if Config.Debug then
            print("Item: "..v.item, "Amount: "..v.amount)
        end
    end

    cb(callback)
end)

-- Check for Required Items
QBCore.Functions.CreateCallback('rs-'..Config.Job..':server:HasItems',function(source, cb, required)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local callback = false
    local idk = 0

    for k, v in pairs(required) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount then -- Check for materials
            idk = idk + 1
            if idk == #required then
                callback = true
            end
        end

        if Config.Debug then
            print("Item: "..v.item, "Amount: "..v.amount)
        end
    end

    cb(callback)
end)





QBCore.Functions.CreateCallback(Config.Job..':MakePlayerList', function(source, cb)
	local onlineList = {}
	for _, v in pairs(QBCore.Functions.GetPlayers()) do
		local P = QBCore.Functions.GetPlayer(v)
		onlineList[#onlineList+1] = { value = tonumber(v), text = "["..v.."] - "..P.PlayerData.charinfo.firstname..' '..P.PlayerData.charinfo.lastname  }
	end
	cb(onlineList)
end)


RegisterServerEvent(Config.Job..":server:Charge", function(citizen, price, billtype, img, outside, gang)

    print ("SERVER CHARGE FUNCTION CALLED")

	local src = source
    local biller = QBCore.Functions.GetPlayer(src)
    local billed = QBCore.Functions.GetPlayer(tonumber(citizen))
    local amount = tonumber(price)
	local balance = billed.Functions.GetMoney(billtype)
	if amount and amount > 0 then
		if balance < amount then
			triggerNotify(nil, "Customer doesn't have enough cash to pay", "error", src)
			triggerNotify(nil, "You don't have enough cash to pay", "error", tonumber(citizen))
			return
		end
		local label = biller.PlayerData.job.label
		if billtype == "cash" then
			TriggerClientEvent(Config.Job..":client:PayPopup", billed.PlayerData.source, amount, src, billtype, img, label, gang, outside)
		else
			MySQL.Async.insert(
				'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
				{billed.PlayerData.citizenid, amount, biller.PlayerData.job.name, biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid}, function(id)
					if id then
						TriggerClientEvent('qb-phone:client:AcceptorDenyInvoice', billed.PlayerData.source, id, biller.PlayerData.charinfo.firstname, biller.PlayerData.job.name, biller.PlayerData.citizenid, amount, GetInvokingResource())
					end
				end)
			TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
			triggerNotify(nil, "Invoice Successfully Sent", 'success', src)
			triggerNotify(nil, "New Invoice Received", nil, billed.PlayerData.source)
		end
	else triggerNotify(nil, "You can't charge $0", 'error', source) return end
end)


RegisterServerEvent(Config.Job..":server:PayPopup", function(data)
	local src = source
    local billed = QBCore.Functions.GetPlayer(src)
    local biller = QBCore.Functions.GetPlayer(tonumber(data.biller))
    local job = biller.PlayerData.job.name
	-- local newdata = { senderCitizenId = biller.PlayerData.citizenid, society = biller.PlayerData.job.name, amount = data.amount }
	if data.accept == true then
		billed.Functions.RemoveMoney(tostring(data.billtype), data.amount)
        exports['qb-management']:AddMoney(job, data.amount)
		triggerNotify(nil, billed.PlayerData.charinfo.firstname.." accepted the $"..data.amount.." payment", "success", data.biller)
	elseif data.accept == false then
		triggerNotify(nil, "You declined the payment", nil, src)
		triggerNotify(nil, billed.PlayerData.charinfo.firstname.." declined the $"..data.amount.." payment", "error", data.biller)
	end
end)

-- function AddMoney(account, amount)
-- 	if not Accounts[account] then
-- 		Accounts[account] = 0
-- 	end

-- 	Accounts[account] = Accounts[account] + amount
-- 	MySQL.insert('INSERT INTO management_funds (job_name, amount, type) VALUES (:job_name, :amount, :type) ON DUPLICATE KEY UPDATE amount = :amount',
-- 		{
-- 			['job_name'] = account,
-- 			['amount'] = Accounts[account],
-- 			['type'] = 'boss'
-- 		})
-- end
