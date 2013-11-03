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

<<<<<<< HEAD
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
=======
	roomsResult = nil -- ここにサーバから返ってきた bodyPayload が入る
	status = 0 -- まだサーバに何もリクエストしてないよ

	shinchoku.api.getRooms(callbackGetRooms)

	status = 1 -- サーバへのリクエスト送ったよ
>>>>>>> 5224723dba2b707dd3c5a21dec7f1a92d847dd9e
end

function execute(deltaT)
	if status == 1 or status == 0 then
		-- TODO: あんまり通信中状態が長かったらキャンセルする処理も入れた方がいいかも
		return
	end
	if status == -1 then
		networkError()

		-- TODO: 前画面かトップ画面に戻る処理を入れる
		return
	end

	-- ここには通信成功 (status == 2)でしかこないはず
	status == 0 -- 通信終わってるはずだから元に戻しておくよ

	-- TODO: ルーム一覧表示を更新する
end

function leave()
end

-- サーバとの通信処理のコールバック
function callbackGetRooms(connectionID, message, status, bodyPayload)
	if not (message == NETAPIMSG_REQUEST_SUCCESS and status == 200) then
		status = -1 -- 通信エラーだよ
		return
	end

	status = 2 -- サーバとの処理成功したよ
	roomsResult = bodyPayload
end

-- TODO: エラー処理を書く
function networkError()
end
