--[[


 /$$$$$$$                                                    /$$$$$$$  /$$$$$$$        /$$   /$$ /$$$$$$$ 
| $$__  $$                                                  | $$__  $$| $$__  $$      | $$  / $$| $$__  $$
| $$  \ $$  /$$$$$$  /$$$$$$/$$$$   /$$$$$$   /$$$$$$$      | $$  \ $$| $$  \ $$      |  $$/ $$/| $$  \ $$
| $$  | $$ /$$__  $$| $$_  $$_  $$ |____  $$ /$$_____/      | $$$$$$$/| $$$$$$$/       \  $$$$/ | $$$$$$$/
| $$  | $$| $$  \ $$| $$ \ $$ \ $$  /$$$$$$$|  $$$$$$       | $$__  $$| $$____/         >$$  $$ | $$____/ 
| $$  | $$| $$  | $$| $$ | $$ | $$ /$$__  $$ \____  $$      | $$  \ $$| $$             /$$/\  $$| $$      
| $$$$$$$/|  $$$$$$/| $$ | $$ | $$|  $$$$$$$ /$$$$$$$/      | $$  | $$| $$            | $$  \ $$| $$      
|_______/  \______/ |__/ |__/ |__/ \_______/|_______/       |__/  |__/|__/            |__/  |__/|__/      
                                                                                                          
                                                                                                          
                                                                                                          
--]]

Config = {}

Config.Debug = false
Config.VersionChecker = true -- Check for latest version
Config.Database = 'oxmysql' -- mysql-async/oxmysql/ghmattimysql
Config.CheckXPType = 'notify' -- chat/notify/print
Config.AutoUpdate = true -- There are listeners pre-coded, but you can secure synced player xp with this
Config.AutoUpdateWait = 120 * 1000 -- How long does it take to re-sync player's XP

--[[


  /$$$$$$                                                                  /$$          
 /$$__  $$                                                                | $$          
| $$  \__/  /$$$$$$  /$$$$$$/$$$$  /$$$$$$/$$$$   /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$$
| $$       /$$__  $$| $$_  $$_  $$| $$_  $$_  $$ |____  $$| $$__  $$ /$$__  $$ /$$_____/
| $$      | $$  \ $$| $$ \ $$ \ $$| $$ \ $$ \ $$  /$$$$$$$| $$  \ $$| $$  | $$|  $$$$$$ 
| $$    $$| $$  | $$| $$ | $$ | $$| $$ | $$ | $$ /$$__  $$| $$  | $$| $$  | $$ \____  $$
|  $$$$$$/|  $$$$$$/| $$ | $$ | $$| $$ | $$ | $$|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/
 \______/  \______/ |__/ |__/ |__/|__/ |__/ |__/ \_______/|__/  |__/ \_______/|_______/ 
                                                                                        
                                                                                        
                                                                                        
--]]


Config.UseXPCheckCommand = true
Config.CheckXPCommand = 'checkxp'
Config.AdminCanCheckOther = true
Config.AdminCheckCommand = 'admincheckxp'

Config.SetXpCommand = 'setxp'
Config.RemoveXpCommand = 'removexp'
Config.AddXpCommand = 'addxp'

--[[


 /$$$$$$$                                /$$                            /$$   /$$ /$$$$$$$ 
| $$__  $$                              |__/                           | $$  / $$| $$__  $$
| $$  \ $$  /$$$$$$   /$$$$$$$  /$$$$$$$ /$$ /$$    /$$  /$$$$$$       |  $$/ $$/| $$  \ $$
| $$$$$$$/ |____  $$ /$$_____/ /$$_____/| $$|  $$  /$$/ /$$__  $$       \  $$$$/ | $$$$$$$/
| $$____/   /$$$$$$$|  $$$$$$ |  $$$$$$ | $$ \  $$/$$/ | $$$$$$$$        >$$  $$ | $$____/ 
| $$       /$$__  $$ \____  $$ \____  $$| $$  \  $$$/  | $$_____/       /$$/\  $$| $$      
| $$      |  $$$$$$$ /$$$$$$$/ /$$$$$$$/| $$   \  $/   |  $$$$$$$      | $$  \ $$| $$      
|__/       \_______/|_______/ |_______/ |__/    \_/     \_______/      |__/  |__/|__/      
                                                                                           
                                                                                           
                                                                                           
--]]

Config.PassiveXP = true -- Add xp just because player is active in the server
Config.PassiveAmount = 10 -- How much xp everytime cooldown finishes
Config.PassiveCooldown = 60 * 1000 -- Every 60 seconds will be added