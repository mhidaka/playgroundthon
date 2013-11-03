--[[
ルーム選択画面

概要：
・サーバから取得したルーム一覧を表示
・新規にルーム作成もできる
・既存ルーム選択、新規ルーム作成をサーバに要求する
・サーバから正常な結果が返ってきたら、ルーム確認画面に遷移する
]]

function setup()
	if not rootTbl then
		rootTbl = {}
	end

	FONT_load("MTLmr3m","asset://MTLmr3m.ttf")
	pLabel = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							64,100,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"Welcome!(Room Select scene sample)"	-- "<text string>"
						)
end

function execute(deltaT)
end

function leave()
end
