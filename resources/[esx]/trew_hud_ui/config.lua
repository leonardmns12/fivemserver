Config = {}

Config.Locale = 'en'

Config.serverLogo = 'https://i.imgur.com/aWEfis3.png'

Config.font = {
	name 	= 'Montserrat',
	url 	= 'https://fonts.googleapis.com/css?family=Montserrat:300,400,700,900&display=swap'
}

Config.date = {
	format	 	= 'default',
	AmPm		= false
}

Config.voice = {

	levels = {
		default = 10.0,
		shout = 70.0,
		whisper = 1.0,
		current = 0
	},
	
	keys = {
		distance 	= 'Z',
	}
}


Config.vehicle = {
	speedUnit = 'KMH',
	maxSpeed = 500,

	keys = {
		seatbelt 	= 'B',
		cruiser		= 'X',
		signalLeft	= 'LEFT',
		signalRight	= 'RIGHT',
		signalBoth	= 'DOWN',
	}
}

Config.ui = {
	showServerLogo		= true,

	showJob		 		= true,

	showWalletMoney 	= true,
	showBankMoney 		= true,
	showBlackMoney 		= true,
	showSocietyMoney	= true,

	showDate 			= false,
	showLocation 		= true,
	showVoice	 		= true,

	showHealth			= false,
	showArmor	 		= false,
	showStamina	 		= false,
	showHunger 			= false,
	showThirst	 		= false,

	showMinimap			= false,

	showWeapons			= true,	
}