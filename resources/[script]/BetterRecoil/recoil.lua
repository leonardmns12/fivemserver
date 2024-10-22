local recoils = {
	[453432689] = 0.8, -- PISTOL
	[3219281620] = 0.3, -- PISTOL MK2
	[1593441988] = 0.2, -- COMBAT PISTOL
	[584646201] = 1.0, -- AP PISTOL
	[-1716589765] = 0.7, -- PISTOL .50
	[324215364] = 0.2, -- MICRO SMG
	[736523883] = 0.1, -- SMG
	[2024373456] = 0.1, -- SMG MK2
	[4024951519] = 0.1, -- ASSAULT SMG
	[-1074790547] = 0.2, -- ASSAULT RIFLE
	[961495388] = 0.2, -- ASSAULT RIFLE MK2
	[-2084633992] = 0.4, -- CARBINE RIFLE
	[4208062921] = 0.4, -- CARBINE RIFLE MK2
	[-1357824103] = 0.4, -- ADVANCED RIFLE
	[2634544996] = 0.1, -- MG
	[2144741730] = 0.1, -- COMBAT MG
	[3686625920] = 0.1, -- COMBAT MG MK2
	[487013001] = 0.4, -- PUMP SHOTGUN
	[1432025498] = 0.35, -- PUMP SHOTGUN MK2
	[2017895192] = 0.7, -- SAWNOFF SHOTGUN
	[3800352039] = 0.4, -- ASSAULT SHOTGUN
	[2640438543] = 0.2, -- BULLPUP SHOTGUN
	[911657153] = 0.1, -- STUN GUN
	[100416529] = 0.5, -- SNIPER RIFLE
	[205991906] = 0.7, -- HEAVY SNIPER
	[177293209] = 0.6, -- HEAVY SNIPER MK2
	[856002082] = 1.2, -- REMOTE SNIPER
	[2726580491] = 1.0, -- GRENADE LAUNCHER
	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE
	[2982836145] = 0.0, -- RPG
	[1752584910] = 0.0, -- STINGER
	[1119849093] = 0.01, -- MINIGUN
	[3218215474] = 0.2, -- SNS PISTOL
	[1627465347] = 0.1, -- GUSENBERG
	[3231910285] = 0.2, -- SPECIAL CARBINE
	[-1768145561] = 0.15, -- SPECIAL CARBINE MK2
	[3523564046] = 0.5, -- HEAVY PISTOL
	[2132975508] = 0.2, -- BULLPUP RIFLE
	[-2066285827] = 0.15, -- BULLPUP RIFLE MK2
	[137902532] = 0.4, -- VINTAGE PISTOL
	[2828843422] = 0.7, -- MUSKET
	[984333226] = 0.2, -- HEAVY SHOTGUN
	[3342088282] = 0.3, -- MARKSMAN RIFLE
	[1785463520] = 0.25, -- MARKSMAN RIFLE MK2
	[1672152130] = 0, -- HOMING LAUNCHER
	[1198879012] = 0.9, -- FLARE GUN
	[171789620] = 0.2, -- COMBAT PDW
	[3696079510] = 0.9, -- MARKSMAN PISTOL
	[1834241177] = 2.4, -- RAILGUN
	[3675956304] = 0.3, -- MACHINE PISTOL
	[3249783761] = 0.6, -- REVOLVER
	[-879347409] = 0.6, -- REVOLVER MK2
	[-1746263880] = 0.7, -- DOUBLE ACTION SHOTGUN
	[1649403952] = 0.5, -- COMPACT RIFLE
	[317205821] = 0.2, -- AUTO SHOTGUN
	[125959754] = 0.5, -- COMPACT LAUNCHER
	[3173288789] = 0.1, -- MINI SMG		
}



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedShooting(PlayerPedId()) and not IsPedDoingDriveby(PlayerPedId()) then
			local _,wep = GetCurrentPedWeapon(PlayerPedId())
			_,cAmmo = GetAmmoInClip(PlayerPedId(), wep)
			if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0
				if GetFollowPedCamViewMode() ~= 4 then
					TriggerEvent('esx_status:getStatus','stress', function(stress)
						if stress.val < 250000.0 then
							repeat 
								Wait(0)
								p = GetGameplayCamRelativePitch()
								SetGameplayCamRelativePitch(p+0.1, 0.2)
								tv = tv+0.1
							until tv >= recoils[wep]
						elseif stress.val > 250000.0 and stress.val < 450000.0 then
							repeat 
								Wait(0)
								p = GetGameplayCamRelativePitch()
								SetGameplayCamRelativePitch(p+0.4, 0.2)
								tv = tv+0.1
							until tv >= recoils[wep] * 2
						elseif stress.val > 450000.0 and stress.val < 750000.0 then
							repeat 
								Wait(0)
								p = GetGameplayCamRelativePitch()
								SetGameplayCamRelativePitch(p+0.6, 0.2)
								tv = tv+0.1
							until tv >= recoils[wep] * 3
						elseif stress.val > 750000.0 then
							repeat 
								Wait(0)
								p = GetGameplayCamRelativePitch()
								SetGameplayCamRelativePitch(p+0.8, 0.2)
								tv = tv+0.1
							until tv >= recoils[wep] * 4
						end
					end)
					-- repeat 
					-- 	Wait(0)
					-- 	p = GetGameplayCamRelativePitch()
					-- 	print(p)
					-- 	SetGameplayCamRelativePitch(p+0.1, 0.2)
					-- 	print(SetGameplayCamRelativePitch(p+0.1, 0.2))
					-- 	tv = tv+0.1
					-- 	print(tv)
					-- until tv >= recoils[wep]
				else
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						if recoils[wep] > 0.1 then
							SetGameplayCamRelativePitch(p+0.6, 1.2)
							tv = tv+0.6
						else
							SetGameplayCamRelativePitch(p+0.016, 0.333)
							tv = tv+0.1
						end
					until tv >= recoils[wep]
				end
			end
		end
	end
end)
