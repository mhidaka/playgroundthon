function setup()
	debugScene = {}

	local x = 0
	local y = 0
	local pForm = UI_Form(nil,	-- arg[1]:	親となるUIタスクのポインタ
		7000,		-- arg[2]:	基準表示プライオリティ
		x, y,		-- arg[3,4]:	表示位置
		"asset://debugMenu.json",	-- arg[5]:	composit jsonのパス
		false		-- arg[6]:	排他フラグ
	)

	shinchoku.api.login("Mr.shinchoku", function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
		debugScene.userId = bodyPayload.id
	end)


	TASK_StageOnly(pForm)
end

function execute(deltaT)
end

function leave()
	TASK_StageClear()
end

function onClick(name,type,param)
	if type == 3 then
		_G[name .. "_click"](name, type, param)
	end
end

function button_a_click(name,type,param)
	syslog('----- Form.button_a_click() -----')
	syslog("create")

	shinchoku.api.createRoom(function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
		debugScene.roomId = bodyPayload.id
	end)
end

function button_b_click(name,type,param)
	syslog('----- Form.button_b_click() -----')
	syslog("engage")

	shinchoku.api.engageStart(debugScene.roomId, function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end)
end

function button_c_click(name,type,param)
	syslog('----- Form.button_c_click() -----')
	syslog("process")

	shinchoku.api.game.fetchStageInfo(function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end)
end

function button_d_click(name,type,param)
	syslog('----- Form.button_d_click() -----')
	syslog("process")
end

function button_1_click(name,type,param)
	syslog('----- Form.button_1_click() -----')

	shinchoku.api.game.addUnit(1, function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end)
end

function button_2_click(name,type,param)
	syslog('----- Form.button_2_click() -----')

	shinchoku.api.game.addUnit(2, function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end)
end

function button_3_click(name,type,param)
	syslog('----- Form.button_3_click() -----')

	shinchoku.api.game.addUnit(3, function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end)
end

function button_4_click(name,type,param)
	syslog('----- Form.button_4_click() -----')

	shinchoku.api.game.addUnit(4, function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end)
end

function button_5_click(name,type,param)
	syslog('----- Form.button_5_click() -----')

	shinchoku.api.game.addUnit(5, function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end)
end
