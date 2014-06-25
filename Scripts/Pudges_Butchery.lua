require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Hookkey", "D", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local hookkey = config.Hookkey

sleeptick = 0
sleeptickk = 0
targetHandle = nil
victimHandle = nil

local xx,yy = 10,client.screenSize.y/25.714
local myFont = drawMgr:CreateFont("Pudge","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Hook'em!",myFont);
local targetText = drawMgr:CreateText(-100,-5,-1,"",myFont);
local reg = nil
local active = true
local hookem = nil
DmgD = {225,375,525}
DmgR = {35,60,85,110}
DmgR2 = {7,12,17,22}
RangeH = {700,900,1100,1300}
SkillShot = {}
SkillShot.trackTable = {}
SkillShot.lastTrackTick = 0
SkillShot.currentTick = 0
targetText.visible = false

function HookKey(msg,code)
	if msg ~= KEY_UP or code ~= hookkey or client.chat then return end
	if active then
		if not hookem then
			hookem = true
			return true
		else
			hookem = nil
			return true
		end
	end
end

function Key(msg,code)	
    if msg ~= KEY_UP or code ~= key or client.chat then	return end

	if not active then
		active = true
		statusText.text = "  Hook'em!"
		return true
	else
		active = nil
		statusText.text = "   OFF!"
		return true
	end
end

function Autohook(tick)
	if not IsIngame() or client.console or client.paused then return end
	local me = entityList:GetMyHero()
	if not me then return end
	local hook = me:GetAbility(1)
	if hook.level > 0 and hookem then
	hookem = nil
		if me.alive then	
			local victim = entityList:GetEntity(victimHandle)		
			if victim and victim.visible and victim.alive and victim.health > 1 then
				if not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
					local move = victim.movespeed 
					local pos = victim.position	
					local mepos = me.position
					local distance = GetDistance2D(victim,me) 
					local project = 1600 
					local cast = 300
					local delay = client.latency
					local delay = cast + delay
					if not victim:CanMove() then
						local prediction = Vector(pos.x, pos.y, 0)
						me:SafeCastAbility(hook, prediction)
					else
						local delay1 = (delay + (distance*1000/project))
						local stage1 = SkillShot.PredictedXYZ(victim,delay1)
						if stage1 then
							local distance1 = math.sqrt(math.pow(mepos.x-stage1.x,2)+math.pow(mepos.y-stage1.y,2))
							local delay2 = delay + (distance1*1000/project)
							local stage2 = SkillShot.PredictedXYZ(victim,delay2)
							local i = 1
							while math.floor(distance1) ~= math.floor(math.sqrt(math.pow(mepos.x-stage1.x,2)+math.pow(mepos.y-stage1.y,2))) do
							stage1 = stage2
							distance1 = math.sqrt(math.pow(mepos.x-stage1.x,2)+math.pow(mepos.y-stage1.y,2))
							delay2 = delay + (distance1*1000/project)
							stage2 = SkillShot.PredictedXYZ(victim,delay2)
							i = i + 1
							end
							me:SafeCastAbility(hook,Vector(stage2.x,stage2.y,stage2.z))
						end
					end
				end
			end
		end
	end	
end

function Tick( tick )
	if tick < sleeptick or not IsIngame() or client.console or client.paused then return end
	
	sleeptick = tick + 30 + client.latency
	
	local me = entityList:GetMyHero()
	
	if not me then return end	
	
	local target = entityList:GetEntity(targetHandle)
	local distance = me:GetDistance2D(target)
	local minRange = 950
	local abilities = me.abilities
	local W = abilities[2]
	local R = abilities[4]
	
	if not target or not target.visible or not target.alive or not me.alive or not active or target:IsUnitState(LuaEntityNPC.STATE_MAGIC_IMMUNE) then
		targetHandle = nil
		targetText.visible = false
		statusText.text = "  Hook'em!"
		if W.toggled == true then
			me:SafeToggleSpell(W.name)
		end
		active = true
		script:UnregisterEvent(Tick)
		return
	end
	
	if W.level > 0 and W.toggled == false then
		if distance <= 250 then
			me:SafeToggleSpell(W.name)
		end
	end
	
	if distance > minRange then
		targetHandle = nil
		targetText.visible = false
		statusText.text = "  Hook'em!"
		if W.toggled == true then
			me:SafeToggleSpell(W.name)
		end
		active = true
		script:UnregisterEvent(Tick)
		return
	end
	
	local urn = me:FindItem("item_urn_of_shadows")
	local aga = me:FindItem("item_ultimate_scepter")
	
	if urn and urn.charges > 0 and urn.state == -1 and not target:DoesHaveModifier("modifier_item_urn_damage")and not aga and R.level > 0 and R.cd < 27 and R.cd ~= 0 and not me:IsChanneling() then 
		if target.health > (DmgD[R.level] * (1 - target.magicDmgResist)) or CanEscape(target) then
			me:SafeCastItem(urn.name,target)
		elseif target.health < (DmgD[R.level] * (1 - target.magicDmgResist)) and R.state ~= LuaEntityAbility.STATE_READY or CanEscape(target) then
			me:SafeCastItem(urn.name,target)
		end
	end
	
	if urn and urn.charges > 0 and urn.state == -1 and not target:DoesHaveModifier("modifier_item_urn_damage") and aga and R.level > 0 and R.cd < 27 and R.cd ~= 0 and not me:IsChanneling() then
		if target.health > (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) or CanEscape(target) then
			me:SafeCastItem(urn.name,target)
		elseif target.health < (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) and R.state ~= LuaEntityAbility.STATE_READY or CanEscape(target) then
			me:SafeCastItem(urn.name,target)
		end
	end
	if R.level > 0 and R.state == LuaEntityAbility.STATE_READY and (target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)*3) or CanEscape(target) then 
		me:SafeCastSpell(R.name,target)
	end
	if R.cd > 0 and not me:IsChanneling() then
		if distance > 150 and (target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)) then
			me:Move(target.position)
		else
		me:Attack(target)
		end
	end
