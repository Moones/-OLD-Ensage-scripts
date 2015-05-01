require("libs.ScriptConfig")
require("libs.Utils")
require("libs.AbilityDamage")
require("libs.Animations")

local config = ScriptConfig.new()
config:SetParameter("Active", "U", config.TYPE_HOTKEY)
config:SetParameter("TresholdPercent", 100) -- TresholdPercent for missing HP
config:SetParameter("GUIxPosition", 10)
config:SetParameter("GUIyPosition", 580)
config:Load()

local toggleKey = config.Active
local x,y = config:GetParameter("GUIxPosition"), config:GetParameter("GUIyPosition")

local reg = false local activ = true 
local myhero = nil local onlyitems = false

local spellDamageTable = {}

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText = drawMgr:CreateText(x*monitor,y*monitor,-1,"Auto Support: ON - Hotkey: ''"..string.char(toggleKey).."''",F14) statusText.visible = false

function SupportTick(tick)
	if not SleepCheck() or not PlayingGame() or Animations.maxCount < 1 then return end Sleep(200)
	local me = entityList:GetMyHero()	
	if not me then return end
	local ID = me.classId
	if ID ~= myhero then GameClose() end
	local meka = me:FindItem("item_mekansm") local guardian = me:FindItem("item_guardian_greaves") local urn = me:FindItem("item_urn_of_shadows") local manaboots = me:FindItem("item_arcane_boots") local needmana = nil local needmeka = nil
	local allies = entityList:GetEntities({type = LuaEntity.TYPE_HERO,team = me.team})
	local fountain = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
	for i,v in ipairs(allies) do
		if not v:IsIllusion() and v.alive and v.health > 0 and me.alive and not me:IsChanneling() and GetDistance2D(me,fountain) > 2000 and (not me:IsInvisible() or me:DoesHaveModifier("modifier_treant_natures_guise")) and activ then
			local distance = GetDistance2D(me,v)
			--if meka and meka.cd == 0 then
				if (v.maxHealth - v.health) > (450 + v.healthRegen*10) and distance <= 2000 and (me.mana >= 225 or guardian) then
					if not needmeka or (needmeka and GetDistance2D(needmeka,me) <= 750) then
						needmeka = v
					end		
				end
			--end
			if urn and urn.cd == 0 and urn.charges > 0 and not v:DoesHaveModifier("modifier_item_urn_heal") then
				if (v.maxHealth - v.health) > (500  + v.healthRegen*10) and distance <= 950 and not IsInDanger(v) then
					me:CastAbility(urn,v) return
				end
				if me:DoesHaveModifier("modifier_wisp_tether") and (v.maxHealth - v.health) >= 600 then
					me:CastAbility(urn,me) return
				end
			end
			if manaboots and manaboots.cd == 0 then
				if (v.maxMana - v.mana) >= 135 and distance < 2000 and me.mana >= 35 then
					if not needmana or (needmana and GetDistance2D(needmana,me) <= 600) then
						needmana = v
					end
				end
			end
		end
	end
	
	if needmeka and ((guardian and guardian:CanBeCasted()) or (meka and meka:CanBeCasted())) and GetDistance2D(needmeka,me) <= 750 then
		if meka then
			me:CastAbility(meka) return 
		else
			me:CastAbility(guardian) return
		end
	end
	if needmana and manaboots and manaboots:CanBeCasted() and GetDistance2D(needmana,me) <= 600 then
		me:CastAbility(manaboots)
	end
	
	if not onlyitems then
		if ID == CDOTA_Unit_Hero_KeeperOfTheLight then
			Save(me,6,4,nil,nil)
		elseif ID == CDOTA_Unit_Hero_Dazzle then
			Save(me,nil,2,nil,nil,{80, 100, 120, 140},3,{1.5,1.5,1.5,1.5},nil,false)
			Heal(me,3,{80, 100, 120, 140},nil,1)
		elseif ID == CDOTA_Unit_Hero_Enchantress then		
			Heal(me,3,{300,500,700,900},300,3)
		elseif ID == CDOTA_Unit_Hero_Legion_Commander then
			Heal(me,2,{150, 200, 250, 300},nil,1)
		elseif ID == CDOTA_Unit_Hero_Huskar then
			Heal(me,1,{32, 64, 96, 128},nil,1,ID)
		elseif ID == CDOTA_Unit_Hero_Abaddon then
			Save(me,nil,2,nil,2,{100, 150, 200, 250},1,nil,1,false)
			Heal(me,1,{100, 150, 200, 250},nil,1,nil,true)
		elseif ID == CDOTA_Unit_Hero_Omniknight then
			Heal(me,1,{90, 180, 270, 360},nil,1)
			Save(me,nil,2,nil,2,{90, 180, 270, 360},1,nil,nil,false)
		elseif ID == CDOTA_Unit_Hero_Treant then
			Heal(me,3,{60, 105, 150, 195},2200000,1)
		elseif ID == CDOTA_Unit_Hero_Chen then
			Heal(me,5,{200, 300, 400},2200000,3,{6,5,4,3})
			Save(me,nil,3,600,nil,{200, 300, 400},5)
		elseif ID == CDOTA_Unit_Hero_Wisp then	
			if me:GetAbility(1).name == "wisp_tether" then
				Heal(me,1,me.healthRegen*18,1800,1,nil,true)
			elseif me:GetAbility(2).name == "wisp_tether" then
				Heal(me,2,me.healthRegen*18,1800,1,nil,true)
			end
		elseif ID == CDOTA_Unit_Hero_Centaur then		
			Save(me,4,nil,2200000)
		elseif ID == CDOTA_Unit_Hero_WitchDoctor then
			Heal(me,2,{16,24,32,40},550,4,ID)
		elseif ID == CDOTA_Unit_Hero_Necrolyte then
			Heal(me,1,{70,90,110,130},500,3)
		elseif ID == CDOTA_Unit_Hero_Warlock then
			Heal(me,2,{165,275,385,495},nil,1)
		--elseif ID == CDOTA_Unit_Hero_Rubick then -- Rubick spell steals not implemented yet
			--Heal()
		elseif ID == CDOTA_Unit_Hero_Undying then
			Heal(me,2,{5,10,15,20},nil,1,ID)
		elseif ID == CDOTA_Unit_Hero_Oracle then
			Save(me,nil,4,nil,nil,{31.5,63,93.5,126},3,{1.5,1.5,1.5},nil,false)
			Heal(me,3,{31.5,63,93.5,126},nil,1)
		elseif ID == CDOTA_Unit_Hero_Winter_Wyvern then
			Heal(me,3,{0.003,0.004,0.005,0.006},nil,1,ID)
		end
	end
