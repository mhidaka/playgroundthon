--[[
ゲームメイン画面

概要：
・ゲーム内のいろいろな処理を実現する。頑張れ。
・途中でやめるボタンを押したらルーム選択画面に遷移する
・ゲームの勝利条件、敗北条件が満たされたら、勝利画面、敗北画面に遷移する
]]

function setup()
	if not rootTbl then
		rootTbl = {}
	end

	local x = 0
	local y = 0
	local pForm = UI_Form(nil,	-- arg[1]:	親となるUIタスクのポインタ
		7000,		-- arg[2]:	基準表示プライオリティ
		x, y,		-- arg[3,4]:	表示位置
		"asset://GameMain.json",	-- arg[5]:	composit jsonのパス
		false		-- arg[6]:	排他フラグ
	)
	--[[
		arg[6]:排他フラグ は、省略可能です。
		省略した場合は false と同じ挙動になります。
	]]
	
	TASK_StageOnly(pForm)
end

function execute(deltaT)
end

function leave()
	TASK_StageClear()
end

function button1_click()
	syslog('----- Form.button1_click() -----')
end

function button2_click()
	syslog('----- Form.button2_click() -----')
end

function button3_click()
	syslog('----- Form.button3_click() -----')
end

function button4_click()
	syslog('----- Form.button4_click() -----')
end

function button5_click()
	syslog('----- Form.button5_click() -----')
end
