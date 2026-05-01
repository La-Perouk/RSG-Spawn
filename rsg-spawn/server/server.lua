local RSGCore = exports['rsg-core']:GetCoreObject()
local webhook = Config.DiscordWebhook or 'YOUR_DISCORD_WEBHOOK_URL'

local function ParseIdentifiers(src)
    local identifiers = GetPlayerIdentifiers(src)
    local discordId, discordName = 'N/A', 'N/A'
    local steamId, steamName, steamProfile = 'N/A', GetPlayerName(src), 'N/A'

    for i = 1, #identifiers do
        local id = identifiers[i]
        if string.find(id, 'discord:') then
            discordId = string.sub(id, 9)
            discordName = '<@' .. discordId .. '>'
        elseif string.find(id, 'steam:') then
            steamId = id
            local steamHex = tonumber(steamId:gsub("steam:", ""), 16) or 0
            steamProfile = steamHex ~= 0 and string.format("https://steamcommunity.com/profiles/%d", steamHex) or "N/A"
        end
    end

    return discordId, discordName, steamId, steamName, steamProfile
end

local function GetPlayerCoords(src)
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 then
        local coords = GetEntityCoords(ped)
        return string.format('%.1f, %.1f, %.1f', coords.x, coords.y, coords.z)
    end
    return 'Unknown'
end

-- NEW SPAWN (with location)
RegisterNetEvent('rsg-spawn:server:logNewSpawn', function(playerName, citizenid, spawnIndex)
    local src = source
    local serverId = src
    local discordId, discordName, steamId, steamName, steamProfile = ParseIdentifiers(src)
    
    local coords = GetPlayerCoords(src)
    local location = 'Unknown'
    local index = tonumber(spawnIndex)
    if index and Config.SpawnLocations and Config.SpawnLocations[index] then
        location = string.format('%.1f, %.1f', Config.SpawnLocations[index].x, Config.SpawnLocations[index].y)
    end

    local profileLink = steamProfile ~= 'N/A' and ('[Click Here To View](' .. steamProfile .. ')') or 'N/A'
    
    local fields = {
        { name = 'Player ID', value = tostring(serverId), inline = true },
        { name = 'Player Name', value = playerName, inline = true },
        { name = 'CitizenID', value = citizenid, inline = true },
        { name = 'Discord Name', value = discordName, inline = true },
        { name = 'Discord ID', value = discordId, inline = true },
        { name = 'Steam Name', value = steamName, inline = true },
        { name = 'Steam ID', value = steamId, inline = true },
        { name = 'Steam Profile', value = profileLink, inline = false },
        { name = 'Coordinates', value = coords, inline = true }
    }
    
    local embed = { 
        title = '🆕 New Player Spawned', 
        fields = fields, 
        color = 3447003, 
        footer = { text = os.date('%Y-%m-%d %H:%M:%S') } 
    }
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
    print(('[SPAWN NEW] %s (Citizen: %s) at spawn %s'):format(playerName, citizenid, spawnIndex))
end)

-- EXISTING SPAWN
RegisterNetEvent('rsg-spawn:server:logExistingSpawn', function(playerName, citizenid)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    local serverId = src
    local coords = GetPlayerCoords(src)
    local discordId, discordName, steamId, steamName, steamProfile = ParseIdentifiers(src)

    local jobLabel = "Unknown"
    if Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.name then
        jobLabel  = Player.PlayerData.job.label
    end
    
    local profileLink = steamProfile ~= 'N/A' and ('[Click Here To View](' .. steamProfile .. ')') or 'N/A'
    
    local fields = {
        { name = 'Player ID', value = tostring(serverId), inline = true },
        { name = 'Player Name', value = playerName, inline = true },
        { name = 'CitizenID', value = citizenid, inline = true },
        { name = 'Job', value = jobLabel, inline = true },        
        { name = 'Discord Name', value = discordName, inline = true },
        { name = 'Discord ID', value = discordId, inline = true },
        { name = 'Steam Name', value = steamName, inline = true },
        { name = 'Steam ID', value = steamId, inline = true },
        { name = 'Steam Profile', value = profileLink, inline = false },
        { name = 'Coordinates', value = coords, inline = true }
    }
    
    local embed = { 
        title = '✅ 🤠 Existing Player Spawned', 
        fields = fields, 
        color = 3066993, 
        footer = { text = os.date('%Y-%m-%d %H:%M:%S') } 
    }
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
    print('[SPAWN] Existing: ' .. playerName .. ' (Citizen: ' .. citizenid .. ')')
end)

