--\\ variables
local discordia = require("discordia")
local http,https,json = require('http'),require('https'),require("json")
local client = discordia.Client {
	cacheAllMembers = true,
}

local serverIds = {
	main = "681644149627420877",
}

local boosters = {}
local boosterRbxIds = {}
local baseUrl = "https://api.blox.link/v1/user/"



--\\ functions
local function httpGET(url, callback)
	url = http.parseUrl(url)

	local req = (url.protocol == 'https' and https or http).get(url, function(res)
		local body = {}

		res:on('data', function(s)
			body[#body+1] = s
		end)

		res:on('end', function()
			res.body = table.concat(body)
			callback(res)
		end)

		res:on('error', function(err)
			callback(res, err)
		end)
	end)

	req:on('error', function(err)
		callback(nil, err)
	end)
end


local function tableFind(table, value)
	for i,v in ipairs(table) do
		if v == value then
			return i
		end
	end
end


local function updateMemberBoosterStatus(member)
	local userId = member.user.id
	local isBooster = member:hasRole("775165373661839401")
	local boosterIndex = tableFind(boosters, member)
	
	if isBooster and not boosterIndex then --user is booster and not cached
		boosters[#boosters + 1] = member

		httpGET(("%s%s?guild=%s"):format(baseUrl, member.user.id, serverIds.main), function(result, error)
			if not error then
				local userInfo = json.decode(result.body)
				local userId = userInfo.matchingAccount or userInfo.primaryAccount

				boosterRbxIds[member.user.id] = userId
			end
		end)
	elseif not isBooster and boosterIndex then --user isnt a booster and is cached
		boosters[boosterIndex] = nil
		boosterRbxIds[member.user.id] = nil
	end
end


--\\ client listens
client:on("ready", function()
	local mainServer = client:getGuild(serverIds.main)

	for member in mainServer.members:iter() do
		updateMemberBoosterStatus(member)
	end
end)

client:on("memberUpdate", function(member)
	if member.guild.id == serverIds.main then
		updateMemberBoosterStatus(member)
	end
end)

client:on("messageCreate", function(message)
	print(json.encode(boosterRbxIds))
end)



--\\ starting bot
client:run("Bot ".."Nzk2NDIyNTgyMjc4NDIyNTc5.X_XsVA.iURLRutgFy7AHQrUlaRSTkF4Jt8")