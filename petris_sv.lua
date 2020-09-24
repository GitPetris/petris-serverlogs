local webhookURLPetrisJoined = Config.JoinedWebhookURL
local webhookURLPetrisLeft = Config.LeftWebhookURL
local name = Config.WebhookName
local logo = Config.WebhookLogo

AddEventHandler('playerConnecting', function()
	local id = source;
    local ids = ExtractIdentifiers(id);
    local steam = ids.steam:gsub("steam:", "");
    local steamhex = GetPlayerIdentifier(source)
    local steamDec = tostring(tonumber(steam,16));
    steam = "https://steamcommunity.com/profiles/" .. steamDec;
    local gameLicense = ids.license;
    local discord = ids.discord;
    local xbl = ids.xbl;
    local live = ids.live;
    local ip = ids.ip:gsub("ip:", "");
    PetrissendToDiscJoin("**[JOINED]** " .. GetPlayerName(id) .. " ",
        '**Steam Profile: **' .. steam .. '\n' ..
        '**Steam Hex: **' .. steamhex .. '\n' ..
        '**Game License: **' .. gameLicense .. '\n' ..
        '**Discord ID: **' .. discord .. '\n' ..
        '**XBOX ID: **' .. xbl .. '\n' ..
        '**Microsoft ID: **' .. live .. '\n' ..
        '**IP: **||' .. ip .. '||\n');
end)

AddEventHandler('playerDropped', function(reason)
	local id = source;
    local ids = ExtractIdentifiers(id);
    local steam = ids.steam:gsub("steam:", "");
    local steamhex = GetPlayerIdentifier(source)
    local steamDec = tostring(tonumber(steam,16));
    steam = "https://steamcommunity.com/profiles/" .. steamDec;
    local gameLicense = ids.license;
    local discord = ids.discord;
    local xbl = ids.xbl;
    local live = ids.live;
    local ip = ids.ip:gsub("ip:", "");
    PetrissendToDiscLeave("**[LEFT]** " .. GetPlayerName(id) .. " (" .. reason .. ")",
        '**Steam Profile: **' .. steam .. '\n' ..
        '**Steam Hex: **' .. steamhex .. '\n' ..
        '**Game License: **' .. gameLicense .. '\n' ..
        '**Discord ID: **' .. discord .. '\n' ..
        '**XBOX ID: **' .. xbl .. '\n' ..
        '**Microsoft ID: **' .. live .. '\n' ..
        '**IP: **||' .. ip .. '||\n');
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end


function PetrissendToDiscJoin(title, message, footer)
    local embedjoin = {}
    embedjoin = {
        {
            ["color"] = 65280, 
            ["title"] = "".. title .."",
            ["description"] = "" .. message ..  "",
            ["footer"] = {
                ["text"] = name,
                ["icon_url"] = logo,
            },
        }
    }
    PerformHttpRequest(webhookURLPetrisJoined, 
    function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embedjoin}), { ['Content-Type'] = 'application/json' })
end

function PetrissendToDiscLeave(title, message, footer)
    local embedleft = {}
    embedleft = {
        {
            ["color"] = 16711680, 
            ["title"] = "".. title .."",
            ["description"] = "" .. message ..  "",
            ["footer"] = {
                ["text"] = name,
                ["icon_url"] = logo,
            },
        }
    }
    PerformHttpRequest(webhookURLPetrisLeft, 
    function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embedleft}), { ['Content-Type'] = 'application/json' })
end

-- VERSION CHECKER - DO NOT TOUCH THIS !!! ---
local verFile = LoadResourceFile(GetCurrentResourceName(), "version.json")
local curVersion = json.decode(verFile).version
Citizen.CreateThread( function()
	local updatePath = "/GitPetris/petris-serverlogs"
	local resourceName = "Petris Server Logs ("..GetCurrentResourceName()..")"
	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version.json", function(err, response, headers)
		local data = json.decode(response)


		if curVersion ~= data.version and tonumber(curVersion) < tonumber(data.version) then
			print("\n-------------------------------------^8[WARNING]^0-------------------------------------")
			print("\n"..resourceName.." is ^1outdated^0.\n^2Newest Version:^0 "..data.version.."\n^5Your Version:^0 "..curVersion.."\n^*Please update it from https://github.com"..updatePath.."")
			print("\n-------------------------------------^8[WARNING]^0-------------------------------------")
		else
			print(resourceName.." ^2is up to date!")
		end
	end, "GET", "", {version = 'this'})
end)