-- LOGOUT
local cachedNames = {}

AddEventHandler('playerDropped', function(reason)
    local src = source
    local steamName = GetPlayerName(src)
    
    local inGameName = 'Unknown (No Character Loaded)'
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if Player then
        inGameName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    elseif cachedNames[src] then
        inGameName = cachedNames[src]
    end
    
    local coords = 'Unknown'
    if Player and Player.PlayerData.position then
        local pCoords = Player.PlayerData.position
        coords = string.format('%.1f, %.1f, %.1f', pCoords.x, pCoords.y, pCoords.z)
    else
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            local pCoords = GetEntityCoords(ped)
            coords = string.format('%.1f, %.1f, %.1f', pCoords.x, pCoords.y, pCoords.z)
        end
    end
    
    local jobLabel = "Unknown"
    if Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.name then
        jobLabel  = Player.PlayerData.job.label
    end
    
    local discordId, discordName, steamId, steamName, steamProfile = ParseIdentifiers(src)
    local profileLink = steamProfile ~= 'N/A' and ('[Click Here To View](' .. steamProfile .. ')') or 'N/A'
    
    local fields = {
        { name = 'Player ID', value = tostring(src), inline = true },
        { name = 'Player Name', value = inGameName, inline = true }, 
        { name = 'Job', value = jobLabel, inline = true },
        { name = 'Discord Name', value = discordName, inline = true },
        { name = 'Discord ID', value = discordId, inline = true },
        { name = 'Steam Name', value = steamName, inline = true },
        { name = 'Steam Profile', value = profileLink, inline = false },
        { name = 'Reason', value = reason, inline = true },
        { name = 'Last Coords', value = coords, inline = true }
    }
    
    local embed = { 
        title = '❌ 🔌 Player Disconnected',  
        fields = fields, 
        color = 15158332, 
        footer = { text = os.date('%Y-%m-%d %H:%M:%S') } 
    }
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
    cachedNames[src] = nil
end)

AddEventHandler('RSGCore:Server:OnPlayerUnload', function(src)
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player then
        local inGameName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        local citizenid = Player.PlayerData.citizenid
        
        cachedNames[src] = inGameName
        
        local coords = 'Unknown'
        if Player.PlayerData.position then
            local pCoords = Player.PlayerData.position
            coords = string.format('%.1f, %.1f, %.1f', pCoords.x, pCoords.y, pCoords.z)
        end

        local jobLabel = "Unknown"
        if Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.name then
            jobLabel  = Player.PlayerData.job.label
        end
        
        local discordId, discordName, steamId, steamName, steamProfile = ParseIdentifiers(src)
        local profileLink = steamProfile ~= 'N/A' and ('[Click Here To View](' .. steamProfile .. ')') or 'N/A'
        
        local fields = {
            { name = 'Player ID', value = tostring(src), inline = true },
            { name = 'Player Name', value = inGameName, inline = true }, 
            { name = 'CitizenID', value = citizenid, inline = true },
            { name = 'Job', value = jobLabel, inline = true },
            { name = 'Discord Name', value = discordName, inline = true },           
            { name = 'Discord ID', value = discordId, inline = true },
            { name = 'Steam Profile', value = profileLink, inline = false },
            { name = 'Last Coords', value = coords, inline = true }
        }
        
        local embed = { 
            title = '🤠 Player Logged Out (Character Unload)', 
            fields = fields, 
            color = 10038562, 
            footer = { text = os.date('%Y-%m-%d %H:%M:%S') } 
        }
        PerformHttpRequest(webhook, function() end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
    end
end)
