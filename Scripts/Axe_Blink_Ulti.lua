--<<Axe Script by Moones Version 1.3, Auto Call and Blink+Ulti when enemy is killable.>>
--[[
	-------------------------------------
	|       Axe Script by Moones        |
	-------------------------------------
	============ Version 1.3 ============
	 
	Description:
	------------	
		- When enemy hero is killable by Culling Blade and is in range of Blink, Axe will Blink and Ulti him.
		- When any hero is in range of call then It will be automaticly casted.
	   
	Changelog:
	----------
		Update 1.3:
			Performance fix.
			Improved cast canceling via Animations lib.
			It will now cancel only when the spell was casted by script.
			
		Update 1.2:
			Fixed Call Hotkey
			Added Stop Ulti when enemy is not killable anymore
			
		Update 1.1:
			Added AutoCall

		Update 1.0:
			First release. Bugs may appear, so feel free to report them.
]]--
require("libs.ScriptConfig")
require("libs.Utils")
require("libs.SkillShot")
require("libs.Animations")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "D", config.TYPE_HOTKEY)
config:SetParameter("CallHotkey", "F", config.TYPE_HOTKEY)
config:Load()

local toggleKey = config.Hotkey

local hero = {} local reg = false
local active = true local myhero = nil local callactive = true local callvictim = nil
local victimhp = 0 local cullvictim = nil
local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor)
local cullingblade = drawMgr:CreateRect(-45,-70,20,20,0x000000ff) cullingblade.visible = false
local blink = drawMgr:CreateRect(-25,-70,35,20,0x000000ff) blink.visible = false

function Tick(tick)
	
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()	
	if not me then return end
	local ID = me.classId
	if ID ~= myhero then GameClose() end

	cullingblade.entity = me 
	cullingblade.entityPosition = Vector(0,0,me.healthbarOffset)
	blink.entity = me 
	blink.entityPosition = Vector(0,0,me.healthbarOffset)
	
	local Cullblade = me:GetAbility(4)
	local Blink = me:FindItem("item_blink")
	local call = me:GetAbility(1)
	
	if Cullblade.level > 0 or call.level > 0 then
		cullingblade.textureId = drawMgr:GetTextureId("NyanUI/Spellicons/axe_culling_blade")
		cullingblade.visible = active
		if Blink then
			blink.textureId = drawMgr:GetTextureId("NyanUI/items/blink")
			blink.visible = active
		else
			blink.visible = false
		end
		local Type = DAMAGE_HPRM
		local Range = 350
		local RangeB = 1200
		local CastPoint,Dmg = 0,0
		if Cullblade.level > 0 then
			CastPoint = Cullblade:GetCastPoint(Cullblade.level)+client.latency/1000
			Dmg = Cullblade:GetSpecialData("kill_threshold",Cullblade.level)
			if me:AghanimState() then		
				Dmg = Cullblade:GetSpecialData("kill_threshold_scepter",Cullblade.level)
			end
		end
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),alive=true,visible=true})
			for i,v in ipairs(enemies) do
				if v.healthbarOffset ~= -1 and not v:IsIllusion() then
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(-45,-55, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if v.visible and v.alive and v.health > 0 then
						hero[v.handle].visible = active
						local culldamage = math.floor(v:DamageTaken(Dmg,Type,me))
						local healthtokill = math.floor(v.health - culldamage + CastPoint*v.healthRegen+Moprhling(v,CastPoint))
						hero[v.handle].text = "Health to kill: "..healthtokill
						if active then
							if healthtokill <= 0 then
								if SleepCheck("blink") and GetDistance2D(me,v) <= RangeB+150 and GetDistance2D(me,v) > Range and (Blink and Blink:CanBeCasted()) and Cullblade:CanBeCasted() then
									if me:IsMagicDmgImmune() or ((NetherWard(Cullblade,v,me)) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and BladeMail(v,me,culldamage)) then
										local bpos = v.position
										if GetDistance2D(me,v) > RangeB then
											bpos = (v.position - me.position) * 1100 / GetDistance2D(me,v) + me.position
										end
										me:CastAbility(Blink,bpos)		
										Sleep(me:GetTurnTime(v)+client.latency,"blink")
									end
								end
								if SleepCheck("cull") and GetDistance2D(me,v) < Range and Cullblade:CanBeCasted() then
									if me:IsMagicDmgImmune() or ((NetherWard(Cullblade,v,me)) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and BladeMail(v,me,culldamage)) then
										me:SafeCastAbility(Cullblade,v)	Sleep(Cullblade:FindCastPoint()*1000+client.latency,"cull")
										victimhp = v.health
										cullvictim = v
									end
								end
							elseif cullvictim and v == cullvictim and SleepCheck("stopcull") and Cullblade.abilityPhase and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) == 0 and GetDistance2D(me,v) <= 300 and 
							Animations.getDuration(Cullblade) > 0.2 then
								me:Stop()
								if victimhp > 0 and victimhp-100 > v.health then
									me:SafeCastAbility(Cullblade,v)
								end
								Sleep(client.latency,"stopcull")
							elseif callactive then
								local pred = SkillShot.PredictedXYZ(v,call:FindCastPoint()*1000+client.latency)
								if not v:IsInvul() and GetDistance2D(v,me)-25 <= call:GetSpecialData("radius",call.level) and ((pred and GetDistance2D(pred,me)-25 <= call:GetSpecialData("radius",call.level)) or not pred) then
									if SleepCheck("call") then
										me:SafeCastAbility(call) Sleep(call:FindCastPoint()*1000+client.latency,"call")
										callvictim = v
									end
								elseif callvictim and v == callvictim and call.abilityPhase and SleepCheck("callstop") and Animations.getDuration(call) > 0.2 then
									me:Stop()
									Sleep(client.latency,"callstop")
								end
							end		
						end		
					else
						hero[v.handle].visible = false
					end
				end
			end
		end
	end
end

function Key(msg,code)
	if msg ~= KEY_UP or not PlayingGame() or client.chat then
		return
	end
	if code == toggleKey then
		active = not active
		return true
	elseif code == config.CallHotkey then
		callactive = not callactive
		return true
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

function BladeMail(hero,me,dmg)
	if hero:DoesHaveModifier("modifier_item_blade_mail_reflect") and me.health < me:DamageTaken(dmg, DAMAGE_PURE, hero) then
		return false
	end
	return true
end

function Moprhling(target,value)
	if target.classId == CDOTA_Unit_Hero_Morphling then
		if target:GetAbility(3) then
			local gainLVL = target:GetAbility(3).level
			local hp = {38,76,114,190}
			if target:DoesHaveModifier("modifier_morphling_morph_agi") and target.strength > 1 then
				return value*(0 - hp[gainLVL] + 1)
			elseif target:DoesHaveModifier("modifier_morphling_morph_str") and target.agility > 1 then
				return value*hp[gainLVL]
			end
		end
	end
	return 0
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Axe then 
			script:Disable() 
		else
			reg = true
			callactive = true
			active = true
			callvictim = nil
			cullvictim = nil
			victimhp = 0
			myhero = me.classId
			script:RegisterEvent(EVENT_FRAME,Tick)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(Load)
		end
	end
end

function GameClose()
	cullingblade.visible = false
	blink.visible = false
	hero = {}
	myhero = nil
	collectgarbage("collect")
	if reg then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)
