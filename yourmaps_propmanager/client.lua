local LoadedZones = {}
local DeletedObjectHashes = {}

if not Config then Config = {} end
if not Config.Zones then
    --print("^1ERROR:^7 Config.Zones is nil! Check config.lua.")
    return
end

local function IsPointInPolygon(testPoint, polyzone)
    local result = false
    local j = #polyzone
    
    for i = 1, #polyzone do
        if (((polyzone[i].y > testPoint.y) ~= (polyzone[j].y > testPoint.y)) and
            (testPoint.x < ((polyzone[j].x - polyzone[i].x) * (testPoint.y - polyzone[i].y) / 
            (polyzone[j].y - polyzone[i].y) + polyzone[i].x))) then
            result = not result
        end
        j = i
    end
    
    return result
end

local function CalculatePolygonCenter(points)
    local center = {x = 0, y = 0, z = 0}
    local count = #points
    
    for i = 1, count do
        center.x = center.x + points[i].x
        center.y = center.y + points[i].y
        center.z = center.z + points[i].z
    end
    
    center.x = center.x / count
    center.y = center.y / count
    center.z = center.z / count
    
    return center
end

local function IsEntityDeleted(entity)
    local entityHash = GetEntityModel(entity)
    return DeletedObjectHashes[entityHash] ~= nil
end

local function GetObjectsInArea(coords, radius)
    local objects = {}
    local itemSet = CreateItemset(true)
    
    local success = Citizen.InvokeNative(0x59B57C4B06531E1E, coords.x, coords.y, coords.z, radius, itemSet, 2)
    
    if IsItemsetValid(itemSet) then
        local size = GetItemsetSize(itemSet)
        for i = 0, size - 1 do
            local entity = GetIndexedItemInItemset(i, itemSet)
            if entity ~= 0 and DoesEntityExist(entity) then
                table.insert(objects, entity)
            end
        end
        DestroyItemset(itemSet)
    end
    
    return objects
end

local function DeleteObjectAndLOD(entity)
    if DoesEntityExist(entity) then
        local model = GetEntityModel(entity)
        DeletedObjectHashes[model] = true
        
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
        
        local entityLod = Citizen.InvokeNative(0x1F922734E259BD26, entity, true)
        if entityLod ~= 0 and DoesEntityExist(entityLod) then
            SetEntityAsMissionEntity(entityLod, true, true)
            DeleteEntity(entityLod)
        end
        
        return true
    end
    return false
end

local function ProcessZone(zone)
    if not zone.loaded then
        local count = 0
        
        for _, obj in ipairs(zone.objects) do
            local entity = GetClosestObjectOfType(obj.coords.x, obj.coords.y, obj.coords.z, obj.distance, obj.model, false, false, false)
            if entity ~= 0 and DoesEntityExist(entity) then
                if DeleteObjectAndLOD(entity) then
                    count = count + 1
                end
            end
        end
        
        if zone.deleteAll then
            local center = CalculatePolygonCenter(zone.polyzone)
            local zOffset = zone.height / 2
            local radius = zone.outerZoneDistance * 1.5
            local objects = GetObjectsInArea(center, radius)
            
            for _, entity in ipairs(objects) do
                if DoesEntityExist(entity) and not IsEntityDeleted(entity) then
                    local entityCoords = GetEntityCoords(entity)
                    local entityPos = {x = entityCoords.x, y = entityCoords.y, z = entityCoords.z}
                    
                    local inZone = IsPointInPolygon({x = entityPos.x, y = entityPos.y}, zone.polyzone)
                    local zCenter = center.z
                    local heightCheck = entityPos.z >= (zCenter - zOffset) and entityPos.z <= (zCenter + zOffset)
                    
                    if inZone and heightCheck then
                        if DeleteObjectAndLOD(entity) then
                            count = count + 1
                        end
                    end
                end
            end
        end
        
        zone.loaded = true
        TriggerServerEvent('yourmaps_propmanager:logDeletion', zone.name, count)
    end
end

local function CheckZones()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for _, zone in ipairs(LoadedZones) do
        local center = CalculatePolygonCenter(zone.polyzone)
        local distance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(center.x, center.y, center.z))
        if distance <= zone.outerZoneDistance then
            ProcessZone(zone)
        end
    end
end

Citizen.CreateThread(function()
    for i, zone in ipairs(Config.Zones) do
        LoadedZones[i] = {
            name = zone.name,
            polyzone = zone.polyzone,
            height = zone.height,
            outerZoneDistance = zone.outerZoneDistance,
            deleteAll = zone.deleteAll,
            objects = zone.objects,
            loaded = false
        }
    end
end)

Citizen.CreateThread(function()
    while true do
        CheckZones()
        Citizen.Wait(1000)
    end
end)
