require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")

local config = ScriptConfig.new()
config:SetParameter("ToggleKey", "D", config.TYPE_HOTKEY)
config:SetParameter("ComboKey", "F", config.TYPE_HOTKEY)
config:Load()

local toggleKey = config.ToggleKey
local combokey = config.ComboKey

local hero = {} local castQueue = {} local reg = false
local active = true local myhero = nil local combo = false local victim = nil local victimHandle = nil

sleeptick = 0

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor)
local avalanche = drawMgr:CreateRect(-45,-70,20,20,0x000000ff) avalanche.visible = false
local toss = drawMgr:CreateRect(-25,-70,20,20,0x000000ff) toss.visible = false
local blink = drawMgr:CreateRect(-5,-70,35,20,0x000000ff) blink.visible = false
local aga = drawMgr:CreateRect(20,-70,35,20,0x000000ff) aga.visible = false

function Tick(tick)
	if tick < sleeptick or client.paused or not IsIngame() or client.console then return end 
	local me = entityList:GetMyHero() if not me then return end
	local ID = me.classId if ID ~= myhero then GameClose() end

	if not avalanche.entity then avalanche.entity = me avalanche.entityPosition = Vector(0,0,me.healthbarOffset) end
	if not toss.entity then toss.entity = me toss.entityPosition = Vector(0,0,me.healthbarOffset) end
	if not blink.entity then blink.entity = me blink.entityPosition = Vector(0,0,me.healthbarOffset) end
	if not aga.entity then aga.entity = me aga.entityPosition = Vector(0,0,me.healthbarOffset) end
	
	avdamage = {200,360,520,600}
	todamage = {75,150,225,300}
	ultibonus = {1.35,1.50,1.65}
	agabonus = {1.50,1.65,1.80}
	
	local aval = me:GetAbility(1)
	local tos = me:GetAbility(2)
	local grow = me:GetAbility(4)
	local Blink = me:FindItem("item_blink")
	
	if aval.level > 0 and tos.level > 0 then	
	
		avalanche.textureId = drawMgr:GetTextureId("NyanUI/Spellicons/tiny_avalanche") avalanche.visible = active
		toss.textureId = drawMgr:GetTextureId("NyanUI/Spellicons/tiny_toss") toss.visible = active
		
		if Blink then
			blink.textureId = drawMgr:GetTextureId("NyanUI/items/blink") blink.visible = active
		else
			blink.visible = false
		end
		
		local Dmg = avdamage[aval.level]+(todamage[tos.level]*1.2)
		
		if grow.level > 0 then
			Dmg = avdamage[aval.level]+(todamage[tos.level]*ultibonus[grow.level])
		end
		
		if me:AghanimState() then		
			Dmg = avdamage[aval.level]+(todamage[tos.level]*agabonus[grow.level])
			aga.textureId = drawMgr:GetTextureId("NyanUI/items/ultimate_scepter") aga.visible = active
		end
		
		for i=1,#castQueue,1 do
			local v = castQueue[1]
			table.remove(castQueue,1)
			local ability = v[2]
			if type(ability) == "string" then
				ability = me:FindItem(ability)
			end
			if ability and me:SafeCastAbility(ability,v[3],false) then
				sleeptick = tick + v[1]
				return
			end
		end
		
		local Type = DAMAGE_MAGC
		local Range = 276.5625
		local RangeB = 1500

		local CastPoint = aval:GetCastPoint(aval.level)+tos:GetCastPoint(tos.level)+client.latency/1000
		
		if not me:IsChanneling() then
		
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),illusion=false})
			
			for i,v in ipairs(enemies) do
			
				if v.healthbarOffset ~= -1 then
				
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(-45,-55, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					
					if me.alive and active then
						if v.visible and v.alive and v.health > 0 then
						
							hero[v.handle].visible = active
							local combodamage = math.floor(v:DamageTaken(Dmg,Type,me))
							local healthtokill = math.floor(v.health - combodamage + CastPoint*v.healthRegen+Moprhling(v,CastPoint))
							hero[v.handle].text = "Health to kill: "..healthtokill
							if healthtokill < 0 or combo then 
								if combo then
									combo = false
								else
									victim = v
								end
								if me:IsMagicDmgImmune() or ((NetherWard(aval,victim,me) and NetherWard(tos,victim,me)) and not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and BladeMail(victim,me,combodamage)) and aval.state == LuaEntityAbility.STATE_READY and tos.state == LuaEntityAbility.STATE_READY then
									
									local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, victim))) - 0.69, 0)/(0.5*(1/0.03)))*1000 + client.latency
									if GetDistance2D(me,victim) <= RangeB and GetDistance2D(me,victim) > Range and (Blink and Blink.state == -1) then
										
										if GetDistance2D(me,victim) >= 1200 then
											
											local poss = (victim.position - me.position) * 1100 / GetDistance2D(me,victim) + me.position
											table.insert(castQueue,{turn,Blink,poss})
											
										else
											
											table.insert(castQueue,{turn,Blink,victim.position})	
											
										end
										
										table.insert(castQueue,{100,aval,victim.position})
										table.insert(castQueue,{200,tos,victim}) break
										
									elseif GetDistance2D(me,victim) <= Range then
									
										table.insert(castQueue,{turn,aval,victim.position})
										table.insert(castQueue,{100,tos,victim}) break
										
									end
								end
							end
						else
							hero[v.handle].visible = false
						end
					else
					
						hero[v.handle].visible = false
						avalanche.visible = false
						toss.visible = false
						blink.visible = false
						aga.visible = false
						
					end
				end
			end
		end
	end
