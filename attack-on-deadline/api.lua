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

	-- 使い方
	-- api.fetchRooms({}, callback) callback は Function
	api.fetchRooms = function (params, callback)
		syslog("[API] called fetchRooms")

		local json = CONV_Lua2Json(params)
		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchRooms_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. callbackName)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		local pHTTP = HTTP_API(callbackName)
		sysCommand(pHTTP, NETAPI_SEND, "https://dl.dropboxusercontent.com/u/6581286/sample.json", params, json, 30000)
		return pHTTP
	end
end
apiLoad()
_G["apiLoad"] = nil
