Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(706414369520484443)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('logo_name')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('[IndoFolks Roleplay]')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('logo_small')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('Verified')
        SetRichPresence('AyamGeprek()')
        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)