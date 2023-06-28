Config = Config or {}

-- Make sure to use the correct fetching when switching over to ESX
-- Please note that you have to disable the QBCore fetching in your framework files when switching over to ESX
-- If you're using an up to date server, ESX Legacy when this was created, use the fetching in your fxmanifest.lua, otherwise use the fetching in the unlocked files
Config.Framework = "QBCore" -- "QBCore" / "ESX"
Config.WeaponType = "item" -- "item" / "weapon", whether to remove and give the weapon as an item or as a scrollwheel weapon, most will use item hence why it's default
Config.Target = "qb-target" -- "qb-target" / "ox_target" / nil (nil = no target script)

-- Set to true to enable debug messages, recommended to always keep true since it doesn't spam the console
-- It only gives relevant information such as critical errors
Config.Debug = false