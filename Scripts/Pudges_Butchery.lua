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
targetHandle = nil local hookem = nil local manualselection = false local active = true local victim = nil local blindxyz = nil

local myFont = drawMgr:CreateFont("Pudge","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Hook'em!",myFont);
local targetText = drawMgr:CreateText(-100,-5,-1,"",myFont);
local victimText = drawMgr:CreateText(-40,-5,-1,"",myFont);

local DmgD = {225,375,525} local DmgR = {35,60,85,110} local DmgR2 = {7,12,17,22} local RangeH = {700,900,1100,1300}
targetText.visible = false victimText.visible = false

function Key(msg,code)	
    if msg ~= KEY_UP or client.chat then return end
	if code == togglekey then
		if not active then
			active = true
			statusText.text = "  Hook'em!"
		else
			active = nil
			statusText.text = "   OFF!"
			victimText.visible = false
		end
	elseif code == hookkey then
		if active and ((victim and victim.visible) or blindxyz) then
			hookem = not hookem
		end
	elseif code == manualtogglekey then
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

function Main(tick)
	if not IsIngame() or client.console or not SleepCheck() then return end
	
	local me = entityList:GetMyHero()
	
	if not me then return end
	
	if me.classId ~= CDOTA_Unit_Hero_Pudge then
		targetText.visible = false
		statusText.visible = false
		script:Disable()
		return
	end
	
	local offset = me.healthbarOffset
	
	if not statusText.entity then
		statusText.entity = me
		statusText.entityPosition = Vector(0,0,offset)
	end
	
	if not targetText.entity then
		targetText.entity = me
		targetText.entityPosition = Vector(0,0,offset)
	end
	
	local hook = me:GetAbility(1)
	
	if active then
	
		if hook.state == LuaEntityAbility.STATE_READY then
			victimText.visible = true
		else
			victimText.visible = false
		end
		
		if hook.level > 0 then
			victim = targetFind:GetLowestEHP(RangeH[hook.level] + 100, magic)
			if manualselection then
				victim = targetFind:GetClosestToMouse(100)
				statusText.text = "Hook'em - Manual!"
			end
			if victim then
				local distance = GetDistance2D(victim, me)
				if distance <= RangeH[hook.level] + 100 and victim.visible then
					statusText.text = "Hook: " .. client:Localize(victim.name)
					victimText.text = "  Hook'em!"
					victimText.entity = entityList:GetEntity(victim.handle)
					victimText.entityPosition = Vector(0,0,entityList:GetEntity(victim.handle).healthbarOffset)
					if hookem and me.alive then hookem = nil
						if not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
							local speed = 1600 
							local delay = (300+client.latency)
							local xyz = SkillShot.BlockableSkillShotXYZ(me,victim,speed,delay,100,true)
							if xyz then	
								me:SafeCastAbility(hook, xyz)
								Sleep(250)
							end
						end
					end
				end
			else
				if not manualselection then
					statusText.text = "  Hook'em!"
					victimText.visible = false
				else
					statusText.text = "Hook'em - Manual!"
					victimText.visible = false
				end
			end
		end
		
		local rot = me:GetAbility(2)
		
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true})) do	
			if v.team ~= me.team and not v:IsIllusion() then
				if v:DoesHaveModifier("modifier_pudge_meat_hook") then
					targetHandle = v.handle
					targetText.visible = true
					targetText.text = "Eating " .. client:Localize(v.name) .. ". Press " .. string.char(togglekey) .. " to cancel."
					script:RegisterEvent(EVENT_TICK,Combo)
					if targetHandle == v.handle then
						victimText.visible = false
					end
				end	
				if rot.level > 0 then
					
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
				if not v.visible and hook.level > 0 and me.alive and not victim then
					local speed = 1600 
					local castPoint = (0.35 + client.latency/1000)
					blindxyz = SkillShot.BlindSkillShotXYZ(me,v,speed,castPoint)
					if blindxyz and blindxyz:GetDistance2D(me) <= RangeH[hook.level] + 100 then 
						statusText.text = "Hook'em - BLIND!"
						if hookem then hookem = nil
							me:SafeCastAbility(hook, blindxyz)
							Sleep(250)
						end
					end
				end
			end
		end
	end
end

function Combo(tick)
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
	
	if not target or not target.visible or not target.alive or not me.alive or not active or target:IsUnitState(LuaEntityNPC.STATE_MAGIC_IMMUNE) or distance > minRange then
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

function CanEscape(who)
	local me = entityList:GetMyHero()
	local W = me:GetAbility(2)
	wID = who.classId
	if who and wID and W.level > 0 then
		if (who.health > DmgR[W.level]) and (wID == CDOTA_Unit_Hero_Anti_Mage or wID == CDOTA_Unit_Hero_Mirana or wID == CDOTA_Unit_Hero_Queen_of_Pain or wID == CDOTA_Unit_Hero_Windrunner or wID == CDOTA_Unit_Hero_Shredder or wID == CDOTA_Unit_Hero_Centaur or wID == CDOTA_Unit_Hero_Earth_Spirit or wID == CDOTA_Unit_Hero_Ember_Spirit or wID == CDOTA_Unit_Hero_Storm_Spirit or who:FindItem("item_force_staff") or who.movespeed > 480) then
			return true
		else
			return	false
		end
	end
end

script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_KEY,Key)
