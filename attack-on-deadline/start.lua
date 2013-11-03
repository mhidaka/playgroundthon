include("asset://Api.lua")

shinchoku.api.debug = true

function setup()
	if not rootTbl then
		rootTbl = {}
	end
end

function execute(deltaT)
	--sysLoad("asset://SimpleItem.lua")
	sysLoad("asset://Login.lua")
end

function leave()

end
