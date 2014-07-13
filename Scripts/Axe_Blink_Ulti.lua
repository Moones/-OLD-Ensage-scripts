require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "D", config.TYPE_HOTKEY)
config:Load()

local toggleKey = config.Hotkey

local hero = {} local reg = false
local active = true local myhero = nil

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor)
local cullingblade = drawMgr:CreateRect(-45,-70,20,20,0x000000ff) cullingblade.visible = false
local blink = drawMgr:CreateRect(-25,-70,35,20,0x000000ff) blink.visible = false

function Tick(tick)
	
	if not SleepCheck() then return end	Sleep(200)
	local me = entityList:GetMyHero()	
	if not me then return end
	local ID = me.classId
	if ID ~= myhero then GameClose() end

	cullingblade.entity = me 
	cullingblade.entityPosition = Vector(0,0,me.healthbarOffset)
	blink.entity = me 
	blink.entityPosition = Vector(0,0,me.healthbarOffset)
	damage = {250,350,450}
	adamage = {300,450,625}
	
	local Cullblade = me:GetAbility(4)
	local Blink = me:FindItem("item_blink")
	
	if Cullblade.level > 0 then
		cullingblade.textureId = drawMgr:GetTextureId("NyanUI/Spellicons/axe_culling_blade")
		cullingblade.visible = active
		if Blink then
			blink.textureId = drawMgr:GetTextureId("NyanUI/items/blink")
			blink.visible = active
		else
			blink.visible = false
		end
		local Dmg = damage[Cullblade.level]
		if me:AghanimState() then		
			Dmg = adamage[Cullblade.level]
		end
		local Type = DAMAGE_HPRM
		local Range = 400
		local RangeB = 1200
		local CastPoint = Cullblade:GetCastPoint(Cullblade.level)+client.latency/1000		
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam()})
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
							if healthtokill < 0 and GetDistance2D(me,v) < RangeB and GetDistance2D(me,v) > Range and (Blink and Blink.state == -1) then
								if me:IsMagicDmgImmune() or (NetherWard(Cullblade,v,me) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and BladeMail(v,me,culldamage)) then
									me:SafeCastItem(Blink.name,v.position)						
								end
							elseif healthtokill < 0 and GetDistance2D(me,v) < Range then
								if me:IsMagicDmgImmune() or (NetherWard(Cullblade,v,me) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and BladeMail(v,me,culldamage)) then
									me:SafeCastAbility(Cullblade,v)	break							
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
	if client.chat then return end
	if IsKeyDown(toggleKey) then
		active = not active
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
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
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
