--[[
ログイン用画面

概要：
・名前が入力済みでOK押したらサーバに要求
・サーバから正常な結果が返ってきたら、ルーム選択画面に遷移する
]]

function setup()
	if not rootTbl then
		rootTbl = {}
	end

--	FONT_load("AlexBrush","asset://AlexBrush-Regular-OTF.otf")
	FONT_load("MTLmr3m","asset://MTLmr3m.ttf")
	pLabel = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							64,100,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"Hello World!(login scene sample)"	-- "<text string>"
						)

-- user name input
    pTB = UI_TextInput( nil, false, 	-- <parent pointer>, <password mode>,
						100, 200,		-- <x>, <y>, 
						300, 40, 		-- <width>, <height>,
						"input UserName",	-- "<default text>"
                        "onChangeCb",   -- [ , "<on-change-callback>", 
						0, 				-- <widget-id>, 
						20				-- <max-length>, <enable-chartype> ] )
						)

	
    TASK_StageOnly(pLabel)
    TASK_StageOnly(pTB)
end

-- Callback for TextInput
function onChangeCb(ptr, newStr, id)
	syslog(string.format("callback - new string = %s", newStr))
	local callback = function (connectionID, message, status, bodyPayload)
		syslog("[API] " .. CONV_Lua2Json(bodyPayload))
	end
	shinchoku.api.login("Mr.shinchoku", callback)
    
-- next scene
    sysLoad("asset://RoomSelect.lua")

end


function execute(deltaT)
end

function leave()
    TASK_StageClear()
end