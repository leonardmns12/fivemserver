# fxserver-esx_drugs
FXserver ESX Drugs

[REQUIREMENTS]

  * esx_policejob => https://github.com/FXServer-ESX/fxserver-esx_policejob


  [UPDATE]
  to install opium :
```
INSERT INTO `items` (name, label) VALUES
	('opium', 'Opium'),
	('opium_pooch', 'Pochon de opium')
;
```
  
  [INSTALLATION]

1) CD in your resources/[esx] folder
2) Clone the repository
```
git clone https://github.com/FXServer-ESX/fxserver-esx_drugs esx_drugs
```
3) * Import esx_drugs.sql in your database

4) Add this in your server.cfg :

```
start esx_drugs
```

[FEATURES]
* Use weed
* Cops can't see or interact with the drugs zones
* In the config.lua change the Config.RequiredCop to block the drugs zone in function of the cops count conected

          
-------------------------------Madhatter23412------------

The Above is the regular README.
 
 Install 
 1) unzip and move esx_drugs to your esx folder
 2) take the esx_drugs.sql and import it into your ITEM table in your DB
 3) add esx_drugs to your server.cfg.
 
 
 The locations are spread through out Blaine County and do not go into the City. You can by all means change the Locations and the Blips. 
 To Disable Blips just Delete the Config Blips in the config.lua 
 If you want to change locations you can in the config.lua 
 To change Blips just change the ID number in the config.lua in the Config Blips. 
 Blips
 B? Moonshine/BootLeg
 M? Meth
 O? Opium
 C? Coke
 D? Weed/dope
 
 
