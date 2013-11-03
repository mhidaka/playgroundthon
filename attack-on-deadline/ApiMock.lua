function mockLoad()
	syslog("[API] in ApiMock.lua")

	if not shinchoku then
		shinchoku = {}
	end

	local root = shinchoku

	if not root.api then
		root.api = {}
	end
	if not root.api.mock then
		root.api.mock = {}
	end

	local mock = root.api.mock

	local randomCounter = 0
	local rand = function()
		randomCounter = randomCounter + 1
		return randomCounter
	end

	mock.replaceServer = function()
		mock.users = {
			{
				id = rand(),
				name = "vvakame"
			},
			{
				id = rand(),
				name = "mhidaka"
			}
		}
		mock.serverData = {
			rooms = {}
		}
		for k, v in pairs(mock.users) do
			mock.createRoom(k)
		end
	end

	mock.addUser = function(userName)
		local user = {
			id = rand(),
			name = userName
		}
		table.insert(mock.users, user)
		return user
	end

	mock.getRooms = function()
		return {rooms = mock.serverData.rooms}
	end

	mock.getRoomInfo = function(roomId)
		local room = nil
		for k, v in pairs(mock.serverData.rooms) do
			if v.id == roomId then
				room = v
			end
		end
		return room
	end

	mock.getUserInfo = function(userId)
		local user = nil
		for k, v in pairs(mock.users) do
			if v.id == userId then
				user = v
			end
		end
		return user
	end

	mock.createRoom = function(userId)
		local room = {}
		local user = mock.getUserInfo(userId)
		room = {}
		room.id = rand()
		room.owner = user
		room.users = {user}
		table.insert(mock.serverData.rooms, room)
		return room
	end

	mock.joinRoom = function(roomId, userId)
		local room = mock.getRoomInfo(roomId)

		for k, v in pairs(room.users) do
			if k == userId then
				return room
			end
		end

		table.insert(room.users, mock.getUserInfo(userId))
		return room
	end

	mock.engageStart = function(roomId)
		local room = mock.getRoomInfo(roomId)
		room.internal = {}
		room.internal.state = {}
		room.internal.state.users = {}
		room.internal.state.boss = {}
		room.internal.state.units = {}

		for k, v in pairs(room.users) do
			table.insert(room.internal.state.users, {
				id = v.id,
				name = v.name,
				wallet = 10000
			})
		end
		room.internal.state.boss.hp = 9999

		return {}
	end

	mock.addUnit = function(roomId, ownerId, kind)
		local room = mock.getRoomInfo(roomId)
		-- {"atk":33,"unitId":1111,"hp":100,"ownerId":111,"x":1,"z":3,"kind":1,"cost":100,"y":2}
		local unit = {
			unitId = rand(),
			ownerId = ownerId,
			kind = kind,
			x = math.random(100),
			y = math.random(100),
			z = math.random(100),
			hp = math.random(100),
			atk = math.random(100),
			cost = math.random(100)
		}
		local user = nil
		for k, v in pairs(room.internal.state.users) do
			if v.id == ownerId and unit.cost <= v.wallet then
				v.wallet = v.wallet - unit.cost
				table.insert(room.internal.state.units, unit)
			end
		end
		return room.internal.state
	end

	mock.getStageInfo = function(roomId)
		local room = mock.getRoomInfo(roomId)
		return room.internal.state
	end

	mock.refresh = function(roomId)
		local room = mock.getRoomInfo(roomId)
		for k, v in pairs(room.internal.state.users) do
			v.wallet = v.wallet + 10
		end
	end
end
mockLoad()
_G["mockLoad"] = nil
