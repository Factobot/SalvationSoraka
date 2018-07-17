-- ### UNREAL SORAKA ###
-- Created by Factobot for Unreal Series --

-- V1.0 released to GoS.

if(GetObjectName(GetMyHero())) ~= "Soraka" then return end

PrintChat("Salvation Soraka by Factobot");

SorakaMenu = Menu("Soraka", "Soraka")

--  [[ AutoUpdate ]]
local version = "1.0"
function AutoUpdate(data)
	
	if tonumber(data) > tonumber(version) then
		PrintChat("<font color='#00ffff'>Current version is outdated"  .. data)
        PrintChat("<font color='#00ffff'>Downloading script update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Factobot/UnrealChampionSeries/master/UnrealSoraka.lua", SCRIPT_PATH .. "UnrealSoraka.lua", function() PrintChat("Update Complete, press F6 2 times") return end)
    else
    	PrintChat("<font color='#00ffff'>No new updates found")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Factobot/UnrealChampionSeries/master/UnrealSoraka.version", AutoUpdate)

SorakaMenu:SubMenu("Combo", "Combo")
SorakaMenu.Combo:Boolean("Q", "Use Q", true)
SorakaMenu.Combo:Boolean("W", "Use W", true)
SorakaMenu.Combo:Boolean("E", "Use E", true)
SorakaMenu.Combo:Boolean("R", "Use R", true)

SorakaMenu:SubMenu("Harass", "Harass")
SorakaMenu.Harass:Boolean("Q", "Use Q", true)
SorakaMenu.Harass:Boolean("E", "Use E", true)

SorakaMenu:SubMenu("Healing", "Healing")
SorakaMenu.Healing:Boolean("W", "Auto W", true)
SorakaMenu.Healing:Slider("HealW", "W Heal At %", 70, 1, 100, 1)
SorakaMenu.Healing:Info("Sep", "")
SorakaMenu.Healing:Boolean("R", "Auto R", true)
SorakaMenu.Healing:Slider("HealR", "R Heal At %", 20, 1, 100, 1)

SorakaMenu:SubMenu("AutoPot", "Auto Pot")
SorakaMenu.AutoPot:Boolean("AutoRed", "Use Red Potion", true)
SorakaMenu.AutoPot:Slider("PotRedPro", "Use At %", 50, 1, 100, 1)
SorakaMenu.AutoPot:Info("Sep", "")
SorakaMenu.AutoPot:Boolean("AutoBlue", "Use Blue Potion", true)
SorakaMenu.AutoPot:Slider("PotBluePro", "Use At %", 50, 1, 100, 1)

SorakaMenu:SubMenu("Items", "Item Usage")
SorakaMenu.Items:Boolean("Redemption", "Use Redemption", true)
SorakaMenu.Items:Slider("HealRedemption", "Use At %", 30, 1, 100, 1)
 


SorakaMenu:SubMenu("Misc", "Misc")
SorakaMenu.Misc:Boolean("Autolvl", "Auto Level Spells", true)

global_ticks = 0
currentTicks = GetTickCount()

function GetAllyHeroesAndMe()
	_ah = GetAllyHeroes()
    table.insert(_ah, myHero)
    return _ah
end

OnTick(function(myHero)

local target = GetCurrentTarget()
local myHero = GetMyHero()
local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1600,0,GetCastRange(myHero, _Q),50,false,true);    
local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1750,500,GetCastRange(myHero, _E),300,false,true);


--Combo
    if IOW:Mode() == "Combo" then
	
		
			if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(target, GetCastRange(myHero, _Q)) and SorakaMenu.Combo.Q:Value() then
                CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z);
            end
		
            if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and ValidTarget(target, GetCastRange(myHero, _E)) and SorakaMenu.Combo.E:Value() then
                CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z);
            end
			
			
			if SorakaMenu.Combo.W:Value() then
				for _, ally in pairs(GetAllyHeroes()) do
                    if (100 * GetCurrentHP(ally)/GetMaxHP(ally)) < SorakaMenu.Healing.HealW:Value() and
                        CanUseSpell(myHero, _W) == READY and IsInDistance(ally, 600) then
                            CastTargetSpell(ally, _W);
                        end
                    end
                end
                
			if SorakaMenu.Combo.R:Value() then
                for _, ally in pairs(GetAllyHeroes()) do
                        if(100 * GetCurrentHP(ally)/GetMaxHP(ally)) < SorakaMenu.Healing.HealR:Value() and
                            CanUseSpell(myHero, _R) == READY and IsObjectAlive(ally) then
                                CastSpell(_R);
                            end
                        end
                end
        end
        

--Harass		
	if IOW:Mode() == "Harass" then
			
                if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(target, GetCastRange(myHero, _Q)) and SorakaMenu.Harass.Q:Value() then
                    CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
                end
			
                if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and ValidTarget(target, GetCastRange(myHero, _E)) and SorakaMenu.Harass.E:Value() then
                    CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
                end
			end
	
		
