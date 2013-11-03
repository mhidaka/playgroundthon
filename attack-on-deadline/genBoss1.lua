--[[
	TASK_Genericを使用してLuaでタスクを記述する例
	genBoss1.lua
	ボスキャラ（しんちょくさん）
]]

tblBOSS1 = {}

countBOSS1 = 0


function initBoss1(key, index, x, y, asset)
	local tbl = {}
	
	-- add execute & die method
	pGenTask = TASK_Generic("execute_Boss1", "die_Boss1", key)

	-- set Char status
	tbl.x = x
	tbl.y = y
--	tbl.atk   = index ^ 2
--	tbl.speed = 1 - (index * 0.1)
	tbl.status = 0	-- status
	tbl.action = 0	-- action
	tbl.timer = 0	-- timer
	tbl.asset = asset	--filename
	
	-- CAN PASS pGenTask as parent, but pGenTask has not graphic node : nodes are attached to ROOT.
	tbl.image = UI_SimpleItem(pGenTask, 6000, x, y, asset)

	tblBOSS1[key] = tbl
	
	countBOSS1 = countBOSS1 + 1
end

function execute_Boss1(pTask, deltaT, key)
	prop = TASK_getProperty(tblBOSS1[key].image)
	if tblBOSS1[key].status == 1 then
		tblBOSS1[key].timer = 30
		tblBOSS1[key].status = 2
	end
	if tblBOSS1[key].status == 2 then
		tblBOSS1[key].action = tblBOSS1[key].action + 1
		if tblBOSS1[key].action >= 2 then
			tblBOSS1[key].action = 0
		end
		if tblBOSS1[key].action == 0 then
			prop.x = prop.x + 8
		end
		if tblBOSS1[key].action == 1 then
			prop.x = prop.x - 8
		end
		tblBOSS1[key].timer = tblBOSS1[key].timer - 1 
		if tblBOSS1[key].timer <= 0 then
			tblBOSS1[key].timer = 0
			tblBOSS1[key].status = 0
		end
	end
	TASK_setProperty(tblBOSS1[key].image, prop)
end

function die_Boss1(pTask, key)
	-- NEVER kill in DIE : forbidden by engine, you will get an assert.
	--TASK_kill(tblCHAR2[key].image)
	tblBOSS1[key] = nil
	syslog(string.format("kill boss1[%s]", key))
end