end

function Key(msg,code)
	if client.chat or client.console or code ~= toggleKey or msg ~= KEY_UP then return end
	activ = not activ
	statusText.text = "Auto Support: "..Activ(activ).." - Hotkey: ''"..string.char(toggleKey).."''"
end

function Save(me,ability1,ability2,range,target,tresh,treshspell,duration,special,excludeme)
	if excludeme == nil then excludeme = false end
	if duration == nil then duration = {1,1,1,1} end
	local save1,save2 = nil,nil
	if ability1 then save1 = me:GetAbility(ability1) end
	if ability2 then save2 = me:GetAbility(ability2) end
	if (save1 and save1.level > 0 and save1:CanBeCasted()) or (save2 and save2.level > 0 and save2:CanBeCasted()) then
		if tresh == nil then tresh = 200 end
		local Range = range or (save2.castRange+50)
		local fountain = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
		if me.alive and not me:IsChanneling() and (not me:IsInvisible() or me:DoesHaveModifier("modifier_treant_natures_guise")) then
			local allies = entityList:GetEntities({type = LuaEntity.TYPE_HERO,team = me.team})
			for i,v in ipairs(allies) do
				if v.healthbarOffset ~= -1 and not v:IsIllusion() then
					if v.alive and v.health > 0 and (v ~= me or not excludeme) and NetherWard(save2,v,me) then
						if activ then
							if type(tresh) == "table" then
								if treshspell and type(treshspell) == "number" then treshspell = me:GetAbility(treshspell) end
								if target == 2 then
									local needsave = nil
									if IncomingDamage(v,true) > v.health or (treshspell and treshspell.level > 0 and IsInDanger(v)) and GetDistance2D(me,v) <= Range then
										if not needsave or (needsave and (v.maxHealth - v.health) > (needsave.maxHealth - needsave.health)) then
											needsave = v
										end
										if needsave and (treshspell.cd ~= 0 or (treshspell.cd > treshspell:GetCooldown(treshspell.level)/2) or not treshspell:CanBeCasted()) then
											me:CastAbility(save2,needsave)
										end
									end
								else
									local ch = ClosestHero(v)
									if ch then
										if v.health <= (IncomingDamage(v)*duration[save2.level]) and IsInDanger(v) and GetDistance2D(me,v) <= Range then
											me:CastAbility(save2,v)
										end	
									else
										if v.health <= IncomingDamage(v) or (treshspell and treshspell.level > 0 and v.health <= tresh[treshspell.level]*(config.TresholdPercent/100)) and IsInDanger(v) and GetDistance2D(me,v) <= Range then
											me:CastAbility(save2,v)
										end	
									end
								end	
							else
								if GetDistance2D(me,fountain) > 2000 then
									if v.health < tresh*(config.TresholdPercent/100) and not IsInDanger(v) and GetDistance2D(v,fountain) > GetDistance2D(me,fountain) and (GetDistance2D(v,fountain) - GetDistance2D(me,fountain)) > 1000 and not v:IsChanneling() then
										me:CastAbility(save1)
										me:CastAbility(save2,v)
									end
									if save1.name == "centaur_stampede" then
										if v.health < tresh*(config.TresholdPercent/100) and not v:IsChanneling() and IsInDanger(v) then
											me:CastAbility(save1)
										end
									end
								end
							end
							if special == 1 then
								for i,m in ipairs(v.modifiers) do
									if m and m.stunDebuff and GetDistance2D(me,v) <= Range then
										me:CastAbility(save2,v)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function Heal(me,ability,amount,range,target,id,excludeme,special)
	local heal = me:GetAbility(ability)
	if heal and heal.level > 0 and heal:CanBeCasted() then
		local Range = (range) or (heal.castRange + 50)		
		local fountain = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
		if me.alive and not me:IsChanneling() and (not me:IsInvisible() or me:DoesHaveModifier("modifier_treant_natures_guise")) and GetDistance2D(me,fountain) > 2000 then
			local allies = entityList:GetEntities({type = LuaEntity.TYPE_HERO,team = me.team})
			for i,v in ipairs(allies) do
				local healthAmount = GetHeal(heal.level,me,amount,id,v)
				if v.healthbarOffset ~= -1 and not v:IsIllusion() and healthAmount > 0 then
					if v.alive and v.health > 0 and (not excludeme or v ~= me) and NetherWard(heal,v,me) and (me.classId ~= CDOTA_Unit_Hero_Oracle or (v:DoesHaveModifier("modifier_oracle_fates_edict") or (not me:GetAbility(2):CanBeCasted() and v.health > 300))) then
						if activ then
							if (((v.maxHealth - v.health)*(config.TresholdPercent/100)) > (math.max(healthAmount + 100,150) + v.healthRegen*10) or v.health < IncomingDamage(v)) and GetDistance2D(me,v) <= Range and IsInDanger(v) then								
								if target == 1 then
									ExecuteHeal(heal,v,me)	break
								elseif target == 2 then
									ExecuteHeal(heal,v.position,me) break
								elseif target == 3 then
									ExecuteHeal(heal,nil,me) break
								elseif target == 4 then
									ExecuteHeal(heal,nil,me,true) Sleep(1000) break
								end
							end
						end
					end
				end
			end
		end
	end
