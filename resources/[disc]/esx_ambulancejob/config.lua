Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 2, y = 2, z = 2, r = 102, g = 0, b = 102, rotate = true } -- pillbox

Config.ReviveReward               = 5000  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 10 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 30 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 3000

Config.RespawnPoint = { coords = vector3(320.052, -593.575, 43.292), heading = 93.42} -- pillbox

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3( 293.6696472168,-583.04443359375,43.189838409424), --pillbox
			sprite = 61,
			scale  = 1.0,
			color  = 2
		},

		AmbulanceActions = {
			vector3(301.41, -599.65, 43.28)
		},

		Pharmacies = {
			vector3(306.87954711914,-601.4384765625,43.284030914307) --pillbox
			
		},

		Vehicles = {
			{
				Spawner = vector3(297.12,-587.512,43.261), --pillbox
				InsideShop = vector3(289.532,-584.539, 42.832), --pillbox
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = { -- all pillbox
					{ coords = vector3(292.516,-609.973,43.042), heading = 68.186, radius = 4.0 }, 
					{ coords = vector3(287.627,-589.442,42.813), heading = 342.019, radius = 4.0 },
					{ coords = vector3(291.625,-571.292, 42.853), heading = 69.296, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(339.82034301758,-589.16693115234,74.165573120117),
				InsideShop = vector3(351.32543945313,-587.58630371094,74.165557861328),
				Marker = {type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true},
				SpawnPoints = {
					{coords = vector3(351.32543945313,-587.58630371094,74.165557861328), heading = 142.7, radius = 10.0},
					{coords = vector3(351.32543945313,-587.58630371094,74.165557861328), heading = 142.7, radius = 10.0}
				}
			}
		},

		FastTravels = {
			-- {
			-- 	From = vector3(0 , 0, 0),
			-- 	To = {coords = vector3(0 , 0, 0), heading = 0.0},
			-- 	Marker = {type = 21, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(0 , 0, 0),
			-- 	To = {coords = vector3(0 , 0, 0), heading = 0.0},
			-- 	Marker = {type = 21, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(0 , 0, 0),
			-- 	To = {coords = vector3(0 , 0, 0), heading = 138.6},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(0 , 0, 0),
			-- 	To = {coords = vector3(0 , 0, 0), heading = 0.0},
			-- 	Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(0 , 0, 0),
			-- 	To = {coords = vector3(0 , 0, 0), heading = 0.0},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(0 , 0, 0),
			-- 	To = {coords = vector3(0 , 0, 0), heading = 0.0},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- }
		},

		FastTravelsPrompt = {
			{
				From = vector3(327.12875366211,-603.37957763672,42.284034729004),
				To = {coords = vector3(341.5446472168,-584.98382568359,74.165557861328), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(338.77 , -583.84, 73.30),
				To = {coords = vector3(327.12875366211,-603.37957763672,43.284034729004), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			}
		}

	}
}
Config.AuthorizedVehicles = {

    ambulance = {
		{ model = 'dodgesamu', label = 'Ambulance', price = 20000 }
    },

	doctor = {
		{ model = 'dodgesamu', label = 'Ambulance', price = 20000 }
	},

	chief_doctor = {
		{ model = 'dodgesamu', label = 'Ambulance', price = 20000 }
	},

	boss = {
		{ model = 'dodgesamu', label = 'Ambulance', price = 20000 }
	},

}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doctor = {
		{
			model = 'buzzard2',
			label = 'Nagasaki Buzzard',
			price = 150000
		}
	},

	chief_doctor = {
		{
			model = 'buzzard2',
			label = 'Nagasaki Buzzard',
			price = 150000
		},

		{
			model = 'seasparrow',
			label = 'Sea Sparrow',
			price = 300000
		}
	},

	boss = {
		{
			model = 'buzzard2',
			label = 'Nagasaki Buzzard',
			price = 100000
		},

		{
			model = 'seasparrow',
			label = 'Sea Sparrow',
			price = 250000
		}
	}

}
