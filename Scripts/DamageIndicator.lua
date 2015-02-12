--<<Shows how much damage you will deal with your spells+items and how much hits you will need to kill enemy>>
require("libs.ScreenPosition")
require("libs.AbilityDamage")
require("libs.Animations")
require("libs.Utils")
require("libs.ScriptConfig")

--[[
   _                    _
 _( ) DAMAGE INDICATOR ( )_
(_, |      __ __      / ,,_)
   \'\    /  ^  \    /'/
    '\'\,/\      \,/'/'
      '\| []   [] |/'
        (_  /^\  _)
          \  ~  /
          /#####\
        /'/{^^^}\'\
    _,/'/'  ^^^  '\'\,_
   (_, |    BY     | ,_)
     (_)  MOONES   (_)
      
        Description:        
        ------------                                 
		 
		- This script shows how much HP will enemy have after casting all your spells/items.
		- Shows how much hits will you need to kill enemy. 
		- If you kill enemy just from spells/items it will show you which ones you need to use.
		- Supports calculating of EtherealBlade damage amplification, expecting that you will cast EtherealBlade first.
		 
        Changelog:
        ----------
		
		v0.6c - Performance fix, Fix for some heroes
		
		v0.6b - Fixed calculation for Meepo: Poof
		
		v0.5a - Added new textures, fixed for some resolutions
		
		v0.5 - Fixed calculations for many heroes
		
		v0.1 - BETA Release
		
]]--

--Preparation for calculating position/size difference between resolutions
local sPos
if math.floor(client.screenRatio*100) == 133 then
	sPos = ScreenPosition.new(1024, 768, client.screenRatio)
elseif math.floor(client.screenRatio*100) == 166 then
	sPos = ScreenPosition.new(1280, 768, client.screenRatio)
elseif math.floor(client.screenRatio*100) == 177 then
	sPos = ScreenPosition.new(1600, 900, client.screenRatio)
elseif math.floor(client.screenRatio*100) == 160 then
	sPos = ScreenPosition.new(1280, 800, client.screenRatio)
elseif math.floor(client.screenRatio*100) == 125 then
	sPos = ScreenPosition.new(1280, 1024, client.screenRatio)
else
	sPos = ScreenPosition.new(1600, 900, client.screenRatio)
end
--Converting position and size of our drawings into other resolutions
local x,y,w,h
local x1,y1,w1,h1
if math.floor(client.screenRatio*100) == 133 then
	x,y,w,h = sPos:GetPosition(37, 24, 72, 10)
	x1,y1,w1,h1 = sPos:GetPosition(45, 20, 12, 14)
elseif math.floor(client.screenRatio*100) == 166 then
	x,y,w,h = sPos:GetPosition(37, 23, 71, 7)
	x1,y1,w1,h1 = sPos:GetPosition(27, 8, 12, 12)
elseif math.floor(client.screenRatio*100) == 177 then
	x,y,w,h = sPos:GetPosition(43, 28, 83.5, 10)
	x1,y1,w1,h1 = sPos:GetPosition(15, 25, 12, 14)
elseif math.floor(client.screenRatio*100) == 160 then
	x,y,w,h = sPos:GetPosition(40, 25, 74, 8)
	x1,y1,w1,h1 = sPos:GetPosition(27, 9, 11, 13)
elseif math.floor(client.screenRatio*100) == 125 then
	x,y,w,h = sPos:GetPosition(48, 32, 94, 10)
	x1,y1,w1,h1 = sPos:GetPosition(31, 11, 15, 14)
else
	x,y,w,h = sPos:GetPosition(43, 28, 83, 10)
	x1,y1,w1,h1 = sPos:GetPosition(30, 10, 13, 14)
end

--Config
local config = ScriptConfig.new()
config:SetParameter("Color", 450)
config:Load()


--Variables
local showDamage = {} local killSpellsIcons = {} local killSpells = {} local killItemsIcons = {} local killItems = {} local sleeptick = 0 local onespell = {} local damages = {}
local monitor = client.screenSize.x/1600
local F13 = drawMgr:CreateFont("F13","Tahoma",13*monitor,650*monitor)

