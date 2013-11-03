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
end

function execute(deltaT)
end

function leave()
end