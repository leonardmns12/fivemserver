Config = {}
Config.Locale = 'en'
Config.Cops = 3
Config.HeistCooldown = 900               -- Bank lockdown after robbery in seconds
Config.dyeTime = 900                        -- Time from bank to dye pack deactivation in seconds
Config.itemsPct = 20                      -- This is percent the script will add items
Config.itemsMax = 2                       -- This is the max number of items you can receive
Config.cardTime = {100,240,420,600,780}   -- Keycard time in seconds, (gold,black,red,green,blue)
Config.dyeChance = {90,70,50,30,10}       -- Chance for dye explosion in %, (gold,black,red,green,blue)
Config.deskItems = {
  'water',
  'cocacola',
  'lighter',
	'cigarette',
  'keycard_green',
  'keycard_blue',
  'keycard_red',
  'keycard_black',
  'keycard_gold',
}

Config.vaultItems = {
  'jewels',
  'whisky',
}

location = {
  {x = 1223.75, y = -489.83, z = 66.41, h = 305.0},
  {x = -1661.58, y = -1001.07, z = 7.37, h = 150.0},
  {x = 181.15, y = -1515.52, z = 29.14, h = 340.0},
  {x = 1534.80, y = 2224.74, z = 77.7, h = 10.0},
  {x = 1899.84, y = 4925.08, z = 48.81, h = 230.0},
  {x = -1129.3, y = 2692.72, z = 18.8, h = 50.0},
}