end

function GetHeal(lvl,me,tab1,id,target)
	local bheal = 0
	if type(tab1) == "number" then
		bheal = tab1
	else
		bheal = tab1[lvl]
	end
	if id == CDOTA_Unit_Hero_Undying then
		local count = entityList:GetEntities(function (v) return (v.courier or v.hero or v.classId == CDOTA_BaseNPC_Creep_Neutral or v.classId == CDOTA_BaseNPC_Creep_Lane or v.classId == CDOTA_Unit_VisageFamiliar or v.classId == CDOTA_Unit_Undying_Zombie or v.classId == CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId == CDOTA_BaseNPC_Creep or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit) and v.alive and v.health~=0 and me:GetDistance2D(v) < 1300 end)
		local num = #count - 2
		if num < bheal then
			return num * 24
		else
			return bheal * 24
		end
	elseif id == CDOTA_Unit_Hero_Huskar then
		local attribute_percentage = {0.05,0.10,0.15,0.20}
		local mainattribute = 0
		local attributes = {target.agility,target.intellect,target.strenght}
		table.sort(attributes, function (a,b) return a > b end)
		if attributes[1] == target.ability then
			mainattribute = target.agilityTotal
		elseif attributes[1] == target.intellect then
			mainattribute = target.intellectTotal
		elseif attributes[1] == target.strenght then
			mainattribute = target.strenghtTotal
		end
		return bheal + mainattribute*attribute_percentage[lvl]*16
	elseif id == CDOTA_Unit_Hero_WitchDoctor then
		return (bheal+((me.mana)/(bheal/2))+target.healthRegen)*3
	elseif id == CDOTA_Unit_Hero_Winter_Wyvern then
		return ((bheal*target.maxHealth) + 2)*40
	end
	return bheal	
