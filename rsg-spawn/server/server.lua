local RSGCore = exports['rsg-core']:GetCoreObject()

-- Shared Helper Functions
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
            steamProfile = steamHex ~= 0 and string.format("https://steamcommunity.com", steamHex) or "N/A"
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

local function GetWebhook(channel)
    if Config.DiscordWebhook and type(Config.DiscordWebhook) == "table" then
        return Config.DiscordWebhook[channel] or Config.DiscordWebhook['default']
    elseif type(Config.DiscordWebhook) == "string" then
        return Config.DiscordWebhook
    end
    return 'YOUR_DEFAULT_WEBHOOK_URL'
end

-- Existing Player Login Logs
RegisterNetEvent('RSGCore:Server:OnPlayerLoaded', function()
    local src = source
    SetTimeout(500, function()
        local Player = RSGCore.Functions.GetPlayer(src)
        if not Player then return end

        local inGameName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        local citizenid = Player.PlayerData.citizenid
        local coords = GetPlayerCoords(src)
        
        local jobLabel = "Unknown"
        if Player.PlayerData.job and Player.PlayerData.job.name then
            jobLabel = Player.PlayerData.job.label
        end
        
        local discordId, discordName, steamId, steamName, steamProfile = ParseIdentifiers(src)
        local profileLink = steamProfile ~= 'N/A' and ('[Click Here To View](' .. steamProfile .. ')') or 'N/A'
        
        local fields = {
            { name = 'Player ID', value = tostring(src), inline = true },
            { name = 'Character Name', value = inGameName, inline = true },
            { name = 'CitizenID', value = citizenid, inline = true },
            { name = 'Discord Name', value = discordName, inline = true },
            { name = 'Discord ID', value = discordId, inline = true },
            { name = 'Steam Name', value = steamName, inline = true },
            { name = 'Steam ID', value = steamId, inline = true },
            { name = 'Steam Profile', value = profileLink, inline = false },
            { name = 'Coordinates', value = coords, inline = true }
        }
        
        local embed = { 
            title = '✅ 🤠 Existing Player Logged In', 
            fields = fields, 
            color = 3066993, 
            footer = { text = os.date('%Y-%m-%d %H:%M:%S') } 
        }
        
        local targetWebhook = GetWebhook('default')
        PerformHttpRequest(targetWebhook, function() end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
        print('[LOGIN] Existing: ' .. inGameName .. ' (Citizen: ' .. citizenid .. ')')
    end)
end)

-- -- New Player Login Logs
-- New Player Login Logs
RegisterNetEvent('rsg-spawn:server:logNewSpawn', function(playerName, citizenid, spawnId)
    local src = source
    local discordId, discordName, steamId, steamName, steamProfile = ParseIdentifiers(src)
    
    local coords = GetPlayerCoords(src)
    local locationLabel = 'Unknown Location'
    
    if Config.SpawnLocations then
        for _, loc in pairs(Config.SpawnLocations) do
            if loc.id == spawnId then
                locationLabel = loc.label
                break
            end
        end
    end

    local profileLink = steamProfile ~= 'N/A' and ('[Click Here To View](' .. steamProfile .. ')') or 'N/A'
    
    local fields = {
        { name = 'Player ID', value = tostring(src), inline = true },
        { name = 'Character Name', value = playerName, inline = true },  
        { name = 'CitizenID', value = citizenid, inline = true },
        { name = 'Spawned At', value = locationLabel, inline = true },  
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
    
    local targetWebhook = GetWebhook('default')
    PerformHttpRequest(targetWebhook, function() end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
    print(('[SPAWN NEW] %s (Citizen: %s) at spawn %s'):format(playerName, citizenid, spawnId))
end)

-- Existing Player Loggout Logs 
AddEventHandler('playerDropped', function(reason)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    local inGameName = 'Unknown (No Character Loaded)'
    local citizenid = 'N/A'
    local jobLabel = "Unknown"
    local coords = 'Unknown'

    if Player then
        inGameName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        citizenid = Player.PlayerData.citizenid
        
        if Player.PlayerData.job and Player.PlayerData.job.name then
            jobLabel = Player.PlayerData.job.label
        end

        if Player.PlayerData.position then
            local pCoords = Player.PlayerData.position
            coords = string.format('%.1f, %.1f, %.1f', pCoords.x, pCoords.y, pCoords.z)
        end
    else
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            local pCoords = GetEntityCoords(ped)
            coords = string.format('%.1f, %.1f, %.1f', pCoords.x, pCoords.y, pCoords.z)
        end
    end
    
    local discordId, discordName, steamId, steamName, steamProfile = ParseIdentifiers(src)
    local profileLink = steamProfile ~= 'N/A' and ('[Click Here To View](' .. steamProfile .. ')') or 'N/A'
    
    local targetWebhook = GetWebhook('default')
    local embedTitle = '❌ 🔌 Player Disconnected'
    local embedColor = 15158332 
    local lowerReason = string.lower(reason)

    if string.find(lowerReason, 'ban') or string.find(lowerReason, 'banned') then
        embedTitle = '⛔ Player Banned From Server'
        embedColor = 10040064 
        targetWebhook = GetWebhook('ban')
    elseif string.find(lowerReason, 'kick') or string.find(lowerReason, 'kicked') then
        embedTitle = '⚠️ Player Kicked From Server'
        embedColor = 16753920 
        targetWebhook = GetWebhook('kick')
    elseif string.find(lowerReason, 'exiting') or string.find(lowerReason, 'closed') then
        embedTitle = '➜🚪 Player Disconnected (Normal Quit)'
        embedColor = 8421504 
    elseif string.find(lowerReason, 'timeout') or string.find(lowerReason, 'timed out') then
        embedTitle = '⏳ 🔌 Player Timed Out / Crashed'
        embedColor = 3447003 
    end

    local fields = {
        { name = 'Player ID', value = tostring(src), inline = true },
        { name = 'Character Name', value = inGameName, inline = true },
        { name = 'CitizenID', value = citizenid, inline = true }, 
        { name = 'Discord Name', value = discordName, inline = true },
        { name = 'Discord ID', value = discordId, inline = true },
        { name = 'Steam Name', value = steamName, inline = true },
        { name = 'Steam ID', value = steamId, inline = true },
        { name = 'Steam Profile', value = profileLink, inline = false },
        { name = 'Reason', value = reason, inline = true },
        { name = 'Coordinates', value = coords, inline = true }
    }
    
    local embed = { 
        title = embedTitle,  
        fields = fields, 
        color = embedColor, 
        footer = { text = os.date('%Y-%m-%d %H:%M:%S') } 
    }
    PerformHttpRequest(targetWebhook, function() end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
end)