BankHeists = {
	["fleeca1"] = {
    ["Bank_Vault"] = {
      ["model"] = 2121050683, ["x"] = 148.025, ["y"] = -1044.364, ["z"] = 29.50693, ["hStart"] = 249.846, ["hEnd"] = -183.599
    },
    ["Desk_Door"] = {
      ["model"] = -131754413, ["x"] = 145.55, ["y"] = -1040.76, ["z"] = 29.37, ["hStart"] = 249.846, ["hEnd"] = -205.599
    },
		["Hack_Pos"] = { ["x"] = 147.00, ["y"] = -1046.16, ["z"] = 29.37 },
    cashPickup = { x = 0, y = 0, z = 0, h = 0 },
    vault = {
      { x = 149.13, y = -1044.89, z = 29.35, h = 339.94 },
      { x = 150.32, y = -1045.42, z = 29.35, h = 339.94 },

      { x = 150.54, y = -1049.27, z = 29.35, h = 246.55 },
      { x = 150.13, y = -1050.48, z = 29.35, h = 246.55 },

      { x = 149.39, y = -1050.9, z = 29.35, h = 160.36 },
      { x = 148.25, y = -1050.56, z = 29.35, h = 160.36 },
      { x = 147.15, y = -1050.1, z = 29.35, h = 160.36 },

      { x = 146.88, y = -1049.18, z = 29.35, h = 69.83 },
      { x = 147.33, y = -1048.01, z = 29.35, h = 69.83 },
    },
		["reward"] = math.random(3500,4500),
		["bankName"] = "The Fleeca Bank (Downtown)",
	},

	["fleeca2"] = {
    ["Bank_Vault"] = {
      ["model"] = -63539571, ["x"] = -2958.539, ["y"] = 482.2706, ["z"] = 15.835, ["hStart"] = -2.5, ["hEnd"] = -79.5
    },
    ["Desk_Door"] = {
      ["model"] = -131754413, ["x"] = -2961.15, ["y"] = 478.71, ["z"] = 15.7, ["hStart"] = -2.5, ["hEnd"] = -95.5
    },
		["Hack_Pos"] = { ["x"] = -2956.57, ["y"] = 481.70, ["z"] = 15.70 },
    cashPickup = { x = 0, y = 0, z = 0, h = 0},
    vault = {
      { x = -2958.38, y = 483.54, z = 15.68, h = 92.6},
      { x = -2958.38, y = 484.67, z = 15.68, h = 92.6},

      { x = -2954.63, y = 486.16, z = 15.68, h = 8.4},
      { x = -2953.44, y = 486.16, z = 15.68, h = 8.4},

      { x = -2952.65, y = 485.26, z = 15.68, h = 268.77},
      { x = -2952.69, y = 484.41, z = 15.68, h = 268.77},
      { x = -2952.72, y = 483.36, z = 15.68, h = 268.77},

      { x = -2953.65, y = 482.59, z = 15.68, h = 180.85},
      { x = -2954.72, y = 482.59, z = 15.68, h = 180.85},
    },
		["reward"] = math.random(2000,3000),
		["bankName"] = "The Fleeca Bank (Highway)",
	},

  ["fleeca3"] = {
    ["Bank_Vault"] = {
      ["model"] = 2121050683, ["x"] = 1175.87, ["y"] = 2711.96, ["z"] = 38.09, ["hStart"] = -270.0, ["hEnd"] = 15.0
    },
    ["Desk_Door"] = {
      ["model"] = -131754413, ["x"] = 1179.28, ["y"] = 2708.41, ["z"] = 38.09, ["hStart"] = -270.0, ["hEnd"] = -5.0
    },
	  ["Hack_Pos"] = { ["x"] = 1175.95, ["y"] = 2712.88, ["z"] = 38.09 },
    cashPickup = { x = 0, y = 0, z = 0, h = 0},
    vault = {
      { x = 1174.34, y = 2710.94, z = 38.07, h = 181.56},
      { x = 1173.12, y = 2710.94, z = 38.07, h = 181.56},

      { x = 1171.43, y = 2714.62, z = 38.07, h = 95.00},
      { x = 1171.40, y = 2715.67, z = 38.07, h = 95.00},

      { x = 1172.31, y = 2716.62, z = 38.07, h = 2.00},
      { x = 1173.27, y = 2716.66, z = 38.07, h = 2.00},
      { x = 1174.39, y = 2716.64, z = 38.07, h = 2.00},

      { x = 1175.07, y = 2715.76, z = 38.07, h = 272.37},
      { x = 1175.07, y = 2714.61, z = 38.07, h = 272.37},
    },
		["reward"] = math.random(2000,3000),
		["bankName"] = "The Fleeca Bank (Senora Desert)",
	},

	["blaineCounty"] = {
    ["Bank_Vault"] = {
      ["model"] = -1185205679, ["x"] = -104.09, ["y"] = 6472.58, ["z"] = 31.63, ["hStart"] = 45.5, ["hEnd"] = 150.599
    },
    ["Desk_Door"] = {
      ["model"] = -1184592117, ["x"] = -109.23, ["y"] = 6468.05, ["z"] = 31.63, ["hStart"] = 45.5, ["hEnd"] = -49.5
    },
		["Hack_Pos"] = { ["x"] = -105.49, ["y"] = 6471.79, ["z"] = 31.63 },
    cashPickup = { x =  0, y = 0, z = 0, h = 0 },
    vault = { x = 1, y = 1, z = 1, h = 160.3 },
		["reward"] = math.random(3000,3000),
		["bankName"] = "The Blaine County Savings",
	},
	["PrincipalBank"] = {
    ["Bank_Vault"] = {
      ["model"] = 961976194, ["x"] = 255.2283, ["y"] = 223.976, ["z"] = 102.3932, ["hStart"] = 160.0, ["hEnd"] = -7.0
    },
    ["Desk_Door"] = {
      --["model"] = 964838196, ["x"] = 261.89, ["y"] = 213.97, ["z"] = 110.28, ["hStart"] = -290.0, ["hEnd"] = 180.6,
      --["model"] = 964838196, ["x"] = 260.25, ["y"] = 209.36, ["z"] = 110.28, ["hStart"] = -290.0, ["hEnd"] = 180.6,
      --["model"] = 1956494919, ["x"] = 265.32, ["y"] = 218.22, ["z"] = 110.28, ["hStart"] = 340.0, ["hEnd"] = 60.0,
      --door = (GetOffsetFromEntityInWorldCoords(fcDoor, -1.2, 0.8, 0.0))
      ["model"] = -222270721, ["x"] = 257.31, ["y"] = 219.97, ["z"] = 106.29, ["hStart"] = 340.0, ["hEnd"] = 85.6,
    },
		--["Hack_Pos"] = { ["x"] = 261.9, ["y"] = 223.13, ["z"] = 106.28 },
    ["Hack_Pos"] = { ["x"] = 253.08, ["y"] = 228.45, ["z"] = 101.68 },
    cashPickup = {
      { x =  262.95, y = 215.97, z = 101.68, h = 50.0 },
      { x =  262.39, y = 212.74, z = 101.68, h = 50.0 },
    },
    vault = {
      { x = 258.32, y = 218.34, z = 101.68, h = 340.56 },
      { x = 259.49, y = 217.87, z = 101.68, h = 340.56 },
      { x = 260.65, y = 217.46, z = 101.68, h = 340.56 },
	
      { x = 259.44, y = 213.90, z = 101.68, h = 161.3 },
      { x = 258.34, y = 214.33, z = 101.68, h = 161.3 },
      { x = 257.1, y = 214.73, z = 101.68, h = 161.3 },
    },
  	["reward"] = math.random(3000,4000),
		["bankName"] = "The Principal Bank",
  },
}