end

function SkillShot.__Track()
	local all = entityList:GetEntities({type = TYPE_HERO})
	for i,v in ipairs(all) do
		if SkillShot.trackTable[v.handle] == nil and v.alive and v.visible then
			SkillShot.trackTable[v.handle] = {nil,nil,nil,v,nil}
		elseif SkillShot.trackTable[v.handle] ~= nil and (not v.alive or not v.visible) then
			SkillShot.trackTable[v.handle] = nil
		elseif SkillShot.trackTable[v.handle] then
			if SkillShot.trackTable[v.handle].last ~= nil then
				SkillShot.trackTable[v.handle].speed = (v.position - SkillShot.trackTable[v.handle].last.pos)/(SkillShot.currentTick - SkillShot.trackTable[v.handle].last.tick)
			end
			SkillShot.trackTable[v.handle].last = {pos = v.position, tick = SkillShot.currentTick}
		end
	end
end

function SkillShot.PredictedXYZ(t,delay)
	if t.CanMove and not t:CanMove() then
		return Vector(t.x,t.y,0)
	elseif SkillShot.trackTable[t.handle] and SkillShot.trackTable[t.handle].speed then
		local v = t.position + SkillShot.trackTable[t.handle].speed * delay
		return Vector(v.x,v.y,0)
	end
end

function target(tick)
	if not IsIngame() or client.console then return end
	
	local me = entityList:GetMyHero()
	
	if not me then return end
	
	SkillShot.currentTick = tick
	if tick > SkillShot.lastTrackTick + 50 then
		SkillShot.__Track()
		SkillShot.lastTrackTick = tick 	
	end
	
	local offset = me.healthbarOffset
	
	statusText.entity = me
	statusText.entityPosition = Vector(0,0,offset)
	targetText.entity = me
	targetText.entityPosition = Vector(0,0,offset)
		
	if me.classId ~= CDOTA_Unit_Hero_Pudge then
		targetText.visible = false
		statusText.visible = false
		script:Disable()
		return
	end

	if active then	
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
			if v.team ~= me.team then
				local victimm = targetFind:GetLowestEHP(1325)
				if victimm and victimm.visible and victimm.alive then
				local distance = GetDistance2D(victimm,me) 
					if distance < 1325 then
						victimHandle = victimm.handle
						statusText.text = "Hook: " .. client:Localize(victimm.name)
					end
				else
					statusText.text = "  Hook'em!"
				end
				if v:DoesHaveModifier("modifier_pudge_meat_hook") then
					targetHandle = v.handle
					targetText.visible = true
					targetText.text = "Eating " .. client:Localize(v.name) .. ". Press " .. string.char(key) .. " to cancel."
					script:RegisterEvent(EVENT_TICK,Tick)
				end
			end
		end
	end
end

function AutoDeny(tick)
	if tick < sleeptickk and not IsIngame() or client.console or client.paused then return end
	
	sleeptickk = tick + 50 + client.latency
	
	local me = entityList:GetMyHero()

	if not me or not me.alive then return end
	
	local rot = me:GetAbility(2)
	
	for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
		if v.team ~= me.team then
			local distance = GetDistance2D(v,me)
			local projectile = entityList:GetProjectiles({target=me, source=v})
			if v:IsRanged() then
				if projectile and distance <= (v.attackRange + 50) then
					for k,z in ipairs(projectile) do
						if me.health <= (DmgR2[rot.level]*3*(1 - me.magicDmgResist)) then
							if rot.toggled == false then
								me:SafeToggleSpell(rot.name)
							end
						end
					end
				end
			else
				if distance <= (v.attackRange + 50) and me.health <= (DmgR2[rot.level]*3*(1 - me.magicDmgResist)) then
					if rot.toggled == false then
						me:SafeToggleSpell(rot.name)
					end
				end
			end
		end
	end
end

function CanEscape(who)
	local me = entityList:GetMyHero()
	local abilities = me.abilities
	local W = abilities[2]
	wID = who.classId
	if (who.health > DmgR[W.level]) and (wID == CDOTA_Unit_Hero_Anti_Mage or wID == CDOTA_Unit_Hero_Mirana or wID == CDOTA_Unit_Hero_Queen_of_Pain or wID == CDOTA_Unit_Hero_Windrunner or wID == CDOTA_Unit_Hero_Shredder or wID == CDOTA_Unit_Hero_Centaur or wID == CDOTA_Unit_Hero_Earth_Spirit or wID == CDOTA_Unit_Hero_Ember_Spirit or wID == CDOTA_Unit_Hero_Storm_Spirit or who:FindItem("item_force_staff") or who.movespeed > 480) then
		return true
	else
		return	false
	end
end


function GameClose()
	statusText.visible = false
	targetText.visible = false
	active = nil
end

function Load()
	targetText.visible = false
	statusText.visible = true
	statusText.text = "  Hook'em!"
	active = true
end


script:RegisterEvent(EVENT_TICK,target)
script:RegisterEvent(EVENT_TICK,Autohook)
script:RegisterEvent(EVENT_TICK,AutoDeny)
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_KEY,HookKey)
