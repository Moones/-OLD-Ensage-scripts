require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Hookkey", "D", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local hookkey = config.Hookkey

sleeptick = 0
targetHandle = nil

local xx,yy = 10,client.screenSize.y/25.714
local myFont = drawMgr:CreateFont("Pudge","Tahoma",14,550)
local statusText = drawMgr:CreateText(xx,yy,-1,"Pudge Script: ON",myFont);
local targetText = drawMgr:CreateText(xx,yy+15,-1,"",myFont);
local reg = nil
local active = true
DmgD = {225,375,525}


targetText.visible = false

function Key(msg,code)

    if msg ~= KEY_UP or code ~= key or client.chat then	return end

	if not active then
		active = true
		statusText.text = "Pudge Script: ON"
		return true
	else
		active = nil
		statusText.text = "Pudge Script: OFF"
		return true
	end

end

--[[ function Autohook(msg,code)
	if msg ~= KEY_UP or code ~= hookkey or client.chat then	return end
	
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = SmartGetDmg(COMPLEX,Spell.level,me,damage,adamage,id)
		local DmgT = GetDmgType(Spell,tdamage)
		local CastPoint = Spell:GetCastPoint(Spell.level)+client.latency/1000
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),illusion=false})			
			for i,v in ipairs(enemies) do
				if v.healthbarOffset ~= -1 then
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if v.visible and v.alive and v.health > 1 then
						hero[v.handle].visible = draw
						local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))
						local DmgF = math.floor(v.health - v:DamageTaken(DmgS,DmgT,me) + CastPoint*v.healthRegen)
						hero[v.handle].text = " "..DmgF
						if activ then
							if DmgF < 0 and KSCanDie(v,me) and (not me:IsMagicDmgImmune() and NotDieFromSpell(Spell,v,me) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and NotDieFromBM(v,me,DmgS)) then
								local move = v.movespeed local pos = v.position	local distance = GetDistance2D(v,me)
								if v.activity == LuaEntityNPC.ACTIVITY_MOVE and v:CanMove() then																		
									local range = Vector(pos.x + move * (distance/(project * math.sqrt(1 - math.pow(move/project,2))) + cast) * math.cos(v.rotR), pos.y + move * (distance/(project * math.sqrt(1 - math.pow(move/project,2))) + cast) * math.sin(v.rotR), pos.z)
									if GetDistance2D(me,range) < Spell.castRange + 25 then									
										me:SafeCastAbility(Spell,range)	break
									end
								elseif distance < Spell.castRange + 25 then
									me:SafeCastAbility(Spell,Vector(pos.x + move * 0.05 * math.cos(v.rotR), pos.y + move* 0.05 * math.sin(v.rotR), pos.z)) break
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
end ]]--

function Tick( tick )
	if tick < sleeptick or not IsIngame() or client.console or client.paused then
		return
	end

	sleeptick = tick + 100
	
	local me = entityList:GetMyHero()
	local player = entityList:GetMyPlayer()
	
	if not me or not player then
		return
	end	
	
	local target = entityList:GetEntity(targetHandle)
	local distance = me:GetDistance2D(target)
	local minRange = 950
	
	if not target or not target.visible or not target.alive or not me.alive or not active or target:IsUnitState(LuaEntityNPC.STATE_MAGIC_IMMUNE) then
		targetHandle = nil
		targetText.visible = false
		statusText.text = "Pudge Script: ON"
		active = true
		script:UnregisterEvent(Tick)
		return
	end
	
	local abilities = me.abilities
	local W = abilities[2]
	local R = abilities[4]
	
	if W.level > 0 and W.toggled == false then
		if distance <= 250 then
			me:SafeToggleSpell(W.name)
		end
	end
	
	if distance > minRange then
		targetHandle = nil
		targetText.visible = false
		statusText.text = "Pudge Script: ON"
		active = true
		script:UnregisterEvent(Tick)
		return
	end
	
	local urn = me:FindItem("item_urn_of_shadows")
	local aga = me:FindItem("item_ultimate_scepter")
	
	if urn and urn.charges > 0 and urn.state == -1 and target:DoesHaveModifier("modifier_item_urn_damage") == false and not aga and R.level > 0 and R.cd > 0 and me:IsChanneling() == false then 
		if target.health > (DmgD[R.level] * (1 - target.magicDmgResist)) then
			me:SafeCastItem(urn.name,target)
		elseif target.health < (DmgD[R.level] * (1 - target.magicDmgResist)) and R.state ~= LuaEntityAbility.STATE_READY then
			me:SafeCastItem(urn.name,target)
		end
	end
	
	if urn and urn.charges ~= 0 and urn.state == -1 and not target:DoesHaveModifier("modifier_item_urn_damage") and aga and R.level > 0 and R.cd > 0 and me:IsChanneling() == false then
		if target.health > (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) then
			me:SafeCastItem(urn.name,target)
		elseif target.health < (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) and R.state ~= LuaEntityAbility.STATE_READY then
			me:SafeCastItem(urn.name,target)
		end
	end
	
	if R.level > 0 and R.state == LuaEntityAbility.STATE_READY and (target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)*3) then 
		me:SafeCastSpell(R.name,target)
	end
	
	if R.cd > 0 and me:IsChanneling() == false then
		if distance > 150 and (target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)) then
			me:Move(target.position)
		else
		me:Attack(target)
		end
	end
end

function target(tick)
	if not IsIngame() or client.console then
		return
	end
	
	local me = entityList:GetMyHero()
	
	if not me then
		return
	end
	
	if not reg then
		script:RegisterEvent(EVENT_KEY,Key)
		reg = true
		statusText.visible = true
	end
		
	if me.classId ~= CDOTA_Unit_Hero_Pudge then
		targetText.visible = false
		statusText.visible = false
		script:Disable()
		return
	end
	
	if active then
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
			if v.team ~= me.team then
				if v:DoesHaveModifier("modifier_pudge_meat_hook") then
					targetHandle = v.handle
					targetText.visible = true
					targetText.text = "Killing " .. client:Localize(v.name)
					script:RegisterEvent(EVENT_TICK,Tick)
				end
			end
		end
	end
end

function GameClose()
	if reg then
		script:UnregisterEvent(EVENT_KEY,Key)
		reg = nil
	end
	
	statusText.visible = false
	targetText.visible = false
	active = nil
end

function Load()
	targetText.visible = false
	statusText.visible = true
	statusText.text = "Pudge Script: ON"
	active = true
end


script:RegisterEvent(EVENT_TICK,target)
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_LOAD,Load)
