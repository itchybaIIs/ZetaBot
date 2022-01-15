local discordia = require("discordia")
local client = discordia.Client()
local prefix = ">"
local token = "Nzk2NDIyNTgyMjc4NDIyNTc5.X_XsVA.iURLRutgFy7AHQrUlaRSTkF4Jt8"


local function checkAutorespond(userId)
	for i,v in pairs(autoResponder) do
		if userId == i then
			return v --ion need you anyway
		end
	end
end

local cmdFunctions = {
	["new phone"] = function(msg)
		msg.channel:send("who dis")
	end;
}

local messageFunctions = {
	function(msg)
		if tonumber(msg.channel.id) == tonumber(774017299338362951) then
			if string.sub(string.lower(msg.content), 1, 11) == "suggestion:" and string.find(string.lower(msg.content), "reason:") and #msg.content >= 38 then
				msg:addReaction("✅")
				msg:addReaction("❌")
			else
				msg:delete()
				msg.author:send("Message blocked because it doesn't have the correct format or was too small.")
			end
		elseif tonumber(msg.channel.id) == tonumber(774017283802005514) then
			if string.sub(string.lower(msg.content), 1, 4) == "Bug:" and string.find(string.lower(msg.content), "Proof:") and #msg.content >= 20 then
				msg:addReaction("✅")
				msg:addReaction("❌")
			else
				pcall(function()
					msg:delete()
				end)
				msg.author:send("Message blocked because it doesn't have the correct format or was too small.")
			end
		end
	end;
}


client:on("messageCreate", function(msg)
	if string.sub(msg.content, 1, 1) == prefix then
		for cmd,cmdFunc in pairs(cmdFunctions) do
			local sub = string.sub(string.lower(msg.content), #prefix + 1, #cmd + #prefix)

			if sub == cmd then
				local arg = string.sub(msg.content, #cmd + (#prefix * 2) + 1, #msg.content)
				
				cmdFunc(msg, arg)

				break
			end
		end
	end

	--[[for i,v in pairs(messageFunctions) do
		v(msg)
	end]]
end)

client:run("Bot "..token)