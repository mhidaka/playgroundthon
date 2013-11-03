--[[
ゲームメイン画面

概要：
・ゲーム内のいろいろな処理を実現する。頑張れ。
・途中でやめるボタンを押したらルーム選択画面に遷移する
・ゲームの勝利条件、敗北条件が満たされたら、勝利画面、敗北画面に遷移する
]]

include("asset://Voice.lua")
include("asset://genChar2.lua")

_growupInterval = 20
_growupCounter = 0

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
	pObjCount2 = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							64,300,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"0"	-- "<text string>"
						)
	pObjBossHP = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							800,160,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"0"	-- "<text string>"
						)
	pObjMoney = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							64,400,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"0"	-- "<text string>"
						)
	
	born_boss(1,700,160)
						
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
	
	Voice_Open()
	
	bgm = SND_Open("asset://assets/musics/uchuusensou", true)
	SND_Play(bgm)
	SND_Volume(bgm,0.4)

	TASK_StageOnly(oSceneLabel)
	TASK_StageOnly(pObjCount)
	TASK_StageOnly(pForm)
end

function execute(deltaT)
	_growupCounter = _growupCounter + 1
	if _growupCounter > _growupInterval then
		_Money = _Money + 1
		_growupCounter = 0
	end
	
	local numString = ""
	numString = "TOTAL :" .. tostring( ObjCounter )
	sysCommand( pObjCount, UI_LABEL_SET_TEXT, numString )
	numString = "ACTIVE:" .. tostring( countCHAR2 )
	sysCommand( pObjCount2, UI_LABEL_SET_TEXT, numString )
	numString = "BOSS HP:" .. tostring( _BossHP )
	sysCommand( pObjBossHP, UI_LABEL_SET_TEXT, numString )
	numString = "MONEY :" .. tostring( _Money )
	sysCommand( pObjMoney, UI_LABEL_SET_TEXT, numString )
	
end

function leave()
	
	Voice_Close()
	
	TASK_StageClear()
end

function button1_click(name,type,param)
	syslog('----- Form.button1_click() -----')
	if type == 3 then
		born_unit(1,200,300)
	end
end

function button2_click(name,type,param)
	syslog('----- Form.button2_click() -----')
	if type == 3 then
		born_unit(2,200,300)
	end
end

function button3_click(name,type,param)
	syslog('----- Form.button3_click() -----')
	if type == 3 then
		born_unit(3,200,300)
	end
end

function button4_click(name,type,param)
	syslog('----- Form.button4_click() -----')
	if type == 3 then
		born_unit(4,200,300)
	end
end

function button5_click(name,type,param)
	syslog('----- Form.button5_click() -----')
	if type == 3 then
		born_unit(5,200,300)
	end
end

-- born unit's 
function born_unit(index,x,y)
	local fileNames ={
		"asset://assets/images/unit01.png.imag",
		"asset://assets/images/unit02.png.imag",
		"asset://assets/images/unit03.png.imag",
		"asset://assets/images/unit04.png.imag",
		"asset://assets/images/unit05.png.imag",
	}
--	local filename[] = "asset://assets/images/unit01.png.imag"

--	pUnitItem = UI_SimpleItem(	nil,							-- arg[1]:		親となるUIタスクポインタ
--									7000,							-- arg[2]:		表示プライオリティ
--									x+(ObjCounter*48), y,							-- arg[3,4]:	表示位置
--									fileNames[index]	-- arg[5]:		表示assetのパス
--								)
	
	-- move objects
	local cost = index * 3
	if _Money >= cost then
		_Money = _Money - cost		-- dec cost
		initChar2(tostring(ObjCounter),index,x,y+48,fileNames[index])
	
		ObjCounter = ObjCounter + 1

		VoiceRandomPlay()
	end

--	TASK_StageOnly(pUnitItem)
end

-- born boss
function born_boss(index,x,y)
	local fileNames ={
		"asset://assets/images/boss01.png.imag",
		"asset://assets/images/unit05.png.imag",
	}
	pBossItem = UI_SimpleItem(	nil,							-- arg[1]:		親となるUIタスクポインタ
									6000,							-- arg[2]:		表示プライオリティ
									x, y,							-- arg[3,4]:	表示位置
									fileNames[index]	-- arg[5]:		表示assetのパス
								)
	
	TASK_StageOnly(pBossItem)
end
