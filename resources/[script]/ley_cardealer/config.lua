-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

-- 100% Working Version Leaked By FivemLeak.com  --

Config 						= {}
Config.Locale 				= 'en'

-- [[ SHOP MENU ]] --
Config.ShopMenu = {{
	Pos = {-56.79,-1096.93,-1.42},
	Key = 38,
	Marker = {
		Enable = true,
		DrawDist = 10.0,
		Type = 27,
		Scale = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 240, g = 52, b = 52, a = 100},
	},
	
}}

Config.SellPercent = 50					-- Set commission taken by shop, when player sells a vehicle
Config.ReceiveBankMoney = true			-- Set this to false, in order to receive money in hand when selling a vehicle to PDM
Config.CarInsuranceScript = false		-- Set to false if you don't own this script
Config.BuyVehWhenNoDealers = false		-- Set to true to enable players being able to buy vehicles through shop menu, when no dealer online

-- [[ BOSS MENU ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.BossMenu = {{
	Pos = {-32.29,-1106.56,26.42},						
	Key = 38,													-- Control Key to open Boss Menu
	Marker = {
		Enable = true,											-- Enable/Disable Draw Marker
		DrawDist = 7.0,											-- Draw Marker Draw Distance
		Type = 27,												-- Draw Marker Type
		Scale = {x = 1.0, y = 1.0, z = 1.0},					-- Draw Marker Scale Settings
		Color = {r = 240, g = 52, b = 52, a = 100}				-- Draw Marker Color Settings
	},
}}
Config.BossGrade = 3											-- Set boss grade here
Config.UseCashMoney = true										-- Set to false to use bank money, when depositing/withdrawing money from dealer society account

-- [[ GENERAL SETTINGS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.DealerPos 			= {-45.25,-1098.05,26.42}			-- Center Pos of the dealer, only change if you move all locations to another custom dealer
Config.DrawTxtDist 			= 3.0								-- Distance to see draw text on display vehicles
Config.VehLoadDistance 		= 20.0								-- Distance from player coords to DealerPos, before display features are loaded. Don't set below 40.0, unless u move cardealer.
Config.CarDealerJobLabel 	= "cardealer"						-- Car Dealer Job Label from Database under table jobs
Config.BoughtVehSpawn 		= {-19.29,-1103.96,26.67}			-- Spawn Position of successfully purchased vehicle
Config.PayWithCash 			= true								-- Purchase vehicles with bank money, set to true to purchase vehicle with cash instead.
Config.MinCommission		= (-30)
Config.MaxCommission		= 50
Config.WarpPlayerIntoVeh	= true								-- Set to true if player should be warped into purchased vehicle
Config.WarpPlyIntoTestVeh 	= true								-- Set to true if player should be warped into test drive vehicle

Config.OwnedVehTable		= 'owned_vehicles'					-- change this if you name your owned_vehicles table something else. Make sure to change all entries in server.lua, as this only changes for the protection.lua

Config.PurchasedVehSpawn = {{									-- Position & heading for purchased vehicle. 
	Pos = {-19.29,-1103.96,26.67},
	H = 333.28,
}}

Config.BigVehSpawn = {{											-- Position & heading for purchased big vehicles. 
	Pos = {-19.29,-1103.96,26.67},
	H = 159.51,
}}

Config.TestReturn = {{
	SmallPos = {-31.7,-1090.72,26.42},
	BigPos = {-19.29,-1103.96,26.67},
	Key = 38,
	DrawText = 4.0,
	Marker = {
		Enable = true,											-- Enable/Disable Draw Marker
		DrawDist = 7.0,											-- Draw Marker Draw Distance
		Type = 27,												-- Draw Marker Type
		Scale = {x = 3.0, y = 3.0, z = 3.0},					-- Draw Marker Scale Settings
		Color = {r = 240, g = 52, b = 52, a = 100}				-- Draw Marker Color Settings
	},
}}

-- [[ DISPLAY CARS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.DisplayCars = {
	[1] = { Pos = {-48.28,-1101.53,26.42}, Heading = 131.5 }, 	-- This is: Compacts // DO NOT TOUCH 
	[2] = { Pos = {-45.63,-1102.99,26.42}, Heading = 115.17 }, 	-- This is: MCs // DO NOT TOUCH  
	[3] = { Pos = {-51.04,-1096.61,26.42}, Heading = 221.4 },	-- All other categories
	[4] = { Pos = {-47.01,-1094.78,26.42}, Heading = 187.32 },	-- All other categories
	[5] = { Pos = {-42.68,-1095.61,26.42}, Heading = 166.75 },	-- All other categories
	[6] = { Pos = {-39.31,-1097.04,26.42}, Heading = 148.9 },	-- All other categories
	[7] = { Pos = {-36.05,-1099.32,26.42}, Heading = 145.77 },	-- This is: SUVs // DO NOT TOUCH 
	[8] = { Pos = {-40.70,-1105.49,26.42}, Heading = 193.93 }, 	-- This is: Bicycle // DO NOT TOUCH 
	[9] = { Pos = {-11.90,-1103.13,26.67}, Heading = 159.94 }, 	-- This is: Utility, Vans & Off Road // DO NOT TOUCH
}

-- [[ DISPLAY KEYS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.KeyToBuyVeh 			= 38	-- E 			: Key to buy vehicle from display
Config.KeyToConfirmBuyVeh 	= 38	-- E 			: Key to confirm vehicle purchase from display
Config.KeyToCancelBuyVeh 	= 202	-- Backspace 	: Key to cancel vehicle purchase from display

Config.KeyToSwapVehicle		= 47	-- G			: Key to replace display vehicle 
Config.KeyToTestVehicle		= 74	-- H			: Key to test drive display vehicle 

Config.KeyToChangeCom1		= 174	-- LEFT ARROW	: Key to change commission (-1) per click
Config.KeyToChangeCom2		= 175	-- RIGHT ARROW	: Key to change commission (+1) per click

Config.KeyToFinanceVeh 		= 999	-- K			: Key to finance vehicle from display
Config.KeyToConfirmFinance 	= 999	-- K 			: Key to confirm vehicle finance from display
Config.KeyToCancelFinance 	= 202	-- Backspace 	: Key to cancel vehicle finance from display

Config.KeyToChangeDownPay1	= 173	-- DOWN ARROW	: Key to change downpayment (-1) per click
Config.KeyToChangeDownPay2	= 172	-- UP ARROW		: Key to change downpayment (+1) per click


-- [[ VEHICLE FINANCING ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.InterestRate 			= 5			-- set an interest rate in % that will be added to vehicle price upon financing
Config.MinDownpayment 			= 10		-- set minimum allowed downpayment that car seller can go down to in %
Config.MaxDownpayment 			= 90		-- set maximum allowed downpayment that car seller can go down to in %
Config.MaxTimePerRepay 			= 30		-- set max time before a repay in hours
Config.AmountOfRepayments 		= 10		-- set amount of repayments in total, where (carPrice-downPayment)/10 will be minimum repay amount
Config.DownPaymentToDealerShip 	= false		-- set to true if dealer account should receive downpayments
Config.WarningTime				= 10		-- Warning Time on player login, if repayments are not paid, before vehicles that are not paid are deleted. Set this in minutes.
Config.PayWithBankMoney 		= true		-- set to false in order to pay repayments with cash money on player

-- [[ REGISTRATION PAPER ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.KeyToHidePaper	= 177			-- set key control to hide registration paper, when it's opened

-- [[ PLATE SETTINGS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.PlateNumbers  = 3
Config.PlateLetters  = 3
Config.PlateNumlast  = 0
Config.PlateUseSpace = true

-- [[ BLIP SETTINSG ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.Blip = {{
	Enable 	= true,
	Pos 	= {-45.25,-1098.05,26.42},
	Sprite 	= 523, Color = 3,
	Name 	= "Araç Galerisi",
	Scale 	= 0.8,
	Display = 4,
}}
