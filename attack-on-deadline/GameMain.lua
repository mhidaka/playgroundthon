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
end

function execute(deltaT)
end

function leave()
end
