local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("radioscanner", function(source, item)
	local src = source
    TriggerClientEvent("skizm-radioscanner:client:usescanner", src)
end)