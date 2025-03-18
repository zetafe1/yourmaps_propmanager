local DeletedObjectHashes = {}
local SpawnedObjects = {}

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
    local center = vec3(0, 0, 0)
    for i = 1, #points do
        center = center + vec3(points[i].x, points[i].y, points[i].z)
    end
    return center / #points
end

local function DeleteObjectAndLOD(entity)
    if DoesEntityExist(entity) then
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

local function EnumerateObjects(callback)
    local handle, object = FindFirstObject()
    local success
    repeat
        callback(object)
        success, object = FindNextObject(handle)
    until not success
    EndFindObject(handle)
end

local function ProcessDeletingZone(zone)
    local count = 0
    if zone.deleteAll then
        EnumerateObjects(function(object)
            if DoesEntityExist(object) then
                local entityCoords = GetEntityCoords(object)
                local entityPos = vec3(entityCoords.x, entityCoords.y, entityCoords.z)

                if IsPointInPolygon(entityPos, zone.polyzone) then
                    if DeleteObjectAndLOD(object) then
                        count = count + 1
                    end
                end
            end
        end)
    else
        for _, obj in ipairs(zone.objects) do
            local entity = GetClosestObjectOfType(obj.coords.x, obj.coords.y, obj.coords.z, obj.distance, obj.model, false, false, false)
            if entity ~= 0 and DoesEntityExist(entity) then
                if DeleteObjectAndLOD(entity) then
                    count = count + 1
                end
            end
        end
    end
    TriggerServerEvent('yourmaps_propmanager:logDeletion', zone.name, count)
end

local function SpawnObjectsInZone(zone)
    if not SpawnedObjects[zone.name] then
        SpawnedObjects[zone.name] = {}
    end

    for _, obj in ipairs(zone.spawnObjects) do
        local alreadySpawned = false
        for _, spawnedObj in ipairs(SpawnedObjects[zone.name]) do
            if DoesEntityExist(spawnedObj) then
                alreadySpawned = true
                break
            end
        end

        if not alreadySpawned then
            RequestModel(obj.model)
            while not HasModelLoaded(obj.model) do
                Citizen.Wait(10)
            end

            local spawnedObj = CreateObject(obj.model, obj.coords.x, obj.coords.y, obj.coords.z, true, false, false)
            SetEntityHeading(spawnedObj, obj.rotation.z)
            SetEntityRotation(spawnedObj, obj.rotation.x, obj.rotation.y, obj.rotation.z, 2, true)
            FreezeEntityPosition(spawnedObj, true)

            SetModelAsNoLongerNeeded(obj.model)

            table.insert(SpawnedObjects[zone.name], spawnedObj)
        end
    end
end


local function RemoveSpawnedObjects(zone)
    if SpawnedObjects[zone.name] then
        for _, obj in ipairs(SpawnedObjects[zone.name]) do
            if DoesEntityExist(obj) then
                DeleteEntity(obj)
            end
        end
        SpawnedObjects[zone.name] = nil
    end
end

local function CheckZones()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, zone in ipairs(Config.DeletingZones) do
        local center = CalculatePolygonCenter(zone.polyzone)
        local distance = #(playerCoords - center)
        if distance <= 100.0 then  
            ProcessDeletingZone(zone)
        end
    end

    for _, zone in ipairs(Config.SpawningZones) do
        local center = CalculatePolygonCenter(zone.polyzone)
        local distance = #(playerCoords - center)

        if distance <= 100.0 then
            if not SpawnedObjects[zone.name] then
                SpawnObjectsInZone(zone)  
            end
        else
            RemoveSpawnedObjects(zone) 
        end
    end
end

Citizen.CreateThread(function()
    while true do
        CheckZones()
        Citizen.Wait(3000)  
    end
end)
