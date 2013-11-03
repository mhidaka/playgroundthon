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
end

function execute(deltaT)
end

function leave()
end
