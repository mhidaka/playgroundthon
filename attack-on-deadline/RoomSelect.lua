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

	local x = 0
	local y = 0
	local pForm = UI_Form(nil,	-- arg[1]:	親となるUIタスクのポインタ
		7000,		-- arg[2]:	基準表示プライオリティ
		x, y,		-- arg[3,4]:	表示位置
		"asset://roomselect.json",	-- arg[5]:	composit jsonのパス
		false		-- arg[6]:	排他フラグ
	)
	--[[
		arg[6]:排他フラグ は、省略可能です。
		省略した場合は false と同じ挙動になります。
	]]

	serverResult = nil -- ここにサーバから返ってきた bodyPayload が入る
	status = 0 -- まだサーバに何もリクエストしてないよ

	shinchoku.api.fetchRooms(callbackFetchRooms)

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

	-- TODO: ルーム一覧表示を更新する
end

function leave()
	TASK_StageClear()
end

-- サーバとの通信処理のコールバック
function callbackFetchRooms(connectionID, message, status, bodyPayload)
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