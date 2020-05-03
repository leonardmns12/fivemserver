#bankrobbery v2

Advanced bank robbery script for small banks and big bank made by mihq.

Mhacking: https://github.com/GHMatti/FiveM-Scripts/tree/master/mhacking

Mythic-progressbar: https://github.com/mythicrp/mythic_progbar

You need to make a place to buy the raspberry, blowtorch and lockpick (Using an already existing script is the easiest way to do this).
If you use esx_shops, place this in config:
```elixir
LesterTools = {
  ShowBlip = true,
  BlipID = 77,
  BlipColor = 6,
  BlipName = "Illegal Tools",
  Items = {},
  Pos = {
    {x = 1269.04,   y = -1710.05, z = 54.77},
  }
 },
```
SQL insert when using esx_shops would then look something like:

```elixir
INSERT INTO `shops`(`id`, `store`, `item`, `price`) VALUES
('100', 'LesterTools', 'raspberry', '3000'),
('101', 'LesterTools', 'blowtorch', '4000'),
('102', 'LesterTools', 'lockpick', '3000');
```
