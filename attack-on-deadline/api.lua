function apiLoad()
	syslog("[API] in api.lua")

	if not shinchoku then
		shinchoku = {}
	end

	local root = shinchoku

	root.api = {}

	local api = root.api

	local function buildUrl(path)
		return "http://54.238.127.127" .. path
	end

	api.fetchRooms = function (params, callback)
		syslog("[API] called fetchRooms")

		local json = CONV_Lua2Json(params)
		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchRooms_" .. timestamp
		_G[callbackName] = function()
			syslog("callback is coming! " .. callbackName)
		end

		local pHTTP = HTTP_API(callbackName)
		sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), params, json, 30000)
	end
end
apiLoad()
_G["apiLoad"] = nil
