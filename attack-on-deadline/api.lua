function apiLoad()
	syslog("[API] in api.lua")

	if not shinchoku then
		shinchoku = {}
	end

	local root = shinchoku

	root.api = {}

	local api = root.api

	api.fetchRooms = function ()
		syslog("[API] called fetchRooms")
	end
end
apiLoad()
