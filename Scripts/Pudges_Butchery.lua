require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.SkillShot")
require("libs.VectorOp")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Hookkey", "D", config.TYPE_HOTKEY)
config:SetParameter("ManualtoggleKey", "G", config.TYPE_HOTKEY)
config:Load()

local togglekey = config.Hotkey local hookkey = config.Hookkey local manualtogglekey = config.ManualtoggleKey

sleeptick = 0 sleeptickk = 0
targetHandle = nil victimHandle = nil local hookem = nil local manualselection = nil local active = true 

local myFont = drawMgr:CreateFont("Pudge","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Hook'em!",myFont);
local targetText = drawMgr:CreateText(-100,-5,-1,"",myFont);
local victimText = drawMgr:CreateText(-40,-5,-1,"",myFont);

DmgD = {225,375,525} DmgR = {35,60,85,110} DmgR2 = {7,12,17,22} RangeH = {700,900,1100,1300}
targetText.visible = false victimText.visible = false

function Key(msg,code)	
    if client.chat then	return end
	if IsKeyDown(togglekey) then
		if not active then
			active = true
			statusText.text = "  Hook'em!"
		else
			active = nil
			statusText.text = "   OFF!"
			victimText.visible = false
		end
	end
	if IsKeyDown(hookkey) then
		if active then
			hookem = not hookem
		end
	end
	if IsKeyDown(manualtogglekey) then
		if active then
			if not manualselection then
				manualselection = true
				statusText.text = "Hook'em - Manual!"
			else
				manualselection = nil
				statusText.text = "  Hook'em!"
			end
		end
	end	
end

function Autohook(tick)
	if not IsIngame() or client.console or client.paused then return end
	local me = entityList:GetMyHero()
	if not me then return end
	local hook = me:GetAbility(1)
	if hook.level > 0 and hookem then
		hookem = nil
		if me.alive and victimHandle then		
			local victim = entityList:GetEntity(victimHandle)		
			if victim and victim.visible and victim.alive and victim.health > 1 then
				if not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
					local speed = 1600 
					local castPoint = 300
					local aoe = 100
					local delay = client.latency
					local distance = me:GetDistance2D(victim)
					local xyz = SkillShot.SkillShotXYZ(me,victim,(castPoint + delay),speed)
					if xyz and distance < 1350 then	
					me:SafeCastAbility(hook, xyz)
					Sleep(250)
					end
				end
			end
		end
	end	
end

function Combo( tick )
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
		if not manualselection then
			statusText.text = "  Hook'em!"
		else
			statusText.text = "Hook'em - Manual!"
		end
		if W.toggled == true then
			me:SafeToggleSpell(W.name)
		end
		active = true
		script:UnregisterEvent(Combo)
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
		if not manualselection then
			statusText.text = "  Hook'em!"
		else
			statusText.text = "Hook'em - Manual!"
		end
		if W.toggled == true then
			me:SafeToggleSpell(W.name)
		end
		active = true
		script:UnregisterEvent(Combo)
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

function tick(tick)
	if tick < sleeptickk and not IsIngame() or client.console then return end
	
	sleeptickk = tick + 50 + client.latency
	
	local me = entityList:GetMyHero()
	
	if not me then return end
	
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
	local huk = me:GetAbility(1)
	if huk.state == LuaEntityAbility.STATE_READY and active then
		victimText.visible = true
	else
		victimText.visible = false
	end
	for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
		if v.team ~= me.team then
			local victimm = nil
			if manualselection then
				victimm = targetFind:GetClosestToMouse(100)
			else
				victimm = targetFind:GetLowestEHP(1350, magic)
			end
			if victimm and victimm.visible and victimm.alive then
			victimText.entity = entityList:GetEntity(victimm.handle)
			victimText.entityPosition = Vector(0,0,entityList:GetEntity(victimm.handle).healthbarOffset)
			victimText.text = "  Hook'em!"
			local distance = GetDistance2D(victimm,me) 
				if distance < 1350 then
					victimHandle = victimm.handle
					if not manualselection and active then
						statusText.text = "Hook: " .. client:Localize(victimm.name)
					end
				end
			else
			victimText.visible = false
				if not manualselection and active then
					statusText.text = "  Hook'em!"
				else
					statusText.text = "Hook'em - Manual!"
				end
			end
			if v:DoesHaveModifier("modifier_pudge_meat_hook") and active then
				targetHandle = v.handle
				targetText.visible = true
				targetText.text = "Eating " .. client:Localize(v.name) .. ". Press " .. string.char(togglekey) .. " to cancel."
				script:RegisterEvent(EVENT_TICK,Combo)
				if targetHandle == victimHandle then
					victimText.visible = false
				end
			end
		end
	end
	local rot = me:GetAbility(2)
	if rot then
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
end

function CanEscape(who)
	local me = entityList:GetMyHero()
	local W = me:GetAbility(2)
	wID = who.classId
	if (who.health > DmgR[W.level]) and (wID == CDOTA_Unit_Hero_Anti_Mage or wID == CDOTA_Unit_Hero_Mirana or wID == CDOTA_Unit_Hero_Queen_of_Pain or wID == CDOTA_Unit_Hero_Windrunner or wID == CDOTA_Unit_Hero_Shredder or wID == CDOTA_Unit_Hero_Centaur or wID == CDOTA_Unit_Hero_Earth_Spirit or wID == CDOTA_Unit_Hero_Ember_Spirit or wID == CDOTA_Unit_Hero_Storm_Spirit or who:FindItem("item_force_staff") or who.movespeed > 480) then
		return true
	else
		return	false
	end
end

function Load()
	targetText.visible = false victimText.visible = false statusText.visible = true
	statusText.text = "  Hook'em!"
	targetHandle = nil victimHandle = nil local hookem = nil local manualselection = nil local active = true
end


script:RegisterEvent(EVENT_TICK,tick)
script:RegisterEvent(EVENT_TICK,Autohook)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_LOAD,Load)