--Main function
function Tick(tick)
	if not PlayingGame() or client.console or tick < sleeptick or Animations.maxCount < 1 then return end sleeptick = tick + 200
	local me = entityList:GetMyHero()
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO, team = me:GetEnemyTeam()})	
	local abilities = me.abilities
	local items = me.items
	local eth = me:FindItem("item_ethereal_blade")
	local ethMult = false
	
	--We have ethereal blade so we write it down into ethMult variable
	if eth and eth:CanBeCasted() then
		ethMult = true
	end
	
	for e, v in ipairs(enemies) do
		if not v:IsIllusion() then
			local hand = v.handle
			if v.visible and v.alive then
				local offset = v.healthbarOffset if offset == -1 then return end						
				
				local totalDamage = 0
				local attack_modifier = nil							
				
				if not killSpells[hand] and not killItems[hand] then
					killSpells[hand] = {}
					killItems[hand] = {}
				end
				
				if not killSpellsIcons[hand] and not killItemsIcons[hand] then
					killSpellsIcons[hand] = {}
					killItemsIcons[hand] = {}
				end
				
				--Meepo's Divided we Stand
				if me.classId == CDOTA_Unit_Hero_Meepo then
					local meepos = entityList:GetEntities({type = LuaEntity.TYPE_MEEPO, team = me.team, alive = true})
					local DwS = me:GetAbility(4)
					if DwS and DwS.level > 0 then
						for h = 1, #meepos do
							local meepo = meepos[h]
							local poof = meepo:GetAbility(2)
							if poof and poof.level > 0 and poof:CanBeCasted() and meepo.handle ~= me.handle then								 
								if not damages[meepo.handle] or poof.level > damages[meepo.handle][2] then
									damages[meepo.handle] = { AbilityDamage.GetDamage(poof,v.healthRegen), poof.level }
								end
								local damage = damages[meepo.handle][1]								
								local type = DAMAGE_MAGC
								if ethMult then
									damage = damage*1.4
								end
								local takenDmg 
								if v.health < v.maxHealth or (v.health - totalDamage) < v.maxHealth then
									takenDmg = math.ceil(v:DamageTaken(damage,type,me) - ((v.healthRegen)*(poof:FindCastPoint() + client.latency/1000)))
								else
									takenDmg = math.ceil(v:DamageTaken(damage,type,me) - ((v.healthRegen)*(poof:GetChannelTime(poof.level))))
								end
								if (v.health - takenDmg) <= 0 and (not ethMult or (v.health - (takenDmg/1.4)) <= 0) then
									if not onespell[hand] or (onespell[hand][2] > h+2) then
										onespell[hand] = {poof, h+2}
									end
								elseif (v.health - totalDamage) > 0 and not killSpells[hand][h+2] then
									killSpells[hand][h+2] = poof.name
									if onespell[hand] and onespell[hand].icon then
										onespell[hand].icon.visible = false
									end
									onespell[hand] = nil
								elseif killSpells[hand][h+2] and (v.health - totalDamage) <= 0 then
									killSpells[hand][h+2] = nil
									killSpellsIcons[hand] = {}
								else
									if onespell[hand] and onespell[hand][1] == poof then
										if onespell[hand].icon then
											onespell[hand].icon.visible = false
										end
										onespell[hand] = nil
									end
								end
								totalDamage = totalDamage + takenDmg
							elseif killSpells[hand][h+2] then
								killSpells[hand][h+2] = nil
								killSpellsIcons[hand] = {}
							end
						end
					end
					sleeptick = sleeptick + 200
				end
				--Calculating damage from items
				for h,k in ipairs(items) do
					if k:CanBeCasted() then						
						if not damages[k.handle] or (k.name == "item_ethereal_blade" and SleepCheck("eth")) then
							damages[k.handle] = AbilityDamage.GetDamage(k)
							if k.name == "item_ethereal_blade" then Sleep(5000, "eth") end
						end
						local damage = damages[k.handle]
						if damage and damage > 0 then
							local type = AbilityDamage.itemList[k.name].type
							
							--every magical damage is amplificated by EtherealBlade
							if ethMult and type == DAMAGE_MAGC then
								damage = damage*1.4
							end
							
							local takenDmg
							if v.health ~= v.maxHealth then
								takenDmg = math.ceil(v:DamageTaken(damage,type,me) - ((v.healthRegen)*(client.latency/1000)))
							else
								takenDmg = math.ceil(v:DamageTaken(damage,type,me))
							end

							if (v.health - takenDmg) <= 0 and (not ethMult or (v.health - (takenDmg/1.4)) <= 0) then
								if not onespell[hand] or onespell[hand][2] > 0 then
									onespell[hand] = {k, 0, true}
								end
							elseif (v.health - totalDamage) > 0 and not killItems[hand][h] then
								killItems[hand][h] = k.name
								if onespell[hand] and onespell[hand].icon then
									onespell[hand].icon.visible = false
								end
								onespell[hand] = nil
							elseif killItems[hand][h] and (v.health - totalDamage) <= 0 then
								killItems[hand][h] = nil
								killItemsIcons[hand] = {}
							else
								if onespell[hand] and onespell[hand][1] == k then
									if onespell[hand].icon then
										onespell[hand].icon.visible = false
									end
									onespell[hand] = nil
								end
							end
							totalDamage = totalDamage + takenDmg
						end
					elseif killItems[hand][h] then
						killItems[hand][h] = nil
						killItemsIcons[hand] = {}
					end
				end
				
				--Calculating damage from spells
				for h,k in ipairs(abilities) do
					if k.level > 0 then
						if not damages[k.handle] or damages[k.handle][2] < k.level or damages[k.handle][3] ~= me.dmgMin+me.dmgBonus or damages[k.handle][4] ~= me.attackSpeed then
							damages[k.handle] = { AbilityDamage.GetDamage(k,v.healthRegen), k.level, me.dmgMin+me.dmgBonus, me.attackSpeed }
						end
						local damage = damages[k.handle][1]
						--Damage dependent on enemy mana
						if k.name == "antimage_mana_void" then
							damage = (v.maxMana - v.mana)*damage
						end
						if k.name == "invoker_emp" then
							if v.mana < damage then
								damage = v.mana
							end
							damage = damage/2
						end
						--Recongnizing the type of damage of our spell
						local type = AbilityDamage.GetDmgType(k)
						
						local takenDmg
						
						--Bristleback's Quill Spray stacks
						if me.classId == CDOTA_Unit_Hero_Bristleback then
							local quill_modif = v:FindModifier("modifier_bristleback_quill_spray")
							local quill_spell = me:FindSpell("bristleback_quill_spray")
							if quill_spell.level > 0 and k.name == "bristleback_quill_spray" then
								if quill_modif then
									damage = math.min(damage + quill_spell:GetSpecialData("quill_stack_damage",quill_spell.level)*quill_modif.stacks,400)
								end
							end
						end
						
						--Doom's Lvl? Death
						if k.name == "doom_bringer_lvl_death" then
							local multiplier = k:GetSpecialData("lvl_bonus_multiple",k.level)
							local bonusPercent = k:GetSpecialData("lvl_bonus_damage")/100
							if (v.level/multiplier) == math.floor(v.level/multiplier) or v.level == 25 then
								damage = damage + v.maxHealth*bonusPercent
							end
						end
						
						--Huskar's Life Break
						if k.name == "huskar_life_break" then
							damage = damage*v.health
						end
						
						--Necrophos's Reapers Scythe
						if k.name == "necrolyte_reapers_scythe" then	
							damage = damage*(v.maxHealth - v.health)
						end
						
						--every magical damage is amplificated by EtherealBlade
						if ethMult and type == DAMAGE_MAGC then
							damage = damage*1.4
						end
						
						--Enchantress's Impetus
						if k.name == "enchantress_impetus" then
							damage = damage * GetDistance2D(me,v)
						end
						
						if v.health < v.maxHealth or (v.health - totalDamage) < v.maxHealth then
							takenDmg = math.ceil(v:DamageTaken(damage,type,me) - ((v.healthRegen)*(k:FindCastPoint() + k:GetChannelTime(k.level) + client.latency/1000)))
						else
							takenDmg = math.ceil(v:DamageTaken(damage,type,me) - ((v.healthRegen)*(k:GetChannelTime(k.level))))
						end
						--Spell will not be registered if it is modifying hero auto attack, in that case we store its bonus damage and add it to our autoAttack damage when calculating hits.
						if AbilityDamage.attackModifiersList[k.name] then
							if AbilityDamage.attackModifiersList[k.name].manaBurn then
								attack_modifier = math.ceil(v:ManaBurnDamageTaken(damage,1,type,me))
							else
								attack_modifier = takenDmg
							end
						else
							if (k:CanBeCasted() or k.abilityPhase or (me:DoesHaveModifier("modifier_"..k.name) and k.name ~= "centaur_stampede" and k.name ~= "crystal_maiden_freezing_field")) and damage and damage > 0 and (k.name ~= "bounty_hunter_jinada" or k.cd == 0) then
								--Calculating damage bonuses for unique spells:
								
								--Zeus's Static Field
								if me.classId == CDOTA_Unit_Hero_Zuus then
									local staticF = me:GetAbility(3)
									if staticF and staticF.level > 0 then
										takenDmg = takenDmg + v:DamageTaken(((staticF:GetSpecialData("damage_health_pct",staticF.level)/100)*(v.health - totalDamage)),DAMAGE_MAGC,me)
									end
								end
							
								--Ancient Apparition's Ice Blast
								if k.name == "ancient_apparition_ice_blast" then
									local percent = k:GetSpecialData("kill_pct", k.level)/100
									percent = v.maxHealth*percent
									if (v.health - (totalDamage + takenDmg)) <= percent then
										takenDmg = takenDmg + percent
									end
								end
							
								--Batrider's Sticky Napalm stacks
								if me.classId == CDOTA_Unit_Hero_Batrider then
									local stickyM = v:FindModifier("modifier_batrider_sticky_napalm")
									local stickyN = me:FindSpell("batrider_sticky_napalm")
									if stickyN.level > 0 then
										if stickyM then
											takenDmg = takenDmg + v:DamageTaken(stickyN:GetSpecialData("damage",stickyN.level)*stickyM.stacks,DAMAGE_MAGC,me)
											attack_modifier = v:DamageTaken(stickyN:GetSpecialData("damage",stickyN.level)*stickyM.stacks,DAMAGE_MAGC,me)
										else
											attack_modifier = nil
										end
									end
								end											
								if (v.health - takenDmg) <= 0 and (not ethMult or (v.health - (takenDmg/1.4)) <= 0) then
									if not onespell[hand] or (onespell[hand][2] > h or (k.name == "axe_culling_blade" and onespell[hand][1].name ~= "axe_culling_blade")) then
										onespell[hand] = {k, h}
									end
								elseif (v.health - totalDamage) > 0 and not killSpells[hand][h] then
									killSpells[hand][h] = k.name
									if onespell[hand] and onespell[hand].icon then
										onespell[hand].icon.visible = false
									end
									onespell[hand] = nil									
								elseif killSpells[hand][h] and (v.health - totalDamage) <= 0 then
									killSpells[hand][h] = nil
									killSpellsIcons[hand] = {}
								else
									if onespell[hand] and onespell[hand][1] == k then
										if onespell[hand].icon then
											onespell[hand].icon.visible = false
										end
										onespell[hand] = nil
									end
								end					
								totalDamage = totalDamage + takenDmg
							elseif killSpells[hand][h] then
								killSpells[hand][h] = nil
								killSpellsIcons[hand] = {}
							end
							if damage and damage > 0 and k.name ~= "crystal_maiden_freezing_field" and 
							((v:DoesHaveModifier("modifier_"..k.name) and me:DoesHaveModifier("modifier_"..k.name) and k.cd > 0) or k.abilityPhase) then 
								sleeptick = tick + k:FindCastPoint()*3000 + k:GetChannelTime(k.level)*500 + client.latency return 
							end
						end
					end
				end
				
				--Drawings
				if not showDamage[hand] then showDamage[hand] = {}
					showDamage[hand].HPLeft = drawMgr:CreateRect(-x,-y+1,0,h,config.Color) showDamage[hand].HPLeft.visible = false showDamage[hand].HPLeft.entity = v showDamage[hand].HPLeft.entityPosition = Vector(0,0,offset)
					showDamage[hand].Sword = drawMgr:CreateRect(-x*monitor-h*monitor,-y*monitor+w1*monitor+5*monitor,x*monitor,h1*monitor,config.Color) showDamage[hand].Sword.visible = false showDamage[hand].Sword.entity = v showDamage[hand].Sword.entityPosition = Vector(0,0,offset) showDamage[hand].Sword.textureId = drawMgr:GetTextureId("NyanUI/other/sword")
					showDamage[hand].Skull = drawMgr:CreateRect(-x/monitor,-y+w1+5,w1*monitor*1.5,h1*monitor*1.5,-1) showDamage[hand].Skull.visible = false showDamage[hand].Skull.entity = v showDamage[hand].Skull.entityPosition = Vector(0,0,offset) showDamage[hand].Skull.textureId = drawMgr:GetTextureId("NyanUI/other/skull")
					showDamage[hand].Hits = drawMgr:CreateText(-x*monitor+w1*monitor,-y*monitor+w1*monitor+5*monitor, 0xFFFFFF99, "",F13) showDamage[hand].Hits.visible = false showDamage[hand].Hits.entity = v showDamage[hand].Hits.entityPosition = Vector(0,0,offset)					
				end
				local hpleft = math.max(v.health - totalDamage, 0)
				local HPLeftPercent = hpleft/v.maxHealth
				local hitDamage = v:DamageTaken(((me.dmgMin + me.dmgMax)/2 + me.dmgBonus),DAMAGE_PHYS,me)
				if attack_modifier then
					hitDamage = hitDamage + attack_modifier
				end
				local hits = math.ceil(hpleft/hitDamage)
				if totalDamage > 0 then
					showDamage[hand].HPLeft.visible = true showDamage[hand].HPLeft.w = w*HPLeftPercent
				elseif showDamage[hand].HPLeft.visible then
					showDamage[hand].HPLeft.visible = false
				end
				if hits > 0 then
					for i = 1, #killSpellsIcons[hand] do
						if killSpellsIcons[hand][i] then 
							killSpellsIcons[hand][i].visible = false
						end
					end
					for i = 1, #killItemsIcons[hand] do
						if killItemsIcons[hand][i] then
							killItemsIcons[hand][i].visible = false
						end
					end
					if Animations.table[me.handle] and Animations.table[me.handle].moveTime and Animations.maxCount > 0 then
						hits = math.ceil((hpleft + ((v.healthRegen)*((Animations.table[me.handle].moveTime)*hits)))/hitDamage)
					end
					showDamage[hand].Hits.visible = true showDamage[hand].Hits.text = ""..hits showDamage[hand].Hits.color = 0xFFFFFF99
					showDamage[hand].Sword.visible = true
					showDamage[hand].Skull.visible = false
				else
					showDamage[hand].Sword.visible = false
					showDamage[hand].Skull.visible = true
					showDamage[hand].Hits.visible = false
					if not onespell[hand] then		
						local count = 1
						for i,ks in pairs(killSpells[hand]) do							
							if not killSpellsIcons[hand][count] then
								killSpellsIcons[hand][count] = drawMgr:CreateRect(-x/monitor+x1*monitor+((w1+2)*monitor*count),-y+w1+5,w1*monitor*1.1,h1*monitor,0x000000FF) killSpellsIcons[hand][count].textureId = drawMgr:GetTextureId("NyanUI/Spellicons/"..ks) killSpellsIcons[hand][count].entity = v killSpellsIcons[hand][count].entityPosition = Vector(0,0,offset) killSpellsIcons[hand][count].visible = true		 			
							else
								killSpellsIcons[hand][count].textureId = drawMgr:GetTextureId("NyanUI/Spellicons/"..ks) killSpellsIcons[hand][count].visible = true		 	
							end
							count = count + 1
						end	
						count = 1
						for i,ks in pairs(killItems[hand]) do
							local yy = w1*1.2
							if #killSpellsIcons[hand] == 0 then
								yy = yy/9
							end
							if not killItemsIcons[hand][count] then
								killItemsIcons[hand][count] = drawMgr:CreateRect(-x/monitor+x1*monitor+((w1+2)*monitor*count),-y+w1+5+yy*monitor,w1*monitor + 7*monitor,h1*monitor,0x000000FF) killItemsIcons[hand][count].textureId = drawMgr:GetTextureId("NyanUI/items/"..ks:gsub("item_","")) killItemsIcons[hand][count].entity = v killItemsIcons[hand][count].entityPosition = Vector(0,0,offset) killItemsIcons[hand][count].visible = true		 			
							else
								killItemsIcons[hand][count].y = (-y+w1+5+yy*monitor)
								killItemsIcons[hand][count].textureId = drawMgr:GetTextureId("NyanUI/items/"..ks:gsub("item_","")) killItemsIcons[hand][count].visible = true	
							end
							count = count + 1
						end
					else
						for i = 1, #killSpellsIcons[hand] do
							if killSpellsIcons[hand][i] then 
								killSpellsIcons[hand][i].visible = false
							end
						end
						for i = 1, #killItemsIcons[hand] do
							if killItemsIcons[hand][i] then
								killItemsIcons[hand][i].visible = false
							end
						end
						if onespell[hand][3] then
							if not onespell[hand].icon then
								onespell[hand].icon = drawMgr:CreateRect(-x/monitor+x1*monitor+((w1+2)*monitor),-y+w1+5,w1*monitor + 7*monitor,h1*monitor,0x000000FF) onespell[hand].icon.textureId = drawMgr:GetTextureId("NyanUI/items/"..onespell[hand][1].name:gsub("item_","")) onespell[hand].icon.entity = v onespell[hand].icon.entityPosition = Vector(0,0,offset) onespell[hand].icon.visible = true		 			
							else
								onespell[hand].icon.textureId = drawMgr:GetTextureId("NyanUI/items/"..onespell[hand][1].name:gsub("item_","")) onespell[hand].icon.visible = true
							end
						else
							if not onespell[hand].icon then
								onespell[hand].icon = drawMgr:CreateRect(-x/monitor+x1*monitor+((w1+2)*monitor),-y+w1+5,w1*monitor,h1*monitor,0x000000FF) onespell[hand].icon.textureId = drawMgr:GetTextureId("NyanUI/Spellicons/"..onespell[hand][1].name) onespell[hand].icon.entity = v onespell[hand].icon.entityPosition = Vector(0,0,offset) onespell[hand].icon.visible = true		 			
							else
								onespell[hand].icon.textureId = drawMgr:GetTextureId("NyanUI/Spellicons/"..onespell[hand][1].name) onespell[hand].icon.visible = true
							end
						end
					end			
				end
			elseif showDamage[hand] then
				if onespell[hand] and onespell[hand].icon then
					onespell[hand].icon.visible = false
				end
				showDamage[hand].HPLeft.visible = false
				showDamage[hand].Hits.visible = false
				showDamage[hand].Skull.visible = false
				showDamage[hand].Sword.visible = false
				for i = 1, #killSpellsIcons[hand] do
					if killSpellsIcons[hand][i] then 
						killSpellsIcons[hand][i].visible = false
					end
				end
				for i = 1, #killItemsIcons[hand] do
					if killItemsIcons[hand][i] then
						killItemsIcons[hand][i].visible = false
					end
				end
			end
		end
	end
end
	
function GameClose()
	sleeptick = 0
	onespell = {}
	showDamage = {}
	killSpellsIcons = {} 
	killSpells = {}
	killItemsIcons = {} 
	killItems = {}
	damages = {}
	attack_modifier = nil
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK, Tick)