end

function ExecuteHeal(spell,target,me,toggle)
	if spell and spell:CanBeCasted() and me:CanCast() then
		if toggle then
			if not spell.toggled then
				local prev = SelectUnit(me)
				entityList:GetMyPlayer():ToggleAbility(spell)
				SelectBack(prev)
			end
		else
			if not target then
				me:CastAbility(spell)
			else
				me:CastAbility(spell,target)
				if spell.name == "wisp_tether" and me:GetAbility(2).toggled == false and me:GetAbility(2).cd == 0 then
					me:ToggleSpell(me:GetAbility(4).name)
				end
			end
		end
	end
end
	
function IsInDanger(hero)
	if hero and hero.alive and hero.health > 0 then
		for k,z in ipairs(entityList:GetProjectiles({target=hero})) do
			if z and z.source and z.target == hero then
				return true
			end
		end
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=hero:GetEnemyTeam()})) do	
			if GetDistance2D(hero,v) < GetAttackRange(v)+50 then
				return true
			end
			for i,k in pairs(v.abilities) do
				if GetDistance2D(hero,v) < k.castRange+50 then
					return true
				end
			end
		end
		local modifiers = {"modifier_item_urn_damage","modifier_doom_bringer_doom","modifier_axe_battle_hunger","modifier_queenofpain_shadow_strike","modifier_phoenix_fire_spirit_burn","modifier_venomancer_poison_nova","modifier_venomancer_venomous_gale","modifier_silencer_curse_of_the_silent","modifier_silencer_last_word"}
		for i,v in ipairs(modifiers) do 
			if hero:DoesHaveModifier(v) then
				return true
			end
		end
	end
end

