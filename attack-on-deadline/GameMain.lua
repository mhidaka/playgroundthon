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
	
	ObjCounter = 0
	
	FONT_load("MTLmr3m","asset://MTLmr3m.ttf")
	pSceneLabel = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							64,100,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"In Game(GameMain scene sample)"	-- "<text string>"
						)
	
	pObjCount = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							64,200,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"0"	-- "<text string>"
						)
	
						
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
	
	TASK_StageOnly(oSceneLabel)
	TASK_StageOnly(pObjCount)
	TASK_StageOnly(pForm)
end

function execute(deltaT)
	local numString = tostring( ObjCounter )
	sysCommand( pObjCount, UI_LABEL_SET_TEXT, numString )
end

function leave()
	TASK_StageClear()
end

function button1_click()
	syslog('----- Form.button1_click() -----')
	born_unit(1,200,200)
end

function button2_click()
	syslog('----- Form.button2_click() -----')
	born_unit(2,200,200)
end

function button3_click()
	syslog('----- Form.button3_click() -----')
	born_unit(3,200,200)
end

function button4_click()
	syslog('----- Form.button4_click() -----')
	born_unit(4,200,200)
end

function button5_click()
	syslog('----- Form.button5_click() -----')
	born_unit(5,200,200)
end

function born_unit(index,x,y)
	local fileNames ={
		"asset://assets/images/unit01.png.imag",
		"asset://assets/images/unit02.png.imag",
		"asset://assets/images/unit03.png.imag",
		"asset://assets/images/unit04.png.imag",
		"asset://assets/images/unit05.png.imag",
	}
--	local filename[] = "asset://assets/images/unit01.png.imag"
	pUnitItem = UI_SimpleItem(	nil,							-- arg[1]:		親となるUIタスクポインタ
									7000,							-- arg[2]:		表示プライオリティ
									x+(ObjCounter*48), y,							-- arg[3,4]:	表示位置
									fileNames[index]	-- arg[5]:		表示assetのパス
								)
	
	ObjCounter = ObjCounter + 1
	
	TASK_StageOnly(pUnitItem)
end
