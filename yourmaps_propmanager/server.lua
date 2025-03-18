RegisterServerEvent('yourmaps_propmanager:logDeletion')
AddEventHandler('yourmaps_propmanager:logDeletion', function(zoneName, count)
    local src = source
    if count > 0 then
        --print('^2[YourMAPS Cleaner]^7 Player ' .. GetPlayerName(src) .. ' (ID: ' .. src .. ') deleted ' .. count .. ' objects in zone: ' .. zoneName)
    end
end)

RegisterServerEvent('yourmaps_propmanager:logSpawn')
AddEventHandler('yourmaps_propmanager:logSpawn', function(zoneName, count)
    local src = source
    if count > 0 then
        --print('^2[YourMAPS Spawner]^7 Player ' .. GetPlayerName(src) .. ' (ID: ' .. src .. ') spawned ' .. count .. ' objects in zone: ' .. zoneName)
    end
end)