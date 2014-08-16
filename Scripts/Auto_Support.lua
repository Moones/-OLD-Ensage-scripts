require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Active", "U", config.TYPE_HOTKEY)
config:Load()

local toggleKey = config.Active

local reg = false local activ = true 
local myhero = nil local onlyitems = false

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText = drawMgr:CreateText(10*monitor,580*monitor,-1,"Auto Support: ON - Hotkey: ''"..string.char(toggleKey).."''",F14) statusText.visible = false

function SupportTick(tick)
	if not SleepCheck() then return end Sleep(200)
	local me = entityList:GetMyHero()	
	if not me then return end
	local ID = me.classId
	if ID ~= myhero then GameClose() end
	local meka = me:FindItem("item_mekansm") local urn = me:FindItem("item_urn_of_shadows") local manaboots = me:FindItem("item_arcane_boots") local needmana = nil local needmeka = nil
	local allies = entityList:GetEntities({type = LuaEntity.TYPE_HERO,team = me.team})
	local fountain = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
	for i,v in ipairs(allies) do
		if not v:IsIllusion() and v.alive and v.health > 0 and me.alive and not me:IsChanneling() and GetDistance2D(me,fountain) > 2000 and (not me:IsInvisible() or me:DoesHaveModifier("modifier_treant_natures_guise")) and activ then
			local distance = GetDistance2D(me,v)
			if meka and meka.cd == 0 then
				if (v.maxHealth - v.health) > (450 + v.healthRegen*10) and distance <= 2000 and me.mana >= 150 then
					if not needmeka or (needmeka and GetDistance2D(needmeka,me) <= 750) then
						needmeka = v
					end
					if GetDistance2D(needmeka,me) <= 750 then
						me:CastItem(meka.name) return
					end
				end
			end
			if urn and urn.cd == 0 and urn.charges > 0 and not v:DoesHaveModifier("modifier_item_urn_heal") then
				if (v.maxHealth - v.health) > (500  + v.healthRegen*10) and distance <= 950 and not IsInDanger(v) then
					me:CastItem(urn.name,v) return
				end
				if me:DoesHaveModifier("modifier_wisp_tether") and (v.maxHealth - v.health) >= 600 then
					me:CastItem(urn.name,me) return
				end
			end
			if manaboots and manaboots.cd == 0 then
				if (v.maxMana - v.mana) >= 135 and distance < 2000 and me.mana >= 35 then
					if not needmana or (needmana and GetDistance2D(needmana,me) <= 600) then
						needmana = v
					end
					if GetDistance2D(needmana,me) <= 600 then
						me:CastItem(manaboots.name)
					end
				end
			end
		end
	end
	if not onlyitems then
		if ID == CDOTA_Unit_Hero_KeeperOfTheLight then
			Save(me,6,4,nil,nil)
		elseif ID == CDOTA_Unit_Hero_Dazzle then
			Heal(me,3,{80, 100, 120, 140},nil,1)
			Save(me,nil,2,nil,nil,{80, 100, 120, 140},3,{0.5,0.5,0.5,0.5})
		elseif ID == CDOTA_Unit_Hero_Enchantress then		
			Heal(me,3,{300,500,700,900},300,3)
		elseif ID == CDOTA_Unit_Hero_Legion_Commander then
			Heal(me,2,{150, 200, 250, 300},nil,1)
		elseif ID == CDOTA_Unit_Hero_Huskar then
			Heal(me,1,{32, 64, 96, 128},nil,1,ID)
		elseif ID == CDOTA_Unit_Hero_Abaddon then
			Heal(me,1,{100, 150, 200, 250},nil,1,nil,true)
			Save(me,nil,2,nil,2,{100, 150, 200, 250},1,nil,1)
		elseif ID == CDOTA_Unit_Hero_Omniknight then
			Heal(me,1,{90, 180, 270, 360},nil,1)
			Save(me,nil,2,nil,2,{90, 180, 270, 360},1)
		elseif ID == CDOTA_Unit_Hero_Treant then
			Heal(me,3,{60, 105, 150, 195},2200000,1)
		elseif ID == CDOTA_Unit_Hero_Chen then
			Heal(me,5,{200, 300, 400},2200000,3,{6,5,4,3})
			Save(me,nil,3,nil,nil,{200, 300, 400},5)
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
		end
	end
end

function Key(msg,code)
	if client.chat or client.console or code ~= toggleKey or msg ~= KEY_UP then return end
	activ = not activ
	statusText.text = "Auto Support: "..Activ(activ).." - Hotkey: ''"..string.char(toggleKey).."''"
end

