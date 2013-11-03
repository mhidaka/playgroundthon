include("asset://ApiMock.lua")

function apiLoad()
	syslog("[API] in Api.lua")

	if not shinchoku then
		shinchoku = {}
	end

	local root = shinchoku

	if not root.api then
		root.api = {}
	end
	if not root.api.game then
		root.api.game = {}
	end

	local api = root.api
	local game = root.api.game
	local userInfo = {}
	local roomInfo = {}

	-- モックサーバを動かすよー
	local mock = root.api.mock
	mock.replaceServer()

	local function buildUrl(path)
		return "http://54.238.127.127" .. path
	end

	local timeout = 30000

	-- 使い方
	-- api.login(userName, callback) callback は Function
	api.login = function (userName, callback)
		local apiName = "login";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({act = "login", userName = userName})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_login_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local user = mock.addUser(userName)
			userInfo = user
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, user)
			return 0
		end
	end

	-- 使い方
	-- api.fetchRooms(callback) callback は Function
	api.fetchRooms = function (callback)
		local apiName = "fetchRooms";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({act = "room_list"})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchRooms_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local rooms = mock.getRooms()
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, rooms)
			return 0
		end
	end

	-- 使い方
	-- api.fetchRoomInfo(roomId, callback) callback は Function
	api.fetchRoomInfo = function (roomId, callback) 
		local apiName = "fetchRoomInfo";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({act = "room_status", id = roomId})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchRoomInfo_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local room = mock.getRoomInfo(roomId)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, room)
			return 0
		end
	end

	-- 使い方
	-- api.createRoom(callback) callback は Function userIdは内部で持っているので渡さなくて良い
	api.createRoom = function (callback) 
		local apiName = "createRoom";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({act = "create_room", userId = userInfo.id})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_createRoom_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local room = mock.createRoom(userInfo.id)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, room)
			return 0
		end
	end

	-- 使い方
	-- api.joinRoom(roomId, callback) callback は Function userIdは内部で持っているので渡さなくて良い
	api.joinRoom = function (roomId, callback) 
		local apiName = "joinRoom";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({roomId = roomId, userId = userInfo.id})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_joinRoom_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local room = mock.joinRoom(roomId, userInfo.id)
			roomInfo = room
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, room)
			return 0
		end
	end

	-- 使い方
	-- api.engageStart(roomId, callback) callback は Function userIdは内部で持っているので渡さなくて良い
	api.engageStart = function (roomId, callback)
		local apiName = "engageStart";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({act = "start", roomId = roomId, userId = userInfo.id})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_engageStart_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local ret = mock.engageStart(roomId)
			roomInfo = mock.getRoomInfo(roomId)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, ret)
			return 0
		end
	end

	-- 使い方
	-- game.addUnit(kind, callback)
	game.addUnit = function (kind, callback)
		local apiName = "addUnit";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({act = "add", roomId = roomInfo.id, userId = userInfo.id, unitKind = kind})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_addUnit_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/stage.php"), nil, json, timeout)
			return pHTTP
		else
			local ret = mock.addUnit(roomInfo.id, userInfo.id, kind)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, ret)
			return 0
		end
	end

	-- 使い方
	-- game.fetchStageInfo(callback)
	game.fetchStageInfo = function (callback)
		local apiName = "fetchStageInfo";
		syslog("[API] called " .. apiName)

		local json = CONV_Lua2Json({roomId = roomInfo.id, userId = userInfo.id})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchStageInfo_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. apiName .. " " .. callbackName .. " args:" .. json)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/stage.php"), nil, json, timeout)
			return pHTTP
		else
			local ret = mock.getStageInfo(roomInfo.id)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, ret)
			return 0
		end
	end
end
apiLoad()
_G["apiLoad"] = nil