function IncomingDamage(unit,onlymagic)
	if unit and unit.alive and unit.health > 0 then
		local result = 0
		local results = {}
		local resultsMagic = {}
		local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=unit:GetEnemyTeam(),illusion=false})		
		for i,v in pairs(enemy) do	
			if not onlymagic and not results[v.handle] and (isAttacking(v) or GetDistance2D(unit,v) < 200) and GetDistance2D(unit,v) <= GetAttackRange(v) + 50 and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, unit))) - 0.20, 0)) == 0 then
				local dmg = math.floor(unit:DamageTaken(v.dmgMin+v.dmgBonus,DAMAGE_PHYS,v))
				if v.type == LuaEntity.TYPE_MEEPO then
					local num = v:GetAbility(4).level
					if v:AghanimState() then
						num = num + 1
					end
					dmg = dmg*num
				end
				result = result + dmg
				results[v.handle] = true
			end
			for i,k in pairs(unit.modifiers) do
				local spell = v:FindSpell(k.name:gsub("modifier_",""))
				if spell then
					local dmg
					if not spellDamageTable[spell.handle] or spellDamageTable[spell.handle][2] ~= spell.level or spellDamageTable[spell.handle][3] ~= v.dmgMin+v.dmgBonus or spellDamageTable[spell.handle][4] ~= v.attackSpeed then
						spellDamageTable[spell.handle] = { AbilityDamage.GetDamage(spell), spell.level, v.dmgMin+v.dmgBonus, v.attackSpeed }
					end
					dmg = spellDamageTable[spell.handle][1]
					if v.type == LuaEntity.TYPE_MEEPO then
						local num = v:GetAbility(4).level
						if v:AghanimState() then
							num = num + 1
						end
						dmg = dmg*num
					end
					if dmg and dmg > 0 and not resultsMagic[spell.handle] and not resultsMagic[k.handle] then
						result = result + math.floor(unit:DamageTaken(dmg,AbilityDamage.GetDmgType(spell),v))
						resultsMagic[k.handle] = true
						resultsMagic[spell.handle] = true
					end
				end
			end
			for i,k in pairs(v.abilities) do
				if k.level > 0 and (k.abilityPhase or (k:CanBeCasted() and k:FindCastPoint() < 0.4)) and not resultsMagic[k.handle] and GetDistance2D(v,unit) <= k.castRange+200 and (((math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, unit))) - 0.20, 0)) == 0 
					and (k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_UNIT_TARGET) or k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_POINT))) or k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_NO_TARGET)) then
					local dmg
					if not spellDamageTable[k.handle] or spellDamageTable[k.handle][2] ~= k.level or spellDamageTable[k.handle][3] ~= v.dmgMin+v.dmgBonus or spellDamageTable[k.handle][4] ~= v.attackSpeed then
						spellDamageTable[k.handle] = { AbilityDamage.GetDamage(k), k.level, v.dmgMin+v.dmgBonus, v.attackSpeed }
					end
					dmg = spellDamageTable[k.handle][1]
					if dmg then
						result = result + math.floor(unit:DamageTaken(dmg,AbilityDamage.GetDmgType(k),v))
						resultsMagic[k.handle] = true
					end
				end
			end
			for i,k in pairs(v.items) do
				local dmg
				if not spellDamageTable[k.handle] or spellDamageTable[k.handle][2] ~= v.level or spellDamageTable[k.handle][3] ~= v.dmgMin+v.dmgBonus or spellDamageTable[k.handle][4] ~= v.attackSpeed then
					spellDamageTable[k.handle] = { AbilityDamage.GetDamage(k), v.level, v.dmgMin+v.dmgBonus, v.attackSpeed }
				end
				dmg = spellDamageTable[k.handle][1]
				if dmg and dmg > 0 and k.castRange and not resultsMagic[k.handle] and GetDistance2D(v,unit) <= k.castRange+200 then
					result = result + math.floor(unit:DamageTaken(dmg,DAMAGE_MAGC,v))
					resultsMagic[k.handle] = true
				end
			end
		end	
		for i,k in pairs(entityList:GetProjectiles({target=unit})) do
			if k.source then
				local spell = k.source:FindSpell(k.name)
				if spell and not resultsMagic[k.source.handle] and not resultsMagic[k.name] then
					local dmg
					if not spellDamageTable[spell.handle] or spellDamageTable[spell.handle][2] ~= spell.level or spellDamageTable[spell.handle][3] ~= k.source.dmgMin+k.source.dmgBonus or spellDamageTable[spell.handle][4] ~= k.source.attackSpeed then
						spellDamageTable[spell.handle] = { AbilityDamage.GetDamage(spell), spell.level, k.source.dmgMin+k.source.dmgBonus, k.source.attackSpeed }
					end
					dmg = spellDamageTable[spell.handle][1]
					if k.source.type == LuaEntity.TYPE_MEEPO then
						local num = k.source:GetAbility(4).level
						if k.source:AghanimState() then
							num = num + 1
						end
						dmg = dmg*num
					end
					if dmg then
						result = result + math.floor(unit:DamageTaken(dmg,AbilityDamage.GetDmgType(spell),k.source))
						resultsMagic[k.source.handle] = true
						resultsMagic[k.name] = true
					end
				elseif not onlymagic and k.source and not results[k.source.handle] and k.source.dmgMax then
					local dmg = math.floor(unit:DamageTaken(k.source.dmgMin+k.source.dmgBonus,DAMAGE_PHYS,k.source))
					if k.source.type == LuaEntity.TYPE_MEEPO then
						local num = k.source:GetAbility(4).level
						if k.source:AghanimState() then
							num = num + 1
						end
						dmg = dmg*num
					end
					result = result + dmg
					results[k.source.handle] = true
				end	
			end
		end		
		if result then
			return result
		else
			return 0
		end
	end
