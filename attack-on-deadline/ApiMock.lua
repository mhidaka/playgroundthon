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
		return mock.serverData.rooms
	end

	mock.getRoomInfo = function(roomId)
		return mock.serverData.rooms[roomId]
	end

	mock.createRoom = function(userId)
		local room = {}
		local user = mock.users[userId]
		room = {}
		room.id = rand()
		room.owner = user
		room.users = {user}
		table.insert(mock.serverData.rooms, room)
		return room
	end

	mock.joinRoom = function(roomId, userId)
		local room = mock.getRooms()[roomId]

		for k, v in pairs(room.users) do
			if k == userId then
				return room
			end
		end

		local user = mock.users[userId]

		table.insert(room.users, user)
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
				wallet = 100
			})
		end
		room.internal.state.boss.hp = 9999

		return {}
	end

end
mockLoad()
_G["mockLoad"] = nil
