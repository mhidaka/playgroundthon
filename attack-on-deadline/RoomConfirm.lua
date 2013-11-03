--[[
ルーム選択画面

概要：
・サーバから取得したルームの情報(参加プレイヤなどなど)を表示する
・STARTを押したらサーバにルームへの参加(ゲーム開始)を要求する
・サーバから正常な結果が返ってきたら、ゲームメイン画面に遷移する
]]

function setup()
	if not rootTbl then
		rootTbl = {}
	end

	FONT_load("MTLmr3m","asset://MTLmr3m.ttf")
	pSceneLabel = UI_Label 	(
							nil, 			-- <parent pointer>, 
							7000, 			-- <order>, 
							64,100,		-- <x>, <y>,
                            0xFF, 0x000000,	-- <alpha>, <rgb>, 
							"MTLmr3m",	-- "<font name>",
							32,				-- <font size>, 
							"Wait Members!(Room Confirm scene sample)"	-- "<text string>"
						)

	serverResult = nil -- ここにサーバから返ってきた bodyPayload が入る
	status = 0 -- まだサーバに何もリクエストしてないよ

	shinchoku.api.fetchRoomInfo(rootTbl.user.id, callbackFetchRoomInfo)

	status = 1 -- サーバへのリクエスト送ったよ

	TASK_StageOnly(pSceneLabel)
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
	status = 0 -- 通信終わってるはずだから元に戻しておくよ

	-- TODO: ルーム情報を表示する
end

function leave()
	TASK_StageClear()
end

-- サーバとの通信処理のコールバック
function callbackFetchRoomInfo(connectionID, message, status, bodyPayload)
	if message ~= NETAPIMSG_REQUEST_SUCCESS or status ~= 200 then
		status = -1 -- 通信エラーだよ
		return
	end

	status = 2 -- サーバとの処理成功したよ
	serverResult = bodyPayload
end

-- TODO: エラー処理を書く
function networkError()
end
