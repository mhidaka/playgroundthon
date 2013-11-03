function apiLoad()
	syslog("[API] in api.lua")

	if not shinchoku then
		shinchoku = {}
	end

	local root = shinchoku

	root.api = {}

	local api = root.api
	local userInfo = {}

	local function buildUrl(path)
		return "http://54.238.127.127" .. path
	end

	-- 使い方
	-- api.login(userName, callback) callback は Function
	api.login = function (userName, callback)
		syslog("[API] called login")

		local json = CONV_Lua2Json({userName = userName})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_login_" .. timestamp
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
				userId = 111,
				userName = "Mr.shinchoku"
			})
			userInfo.userId = 111
			userInfo.userName = "Mr.schinchoku"
			return 0
		end
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

	-- 使い方
	-- api.fetchRoomInfo(roomId, callback) callback は Function
	api.fetchRoomInfo = function (roomId, callback) 
		syslog("[API] called fetchRoomInfo")

		local json = CONV_Lua2Json({act = "room_status", id = 1})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchRoomInfo_" .. timestamp
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
				users = {
					{
						id = 111,
						name = "vvakame"
					},
					{
						id = 2222,
						name = "mhidaka"
					}
				}
			})
			return 0
		end
	end

	-- 使い方
	-- api.createRoom(callback) callback は Function userIdは内部で持っているので渡さなくて良い
	api.createRoom = function (callback) 
		syslog("[API] called createRoom")

		local json = CONV_Lua2Json({ownerId = userInfo.userId})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_createRoom_" .. timestamp
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
				roomId = 111,
				ownerId = 1,
				users = {userInfo}
			})
			return 0
		end
	end
end
apiLoad()
_G["apiLoad"] = nil
