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
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local user = mock.addUser(userName)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, user)
			userInfo = user
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
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local room = mock.createRoom(userInfo.userId)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, room)
			return 0
		end
	end

	-- 使い方
	-- api.joinRoom(roomId, callback) callback は Function userIdは内部で持っているので渡さなくて良い
	api.joinRoom = function (roomId, callback) 
		syslog("[API] called joinRoom")

		local json = CONV_Lua2Json({roomId = roomId, userId = userInfo.userId})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_joinRoom_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. callbackName)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local room = mock.joinRoom(roomId, userInfo.userId)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, room)
			roomInfo = room
			return 0
		end
	end

	-- 使い方
	-- api.engageStart(roomId, callback) callback は Function userIdは内部で持っているので渡さなくて良い
	api.engageStart = function (roomId, callback)
		syslog("[API] called engageStart")

		local json = CONV_Lua2Json({act = "start", roomId = roomId, userId = userInfo.userId})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_engageStart_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. callbackName)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/room.php"), nil, json, timeout)
			return pHTTP
		else
			local ret = mock.engageStart(roomId)
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, ret)
			roomInfo.roomId = roomId
			return 0
		end
	end

	-- 使い方
	-- game.addUnit(kind, callback)
	game.addUnit = function (kind, callback)
		syslog("[API] called addUnit")

		local json = CONV_Lua2Json({act = "add", roomId = roomInfo.roomId, userId = userInfo.userId, unitKind = kind})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_addUnit_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. callbackName)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/stage.php"), nil, json, timeout)
			return pHTTP
		else
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, {
				unitId = 1111,
				ownerId = userInfo.userId,
				kind = kind,
				x = 1,
				y = 2,
				z = 3,
				hp = 100,
				atk = 33,
				cost = 100
			})
			return 0
		end
	end

	-- 使い方
	-- game.fetchStageInfo(callback)
	game.fetchStageInfo = function (callback)
		syslog("[API] called fetchStageInfo")

		local json = CONV_Lua2Json({roomId = roomInfo.roomId, userId = userInfo.userId})
		syslog("[API] " .. json)

		local timestamp = ENG_getNanoTime()
		local callbackName = "SHINCHOKU_CALLBACK_fetchStageInfo_" .. timestamp
		_G[callbackName] = function(connectionID, message, status, bodyPayload)
			syslog("callback is coming! " .. callbackName)
			_G[callbackName] = nil
			callback(connectionID, message, status, bodyPayload)
		end

		if not api.debug then
			local pHTTP = HTTP_API(callbackName)
			sysCommand(pHTTP, NETAPI_SEND, buildUrl("/stage.php"), nil, json, timeout)
			return pHTTP
		else
			_G[callbackName](0, NETAPIMSG_REQUEST_SUCCESS, 200, {
				boss = {
					hp = 9999
				},
				user = {
					wallet = 1000
				},
				units = {
					{
						unitId = 1111,
						ownerId = userInfo.userId,
						kind = 1,
						x = 1,
						y = 2,
						z = 3,
						hp = 100,
						atk = 33,
						cost = 100
					},
					{
						unitId = 1112,
						ownerId = userInfo.userId,
						kind = 2,
						x = 3,
						y = 1,
						z = 2,
						hp = 2,
						atk = 11,
						cost = 100
					},
					{
						unitId = 1113,
						ownerId = userInfo.userId,
						kind = 3,
						x = 4,
						y = 3,
						z = 1,
						hp = 1,
						atk = 1,
						cost = 1
					}
				}
			})
			return 0
		end
	end
end
apiLoad()
_G["apiLoad"] = nil