end

function ClosestHero(hero)
	if hero and hero.alive and hero.health > 0 then
		local result = nil
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=hero:GetEnemyTeam()})) do	
			if GetDistance2D(hero,v) < (GetAttackRange(v) + 50) then
				if not result or GetDistance2D(result,hero) > GetDistance2D(hero,v) then
					result = v
				end	
			end
		end
		return result
	end
end

function NetherWard(skill,hero,me)
	if me:DoesHaveModifier("modifier_pugna_nether_ward_aura") then
		if me.health < me:DamageTaken((skill.manacost*1.75), DAMAGE_MAGC, hero) then
			return false
		end		
	end
	return true
end

function Support(hId)
	if hId == CDOTA_Unit_Hero_Oracle or hId == CDOTA_Unit_Hero_Winter_Wyvern or hId == CDOTA_Unit_Hero_KeeperOfTheLight or hId == CDOTA_Unit_Hero_Dazzle or hId == CDOTA_Unit_Hero_Chen or hId == CDOTA_Unit_Hero_Dazzle or hId == CDOTA_Unit_Hero_Enchantress or hId == CDOTA_Unit_Hero_Legion_Commander or hId == CDOTA_Unit_Hero_Abaddon or hId == CDOTA_Unit_Hero_Omniknight or hId == CDOTA_Unit_Hero_Treant or hId == CDOTA_Unit_Hero_Wisp or hId == CDOTA_Unit_Hero_Centaur or hId == CDOTA_Unit_Hero_Undying or hId == CDOTA_Unit_Hero_WitchDoctor or hId == CDOTA_Unit_Hero_Necrolyte or hId == CDOTA_Unit_Hero_Warlock or hId == CDOTA_Unit_Hero_Rubick or hId == CDOTA_Unit_Hero_Huskar then
		return true
	else
		return false
	end
end

function isAttacking(ent)
	if ent.activity == LuaEntityNPC.ACTIVITY_ATTACK or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK1 or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK2 then
		return true
	end
	return false
end

function GetAttackRange(hero)
	local bonus = 0
	if hero.classId == CDOTA_Unit_Hero_TemplarAssassin then		
		local psy = hero:GetAbility(3)
		psyrange = {60,120,180,240}			
		if psy and psy.level > 0 then			
			bonus = psyrange[psy.level]				
		end			
	elseif hero.classId == CDOTA_Unit_Hero_Sniper then		
		local aim = hero:GetAbility(3)
		aimrange = {100,200,300,400}			
		if aim and aim.level > 0 then		
			bonus = aimrange[aim.level]				
		end			
	end		
	return hero.attackRange + bonus
end

function Activ(a)
	if a == true then
		return "ON"
	else
		return "OFF"
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		statusText.visible = true
		reg = true
		save1,save2 = nil,nil
		myhero = me.classId
		if not Support(myhero) then 
			onlyitems = true			
		else
			onlyitems = false
		end
		spellDamageTable = {}
		script:RegisterEvent(EVENT_TICK,SupportTick)
		script:RegisterEvent(EVENT_KEY,Key)
		script:UnregisterEvent(Load)
	end
end

function GameClose()
	myhero = nil
	needmana = nil 
	needmeka = nil
	onlyitems = false
	spellDamageTable = {}
	if reg then
		script:UnregisterEvent(SupportTick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)
