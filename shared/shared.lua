local QBCore = exports['qb-core']:GetCoreObject()

function triggerNotify(title, message, type, src)
    if not src then	TriggerEvent("QBCore:Notify", message, "primary")
    else TriggerClientEvent("QBCore:Notify", src, message, "primary") end
end