end

function Key(msg,code)
	if client.chat or msg ~= KEY_UP or not IsIngame() then return end
	
	if code == toggleKey then
	
		active = not active
		return true
	
	elseif code == combokey then
		
		local victimm = targetFind:GetLowestEHP(1500, magic)
		
		if not victimm or victimm:IsUnitState(LuaEntityNPC.STATE_MAGIC_IMMUNE) then
			victimHandle = nil
			return
		end

		victimHandle = victimm.handle
		victim = entityList:GetEntity(victimHandle)
		combo = true
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
		local gainLVL = target:GetAbility(3).level
		local hp = {38,76,114,190}
		if target:DoesHaveModifier("modifier_morphling_morph_agi") and target.strength > 1 then
			return value*(0 - hp[gainLVL] + 1)
		elseif target:DoesHaveModifier("modifier_morphling_morph_str") and target.agility > 1 then
			return value*hp[gainLVL]
		end
	end
	return 0
end

function FindAngleBetween(first, second)

	xAngle = math.deg(math.atan(math.abs(second.position.x - first.position.x)/math.abs(second.position.y - first.position.y)))

	if first.position.x <= second.position.x and first.position.y >= second.position.y then

		return 90 - xAngle

	elseif first.position.x >= second.position.x and first.position.y >= second.position.y then

		return xAngle + 90

	elseif first.position.x >= second.position.x and first.position.y <= second.position.y then

		return 90 - xAngle + 180

	elseif first.position.x <= second.position.x and first.position.y <= second.position.y then

		return xAngle + 90 + 180

	end

	return nil

end

function FindAngleR(entity)
	if entity.rotR < 0 then
		return math.abs(entity.rotR)
	else
		return 2 * math.pi - entity.rotR
	end
end

function Load()
	if PlayingGame() then
	
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Tiny then 
			script:Disable() 
			
		else
		
			reg = true
			active = true
			combo = false
			victim = nil 
			victimHandle = nil
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(Load)
			
		end
	end
end

function GameClose()

	avalanche.visible = false
	toss.visible = false
	blink.visible = false
	aga.visible = false
	hero = {}
	myhero = nil
	active = true
	combo = false
	victim = nil 
	victimHandle = nil
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
