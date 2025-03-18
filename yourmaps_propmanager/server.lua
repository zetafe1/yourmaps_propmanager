RegisterServerEvent('object_cleaner:logDeletion')
AddEventHandler('object_cleaner:logDeletion', function(zoneName, count)
    local src = source
    if count > 0 then
        print('^2[Object Cleaner]^7 Player ' .. GetPlayerName(src) .. ' (ID: ' .. src .. ') deleted ' .. count .. ' objects in zone: ' .. zoneName)
    end
end)
