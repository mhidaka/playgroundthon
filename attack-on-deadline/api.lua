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
	-- api.fetchRooms(callback) callback は Function
	api.fetchRooms = function (callback)
		syslog("[API] called fetchRooms")

		local json = CONV_Lua2Json({act = "room_list"})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchRooms_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. callbackName)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, "https://dl.dropboxusercontent.com/u/6581286/sample.json", params, json, 30000)
			return pHTTP
		else
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, {
				rooms = {
					{
						id = 1,
						owner = "hoge"
					},
					{
						id = 2,
						owner = "fuga"
					}
				}
			})
			return 0
		end
	end
end
apiLoad()
_G["apiLoad"] = nil
