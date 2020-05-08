Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 2, y = 2, z = 2, r = 102, g = 0, b = 102, rotate = true } -- pillbox

Config.ReviveReward               = 15000  -- revive reward, set to 0 if you don't want it enabled
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
Config.EarlyRespawnFineAmount     = 5000

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
			{
				From = vector3(327.12875366211,-603.37957763672,43.284034729004),
				To = {coords = vector3(341.5446472168,-584.98382568359,74.165557861328), heading = 0.0},
				Marker = {type = 21, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(338.50665283203,-583.82525634766,74.165679931641),
				To = {coords = vector3(327.92477416992,-600.81384277344,43.283981323242), heading = 0.0},
				Marker = {type = 21, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = {coords = vector3(333.1, -1434.9, 45.5), heading = 138.6},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = {coords = vector3(249.1, -1369.6, 23.5), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = {coords = vector3(320.9, -1478.6, 28.8), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = {coords = vector3(238.6, -1368.4, 23.5), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(237.4, -1373.8, 26.0),
				To = {coords = vector3(251.9, -1363.3, 38.5), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(256.5, -1357.7, 36.0),
				To = {coords = vector3(235.4, -1372.8, 26.3), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			}
		}

	}
}
Config.AuthorizedVehicles = {

    ambulance = {
		{ model = 'ambulance', label = 'Ambulance', price = 40 },
		{ model = 'ambulance2', label = 'Ambulance 2', price = 40 },
		{ model = 'emscar', label = 'EMS Car', price = 40 },
		{ model = 'emscar2', label = 'Car 2', price = 40 },
		{ model = 'emsvan', label = 'VAN', price = 40 },
		{ model = 'sheriff2', label = 'Raptor', price = 40 },
		{ model = 'emssuv', label = 'SUV', price = 40 }
    },

	doctor = {
		{ model = 'ambulance', label = 'Ambulance', price = 40 },
		{ model = 'ambulance2', label = 'Ambulance 2', price = 40 },
		{ model = 'emscar', label = 'EMS Car', price = 40 },
		{ model = 'emscar2', label = 'Car 2', price = 40 },
		{ model = 'emsvan', label = 'VAN', price = 40 },
		{ model = 'sheriff2', label = 'Raptor', price = 40 },
		{ model = 'emssuv', label = 'SUV', price = 40 }
	},

	chief_doctor = {
		{ model = 'ambulance', label = 'Ambulance', price = 40 },
		{ model = 'ambulance2', label = 'Ambulance 2', price = 40 },
		{ model = 'emscar', label = 'EMS Car', price = 40 },
		{ model = 'emscar2', label = 'Car 2', price = 40 },
		{ model = 'emsvan', label = 'VAN', price = 40 },
		{ model = 'sheriff2', label = 'Raptor', price = 40 },
		{ model = 'emssuv', label = 'SUV', price = 40 }
	},

	boss = {
		{ model = 'ambulance', label = 'Ambulance', price = 40 },
		{ model = 'ambulance2', label = 'Ambulance 2', price = 40 },
		{ model = 'emscar', label = 'EMS Car', price = 40 },
		{ model = 'emscar2', label = 'Car 2', price = 40 },
		{ model = 'emsvan', label = 'VAN', price = 40 },
		{ model = 'sheriff2', label = 'Raptor', price = 40 },
		{ model = 'emssuv', label = 'SUV', price = 40 }
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
