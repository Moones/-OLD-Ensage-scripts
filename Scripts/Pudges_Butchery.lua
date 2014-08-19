--[[
	-------------------------------------
	| Pudge's Butchery Script by Moones |
	-------------------------------------
	========== Version 1.7.1 ============
	 
	Description:
	------------
	
		Autohook with prediction:
			- When hotkey pressed Pudge will auto hook enemy whithin hook range and with lowest HP.
		Autocombto after a succesfull hook:
			- Pudge will auto urn+rot+ult enemy.
			- Pudge will not use ulti when the hero is 3 hits away from death.
			- Pudge will not use urn when enemy will die from ulti.
			- Pudge will use both urn and ulti when enemy has escape ability/item.
			- If enemy use cyclone after being hooked, Pudge will automaticly do the combo after It lands.
			- After ult Pudge will chase enemy and when its one hit away from death he will chop'em!
			- If enemy escapes from you to more than 950 range, the combo will automaticly stop.
		Autodeny with Rot when:
			- Ranged enemy shooted to Pudge or melee enemy is in range to attack and Pudge's health <= than 3 ticks of Rot damage(one tick procs every 0.2 secs)
	   
	Changelog:
	----------
	
		Update 1.7.1:
			Updated with new Ensage events (EVENT_MODIFIER_ADD, EVENT_MODIFIER_REMOVE). 
			That ensures to detect succesfull hook on minimum range and is also faster.

		Update 1.7b:
			Added immediate Auto Rot activation after hook, so you prevent Rubcik from stealing your Hook.
			Increased speed of combo.
			Pudge will now Automaticly HoldPosition after a succesfull hook to ensure instant Dismember after enemy lands.

		Update 1.7a:
			Fixed not hooking into fog.

		Update 1.7:
			Added Blind Prediction - when enemy goes to fog or becomes invisible, Hook'em BLIND sign will appear and when the hotkey is pressed Pudge will hook with prediction based on enemy last facing angle and movement speed. [/FONT][COLOR=#333333][FONT=Tahoma]If you also want to see what is prediction based on and current predicted enemy position enable with this script [/FONT][/COLOR][URL="http://www.zynox.net/forum/threads/886-Blind-Prediction"]Blind Prediction[/URL][COLOR=#333333][FONT=Tahoma] script[/FONT][/COLOR][FONT=Tahoma]

		Update 1.6:
			Improved prediction, fixed hook being too distant, updated SkillShot lib

		Update 1.5:
			Added manual target selection option. When G hotkey is pressed you are able to manualy select target with mouse hover.

		Update 1.4:
			Now requires https://github.com/Rulfy/ensage-wip/blob/master/Libraries/VectorOp.lua and reworked https://github.com/Moones/Ensage-scripts/blob/master/Libraries/SkillShot.lua libraries
			Improved prediction

		Update 1.3:
			Implemented stuff from old Skillshot library = prediction is now way better. 
			Fixed bug where urn was used during ulti.

		Update 1.2: 
			Added AutoDeny when ranged enemy shooted to Pudge or melee enemy is in range to attack and Pudge's health <= than 3 ticks of Rot damage(one tick procs every 0.2 secs)

		Update 1.1c:
			Pudge will now use urn immediately when enemy is flying towards him. 
			Added checking if enemy has escape abilities/items and in that case use urn and ulti even if he can die from 3 hits.

		Update 1.1b:
			Added Auto hook with basic prediction which will hook hero with lowest HP in range, its in beta stage so feel free to report bugs.
			Script now requires https://github.com/Rulfy/ensage-wip/blob/master/Libraries/TargetFind.lua library.
]]--

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
local sleeptick = 0 local targetHandle = nil local manualselection = false local active = true local victim = nil local blindxyz = nil local rottoggled = false local count = 0 local hooked = false local urned = false local reg = false

local myFont = drawMgr:CreateFont("Pudge","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Hook'em!",myFont);
local targetText = drawMgr:CreateText(-100,-5,-1,"",myFont);
local victimText = drawMgr:CreateText(-40,-5,-1,"",myFont);

local DmgD = {225,375,525} local DmgR = {35,60,85,110} local DmgR2 = {7,12,17,22} local RangeH = {700,900,1100,1300}
targetText.visible = false victimText.visible = false