--Healing
			if SorakaMenu.Healing.W:Value() then
				for _, ally in pairs(GetAllyHeroes()) do
						if (100 * GetCurrentHP(ally))/GetMaxHP(ally) <  SorakaMenu.Healing.HealW:Value() and
							CanUseSpell(myHero, _W) == READY and IsInDistance(ally, 600) then
								CastTargetSpell(ally, _W)
                        end
                    end
                end
			if SorakaMenu.Healing.R:Value() then
				for _, ally in pairs(GetAllyHeroes()) do
						if (100 * GetCurrentHP(ally)/GetMaxHP(ally)) < SorakaMenu.Healing.HealR:Value() and
							CanUseSpell(myHero, _R) == READY and IsObjectAlive(ally) then
								CastSpell(_R);
                        end
                    end
				end
				
		
		

--Item
            if SorakaMenu.Items.Redemption:Value() then
                for _, ally in pairs(GetAllyHeroesAndMe()) do
                        if (100 * GetCurrentHP(ally)/GetMaxHP(ally)) < SorakaMenu.Items.HealRedemption:Value() and
                            IsObjectAlive(ally) and
                            CanUseSpell(myHero, GetItemSlot(myHero, 3107)) == READY and IsInDistance(ally, 5500) then
                                CastSkillShot(GetItemSlot(myHero, 3107), GetOrigin(ally))
                        end
                    end
                end
--Potting
			if SorakaMenu.AutoPot.AutoRed:Value() then
				if (global_ticks + 15000) < currentTicks then
				local potionslot = GetItemSlot(myHero, 2003)
					if potionslot > 0 then
						if 100 * GetCurrentHP(myHero) / GetMaxHP(myHero) < SorakaMenu.AutoPot.PotRedPro:Value() then
						global_ticks = currentTicks
						CastSpell(GetItemSlot(myHero, 2003))
						end
					end
				end
			end
			
			if SorakaMenu.AutoPot.AutoBlue:Value() then
				if (global_ticks + 15000) < currentTicks then
				local potionslot = GetItemSlot(myHero, 2004)
					if potionslot > 0 then
						if 100 * GetCurrentMana(myHero) / GetMaxMana(myHero) < SorakaMenu.AutoPot.PotBluePro:Value() then
						global_ticks = currentTicks
						CastSpell(GetItemSlot(myHero, 2004))
						end
					end
				end
			end
			
			
--AutoLevel
			if SorakaMenu.Misc.Autolvl:Value() then
				if GetLevel(myHero) >= 1 and GetLevel(myHero) < 2 then
				LevelSpell(_Q)
				elseif GetLevel(myHero) >= 2 and GetLevel(myHero) < 3 then
				LevelSpell(_W)
				elseif GetLevel(myHero) >= 3 and GetLevel(myHero) < 4 then
				LevelSpell(_Q)
				elseif GetLevel(myHero) >= 4 and GetLevel(myHero) < 5 then
				LevelSpell(_E)
				elseif GetLevel(myHero) >= 5 and GetLevel(myHero) < 6 then
				LevelSpell(_Q)
				elseif GetLevel(myHero) >= 6 and GetLevel(myHero) < 7 then
				LevelSpell(_R)
				elseif GetLevel(myHero) >= 7 and GetLevel(myHero) < 8 then
				LevelSpell(_Q)
				elseif GetLevel(myHero) >= 8 and GetLevel(myHero) < 9 then
				LevelSpell(_W)
				elseif GetLevel(myHero) >= 9 and GetLevel(myHero) < 10 then
				LevelSpell(_Q)
				elseif GetLevel(myHero) >= 10 and GetLevel(myHero) < 11 then
				LevelSpell(_W)
				elseif GetLevel(myHero) >= 11 and GetLevel(myHero) < 12 then
				LevelSpell(_R)
				elseif GetLevel(myHero) >= 12 and GetLevel(myHero) < 13 then
				LevelSpell(_W)
				elseif GetLevel(myHero) >= 13 and GetLevel(myHero) < 14 then
				LevelSpell(_E)
				elseif GetLevel(myHero) >= 14 and GetLevel(myHero) < 15 then
				LevelSpell(_W)
				elseif GetLevel(myHero) >= 15 and GetLevel(myHero) < 16 then
				LevelSpell(_E)
				elseif GetLevel(myHero) >= 16 and GetLevel(myHero) < 17 then
				LevelSpell(_R)
				elseif GetLevel(myHero) >= 17 and GetLevel(myHero) < 18 then
				LevelSpell(_E)
				elseif GetLevel(myHero) == 18 then
				LevelSpell(_E)
				end
			end
    end)    
