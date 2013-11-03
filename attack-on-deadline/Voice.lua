
voice = {}
voice_name = {}

voice_name[ 1] = "voice01_akanyatsuya"
voice_name[ 2] = "voice02_iie"
voice_name[ 3] = "voice03_shiyouhenkou"
voice_name[ 4] = "voice04_sagyoumore"
voice_name[ 5] = "voice05_uwa-"
voice_name[ 6] = "voice06_uo-"
voice_name[ 7] = "voice07_orenimakasetoke"
voice_name[ 8] = "voice08_ganbarimasu"
voice_name[ 9] = "voice09_kigougamietekita"
voice_name[10] = "voice10_kyouhakaeremasen"
voice_name[11] = "voice11_kuchikusiteyaru"
voice_name[12] = "voice12_kokohaorenimakaseteike"
voice_name[13] = "voice13_ienikaeritai"
voice_name[14] = "voice14_doryokusuru"
voice_name[15] = "voice15_dead"
voice_name[16] = "voice16_shiyouhenkou"
voice_name[17] = "voice17_newcomer"
voice_name[18] = "voice18_shintyoku_dame"
voice_name[19] = "voice19_shintyoku_doudesuka"
voice_name[20] = "voice20_shintyokuwokaishi"
voice_name[21] = "voice21_dame"
voice_name[22] = "voice22_torya-"
voice_name[23] = "voice23_nannoseikamoeraremasendesita"
voice_name[24] = "voice24_yes"
voice_name[25] = "voice25_pronimakasetai"
voice_name[26] = "voice26_veterannimakasetai"
voice_name[27] = "voice27_moudameda"
voice_name[28] = "voice28_yattaka"
voice_name[29] = "voice29_youkenitiran"

function Voice_Open()
	for i = 1,29 do
		voice[i] = SND_Open("asset://assets/voices/" .. voice_name[i])
	end
end

function Voice_Close()
	for i = 1,29 do
		voice[i] = SND_Close(voice_name[i])
	end
end

function VoicePlay(no)
	SND_Play(voice[no])
end

function VoiceRandomPlay(type)
	r = math.random(1,29)
    SND_Play(voice[r])
end