function Key(msg,code)	
    if client.chat or not PlayingGame() then return end
	if msg == KEY_UP then
		if code == togglekey then
			if not active then
				active = true
				statusText.text = "  Hook'em!"
			else
				active = false
				if not targetHandle then
					statusText.text = "   OFF!"
					victimText.visible = false
				end
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
	elseif msg == RBUTTON_UP then
		if targetHandle then
			if count == 0 then
				count = 1
			elseif count == 1 then
				count = 2
			end
		end
	end
end

function Main(tick)
	if not PlayingGame() or client.console then return end	
	local me = entityList:GetMyHero()

	local hook = me:GetAbility(1)
	local rot = me:GetAbility(2)	
	
	if active then
		if hook.abilityPhase then
			if rot.level > 0 and rot.toggled == false and not rot.abilityPhase and not rottoggled and SleepCheck("rot") then
				rottoggled = true
				me:SafeToggleSpell(rot.name)
				Sleep(250 + client.latency, "rot")
			end
		else
			rottoggled = false
		end
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true})) do	
			if v.team ~= me.team and not v:IsIllusion() then
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
					local blindvictim
					if not blindvictim or v.health < blindvictim.health or blindvictim.visible then
						blindvictim = v
					end
					blindxyz = SkillShot.BlindSkillShotXYZ(me,blindvictim,speed,castPoint)
					if blindxyz and blindxyz:GetDistance2D(me) <= RangeH[hook.level] + 100 then 
						statusText.text = "Hook'em - BLIND!"
						if IsKeyDown(hookkey) and SleepCheck("hook") and not client.chat then
							me:SafeCastAbility(hook, blindxyz)
							Sleep(100+client.latency,"hook")
						end
					end
				else
					blindvictim = nil
				end
			end
		end
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
					if IsKeyDown(hookkey) and me.alive and not client.chat then
						if not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
							local speed = 1600 
							local delay = (300+client.latency)
							local xyz = SkillShot.BlockableSkillShotXYZ(me,victim,speed,delay,100,true)
							if xyz and SleepCheck("hook") then	
								me:SafeCastAbility(hook, xyz)
								Sleep(100+client.latency,"hook")
							end
						end
					end
				end
			elseif not blindvictim then
				if not manualselection then
					statusText.text = "  Hook'em!"
					victimText.visible = false
				else
					statusText.text = "Hook'em - Manual!"
					victimText.visible = false
				end
			end
		end
	end
end

function Combo(tick)
	if tick < sleeptick or not PlayingGame() or client.console or client.paused then return end
	sleeptick = tick + 30 + client.latency
	local me = entityList:GetMyHero()
	
	local target = entityList:GetEntity(targetHandle)
	local distance = me:GetDistance2D(target)
	local minRange = 950
	local abilities = me.abilities
	local W = abilities[2]
	local R = abilities[4]
	
	if not target or not target.alive or not me.alive or not active or target:IsUnitState(LuaEntityNPC.STATE_MAGIC_IMMUNE) or (distance > minRange and not hooked) or count == 2 then
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
		count = 0
		script:UnregisterEvent(Combo)
		return
	end
	
	if W.level > 0 and W.toggled == false and not W.abilityPhase and not rottoggled and SleepCheck("rot") then
		if distance <= 250 then
			me:SafeToggleSpell(W.name)
			Sleep(250 + client.latency, "rot")
		end
	end
		
	local urn = me:FindItem("item_urn_of_shadows")
	local aga = me:FindItem("item_ultimate_scepter")
	
	if not target:DoesHaveModifier("modifier_item_urn_damage") then
		urned = false
	else
		urned = true
	end
		
	if urn and urn.charges > 0 and urn.state == -1 and not urned and not me:IsChanneling() and ((R.level > 0 and not R.abilityPhase) or R.level == 0) then 
		if not aga then 
			if target.health > (DmgD[R.level] * (1 - target.magicDmgResist)) or CanEscape(target) then
				me:SafeCastItem(urn.name,target)
			elseif target.health < (DmgD[R.level] * (1 - target.magicDmgResist)) and R.state ~= LuaEntityAbility.STATE_READY or CanEscape(target) then
				me:SafeCastItem(urn.name,target)
			end
		else
			if target.health > (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) or CanEscape(target) then
				me:SafeCastItem(urn.name,target)
			elseif target.health < (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) and R.state ~= LuaEntityAbility.STATE_READY or CanEscape(target) then
				me:SafeCastItem(urn.name,target)
			end
		end
	end
	if not hooked or GetDistance2D(me, target) < 1600*(0.3 + client.latency/1000) then
		if R.level > 0 and R.state == LuaEntityAbility.STATE_READY and ((target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)*3) or CanEscape(target)) then 
			me:SafeCastSpell(R.name,target)
		elseif not me:IsChanneling() then
			if distance > 150 and (target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)) then
				me:Move(target.position)
			else
			me:Attack(target)
			end
		end
	else
		entityList:GetMyPlayer():HoldPosition()
	end
