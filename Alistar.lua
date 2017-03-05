local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Alistar" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Alistar/master/Alistar.lua', SCRIPT_PATH .. 'Alistar.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Alistar/master/Alistar.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local AlistarMenu = Menu("Alistar", "Alistar")

AlistarMenu:SubMenu("Combo", "Combo")

AlistarMenu.Combo:Boolean("Q", "Use Q in combo", true)
AlistarMenu.Combo:Boolean("W", "Use W in combo", true)
AlistarMenu.Combo:Boolean("E", "Use E in combo", true)
AlistarMenu.Combo:Boolean("R", "Use R in combo", true)
AlistarMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
AlistarMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
AlistarMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
AlistarMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
AlistarMenu.Combo:Boolean("RHydra", "Use RHydra", true)
AlistarMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
AlistarMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
AlistarMenu.Combo:Boolean("Randuins", "Use Randuins", true)


AlistarMenu:SubMenu("AutoMode", "AutoMode")
AlistarMenu.AutoMode:Boolean("Level", "Auto level spells", false)
AlistarMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
AlistarMenu.AutoMode:Boolean("Q", "Auto Q", false)
AlistarMenu.AutoMode:Boolean("W", "Auto W", false)
AlistarMenu.AutoMode:Boolean("E", "Auto E", false)
AlistarMenu.AutoMode:Boolean("R", "Auto R", false)

AlistarMenu:SubMenu("LaneClear", "LaneClear")
AlistarMenu.LaneClear:Boolean("Q", "Use Q", true)
AlistarMenu.LaneClear:Boolean("W", "Use W", true)
AlistarMenu.LaneClear:Boolean("E", "Use E", true)
AlistarMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
AlistarMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

AlistarMenu:SubMenu("Harass", "Harass")
AlistarMenu.Harass:Boolean("Q", "Use Q", true)
AlistarMenu.Harass:Boolean("W", "Use W", true)

AlistarMenu:SubMenu("KillSteal", "KillSteal")
AlistarMenu.KillSteal:Boolean("Q", "KS w Q", true)
AlistarMenu.KillSteal:Boolean("E", "KS w E", true)

AlistarMenu:SubMenu("AutoIgnite", "AutoIgnite")
AlistarMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

AlistarMenu:SubMenu("Drawings", "Drawings")
AlistarMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

AlistarMenu:SubMenu("SkinChanger", "SkinChanger")
AlistarMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
AlistarMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if AlistarMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if AlistarMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 365) then
				if target ~= nil then 
                                      CastSpell(_Q)
                                end
            end

            if AlistarMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 650) then
				CastTargetSpell(target, _W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if AlistarMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if AlistarMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if AlistarMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if AlistarMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if AlistarMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 300) then
			 CastSpell(_E)
	    end

            if AlistarMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 365) then
		     if target ~= nil then 
                         CastSpell(_Q)
                     end
            end

            if AlistarMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if AlistarMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if AlistarMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if AlistarMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 650) then
			CastTargetSpell(target, _W)
	    end
	    
	    
            if AlistarMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 650) and (EnemiesAround(myHeroPos(), 650) >= AlistarMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and AlistarMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSpell(_Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and AlistarMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if AlistarMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 365) then
	        	CastSpell(_Q)
                end

                if AlistarMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 650) then
	        	CastTargetSpell(target, _W)
	        end

                if AlistarMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 300) then
	        	CastSpell(_E)
	        end

                if AlistarMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if AlistarMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if AlistarMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 365) then
		      CastSpell(target, _Q)
          end
        end 
        if AlistarMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 650) then
	  	      CastTargetSpell(target, _W)
          end
        end
        if AlistarMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 300) then
		      CastSpell(_E)
	  end
        end
        if AlistarMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 650) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if AlistarMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if AlistarMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 365, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
              

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if AlistarMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Alistar</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





