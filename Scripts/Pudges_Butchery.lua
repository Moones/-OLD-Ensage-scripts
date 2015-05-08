--<<Pudge's Butchery script by Moones version 1.9.3>>
--[[
	-------------------------------------
	| Pudge's Butchery Script by Moones |
	-------------------------------------
	=========== Version 1.9.3 ===========
	 
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
		Update 1.9.3:
			Added configs: AutoCombo, AutoUrn, AutoEthereal
			Function AutoEthereal now also killsteals.
			Fixed bug with ulti, it needs tests.
			
		Update 1.9.2:
			Little improve of PredictionGui.
			
		Update 1.9.1:
			Performance fix.
			
		Update 1.9:
			Increased accuracy a bit.
			Added PredictionGUI:
				Shows you prediction where hook will be casted.
				You can adjust prediction with your mouse if you put it near the victim.
				It will show you a range of where you are able to aim.
			
		Update 1.8.2:
			Fixed urning and using ethereal to cancel ulti. 
			Fixed not immediate ulti after close hook.
			
		Update 1.8.1:
			Hooking will now properly stop when hotkey is pressed or when StopKey is pressed
			Added HookTolerancy - higher number means less hook canceling but also means less accuracy. Tested with 2000 when it was not canceling anymore, so value less than 2000 is recommended.
	
		Update 1.8:
			Fixed inaccurate hook
			Added hook canceling
			Added auto urn to killable enemy
	
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
require("libs.Animations")
require("libs.AbilityDamage")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Hookkey", "D", config.TYPE_HOTKEY)
config:SetParameter("StopKey", "S", config.TYPE_HOTKEY)
config:SetParameter("ManualtoggleKey", "G", config.TYPE_HOTKEY)
config:SetParameter("HookTolerancy", 0)
config:SetParameter("PredictionGUI", true)
config:SetParameter("EnableMouseAdjusting", false)
config:SetParameter("BlindHooks", false)
config:SetParameter("HookCanceling", true)
config:SetParameter("AutoCombo", true)
config:SetParameter("AutoUrn", true)
config:SetParameter("AutoEthereal", true)
config:SetParameter("GuiSleep", 0)
config:Load()

local togglekey = config.Hotkey local hookkey = config.Hookkey local manualtogglekey = config.ManualtoggleKey
local sleeptick = 0 local targetHandle = nil local manualselection = false local active = true local victim = nil local xyz = nil local blindxyz = nil local rottoggled = false local count = 0 local hooked = false local urned = false local reg = false local ultied = nil
local eff = {} local guixyz = false local distxyz = nil local predxyz = nil local EthDmg = 0
local myFont = drawMgr:CreateFont("Pudge","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Hook'em!",myFont);
local targetText = drawMgr:CreateText(-100,-5,-1,"",myFont);
local victimText = drawMgr:CreateText(-40,-5,-1,"",myFont);

local DmgD = {225,375,525} local DmgR = {35,60,85,110} local DmgR2 = {7,12,17,22} local RangeH = {1000,1100,1200,1300}
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
					eff = {}
				end
			end
			if xyz then 
				xyz = nil
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
		local hook = entityList:GetMyHero():GetAbility(1)
		if hook and (((hook.abilityPhase and not SleepCheck("hook")) and (math.ceil(hook.cd) ~= math.ceil(hook:GetCooldown(hook.level)) or not SleepCheck("hook")))) then
			xyz = nil
			local prev = SelectUnit(me)
			entityList:GetMyPlayer():HoldPosition()
			SelectBack(prev)
			Sleep(client.latency + 200, "testhook")
			Sleep(client.latency + 300, "stop")
		end
		if targetHandle then
			local target = entityList:GetEntity(targetHandle)
			local player = entityList:GetMyPlayer()
			if target and player.orderId and player.orderPosition and player.orderPosition ~= Vector(0,0,0) and GetDistance2D(target,player.orderPosition) > 500 then
				if count == 0 then
					count = 1
				elseif count == 1 then
					count = 2
				end
			end
		end
	end
end

function Main(tick)
	if not PlayingGame() or client.console or not SleepCheck("stop") then return end	
	local me = entityList:GetMyHero()
	local player = entityList:GetMyPlayer()

	local hook = me:GetAbility(1)
	local rot = me:GetAbility(2)
	
	local offset = me.healthbarOffset
	statusText.entity = me
	statusText.entityPosition = Vector(0,0,offset)
	if not targetText.entity then
		targetText.entity = me
		targetText.entityPosition = Vector(0,0,offset)
	end
	if active and me.alive then
		if config.PredictionGUI and victim and victim.visible then
			local pred = SkillShot.SkillShotXYZ(me,victim,(300+client.latency+me:GetTurnTime(victim)*1000),1600)
			if not distxyz then
				distxyz = GetDistance2D(victim,xyz)
			end
			if xyz and me:GetDistance2D(xyz) < RangeH[hook.level] + 200 and SleepCheck("mouse") and config.EnableMouseAdjusting and config.PredictionGUI and client.mousePosition and GetDistance2D(victim,xyz) > 0 and GetDistance2D(victim,client.mousePosition) <= distxyz*2 then
				xyz = client.mousePosition
				if xyz and GetDistance2D(xyz,victim) > distxyz then
					xyz = (xyz - victim.position) * (GetDistance2D(xyz,victim)-((GetDistance2D(xyz,victim)-distxyz)*(distxyz/GetDistance2D(xyz,victim)))) / GetDistance2D(xyz,victim) + victim.position
				end
				if GetDistance2D(xyz,pred) < 100 then
					xyz = pred
				end
				guixyz = true
				if xyz and GetDistance2D(victim,xyz) > 0 then
					if not eff[3] then
						eff[3] = Effect(victim, "range_display" )
						eff[3]:SetVector(1,Vector(distxyz+100,0,0))
						eff[3]:SetVector(0, victim.position )
					else
						eff[3]:SetVector(0, victim.position )
					end
				end
			else
				if SleepCheck("mouse") then
					Sleep(250,"mouse")
				end
				eff[3] = nil
				eff[4] = nil
				guixyz = false
				distxyz = nil
			end
			if SleepCheck("guisleep") and xyz and me:GetDistance2D(xyz) < RangeH[hook.level] + 200 then
				if guixyz then
					if not eff[4] then 
						eff[4] = Effect(xyz, "range_display" )
						eff[4]:SetVector(1,Vector(75,0,0))
						eff[4]:SetVector(0, xyz )
					else
						eff[4]:SetVector(0, xyz )
					end
				end
				if not eff[1] then 
					eff[1] = Effect(xyz, "range_display" )
					eff[1]:SetVector(1,Vector(75,0,0))
					eff[1]:SetVector(0, xyz )
				elseif guixyz and pred then
					eff[1]:SetVector(0, pred )
				else
					eff[1]:SetVector(0, xyz )
				end
				local visible1, screenpos1 = client:ScreenPosition(me.position);
				local visible2, screenpos2 = client:ScreenPosition(xyz);
				local visible3, screenpos3 = client:ScreenPosition(victim.position);
				local visible4, screenpos4
				if pred then
					visible4, screenpos4 = client:ScreenPosition(pred);
				end
				if visible1 or visible2 then
					if not eff[2] then
						eff[2] = drawMgr:CreateLine(screenpos1.x, screenpos1.y, screenpos2.x, screenpos2.y, 0x006fffff)
					else
						eff[2].visible = true
						eff[2]:SetPosition(screenpos1,screenpos2)
					end
				elseif eff[2] then
					eff[2].visible = false
				end
				if (visible4 or visible3) and screenpos4 then
					if not eff[5] then
						eff[5] = drawMgr:CreateLine(screenpos3.x, screenpos3.y, screenpos4.x, screenpos4.y, 0xff000fff)
					else
						eff[5].visible = true
						eff[5]:SetPosition(screenpos3,screenpos4)
					end
				elseif eff[5] then
					eff[5].visible = false
				end
				Sleep(config.GuiSleep,"guisleep")
			elseif not xyz and (eff[1] or eff[2] or eff[4] or eff[5]) then
				eff[1] = nil
				eff[2] = nil
				eff[4] = nil
				eff[5] = nil
			end
		elseif eff[1] or eff[2] or eff[3] or eff[4] or eff[5] then
			eff[1] = nil
			eff[2] = nil
			eff[3] = nil
			eff[4] = nil
			eff[5] = nil
		end
		local Rubick = entityList:GetEntities({type=LuaEntity.TYPE_HERO,classId=CDOTA_Unit_Hero_Rubick,team=me:GetEnemyTeam(),illusion=false})[1] 
		if hook.level > 0 and math.ceil(hook.cd) == math.ceil(hook:GetCooldown(hook.level)) then
			xyz = nil
			if (Rubick or (targetHandle and entityList:GetEntity(targetHandle))) and rot.level > 0 and rot.toggled == false and not rot.abilityPhase and not rottoggled and SleepCheck("rot") then
				local prev = SelectUnit(me)
				entityList:GetMyPlayer():ToggleAbility(rot)
				SelectBack(prev)
				Sleep(250 + client.latency, "rot")
				rottoggled = true
			else
				rottoggled = false
			end
		end
		if (IsKeyDown(config.StopKey) or IsKeyDown(togglekey)) and (((hook.abilityPhase and not SleepCheck("hook")) and (math.ceil(hook.cd) ~= math.ceil(hook:GetCooldown(hook.level)) or not SleepCheck("hook"))) or targetHandle) then
			xyz = nil
			if not client.chat then
				local prev = SelectUnit(me)
				entityList:GetMyPlayer():HoldPosition()
				SelectBack(prev)
				Sleep(client.latency + 200, "testhook")
				Sleep(client.latency + 300, "stop")
			end
			return
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
										local prev = SelectUnit(me)
										entityList:GetMyPlayer():ToggleAbility(rot)
										SelectBack(prev)
										Sleep(250 + client.latency, "rot")
									end
								end
							end
						end
					else
						if distance <= (v.attackRange + 50) and me.health <= (DmgR2[rot.level]*3*(1 - me.magicDmgResist)) then
							if rot.toggled == false then
								local prev = SelectUnit(me)
								entityList:GetMyPlayer():ToggleAbility(rot)
								SelectBack(prev)
								Sleep(250 + client.latency, "rot")
							end
						end
					end
				end
				local urn = me:FindItem("item_urn_of_shadows")
				if config.AutoUrn and v.visible and v.health <= 150 and urn and urn:CanBeCasted() and me:CanCast() and SleepCheck("urn") and not targetHandle and GetDistance2D(me,v) <= 950 and GetDistance2D(me,v) > me.attackRange then
					local close_allies = entityList:GetEntities(function (ent) return ent.type == LuaEntity.TYPE_HERO and ent.alive and GetDistance2D(v,ent) < ent.attackRange end)
					if close_allies and #close_allies > 0 then
						me:SafeCastAbility(urn, v)
						Sleep(250,"urn")
					end
				end
				local ethereal = me:FindItem("item_ethereal_blade")	
				if config.AutoEthereal and SleepCheck("ethereal") and ethereal and ethereal:CanBeCasted() and me:CanCast() and GetDistance2D(me,v) <= ethereal.castRange+100 then
					if SleepCheck("eth") then
						EthDmg = AbilityDamage.GetDamage(ethereal)*1.4
						Sleep(10000,"eth")
					end
					if EthDmg > 0 then
						local taken = v:DamageTaken(EthDmg,DAMAGE_MAGC,me)
						if v.health <= taken and v:CanDie() then
							me:CastAbility(ethereal,v)
							Sleep(250,"ethereal")
						end
					end
				end
				if config.BlindHooks and hook.level > 0 and me.alive and not victim then
					if not v.visible then
						if not blindvictim or v.health < blindvictim.health or blindvictim.visible then
							blindvictim = v
						end
					end
				else 
					blindvictim = nil
				end
			end
		end
		if config.BlindHooks and hook.level > 0 and me.alive and not victim and blindvictim and not blindvictim.visible then
			local speed = 1600 
			local castPoint = (0.35 + client.latency/1000 + me:GetTurnTime(blindvictim))
			blindxyz = SkillShot.BlindSkillShotXYZ(me,blindvictim,speed,castPoint)
			if blindxyz and blindxyz:GetDistance2D(me) <= RangeH[hook.level] + 200 then 
				statusText.text = "Hook'em - BLIND!"
				if IsKeyDown(hookkey) and SleepCheck("hook") and not client.chat then
					me:SafeCastAbility(hook, blindxyz)
					Sleep(hook:FindCastPoint()*1000+client.latency,"hook")
				end
			end
		end
		if hook:CanBeCasted() and victim and victim.visible then
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
			if victim and not victim.visible then victim = nil end
			if not IsKeyDown(config.StopKey) and victim and victim.visible and hook:CanBeCasted() and SleepCheck("hook") then
				hooked = false
				local speed = 1600 
				local delay = (300+client.latency+me:GetTurnTime(victim)*1000)
				if not guixyz and ((config.PredictionGUI and SleepCheck("guisleep2")) or IsKeyDown(hookkey)) then	
					xyz = SkillShot.BlockableSkillShotXYZ(me,victim,speed,delay,100,true)
					predxyz = SkillShot.PredictedXYZ(victim,delay)
					Sleep(config.GuiSleep, "guisleep2")
				end
				local distance = GetDistance2D(victim, me)
				if distance <= RangeH[hook.level] + 200 and victim.visible then
					statusText.text = "Hook: " .. client:Localize(victim.name)
					victimText.text = "  Hook'em!"
					victimText.entity = victim
					if victim.healthbarOffset then
						victimText.entityPosition = Vector(0,0,victim.healthbarOffset)
					end
					if IsKeyDown(hookkey) and me.alive and not client.chat then
						if not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
							if xyz and (GetType(xyz) == "Vector" or GetType(xyz) == "Vector2D") and GetDistance2D(me,xyz) <= RangeH[hook.level] + 300 then	
								if GetDistance2D(xyz,me) > RangeH[hook.level] then
									xyz = (xyz - me.position) * (hook.castRange - 100) / GetDistance2D(xyz,me) + me.position
								end
								me:SafeCastAbility(hook, xyz)
								Sleep(hook:FindCastPoint()*1000+client.latency,"hook")
							else
								xyz = nil
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
			if config.HookCanceling and not guixyz and not ultied and not IsKeyDown(config.StopKey) and ((hook.abilityPhase and not SleepCheck("hook")) and math.ceil(hook.cd) ~= math.ceil(hook:GetCooldown(hook.level)) or not SleepCheck("hook")) and predxyz and victim and SleepCheck("testhook") then
				local speed = 1600 
				local delay = ((300-Animations.getDuration(hook)*1000)+client.latency+me:GetTurnTime(victim)*1000)
				local testxyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
				local testpredxyz = SkillShot.PredictedXYZ(victim,delay)
				if testpredxyz and testxyz and GetDistance2D(me,testxyz) <= RangeH[hook.level] + 200 and victim.alive then	
					if GetDistance2D(testxyz,me) > RangeH[hook.level] then
						testxyz = (testxyz - me.position) * (hook.castRange - 100) / GetDistance2D(testxyz,me) + me.position
					end
					if (GetDistance2D(testpredxyz,predxyz) >= math.max(GetDistance2D(testpredxyz,victim)+Animations.maxCount-50, 25)) or SkillShot.__GetBlock(me.position,testxyz,victim,100,true) then
						local prev = SelectUnit(me)
						entityList:GetMyPlayer():HoldPosition()
						SelectBack(prev)
						me:SafeCastAbility(hook, testxyz)
						xyz = testxyz
						predxyz = testpredxyz
						Sleep(math.max(hook:FindCastPoint()*500 - client.latency,0),"testhook")
						Sleep(hook:FindCastPoint()*1000+client.latency,"hook")
					end
				elseif GetDistance2D(me,xyz) > RangeH[hook.level] + 200 then
					local prev = SelectUnit(me)
					entityList:GetMyPlayer():HoldPosition()
					SelectBack(prev)
					Sleep(math.max(hook:FindCastPoint()*500 - client.latency,0),"testhook")
					Sleep(hook:FindCastPoint()*1000+client.latency,"hook")
				end
			end
		end
	end
end

function Combo(tick)
	if not PlayingGame() or client.console or client.paused or not SleepCheck("combo") or not targetHandle then return end
	local me = entityList:GetMyHero()
	
	local target = entityList:GetEntity(targetHandle)
	local minRange = 950
	local abilities = me.abilities
	local W = abilities[2]
	local R = abilities[4]
	
	if not target or (not target.alive or target:IsUnitState(LuaEntityNPC.STATE_MAGIC_IMMUNE) or (me:GetDistance2D(target) > minRange and not hooked) or target:IsIllusion()) or not me.alive or not active or count == 2 then
		targetHandle = nil
		hooked = false
		targetText.visible = false
		if not manualselection then
			statusText.text = "  Hook'em!"
		else
			statusText.text = "Hook'em - Manual!"
		end
		if me.alive and (W.toggled == true or rottoggled) then
			local prev = SelectUnit(me)
			entityList:GetMyPlayer():ToggleAbility(W)
			SelectBack(prev)
		end
		active = true
		count = 0
		script:UnregisterEvent(Combo)
		return
	end
	
	local distance = me:GetDistance2D(target)
	
	if W.level > 0 and W.toggled == false and not W.abilityPhase and not rottoggled and SleepCheck("rot") then
		if distance <= 250 then
			local prev = SelectUnit(me)
			entityList:GetMyPlayer():ToggleAbility(W)
			SelectBack(prev)
			Sleep(250 + client.latency, "rot")
		end
	end
	
	local ethereal = me:FindItem("item_ethereal_blade")	
	local urn = me:FindItem("item_urn_of_shadows")
	local aga = me:FindItem("item_ultimate_scepter")
	
	if not target:DoesHaveModifier("modifier_item_urn_damage") then
		urned = false
	else
		urned = true
	end
		
	if not R or R.level < 1 or not R:CanBeCasted() then
		ultied = nil
	end
		
	if config.AutoUrn and urn and urn.charges > 0 and urn:CanBeCasted() and not urned and not me:IsChanneling() and ((R.level > 0 and not R.abilityPhase and R.channelTime == 0 and not ultied) or R.level == 0) then 
		if not aga then 
			if R.level == 0 or target.health > (DmgD[R.level] * (1 - target.magicDmgResist)) or CanEscape(target) then
				me:CastAbility(urn,target)
			elseif R.level == 0 or target.health < (DmgD[R.level] * (1 - target.magicDmgResist)) and not R:CanBeCasted() or CanEscape(target) then
				me:CastAbility(urn,target)
			end
			Sleep(client.latency,"combo")
		else
			if R.level == 0 or target.health > (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) or CanEscape(target) then
				me:CastAbility(urn,target)
			elseif R.level == 0 or target.health < (DmgD[R.level]+(3*me.strengthTotal) * (1 - target.magicDmgResist)) and not R:CanBeCasted() or CanEscape(target) then
				me:CastAbility(urn,target)
			end
			Sleep(client.latency,"combo")
		end
	end
	
	if config.AutoEthereal and ethereal and ethereal:CanBeCasted() and not target:IsMagicImmune() and ((R.level > 0 and not R.abilityPhase and R.channelTime == 0 and not ultied) or R.level == 0) then
		me:CastAbility(ethereal,target)
		Sleep(client.latency,"combo")
	end

	if (not hooked or GetDistance2D(me, target) < (1600*math.max(client.latency/1000,0.1)+500)) and not R.abilityPhase then
		if R.level > 0 and R:CanBeCasted() and me:CanCast() and ((target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)*3) or CanEscape(target)) then 
			me:CastAbility(R,target)
			Sleep(50,"combo")
			ultied = true
			return
		end
		if not me:IsChanneling() and not ultied then
			if (hooked and GetDistance2D(me, target) < 1600*(client.latency/1000)) and GetDistance2D(me,target) > 150 and (target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)) and target.activity == LuaEntityNPC.ACTIVITY_MOVE then
				me:Move(target.position)
			elseif not target:IsAttackImmune() then
				me:Attack(target)
			end
			Sleep(30+client.latency,"combo")
		end
	elseif (hooked and target:DoesHaveModifier("modifier_pudge_meat_hook")) and not ultied then
		entityList:GetMyPlayer():HoldPosition()
		Sleep(30+client.latency,"combo")
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
		elseif config.AutoCombo and modifier.name == "modifier_pudge_meat_hook" then
			if v.hero and v.team ~= me.team and not v:IsIllusion() and not hooked then
				targetHandle = v.handle
				targetText.visible = true
				targetText.text = "Eating " .. client:Localize(v.name) .. ". Press " .. string.char(togglekey) .. " to cancel."
				script:RegisterEvent(EVENT_FRAME,Combo)
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

function FindAB(first, second, distance)
	local xAngle = math.deg(math.atan(math.abs(second.x - first.x)/math.abs(second.y - first.y)))
	local retValue = nil
	local retVector = Vector()
	if first.x <= second.x and first.y >= second.y then
			retValue = 270 + xAngle
	elseif first.x >= second.x and first.y >= second.y then
			retValue = (90-xAngle) + 180
	elseif first.x >= second.x and first.y <= second.y then
			retValue = 90+xAngle
	elseif first.x <= second.x and first.y <= second.y then
			retValue = 90 - xAngle
	end
	if retValue then
		retVector = Vector(first.x + math.cos(math.rad(retValue))*distance,first.y + math.sin(math.rad(retValue))*distance,0)
		client:GetGroundPosition(retVector)
		retVector.z = retVector.z+100
		return retVector
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
			xyz = nil
			rottoggled = false
			count = 0
			hooked = false
			urned = false
			reg = true
			ultied = nil
			blindvictim = nil
			guixyz = false
			distxyz = nil
			predxyz = nil
			script:RegisterEvent(EVENT_FRAME, Main)
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
	xyz = nil
	rottoggled = false
	count = 0
	hooked = false
	urned = false
	reg = true
	ultied = nil
	collectgarbage("collect")
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