function Save(me,ability1,ability2,range,target,tresh,treshspell,duration,special)
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
					if v.alive and v.health > 0 and v ~= me and NetherWard(save2,v,me) then
						if activ then
							if type(tresh) == "table" then
								if treshspell and type(treshspell) == "number" then treshspell = me:GetAbility(treshspell) end
								if target == 2 then
									local needsave = nil
									if treshspell and treshspell.level > 0 and IsInDanger(v) and GetDistance2D(me,v) <= Range then
										if not needsave or (needsave and (v.maxHealth - v.health) > (needsave.maxHealth - needsave.health)) then
											needsave = v
										end
										if needsave and (treshspell.cd ~= 0 or (treshspell.cd > treshspell:GetCooldown(treshspell.level)/2)) then
											me:CastAbility(save2,needsave)
										end
									end
								else
									local ch = ClosestHero(v)
									if ch then
										if v.health <= ClosestHeroDmg(v)*(ch.attackBaseTime/1+(ch.attackSpeed/100))*duration[save2.level] or (treshspell and treshspell.level > 0 and v.health < tresh[treshspell.level]) and IsInDanger(v) and GetDistance2D(me,v) <= Range then
											me:CastAbility(save2,v)
										end	
									else
										if v.health <= ClosestHeroDmg(v) or (treshspell and treshspell.level > 0 and v.health <= tresh[treshspell.level]) and IsInDanger(v) and GetDistance2D(me,v) <= Range then
											me:CastAbility(save2,v)
										end	
									end
								end	
							else
								if GetDistance2D(me,fountain) > 2000 then
									if v.health < tresh and not IsInDanger(v) and GetDistance2D(v,fountain) > GetDistance2D(me,fountain) and (GetDistance2D(v,fountain) - GetDistance2D(me,fountain)) > 1000 and not v:IsChanneling() then
										me:CastAbility(save1)
										me:CastAbility(save2,v)
									end
									if save1.name == "centaur_stampede" then
										if v.health < tresh and not v:IsChanneling() and IsInDanger(v) then
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
	if heal and heal.level > 0 and heal.state == LuaEntityAbility.STATE_READY then
		local Range = (range) or (heal.castRange + 50)		
		local fountain = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
		if me.alive and not me:IsChanneling() and (not me:IsInvisible() or me:DoesHaveModifier("modifier_treant_natures_guise")) and GetDistance2D(me,fountain) > 2000 then
			local allies = entityList:GetEntities({type = LuaEntity.TYPE_HERO,team = me.team})
			for i,v in ipairs(allies) do
				local healthAmount = GetHeal(heal.level,me,amount,id,v)
				if v.healthbarOffset ~= -1 and not v:IsIllusion() and healthAmount > 0 then
					if v.alive and v.health > 0 and (not excludeme or v ~= me) and NetherWard(heal,v,me) then
						if activ then
							if ((v.maxHealth - v.health) > (math.max(healthAmount + 100,150) + v.healthRegen*10) or v.health < ClosestHeroDmg(v)) and GetDistance2D(me,v) <= Range and IsInDanger(v) then								
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
	end
	return bheal	
end

function ExecuteHeal(spell,target,me,toggle)
	if spell and spell:CanBeCasted() and me:CanCast() then
		if toggle then
			if not spell.toggled then
				me:ToggleSpell(spell.name)
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
			if GetDistance2D(hero,v) < (v.attackRange + 50) then
				return true
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

function ClosestHeroDmg(hero)
	if hero and hero.alive and hero.health > 0 then
		local result = 0
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=hero:GetEnemyTeam()})) do	
			if GetDistance2D(hero,v) < (v.attackRange + 50) then
				result = result + v.dmgMin	
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
			if GetDistance2D(hero,v) < (v.attackRange + 50) then
				if not result or GetDistance2D(result,hero) > GetDistance2D(hero,v) then
					result = v
				end	
			end
			return result
		end
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
	if hId == CDOTA_Unit_Hero_KeeperOfTheLight or hId == CDOTA_Unit_Hero_Dazzle or hId == CDOTA_Unit_Hero_Chen or hId == CDOTA_Unit_Hero_Dazzle or hId == CDOTA_Unit_Hero_Enchantress or hId == CDOTA_Unit_Hero_Legion_Commander or hId == CDOTA_Unit_Hero_Abaddon or hId == CDOTA_Unit_Hero_Omniknight or hId == CDOTA_Unit_Hero_Treant or hId == CDOTA_Unit_Hero_Wisp or hId == CDOTA_Unit_Hero_Centaur or hId == CDOTA_Unit_Hero_Undying or hId == CDOTA_Unit_Hero_WitchDoctor or hId == CDOTA_Unit_Hero_Necrolyte or hId == CDOTA_Unit_Hero_Warlock or hId == CDOTA_Unit_Hero_Rubick or hId == CDOTA_Unit_Hero_Huskar then
		return true
	else
		return false
	end
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
	if reg then
		script:UnregisterEvent(SupportTick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)
