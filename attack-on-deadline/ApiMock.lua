function mockLoad()
	syslog("[API] in ApiMock.lua")

	-- データ初期値
	local DATA = {
		user = {
			wallet = 7,
			walletDelta = 1 -- 1秒あたりのコスト回復数
		},
		boss = {
			hp = 530000,
			atk = 2
		},
		units = { -- 添字 = kind
			{
				cost = 3,
				hp = 3,
				atk = 3
			},
			{
				cost = 5,
				hp = 5,
				atk = 5
			},
			{
				cost = 8,
				hp = 8,
				atk = 8
			},
			{
				cost = 13,
				hp = 13,
				atk = 13
			},
			{
				cost = 21,
				hp = 21,
				atk = 21
			}
		},
		range = {
			x = 100,
			y = 100,
			z = 100
		}
	}

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
		room.internal.lastUpdateAt = ENG_getNanoTime()
		room.internal.state = {}
		room.internal.state.users = {}
		room.internal.state.boss = {}
		room.internal.state.units = {}

		for k, v in pairs(room.users) do
			table.insert(room.internal.state.users, {
				id = v.id,
				name = v.name,
				wallet = DATA.user.wallet
			})
		end
		room.internal.state.boss.hp = DATA.boss.hp

		return room.internal.state
	end

	mock.addUnit = function(roomId, ownerId, kind)
		mock.refresh(roomId)

		local room = mock.getRoomInfo(roomId)
		-- {"atk":33,"unitId":1111,"hp":100,"ownerId":111,"x":1,"z":3,"kind":1,"cost":100,"y":2}
		local unitData = DATA.units[kind]
		local unit = {
			unitId = rand(),
			ownerId = ownerId,
			kind = kind,
			x = math.random(DATA.range.x),
			y = math.random(DATA.range.y),
			z = math.random(DATA.range.z),
			hp = math.random(unitData.hp),
			atk = math.random(unitData.atk),
			cost = math.random(unitData.cost)
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
		mock.refresh(roomId)

		local room = mock.getRoomInfo(roomId)
		return room.internal.state
	end

	mock.refresh = function(roomId)
		local room = mock.getRoomInfo(roomId)
		local last = room.internal.lastUpdateAt

		while last + 3000 < ENG_getNanoTime() do
			mock.nextTick()
			last = last + 3000
		end

		room.internal.lastUpdateAt = last
	end

	mock.nextTick = function(roomid)
		local room = mock.getRoomInfo(roomId)

		-- お金増やす
		for k, v in pairs(room.internal.state.users) do
			v.wallet = v.wallet + DATA.user.walletDelta * 3
		end
		local boss = room.internal.state.boss
		for k, v in pairs(room.internal.state.units) do
			-- ボスへの攻撃
			boss.hp = boss.hp - v.atk
			-- ボスの攻撃
			v.hp = v.hp - DATA.boss.atk
			-- 死亡処理
			if v.hp <= 0 then
				room.internal.state.units[k] = nil
			end
		end
	end
end
mockLoad()
_G["mockLoad"] = nil