end

function CanEscape(who)
	local me = entityList:GetMyHero()
	local W = me:GetAbility(2)
	wID = who.classId
	if who and wID and W.level > 0 then
		if (who.health > DmgR[W.level]) and (wID == CDOTA_Unit_Hero_AntiMage or wID == CDOTA_Unit_Hero_Mirana or wID == CDOTA_Unit_Hero_QueenOfPain or wID == CDOTA_Unit_Hero_Windrunner or wID == CDOTA_Unit_Hero_Shredder or wID == CDOTA_Unit_Hero_Centaur or wID == CDOTA_Unit_Hero_EarthSpirit or wID == CDOTA_Unit_Hero_EmberSpirit or wID == CDOTA_Unit_Hero_StormSpirit or wID == CDOTA_Unit_Hero_Rubick or who:FindItem("item_force_staff") or who.movespeed > 480) then
			return true
		else
			return	false
		end
	end
end

function ModifierAdd(v,modifier)
	if not PlayingGame() or client.console then return end	
	local me = entityList:GetMyHero()
	if active then
		if modifier.name == "modifier_pudge_rot" and v.classId == me.classId then
			rottoggled = true
		elseif modifier.name == "modifier_pudge_meat_hook" then
			if v.hero and v.team ~= me.team and not v:IsIllusion() then
				targetHandle = v.handle
				targetText.visible = true
				targetText.text = "Eating " .. client:Localize(v.name) .. ". Press " .. string.char(togglekey) .. " to cancel."
				script:RegisterEvent(EVENT_TICK,Combo)
				if targetHandle == v.handle then
					victimText.visible = false
				end
				hooked = true
			end
		elseif modifier.name == "modifier_item_urn_damage" and targetHandle and targetHandle == v.handle then
			urned = true
		end
	end
end

function ModifierRemove(v,modifier)
	if not PlayingGame() or client.console then return end	
	local me = entityList:GetMyHero()
	if active then
		if modifier.name == "modifier_pudge_rot" and v.classId == me.classId then
			rottoggled = false
		elseif modifier.name == "modifier_pudge_meat_hook" and v.team == me:GetEnemyTeam() then
			hooked = false
		elseif modifier.name == "modifier_item_urn_damage" and targetHandle and targetHandle == v.handle then
			urned = false
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Pudge then 
			script:Disable()
		else
			targetHandle = nil
			manualselection = false
			local offset = me.healthbarOffset
			if not statusText.entity then
				statusText.entity = me
				statusText.entityPosition = Vector(0,0,offset)
			end
			if not targetText.entity then
				targetText.entity = me
				targetText.entityPosition = Vector(0,0,offset)
			end
			statusText.visible = true
			targetText.visible = false
			active = true
			victim = nil
			blindxyz = nil
			rottoggled = false
			count = 0
			hooked = false
			urned = false
			reg = true
			blindvictim = nil
			script:RegisterEvent(EVENT_TICK, Main)
			script:RegisterEvent(EVENT_KEY, Key)
			script:RegisterEvent(EVENT_MODIFIER_ADD, ModifierAdd)
			script:RegisterEvent(EVENT_MODIFIER_REMOVE, ModifierRemove)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	targetHandle = nil
	manualselection = false
	statusText.visible = false
	targetText.visible = false
	active = true
	victim = nil
	blindxyz = nil
	rottoggled = false
	count = 0
	hooked = false
	urned = false
	reg = true
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:UnregisterEvent(ModifierAdd)
		script:UnregisterEvent(ModifierRemove)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_TICK, Load)	
script:RegisterEvent(EVENT_CLOSE, Close)
