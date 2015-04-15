--<<Auto Farm and Stack, Made by Moones>>

--LIBRARIES--

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.AbilityDamage")
require("libs.Res")
require("libs.DrawManager3D")

--END of LIBRARIES--

--INFO--

--[[
	+--------------------------------------------------+              
	|                                                  |          
	|  iMeepo Script (AutoFarm Only) - Made by Moones  |        
	|  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  |     
	+--------------------------------------------------+    
																   
	=+=+=+=+=+=+=+=+=+ VERSION 0.2 +=+=+=+=+=+=+=+=+=+=+
 
	Description:
	------------
		- AutoFarm function for Meepo.
		- Taken from iMeepo script.

]]--

--END of INFO--

--SETTINGS--

----ScriptConfig----
local config = ScriptConfig.new()
config:SetParameter("FarmJungleKey", "B", config.TYPE_HOTKEY)
config:SetParameter("AllMeeposIdle", "V", config.TYPE_HOTKEY)
config:SetParameter("Debug", "P", config.TYPE_HOTKEY)
config:SetParameter("EnableAutoBind", true)
config:SetParameter("Meepo1", 49, config.TYPE_HOTKEY) -- 49 is Key Code for 1
config:SetParameter("Meepo2", 50, config.TYPE_HOTKEY) -- 50 is Key Code for 2 for all KeyCodes go to http://www.zynox.net/forum/threads/336-KeyCodes
config:SetParameter("Meepo3", 51, config.TYPE_HOTKEY) -- 3
config:SetParameter("Meepo4", 52, config.TYPE_HOTKEY) -- 4
config:SetParameter("Meepo5", 53, config.TYPE_HOTKEY) -- 5
config:SetParameter("PoofBindInDota", "W", config.TYPE_HOTKEY)
config:SetParameter("EarthbindBindInDota", "Q", config.TYPE_HOTKEY)
config:SetParameter("StopKeyBindInDota", "S", config.TYPE_HOTKEY)
config:SetParameter("MinimapNumbersXMove", 0)
config:Load()
	
farmJkey = config.FarmJungleKey
debugKey = config.Debug
idleKey = config.AllMeeposIdle
meepo1 = config.Meepo1
meepo2 = config.Meepo2
meepo3 = config.Meepo3
meepo4 = config.Meepo4
meepo5 = config.Meepo5
stop1 = config.PoofBindInDota
stop2 = config.EarthbindBindInDota
stop3 = config.StopKeyBindInDota
minimapMove = config.MinimapNumbersXMove

-----Local Script Variables----
local reg = false local myId = nil local start = false local meepoTable = {}
local active = true local monitor = client.screenSize.x/1920 local DWS = {} local poofDamage = { 0, 0 }
local F14 = drawMgr:CreateFont("F14","Tahoma",15*monitor,600*monitor) local meepoStateSigns = {} local base = nil local allies = nil local enemies = nil
local meepoNumberSigns = {} local F15 = drawMgr:CreateFont("F15","Tahoma",50*monitor,600*monitor) local meepoMinimapNumberSigns = {}
local F13 = drawMgr:CreateFont("F13","Tahoma",16*monitor,600*monitor) local spellDamageTable = {} local visibleCamps = {} local entitiesForPush = {}
local campSigns = {} local mousehoverCamp = nil local closestCamp = nil
 
----Local Meepo States----
local STATE_NONE, STATE_CHASE, STATE_FARM_JUNGLE, STATE_FARM_LANE, STATE_LANE, STATE_PUSH, STATE_HEAL, STATE_ESCAPE, STATE_POOF_OUT, STATE_MOVE, STATE_STACK = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11

----States Signs----
local statesSigns = {
	{"Idling", -1}, 
	{"Chasing", 0x17E317FF},
	{"Farming and Stacking Jungle", 0x65d9f7ff},
	{"Farming Lane", 0x3375ffff},
	{"Laninng", 0xbf00bfff},
	{"Pushing Lane", 0xf3f00bff},
	{"Healing", 0xff6b00ff},
	{"Escaping", 0xfe86c2ff},
	{"Poofing Out", 0x008321ff},
	{"Moving", 0xa46900ff},
	{"Stacking", 0xa89500ff}
}

----Jungle Camps positions, Stacks Positions----
local JungleCamps = {
	{position = Vector(-1131,-4044,127), stackPosition = Vector(-2498.94,-3517.86,128), waitPosition = Vector(-1401.69,-3791.52,128), team = 2, id = 1, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
	{position = Vector(-366,-2945,127), stackPosition = Vector(-534.219,-1795.27,128), waitPosition = Vector(536,-3001,256), team = 2, id = 2, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
	{position = Vector(1606.45,-3433.36,256), stackPosition = Vector(1325.19,-5108.22,256), waitPosition = Vector(1541.87,-4265.38,256), team = 2, id = 3, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
	{position = Vector(3126,-3439,256), stackPosition = Vector(4410.49,-3985,256), waitPosition = Vector(3401.5,-4233.39,256), team = 2, id = 4, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
	{position = Vector(3031.03,-4480.06,256), stackPosition = Vector(1368.66,-5279.04,256), waitPosition = Vector(2939.61,-5457.52,256), team = 2, id = 5, farmed = false, lvlReq = 1, visible = false, visTime = 0, stacking = false},
	{position = Vector(-2991,191,256), stackPosition = Vector(-3483,-1735,247), waitPosition = Vector(-2433,-356,256), team = 2, id = 6, farmed = false, lvlReq = 12, visible = false, visTime = 0, ancients = true, stacking = false},
	{position = Vector(1167,3295,256), stackPosition = Vector(570.86,4515.96,256), waitPosition = Vector(1011,3656,256), team = 3, id = 7, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
	{position = Vector(-244,3629,256), stackPosition = Vector(-1170.27,4581.59,256), waitPosition = Vector(-515,4845,256), team = 3, id = 8, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
	{position = Vector(-1588,2697,127), stackPosition = Vector(-1302,3689.41,136.411), waitPosition = Vector(-1491,2986,127), team = 3, id = 9, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
	{position = Vector(-3157.74,4475.46,256), stackPosition = Vector(-3296.1,5508.48,256), waitPosition = Vector(-3086,4924,256), team = 3, id = 10, farmed = false, lvlReq = 1, visible = false, visTime = 0, stacking = false},
	{position = Vector(-4382,3612,256), stackPosition = Vector(-3026.54,3819.69,132.345), waitPosition = Vector(-3995,3984,256), team = 3, id = 11, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
	{position = Vector(4026,-709.943,128), stackPosition = Vector(2228.46,-1046.78,128), waitPosition = Vector(3122,-1158.69,128), team = 3, id = 12, farmed = false, lvlReq = 12, visible = false, visTime = 0,  ancients = true, stacking = false}
}

--END of SETTINGS--

--GLOBAL CONSTANTS--

----Key Function

function Key(msg, code)
	if client.chat or client.console or Animations.maxCount < 1 or not PlayingGame() or client.shopOpen then return end
	if msg == RBUTTON_DOWN and shop() and client.mousePosition.x < 10000 then
		local player = entityList:GetMyPlayer()
		local selection = player.selection
		for h, smeepo in pairs(selection) do
			if meepoTable[smeepo.handle] and meepoTable[smeepo.handle].state ~= STATE_LANE and meepoTable[smeepo.handle].state ~= STATE_MOVE and meepoTable[smeepo.handle].state ~= STATE_NONE then
				--Updating state of meepo
				meepoTable[smeepo.handle].state = STATE_NONE
			end
		end
	elseif msg == KEY_UP then	
		if code == farmJkey then
			local player = entityList:GetMyPlayer()
			local selection = player.selection
			for h, smeepo in pairs(selection) do
				if meepoTable[smeepo.handle] then
					--Updating state of meepo
					local hovc = closestCamp and GetDistance2D(client.mousePosition,closestCamp.position) < 100
					if meepoTable[smeepo.handle].state ~= STATE_STACK and meepoTable[smeepo.handle].state ~= STATE_HEAL and meepoTable[smeepo.handle].state ~= STATE_POOF_OUT and meepoTable[smeepo.handle].state ~= STATE_ESCAPE and 
					(meepoTable[smeepo.handle].state ~= STATE_FARM_JUNGLE or hovc) then
						if hovc then
							meepoTable[smeepo.handle].camp = closestCamp
							meepoTable[smeepo.handle].hoveredCamp = true
						else
							meepoTable[smeepo.handle].camp = nil
							meepoTable[smeepo.handle].hoveredCamp = false
						end
						meepoTable[smeepo.handle].lastcamp = nil
						meepoTable[smeepo.handle].state = STATE_FARM_JUNGLE
					elseif meepoTable[smeepo.handle].state == STATE_FARM_JUNGLE or meepoTable[smeepo.handle].state == STATE_PUSH then
						meepoTable[smeepo.handle].camp = nil
						meepoTable[smeepo.handle].lastcamp = nil
						meepoTable[smeepo.handle].state = STATE_STACK
					else
						meepoTable[smeepo.handle].state = STATE_NONE
					end
				end
			end
			return true
		elseif code == stop1 or code == stop2 or code == stop3 then
			local player = entityList:GetMyPlayer()
			local selection = player.selection
			for h, smeepo in pairs(selection) do
				if meepoTable[smeepo.handle] and meepoTable[smeepo.handle].state ~= STATE_LANE and meepoTable[smeepo.handle].state ~= STATE_MOVE and meepoTable[smeepo.handle].state ~= STATE_NONE then
					--Updating state of meepo
					meepoTable[smeepo.handle].state = STATE_NONE
				end
			end
		elseif code == idleKey then
			for h, smeepo in pairs(meepoTable) do
				--Updating state of meepo
				meepoTable[smeepo.handle].state = STATE_NONE
			end
			return true
		elseif code == debugKey then
			SetDebugState(not IsDebugActive())
			return true
		elseif config.EnableAutoBind and (code == meepo1 or code == meepo2 or code == meepo3 or code == meepo4 or code == meepo5) then
			for number,meepo in pairs(meepoTable) do
				if meepo.alive then
					local meepoUlt = meepo:GetAbility(4)
					local meeponumber = (meepoUlt:GetProperty( "CDOTA_Ability_Meepo_DividedWeStand", "m_nWhichDividedWeStand" ) + 1)
					if code == meepo1 and meeponumber == 1 then
						SelectUnit(meepo)
						return true
					elseif code == meepo2 and meeponumber == 2 then
						SelectUnit(meepo)
						return true
					elseif code == meepo3 and meeponumber == 3 then
						SelectUnit(meepo)
						return true
					elseif code == meepo4 and meeponumber == 4 then
						SelectUnit(meepo)
						return true
					elseif code == meepo5 and meeponumber == 5 then
						SelectUnit(meepo)
						return true
					end
				end
			end
		end
	end
end

----Main tick function--

function Main(tick)
	if not PlayingGame() or client.paused or Animations.maxCount < 1 or client.shopOpen then return end
	
	--Local function variables
	local me = entityList:GetMyHero() local ID = me.classId if ID ~= myId then Close() end
	local player = entityList:GetMyPlayer() local DWSMain = me:GetAbility(4)
	local victim = nil local ethereal = me:FindItem("item_ethereal_blade")
	local EthDmg = 0 local mOver = entityList:GetMouseover() local numberOfNotVisibleEnemies = 0
	local allchase = false
	
	--Collecting Meepos
	if DWS and not DWS[1] then
		DWS[1] = DWSMain.level
	elseif DWS[1] < DWSMain.level then
		collectMeepos()
		DWS[1] = DWSMain.level
	elseif not DWS[2] and me:AghanimState() then
		collectMeepos()
		DWS[2] = true
	end
	
	--Getting Poof Damage
	if meepoTable[me.handle].poof and meepoTable[me.handle].poof.level > 0 and (not poofDamage or poofDamage[2] < meepoTable[me.handle].poof.level) then
		poofDamage = { AbilityDamage.GetDamage(meepoTable[me.handle].poof), meepoTable[me.handle].poof.level }
	end
	
	--SwitchingTreads back to agility
	SwitchTreads(true)
	
	--KS with ethereal -- ((ONLY IN FULL VERSION))
	-- if ethereal and SleepCheck("eth") then
		-- EthDmg = AbilityDamage.GetDamage(ethereal)*1.4
		-- Sleep(10000,"eth")
	-- end
	
	--base
	if not base then
		base = entityList:GetEntities({classId = CDOTA_Unit_Fountain,team = me.team})[1]
	end
	
	--allies
	if not allies or #allies < (4+getAliveNumber(true)) then
		allies = entityList:GetEntities({type = LuaEntity.TYPE_HERO, team = me.team})
	end
	
	--Reseting farmed/visible/stacking state of camps
	for i, camp in ipairs(JungleCamps) do
		if client.gameTime < 30 then
			JungleCamps[camp.id].farmed = true
		end
		if (client.gameTime % 60 > 0.5 and client.gameTime % 60 < 2) or (client.gameTime > 30 and client.gameTime < 32) then
			if camp.farmed then
				local block = false
				for m, v in pairs(allies) do
					if GetDistance2D(v,camp.position) < 500 and v.alive then
						block = true
					end
				end
				if not block then
					JungleCamps[camp.id].farmed = false
				end
			end
			if camp.stacking then
				JungleCamps[camp.id].stacking = false
			end
		end
		if camp.visible then
			for m, v in pairs(allies) do
				if GetDistance2D(v,camp.position) < 500 and not v.visibleToEnemy then
					JungleCamps[camp.id].visible = false
				end
			end
			if (client.gameTime - camp.visTime) > 30 then
				JungleCamps[camp.id].visible = false
			end
		end
		if not campSigns[camp.id] then
			campSigns[camp.id] = drawMgr3D:CreateText(camp.position, Vector(0,0,0), Vector2D(0,0), 0x66FF33FF, "Camp Available!", F14)
		else
			if JungleCamps[camp.id].farmed then
				campSigns[camp.id].drawObj.text = "Camp farmed!"
				campSigns[camp.id].drawObj.color = 0xFF6600FF
			elseif JungleCamps[camp.id].visible then
				campSigns[camp.id].drawObj.text = "Camp visible!"
				campSigns[camp.id].drawObj.color = 0xFFFF00FF
			else
				campSigns[camp.id].drawObj.text = "Camp available!"
				campSigns[camp.id].drawObj.color = 0x66FF33FF
			end
		end
		if not closestCamp or GetDistance2D(client.mousePosition,closestCamp.position) > GetDistance2D(client.mousePosition,camp.position) then
			closestCamp = camp
		end
	end	
	
	if closestCamp and GetDistance2D(client.mousePosition,closestCamp.position) < 100 then
		if not mousehoverCamp then
			mousehoverCamp = drawMgr3D:CreateText(closestCamp.position, Vector(0,0,0), Vector2D(0,15), -1, "Farm this CAMP? Press B", F14)
		else
			mousehoverCamp.pos = closestCamp.position
		end
	elseif mousehoverCamp then
		mousehoverCamp.drawObj.visible = false
	end
	
    --neutrals
	local neutrals = entityList:GetEntities({alive=true,team=LuaEntity.TEAM_NEUTRAL})
	
	--Get enemies
	enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team=me:GetEnemyTeam(),illusion=false})
	
	--Enemies loop
	for vNum,enemy in pairs(enemies) do
		if not enemy.visible and enemy.alive and not enemy:IsIllusion() then
			numberOfNotVisibleEnemies = numberOfNotVisibleEnemies + 1
		end
	end
	
	--creeps 
	entitiesForPush = {}
	
	local lanecreeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,visible=true})
	local siege = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Siege,alive=true,visible=true})
	local towers = entityList:GetEntities({classId=CDOTA_BaseNPC_Tower,alive=true,visible=true})
	local ward = entityList:GetEntities({classId=CDOTA_BaseNPC_Venomancer_PlagueWard,alive=true,visible=true})

	for k,v in pairs(lanecreeps) do if not v:IsInvul() and v.team ~= me.team and not v:IsAttackImmune() and v.spawned then entitiesForPush[#entitiesForPush + 1] = v end end
	for k,v in pairs(siege) do if not v:IsInvul() and not v:IsAttackImmune() and v.spawned then entitiesForPush[#entitiesForPush + 1] = v end end
	for k,v in pairs(ward) do if not v:IsInvul() and not v:IsAttackImmune() then entitiesForPush[#entitiesForPush + 1] = v end end
	
	--Checking if an ally farmed camp
	for i,ally in pairs(allies) do
		for m,camp in pairs(JungleCamps) do 
			if GetDistance2D(ally,camp.position) < 300 then
				local farmed = true
				for k,ent in pairs(neutrals) do
					if ent.alive and ent.visible and ent.spawned and GetDistance2D(ent,ally) < 600 then						
						farmed = false
					end
				end
				if farmed then
					JungleCamps[camp.id].farmed = true
				end
			end
		end
	end
	
	--Cycling through our meepos
	for meepoHandle,meepo in pairs(meepoTable) do	
		if not meepo:IsChanneling() then		
			if meepo.alive then
			
				--Escape
				for vNum,enemy in pairs(enemies) do
					if enemy.visible and enemy.alive and not enemy:IsIllusion() then
						
						--Escape mode
						if enemy.hero and meepo.alive and meepoTable[meepo.handle].state ~= STATE_ESCAPE then			
							if (meepoTable[meepo.handle].state == STATE_FARM_JUNGLE or meepoTable[meepo.handle].state == STATE_PUSH or meepoTable[meepo.handle].state == STATE_LANE or meepoTable[meepo.handle].state == STATE_HEAL) and ((meepo.visibleToEnemy and GetDistance2D(meepo,enemy) < enemy.dayVision) or (GetDistance2D(meepo,enemy) < enemy.attackRange and client.gameTime > 1200)) then
								DebugPrint("EscapeE")
								if meepo.health < 300 or meepoTable[meepo.handle].state ~= STATE_CHASE then
									meepoTable[meepo.handle].state = STATE_ESCAPE
									if SleepCheck("ping") then
										client:Ping(Client.PING_DANGER,enemy.position)
										Sleep(7000,"ping")
									end
									Sleep(4000,meepo.handle.."-escape")
								end
							end
						end
					end
				end
				
				--Blink
				if SleepCheck("blink") and ((victim and victim.visible and GetDistance2D(me,victim) > 500 and GetDistance2D(me,victim) < 1500 and meepoTable[me.handle].state == STATE_CHASE) or 
				(meepoTable[me.handle].camp and GetDistance2D(me,meepoTable[me.handle].camp.position) > 200 and GetDistance2D(me,meepoTable[me.handle].camp.position) < 1200 and meepoTable[me.handle].state == STATE_FARM_JUNGLE)) then
					if not meepoTable[me.handle].blink then
						meepoTable[me.handle].blink = me:FindItem("item_blink")
					end
					local blink = meepoTable[me.handle].blink
					local blinkPos = nil
					if (victim and victim.hero and victim.visible and GetDistance2D(me,victim) > 500 and GetDistance2D(me,victim) < 1500 and meepoTable[me.handle].state == STATE_CHASE) then
						blinkPos = victim.position
					elseif meepoTable[me.handle].state == STATE_FARM_JUNGLE then
						blinkPos = meepoTable[me.handle].camp.position
					end
					if blinkPos then
						if GetDistance2D(me,blinkPos) > 1100 then
							blinkPos = (blinkPos - me.position) * 1100 / GetDistance2D(blinkPos,me) + me.position
						end
						meepoTable[me.handle].blinkPos = blinkPos
						if canCast(me, blink) then
							DebugPrint("blink")
							me:CastAbility(blink,blinkPos)
							if victim then
								Sleep(me:GetTurnTime(victim)*1000,me.handle.."-casting")
								Sleep(me:GetTurnTime(victim)*1000+500,"blink")
							else
								Sleep(me:GetTurnTime(meepoTable[me.handle].camp.position)*1000,me.handle.."-casting")
								Sleep(me:GetTurnTime(meepoTable[me.handle].camp.position)*1000+500,"blink")
							end
						end
					end
				end
			
				--rupture
				if meepo:DoesHaveModifier("modifier_bloodseeker_rupture") then
					if meepo.activity == LuaEntityNPC.ACTIVITY_MOVE then
						local prev = SelectUnit(meepo)
						player:HoldPosition()
						SelectBack(prev)
					end
					local rupture = meepo:FindModifier("modifier_bloodseeker_rupture")
					Sleep(rupture.remainingTime*1000,meepoHandle.."-move")
				end
			
				--Poof out
				if meepoTable[meepo.handle].state == STATE_POOF_OUT and SleepCheck(meepoHandle.."-casting") then
					if meepoTable[meepo.handle].lastState then
						meepoTable[meepo.handle].state = meepoTable[meepo.handle].lastState
						meepoTable[meepo.handle].lastState = nil
					else
						meepoTable[meepo.handle].state = STATE_FARM_JUNGLE
					end
				end
			
				--Charged Mapo
				if meepo:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness_vision") and (meepoTable[meepo.handle].state == STATE_FARM_JUNGLE or meepoTable[meepo.handle].state == STATE_PUSH) then
					meepoTable[meepo.handle].state = STATE_ESCAPE
				end
			
				--Escape function
				if meepoTable[meepo.handle].state == STATE_ESCAPE then
					local travels = meepo:FindItem("item_travel_boots")
					local tp = meepo:FindItem("item_tpscroll")
					local item = nil
					local poof = meepoTable[meepoHandle].poof
					meepoTable[meepoHandle].victim = nil
					if meepoTable[meepoHandle].foundCreep then
						meepoTable[meepoHandle].foundCreep = false
					end
					if SleepCheck(meepo.handle.."-casting") then
						if poof.level > 0 and canCast(meepo, poof) then
							local farrest = getFarrestMeepo(meepo)
							if farrest and GetDistance2D(meepo,farrest) > 1000 and GetDistance2D(meepo,base) > GetDistance2D(meepo,farrest) then
								meepo:CastAbility(poof,farrest.position)
								Sleep(poof:FindCastPoint()*1000,meepo.handle.."-casting")
							end
						end
						if travels then item = travels else item = tp end
						if item and canCast(meepo, item) and not IsInDanger(meepo) then
							meepo:CastAbility(item,base.position)
							Sleep(3000,meepo.handle.."-casting")
						end
					end
					if SleepCheck(meepo.handle.."-move") then
						local pos 
						if victim then
							pos = (meepo.position - victim.position) * (GetDistance2D(meepo,victim) + 5000) / GetDistance2D(meepo,victim) + meepo.position
						end
						if pos and GetDistance2D(meepo,victim) < 1200 then
							meepo:Move(pos)
						else
							meepo:Move(base.position)
						end
						Sleep(750, meepo.handle.."-move")				
					end
				end
			
				--Heal function
				if (meepoTable[meepoHandle].state == STATE_HEAL or (meepo.alive and (((meepo.health+(meepo.healthRegen*(GetDistance2D(meepo,base)/meepo.movespeed))) < meepo.maxHealth/4.25 and 
				meepoTable[meepoHandle].state ~= STATE_POOF_OUT and meepoTable[meepoHandle].state ~= STATE_LANE and meepoTable[meepoHandle].state ~= STATE_ESCAPE and (meepoTable[meepoHandle].state ~= STATE_FARM_JUNGLE or 
				(meepoTable[meepoHandle].camp and GetDistance2D(meepoTable[meepoHandle].camp.position,meepo) > 1000))) or meepo:DoesHaveModifier("modifier_bloodseeker_thirst_vision")))) and SleepCheck(meepoHandle.."-heal") then			
					local incDmgM = IncomingDamage(meepo,false) 	
					--Updating state of meepo
					if meepoTable[meepoHandle].state ~= STATE_HEAL then
						meepoTable[meepoHandle].lastState = meepoTable[meepoHandle].state
						meepoTable[meepoHandle].state = STATE_HEAL	
						meepoTable[meepoHandle].camp = nil
						meepoTable[meepoHandle].lastcamp = nil
						if meepoTable[meepoHandle].foundCreep then
							meepoTable[meepoHandle].foundCreep = false
						end
					end
					
					--Giving orders to heal
					local mustGoBase,items,isMe = haveHealingItems(meepo)
					if not mustGoBase and not IsInDanger(meepo) and (not meepoTable[meepoHandle].camp or GetDistance2D(meepo,meepoTable[meepoHandle].camp.position) > 1000) and not me:DoesHaveModifier("modifier_flask_healing") then
						if isMe and (me.maxHealth - me.health) > 300 then
							me:CastAbility(items[1], me)
						elseif GetDistance2D(me, meepo) > 200 then
							meepo:Follow(me)
						else
							me:CastAbility(items[1], meepo)
						end
					else
						if meepoTable[meepoHandle].victim and meepoTable[meepoHandle].victim.visible and GetDistance2D(meepoTable[meepoHandle].victim,meepo) < meepoTable[meepoHandle].victim.attackRange and incDmgM > meepo.health then
							meepo:Move((meepo.position - meepoTable[meepoHandle].victim.position) * (GetDistance2D(meepo,meepoTable[meepoHandle].victim) + meepoTable[meepoHandle].victim.attackRange) / GetDistance2D(meepo,meepoTable[meepoHandle].victim) + meepo.position)
						else
							if not IsInDanger(meepo) then
								useTP(meepo, meepoHandle, base.position)
							end
							if SleepCheck(meepoHandle.."-casting") then
								meepo:Move(base.position)
							end
						end
					end
					
					Sleep(500, meepoHandle.."-heal")
				end
			
				--Going farm after healed
				if meepo.alive and ((meepoTable[meepoHandle].state == STATE_HEAL and meepo.health > meepo.maxHealth/1.4) or (meepoTable[meepoHandle].state == STATE_ESCAPE and not IsInDanger(meepo) and SleepCheck(meepoHandle.."-escape"))) then		
					--Updating state of meepo	
					if meepoTable[meepoHandle].lastState and meepoTable[meepoHandle].lastState ~= STATE_HEAL then
						meepoTable[meepoHandle].state = meepoTable[meepoHandle].lastState
					else
						meepoTable[meepoHandle].state = STATE_FARM_JUNGLE
					end
				end
				
				--Lane Farm
				if meepo.alive and meepoTable[meepoHandle].state == STATE_PUSH then						
					local def = false
					local pushEntity = nil
					local pushEntities = {}			
					for i,creep in pairs(entitiesForPush) do
						if creep.team ~= me.team then
							if meepo:GetDistance2D(creep) <= 4000 then
								if meepo:GetDistance2D(creep) <= 400 then 
									pushEntities[#pushEntities + 1] = creep
								end
								if not pushEntity or (creep.health < pushEntity.health and GetDistance2D(creep,pushEntity) < 700) then
									pushEntity = creep
								end
							end
						end
					end

					if (not meepoTable[meepoHandle].camp or ((client.gameTime % 60 > 0 and client.gameTime % 60 < 1) or JungleCamps[meepoTable[meepoHandle].camp.id].farmed or JungleCamps[meepoTable[meepoHandle].camp.id].visible)) then
						DebugPrint("Getting Camp")
						meepoTable[meepoHandle].camp = getClosestCamp(meepoTable[meepoHandle])
					elseif meepoTable[meepoHandle].camp and SleepCheck(meepoHandle.."-camp") then
						DebugPrint("Getting Camp 2")
						local camp = getClosestCamp(meepoTable[meepoHandle])
						if camp and GetDistance2D(meepo,camp.position) < GetDistance2D(meepo,meepoTable[meepoHandle].camp.position) then
							meepoTable[meepoHandle].camp = camp
						end
						Sleep(3000, meepoHandle.."-camp")
					end
					
					local camp = nil
					if meepoTable[meepoHandle].camp then
						camp = JungleCamps[meepoTable[meepoHandle].camp.id]
					end
					
					local en = false
					
					if pushEntity then
						for i,v in ipairs(towers) do
							if v.team == me.team and GetDistance2D(v,pushEntity) < 1000 then
								def = true
							end
							if v.team ~= me.team and GetDistance2D(v,pushEntity) < 1000 then
								meepoTable[meepoHandle].state = STATE_FARM_JUNGLE
							end
						end
						for m, e in pairs(enemies) do
							if e.alive and e.visible and GetDistance2D(e,pushEntity) < 700 and not def then
								en = true
							end
						end
					end

					if en or (not def and numberOfNotVisibleEnemies > 2) or (not pushEntity or (camp and not camp.farmed and not camp.visible and not camp.stacking and GetDistance2D(camp.position,meepo) < GetDistance2D(pushEntity,meepo) and GetDistance2D(pushEntity,meepo) < 500)) then				
						meepoTable[meepoHandle].state = STATE_FARM_JUNGLE
					end

					if pushEntity then
						victim = pushEntity
					else
						victim = nil
					end
					
					local tp = false
					if victim and victim.alive and not meepo:IsChanneling() then
						DebugPrint("FarmJungle2")
						tp = useTP(meepo, meepoHandle, victim.position)

						if GetDistance2D(victim,meepo) < 500 then
							if victim.classId == CDOTA_BaseNPC_Tower then
								local tank = false
								for i,v in ipairs(lanecreeps) do
									if v.team == me.team and v.spawned and GetDistance2D(v,victim) < victim.attackRange+100 then
										tank = true
									end
								end
								if tank then
									local poofDmg = math.ceil(victim:DamageTaken(poofDamage[1],DAMAGE_MAGC,meepo))
									OrbWalk(meepo, meepoHandle, victim, (victim.health > poofDmg or #pushEntities > 1))
								elseif GetDistance2D(meepo,victim) < victim.attackRange+500 and SleepCheck(meepoHandle.."-move") then
									local pos = (meepo.position - victim.position) * (GetDistance2D(meepo,victim) + victim.attackRange+100) / GetDistance2D(meepo,victim) + meepo.position
									meepo:Move(pos)
									Sleep(500, meepoHandle.."-move")
								end
							else
								local poofDmg = math.ceil(victim:DamageTaken(poofDamage[1],DAMAGE_MAGC,meepo))
								OrbWalk(meepo, meepoHandle, victim, (victim.health > poofDmg or #pushEntities > 1))	
							end
						elseif SleepCheck(meepoHandle.."-move") then
							meepo:Move(victim.position)
							Sleep(500, meepoHandle.."-move")
						end					
					end
				end
				
				--Jungling
				if meepo.alive and meepoTable[meepoHandle].state == STATE_FARM_JUNGLE then
					local push = {false,0,nil}
					for i,creep in pairs(entitiesForPush) do
						if creep.team ~= me.team and meepo:GetDistance2D(creep) <= 4000 then
							local en = false
							for m, e in pairs(enemies) do
								if e.alive and e.visible and GetDistance2D(e,creep) < 700 then
									en = true
								end
							end
							if not en then
								push = {true,meepo:GetDistance2D(creep),creep}
							end
						end
					end
					DebugPrint("FarmJungle1")
					if (not meepoTable[meepoHandle].camp or (((client.gameTime % 60 > 0 and client.gameTime % 60 < 1) or (JungleCamps[meepoTable[meepoHandle].camp.id].farmed and client.gameTime > 30) or JungleCamps[meepoTable[meepoHandle].camp.id].visible) and not meepoTable[meepoHandle].hoveredCamp)) then
						DebugPrint("Getting Camp")
						meepoTable[meepoHandle].camp = nil
						meepoTable[meepoHandle].lastcamp = nil
						meepoTable[meepoHandle].camp = getClosestCamp(meepoTable[meepoHandle], false, numberOfNotVisibleEnemies)
						meepoTable[meepoHandle].hoveredCamp = false
					elseif meepoTable[meepoHandle].camp and SleepCheck(meepoHandle.."-camp") and not meepoTable[meepoHandle].hoveredCamp then
						DebugPrint("Getting Camp 2")
						local camp = getClosestCamp(meepoTable[meepoHandle], false, numberOfNotVisibleEnemies)
						if camp and (GetDistance2D(meepo,camp.position) < GetDistance2D(meepo,meepoTable[meepoHandle].camp.position) or (camp.team ~= me.team and numberOfNotVisibleEnemies > 2)) then
							meepoTable[meepoHandle].hoveredCamp = false
							meepoTable[meepoHandle].camp = camp
						end
						Sleep(3000, meepoHandle.."-camp")
					end
					local camp = nil
					if meepoTable[meepoHandle].camp then
						camp = JungleCamps[meepoTable[meepoHandle].camp.id]
					end
					local creepForCurrentMeepo = nil
					local creepsNearCurrentMeepo = {}
					if camp then
						for i,creep in pairs(neutrals) do
							if creep.spawned and meepo:GetDistance2D(creep) <= 1000 and (creep:GetDistance2D(camp.position) <= 650 or (creep.visible and GetDistance2D(creep,camp.position) < 1200)) then
								creepsNearCurrentMeepo[#creepsNearCurrentMeepo + 1] = creep
								if not creepForCurrentMeepo or creep.health < creepForCurrentMeepo.health then
									creepForCurrentMeepo = creep
								end
							end
						end

						if meepo.visibleToEnemy and not JungleCamps[camp.id].visible and creepForCurrentMeepo and GetDistance2D(meepo,camp.position) < 500 then
							JungleCamps[camp.id].visible = true
							JungleCamps[camp.id].visTime = client.gameTime
							meepoTable[meepoHandle].lastcamp = camp
							meepoTable[meepoHandle].camp = nil
							if meepoTable[meepoHandle].foundCreep then
								meepoTable[meepoHandle].foundCreep = false
							end
							meepoTable[meepoHandle].hoveredCamp = false
							camp = getClosestCamp(meepoTable[meepoHandle], false, numberOfNotVisibleEnemies)
						end

						local def = false
						local back = false
						if push[3] then
							for i,v in ipairs(towers) do
								if v.team == me.team and GetDistance2D(v,push[3]) < 2000 then
									def = true
								end
								if v.team ~= me.team and GetDistance2D(v,push[3]) < 2000 then
									back = true
								end
							end
						end
						if camp then
							if not meepoTable[meepoHandle].hoveredCamp and (numberOfNotVisibleEnemies < 4 or def) and push[1] and push[2] < GetDistance2D(camp.position,meepo) and GetDistance2D(camp.position,meepo) > 5000 and not back then
								meepoTable[meepoHandle].state = STATE_PUSH
							end
						end
					elseif SleepCheck(meepoHandle.."-move") then
						if meepoTable[meepoHandle].lastcamp then
							meepo:Move(meepoTable[meepoHandle].lastcamp.stackPosition)
							Sleep(750,meepoHandle.."-move")
						else
							local c = getClosestPos(meepo)
							meepo:Move(c.stackPosition)
							Sleep(750,meepoHandle.."-move")
						end
					end
					if camp and not meepo:IsChanneling() then
						DebugPrint("FarmJungle2")
						local tp = nil
						if GetDistance2D(camp.position,meepo) > 1200 then
							tp = useTP(meepo, meepoHandle, camp.position)
						end

						if creepForCurrentMeepo then
							victim = creepForCurrentMeepo
						else
							victim = nil
						end

						if SleepCheck(meepoHandle.."stack") and (GetDistance2D(meepo,camp.position) > 450 or not meepoTable[meepoHandle].foundCreep) and SleepCheck(meepoHandle.."-move") and not meepo:IsChanneling() and 
						not tp and (not victim or not victim.alive) then
							if meepoTable[meepoHandle].foundCreep then						
								meepoTable[meepoHandle].foundCreep = false
							end
							if (JungleCamps[camp.id].stacking or (JungleCamps[camp.id].farmed and client.gameTime % 60 > 50)) and GetDistance2D(meepo,camp.position) < 1500 then
								if GetDistance2D(meepo,camp.position) < 1000 then							
									meepo:Move(camp.stackPosition)
								elseif meepo.activity == LuaEntityNPC.ACTIVITY_MOVE then
									DebugPrint("HoldPos")
									local prev = SelectUnit(meepo)
									player:HoldPosition()
									SelectBack(prev)
								end
							elseif not meepoTable[meepoHandle].hoveredCamp or not JungleCamps[camp.id].farmed then
								meepo:Move(camp.position)
							elseif JungleCamps[camp.id].farmed and meepoTable[meepoHandle].hoveredCamp then
								meepo:Move(camp.stackPosition)
							end
							Sleep(750,meepoHandle.."-move")
						end
						if victim and victim.alive then
							if (meepo.health <= math.min(math.max(math.ceil(meepo:DamageTaken(victim.dmgMin + victim.dmgBonus,DAMAGE_PHYS,victim))*(#creepsNearCurrentMeepo)*2, meepo.maxHealth/5),meepo.maxHealth/4.25) or meepo.health < 150) and ((meepo.health <= victim.health) or #creepsNearCurrentMeepo > 1) then
								if GetDistance2D(meepo,victim) < victim.attackRange+100 and not IsInDanger(meepo) then
									local pos = (meepo.position - victim.position) * (GetDistance2D(meepo,victim) + victim.attackRange+100) / GetDistance2D(meepo,victim) + meepo.position
									if SleepCheck(meepoHandle.."-move") then
										meepo:Move(pos)
										Sleep(500,meepoHandle.."-move")
									end
								else
									if not SleepCheck(meepoHandle.."-casting") then
										local prev = SelectUnit(meepo)
										player:HoldPosition()
										SelectBack(prev)
									end
									meepoTable[meepoHandle].state = STATE_HEAL
								end
							end
							meepoTable[meepoHandle].foundCreep = true
							JungleCamps[camp.id].farmed = false
							local stackDuration = math.min((GetDistance2D(victim,camp.stackPosition)+(#creepsNearCurrentMeepo*60))/math.min(victim.movespeed,me.movespeed), 9)
							if victim:IsRanged() and #creepsNearCurrentMeepo <= 4 then
								stackDuration = math.min((GetDistance2D(victim,camp.stackPosition)+victim.attackRange+(#creepsNearCurrentMeepo*60))/math.min(victim.movespeed,me.movespeed), 9)
							end
							if SleepCheck(meepoHandle.."-moveStack") and (client.gameTime % 60 > (60 - stackDuration) and client.gameTime % 60 < 57) and (GetDistance2D(victim,meepo) < 250 or JungleCamps[camp.id].stacking) then	
								local pos = (camp.stackPosition - victim.position) * (GetDistance2D(camp.stackPosition,victim) + victim.attackRange) / GetDistance2D(camp.stackPosition,victim) + camp.stackPosition
								meepo:Move(pos)
								Sleep((GetDistance2D(meepo,pos)/meepo.movespeed)*1000,meepoHandle.."-moveStack")
								Sleep((60 - (client.gameTime % 60))*1000,meepoHandle.."stack")
								JungleCamps[camp.id].stacking = true
							elseif SleepCheck(meepoHandle.."stack") and not JungleCamps[camp.id].stacking then
								local poofDmg = math.ceil(victim:DamageTaken(poofDamage[1],DAMAGE_MAGC,meepo))
								if ((#creepsNearCurrentMeepo > 3 and camp.lvlReq == 8) or (#creepsNearCurrentMeepo > 4 and camp.lvlReq < 8 and camp.lvlReq >= 3) or (#creepsNearCurrentMeepo > 4 and camp.lvlReq < 3)) and meepoTable[meepoHandle].poof and meepoTable[meepoHandle].poof.state ~= STATE_NOMANA and meepo.mana >= meepoTable[meepoHandle].poof.manacost and (meepoTable[meepoHandle].poof.level == 4 or (meepoTable[meepoHandle].poof.level >= 1 and camp.lvlReq < 8)) then 
									if meepoTable[meepoHandle].poof and canCast(meepo, meepoTable[meepoHandle].poof) then
										local pos = camp.position
										if GetDistance2D(meepo,victim.position) < GetDistance2D(meepo,camp.position) then
											pos = victim.position
										end
										if GetDistance2D(meepo,pos) > 50 then
											if SleepCheck(meepoHandle.."-move") then
												meepo:Move(pos)
												Sleep(750,meepoHandle.."-move")
											end
										elseif SleepCheck(meepoHandle.."-casting") and GetDistance2D(meepo,camp.position) < 200 then
											meepo:CastAbility(meepoTable[meepoHandle].poof,meepo)
											Sleep(meepoTable[meepoHandle].poof:FindCastPoint()*1000,meepoHandle.."-casting")
										end
									elseif SleepCheck(meepoHandle.."-move") then
										local pos = (camp.stackPosition - victim.position) * (GetDistance2D(camp.stackPosition,victim) + victim.attackRange) / GetDistance2D(camp.stackPosition,victim) + camp.stackPosition
										meepo:Move(pos)
										Sleep(750,meepoHandle.."-move")
										Sleep(math.min((GetDistance2D(meepo,camp.stackPosition)/meepo.movespeed)*1000,meepoTable[meepoHandle].poof.cd*1000),meepoHandle.."-orb")							
									end
								elseif SleepCheck(meepoHandle.."-orb") then
									OrbWalk(meepo, meepoHandle, victim, (victim.health > poofDmg/1.2 or #creepsNearCurrentMeepo > 1 or victim.health > meepo.health))
								end
							end
						elseif ((meepoTable[meepoHandle].foundCreep and GetDistance2D(meepo,camp.position) < 600) or GetDistance2D(meepo,camp.position) < 200) and SleepCheck("blink") then
							if meepo.health < meepo.maxHealth/4.25 then
								meepoTable[meepoHandle].state = STATE_HEAL
							end
							meepoTable[meepoHandle].lastcamp = camp
							JungleCamps[camp.id].farmed = true
							if not meepoTable[meepoHandle].hoveredCamp then
								meepoTable[meepoHandle].camp = nil
								meepoTable[meepoHandle].hoveredCamp = false
							elseif meepoTable[meepoHandle].camp and GetDistance2D(meepo, meepoTable[meepoHandle].camp.stackPosition) > 100 and SleepCheck(meepoHandle.."-move") then
								meepo:Move(meepoTable[meepoHandle].camp.stackPosition)
								Sleep(750,meepoHandle.."-move")
							end
							if meepoTable[meepoHandle].foundCreep then
								meepoTable[meepoHandle].foundCreep = false
							end
						end
					elseif SleepCheck(meepoHandle.."-move") and not meepo:IsChanneling() and not tp then
						for i,creep in pairs(entitiesForPush) do
							if creep.team ~= me.team and meepo:GetDistance2D(creep) <= 4000 then
								local en = false
								for m, e in pairs(enemies) do
									if e.alive and e.visible and GetDistance2D(e,creep) < 700 then
										en = true
									end
								end
								local back = false
								for i,v in pairs(towers) do
									if v.team ~= me.team and GetDistance2D(v,creep) < 2000 then
										back = true
									end
								end
								if not en and not back and not meepoTable[meepoHandle].hoveredCamp then
									meepoTable[meepoHandle].state = STATE_PUSH
								end
							end
						end
						if not meepoTable[meepoHandle].hoveredCamp then
							meepoTable[meepoHandle].camp = nil
							meepoTable[meepoHandle].hoveredCamp = false
						end
						if meepoTable[meepoHandle].foundCreep then
							meepoTable[meepoHandle].foundCreep = false
						end
						if meepoTable[meepoHandle].hoveredCamp then
							meepoTable[meepoHandle].lastcamp = meepoTable[meepoHandle].camp
						end 
						if meepoTable[meepoHandle].lastcamp then
							if GetDistance2D(meepo, meepoTable[meepoHandle].lastcamp.stackPosition) > 100 then
								meepo:Move(meepoTable[meepoHandle].lastcamp.stackPosition)
								Sleep(750,meepoHandle.."-move")
							end
						else
							local camp = getClosestCamp(meepoTable[meepoHandle],true, numberOfNotVisibleEnemies)
							if camp and GetDistance2D(meepo, camp.stackPosition) > 100 then
								meepo:Move(camp.stackPosition)
								Sleep(750,meepoHandle.."-move")
							end
						end
					end
				end				
			
				--Stacking
				if meepo.alive and meepoTable[meepoHandle].state == STATE_STACK then
					
					if (not meepoTable[meepoHandle].camp or ((client.gameTime % 60 > 0 and client.gameTime % 60 < 1) or JungleCamps[meepoTable[meepoHandle].camp.id].farmed or JungleCamps[meepoTable[meepoHandle].camp.id].visible)) then
						DebugPrint("Getting Camp")
						meepoTable[meepoHandle].camp = getClosestCamp(meepoTable[meepoHandle], true, numberOfNotVisibleEnemies)
					elseif meepoTable[meepoHandle].camp and SleepCheck(meepoHandle.."-camp") then
						DebugPrint("Getting Camp 2")
						local camp = getClosestCamp(meepoTable[meepoHandle], true, numberOfNotVisibleEnemies)
						if camp and (GetDistance2D(meepo,camp.position) < GetDistance2D(meepo,meepoTable[meepoHandle].camp.position) or (camp.team ~= me.team and numberOfNotVisibleEnemies > 3)) then
							meepoTable[meepoHandle].camp = camp
						end
						Sleep(3000, meepoHandle.."-camp")
					end
					local camp = nil
					if meepoTable[meepoHandle].camp then
						camp = JungleCamps[meepoTable[meepoHandle].camp.id]
					end
					local creepForCurrentMeepo = nil
					local creepsNearCurrentMeepo = {}
					if camp then
						for i,creep in pairs(neutrals) do
							if creep.visible and creep.spawned and meepo:GetDistance2D(creep) <= 900 and (creep:GetDistance2D(camp.position) <= 1000 or (creep.visible and GetDistance2D(creep,camp.position) < 1200)) then
								creepsNearCurrentMeepo[#creepsNearCurrentMeepo + 1] = creep
								if not creepForCurrentMeepo or GetDistance2D(meepo, creep) > GetDistance2D(meepo, creepForCurrentMeepo) then
									creepForCurrentMeepo = creep
								end
							end
						end

						if meepo.visibleToEnemy and not JungleCamps[camp.id].visible and creepForCurrentMeepo then
							JungleCamps[camp.id].visible = true
							JungleCamps[camp.id].visTime = client.gameTime
							meepoTable[meepoHandle].lastcamp = camp
							meepoTable[meepoHandle].camp = nil
							if meepoTable[meepoHandle].foundCreep then
								meepoTable[meepoHandle].foundCreep = false
							end
							camp = getClosestCamp(meepoTable[meepoHandle], true, numberOfNotVisibleEnemies)
						end
					elseif SleepCheck(meepoHandle.."-move") then
						if meepoTable[meepoHandle].lastcamp then
							meepo:Move(meepoTable[meepoHandle].lastcamp.stackPosition)
							Sleep(750,meepoHandle.."-move")
						end
					end
						
					if camp and not meepo:IsChanneling() then
						DebugPrint("FarmJungle2")
						local tp = useTP(meepo, meepoHandle, camp.position)

						if creepForCurrentMeepo then
							victim = creepForCurrentMeepo
						else
							victim = nil
						end
						local stackDuration = 0
						if victim and victim.alive then
							stackDuration = math.min((GetDistance2D(victim,camp.stackPosition)+(#creepsNearCurrentMeepo*45))/math.min(victim.movespeed,me.movespeed), 9)
							if victim:IsRanged() and #creepsNearCurrentMeepo <= 4 then
								stackDuration = math.min((GetDistance2D(victim,camp.stackPosition)+victim.attackRange+(#creepsNearCurrentMeepo*45))/math.min(victim.movespeed,me.movespeed), 9)
							end
						end
						local moveTime = 50 - GetDistance2D(meepo,camp.position)/meepo.movespeed
						if stackDuration > 0 then
							moveTime = 60 - stackDuration - GetDistance2D(meepo,victim.position)/meepo.movespeed
						end
						if SleepCheck(meepoHandle.."stack") and SleepCheck(meepoHandle.."-move") and not meepo:IsChanneling() and 
						not tp then
							if client.gameTime % 60 < moveTime then
								if GetDistance2D(meepo,camp.waitPosition) > 50 then
									meepo:Move(camp.waitPosition)
								end
							elseif (not victim or not victim.visible) then
								if GetDistance2D(meepo,camp.position) > 50 then
									meepo:Move(camp.position)
								end
							end
							Sleep(750,meepoHandle.."-move")
						end
						if client.gameTime % 60 > moveTime then
							if victim and victim.alive then
								meepoTable[meepoHandle].foundCreep = true
								JungleCamps[camp.id].farmed = false
								if SleepCheck(meepoHandle.."-moveStack") and (client.gameTime % 60 > (60 - stackDuration) and client.gameTime % 60 < 57) and (GetDistance2D(victim,meepo) < 700 or JungleCamps[camp.id].stacking) then	
									local pos = (camp.stackPosition - victim.position) * (GetDistance2D(camp.stackPosition,victim) + victim.attackRange) / GetDistance2D(camp.stackPosition,victim) + camp.stackPosition
									meepo:Move(pos)
									Sleep((GetDistance2D(meepo,pos)/meepo.movespeed)*1000,meepoHandle.."-moveStack")
									Sleep((60 - (client.gameTime % 60))*1000,meepoHandle.."stack")
									JungleCamps[camp.id].stacking = true
								elseif SleepCheck(meepoHandle.."stack") and not JungleCamps[camp.id].stacking and SleepCheck(meepoHandle.."-attack") then
									local pos = (victim.position - meepo.position) * (GetDistance2D(meepo.position,victim) - 800) / GetDistance2D(meepo.position,victim) + victim.position
									meepo:Move(pos)
									meepo:Move(camp.stackPosition,true)
									Sleep(5000,meepoHandle.."-attack")
								end
							end
						end
					end
				end
			
				--Drawings
				local meepoUlt = meepo:GetAbility(4)
				local meeponumber = (meepoUlt:GetProperty( "CDOTA_Ability_Meepo_DividedWeStand", "m_nWhichDividedWeStand" ) + 1)
				if not meepoNumberSigns[meepoHandle] then
					if meeponumber == 1 then
						meepoNumberSigns[meepoHandle] = drawMgr:CreateText(-7*monitor,-90*monitor,-1,""..meeponumber,F15)
					else
						meepoNumberSigns[meepoHandle] = drawMgr:CreateText(-7*monitor,-80*monitor,-1,""..meeponumber,F15)
					end
					meepoNumberSigns[meepoHandle].visible = true
					meepoNumberSigns[meepoHandle].entity = meepo
					meepoNumberSigns[meepoHandle].entityPosition = Vector(0,0,meepo.healthbarOffset)
				end
				if not meepoNumberSigns[meepoHandle.."-num"] then
					meepoNumberSigns[meepoHandle.."-num"] = drawMgr:CreateText(2*monitor,70*monitor + 82*(meeponumber-1)*monitor,-1,""..meeponumber,F15)
				end
				if not meepoNumberSigns[meepoHandle.."-minimap"] then
					local minimap_vec = MapToMinimap(meepo.position.x,meepo.position.y)
					meepoNumberSigns[meepoHandle.."-minimap"] = drawMgr:CreateText(minimap_vec.x-2+minimapMove,minimap_vec.y-5,-1,""..meeponumber,F13)
				elseif SleepCheck(meepoHandle.."-minimap") then
					local minimap_vec = MapToMinimap(meepo.position.x,meepo.position.y)
					meepoNumberSigns[meepoHandle.."-minimap"].x, meepoNumberSigns[meepoHandle.."-minimap"].y = minimap_vec.x-2+minimapMove,minimap_vec.y-5
					Sleep(Animations.maxCount*2, meepoHandle.."-minimap")
				end
				local sign = statesSigns[meepoTable[meepoHandle].state]
				if sign then
					if not meepoStateSigns[meepoHandle] then
						meepoStateSigns[meepoHandle] = drawMgr:CreateText(120*monitor,82*meeponumber*monitor,sign[2],""..sign[1],F14) meepoStateSigns[meepoHandle].visible = true
					else
						meepoStateSigns[meepoHandle].text = ""..sign[1]
						if meepoTable[meepoHandle].state == STATE_CHASE and meepoTable[meepoHandle].victim then 
							meepoStateSigns[meepoHandle].text = meepoStateSigns[meepoHandle].text..": "..client:Localize(meepoTable[meepoHandle].victim.name)
						end
						meepoStateSigns[meepoHandle].color = sign[2]
					end
				end
				
				--Determining move and idle states
				if meepo.state == STATE_NONE or meepo.state == STATE_MOVE then
					if meepo.activity == LuaEntityNPC.ACTIVITY_MOVE then
						meepoTable[meepoHandle].state = STATE_MOVE
					elseif meepo.activity == LuaEntityNPC.ACTIVITY_IDLE then
						meepoTable[meepoHandle].state = STATE_NONE
					end
				end

			else
			
				--Reseting meepo attributes when he ded
				meepoTable[meepoHandle].state = STATE_NONE
				meepoTable[meepoHandle].victim = nil
				meepoTable[meepoHandle].foundCreep = false
				meepoTable[meepoHandle].camp = nil
				meepoTable[meepoHandle].victimFogTime = 0			
			end
		end
	end 
end

----Better functions to collect our meepos. Currently broken in Ensage

-- function meepoAdd(entity)
	-- if entity.type == LuaEntity.TYPE_MEEPO and not meepoTable[entity.handle] then
		-- meepoTable[entity.handle] = entity
	-- end
-- end

-- function meepoUpdate(propertyName,entity,newData)
	-- if entity.type == LuaEntity.TYPE_MEEPO then
		-- meepoTable[entity.handle] = entity
	-- end
-- end

----Function called on Load, registers our Main tick function and ensures reseting of all variables and settings to prevent crash

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Meepo then 
			script:Disable()
		else
			reg = true
			start = false
			myId = me.classId
			active = true
			meepoTable = {}
			DWS = {}
			collectMeepos(true)
			base = nil
			allies = nil 
			enemies = nil
			poofDamage = { 0, 0 }
			meepoStateSigns = {}
			meepoMinimapNumberSigns = {}
			meepoNumberSigns = {}
			spellDamageTable = {}
			entitiesForPush = {}
			mousehoverCamp = nil
			closestCamp = nil
			JungleCamps = {
				{position = Vector(-1131,-4044,127), stackPosition = Vector(-2498.94,-3517.86,128), waitPosition = Vector(-1401.69,-3791.52,128), team = 2, id = 1, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
				{position = Vector(-366,-2945,127), stackPosition = Vector(-534.219,-1795.27,128), waitPosition = Vector(536,-3001,256), team = 2, id = 2, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
				{position = Vector(1606.45,-3433.36,256), stackPosition = Vector(1325.19,-5108.22,256), waitPosition = Vector(1541.87,-4265.38,256), team = 2, id = 3, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
				{position = Vector(3126,-3439,256), stackPosition = Vector(4410.49,-3985,256), waitPosition = Vector(3401.5,-4233.39,256), team = 2, id = 4, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
				{position = Vector(3031.03,-4480.06,256), stackPosition = Vector(1368.66,-5279.04,256), waitPosition = Vector(2939.61,-5457.52,256), team = 2, id = 5, farmed = false, lvlReq = 1, visible = false, visTime = 0, stacking = false},
				{position = Vector(-2991,191,256), stackPosition = Vector(-3483,-1735,247), waitPosition = Vector(-2433,-356,256), team = 2, id = 6, farmed = false, lvlReq = 12, visible = false, visTime = 0, ancients = true, stacking = false},
				{position = Vector(1167,3295,256), stackPosition = Vector(570.86,4515.96,256), waitPosition = Vector(1011,3656,256), team = 3, id = 7, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
				{position = Vector(-244,3629,256), stackPosition = Vector(-1170.27,4581.59,256), waitPosition = Vector(-515,4845,256), team = 3, id = 8, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
				{position = Vector(-1588,2697,127), stackPosition = Vector(-1302,3689.41,136.411), waitPosition = Vector(-1491,2986,127), team = 3, id = 9, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
				{position = Vector(-3157.74,4475.46,256), stackPosition = Vector(-3296.1,5508.48,256), waitPosition = Vector(-3086,4924,256), team = 3, id = 10, farmed = false, lvlReq = 1, visible = false, visTime = 0, stacking = false},
				{position = Vector(-4382,3612,256), stackPosition = Vector(-3026.54,3819.69,132.345), waitPosition = Vector(-3995,3984,256), team = 3, id = 11, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
				{position = Vector(4026,-709.943,128), stackPosition = Vector(2228.46,-1046.78,128), waitPosition = Vector(3122,-1158.69,128), team = 3, id = 12, farmed = false, lvlReq = 12, visible = false, visTime = 0,  ancients = true, stacking = false}
			}
			campSigns = {}
			script:RegisterEvent(EVENT_FRAME, Main)
			-- script:RegisterEvent(EVENT_ENTITY_ADD, meepoAdd)
			-- script:RegisterEvent(EVENT_ENTITY_UPDATE, meepoUpdate)
			script:RegisterEvent(EVENT_KEY, Key)
			script:UnregisterEvent(Load)
		end
	end	
end

----Function called on close, unregisters our Main tick function and resets everything as well

function Close()
	start = false
	myId = nil
	active = true
	meepoTable = {}
	DWS = {}
	base = nil
	allies = nil 
	enemies = nil
	poofDamage = { 0, 0 }
	meepoStateSigns = {}
	meepoMinimapNumberSigns = {}
	meepoNumberSigns = {}
	spellDamageTable = {}
	entitiesForPush = {}
	mousehoverCamp = nil
	closestCamp = nil
	JungleCamps = {
		{position = Vector(-1131,-4044,127), stackPosition = Vector(-2498.94,-3517.86,128), waitPosition = Vector(-1401.69,-3791.52,128), team = 2, id = 1, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
		{position = Vector(-366,-2945,127), stackPosition = Vector(-534.219,-1795.27,128), waitPosition = Vector(536,-3001,256), team = 2, id = 2, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
		{position = Vector(1606.45,-3433.36,256), stackPosition = Vector(1325.19,-5108.22,256), waitPosition = Vector(1541.87,-4265.38,256), team = 2, id = 3, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
		{position = Vector(3126,-3439,256), stackPosition = Vector(4410.49,-3985,256), waitPosition = Vector(3401.5,-4233.39,256), team = 2, id = 4, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
		{position = Vector(3031.03,-4480.06,256), stackPosition = Vector(1368.66,-5279.04,256), waitPosition = Vector(2939.61,-5457.52,256), team = 2, id = 5, farmed = false, lvlReq = 1, visible = false, visTime = 0, stacking = false},
		{position = Vector(-2991,191,256), stackPosition = Vector(-3483,-1735,247), waitPosition = Vector(-2433,-356,256), team = 2, id = 6, farmed = false, lvlReq = 12, visible = false, visTime = 0, ancients = true, stacking = false},
		{position = Vector(1167,3295,256), stackPosition = Vector(570.86,4515.96,256), waitPosition = Vector(1011,3656,256), team = 3, id = 7, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
		{position = Vector(-244,3629,256), stackPosition = Vector(-1170.27,4581.59,256), waitPosition = Vector(-515,4845,256), team = 3, id = 8, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
		{position = Vector(-1588,2697,127), stackPosition = Vector(-1302,3689.41,136.411), waitPosition = Vector(-1491,2986,127), team = 3, id = 9, farmed = false, lvlReq = 3, visible = false, visTime = 0, stacking = false},
		{position = Vector(-3157.74,4475.46,256), stackPosition = Vector(-3296.1,5508.48,256), waitPosition = Vector(-3086,4924,256), team = 3, id = 10, farmed = false, lvlReq = 1, visible = false, visTime = 0, stacking = false},
		{position = Vector(-4382,3612,256), stackPosition = Vector(-3026.54,3819.69,132.345), waitPosition = Vector(-3995,3984,256), team = 3, id = 11, farmed = false, lvlReq = 8, visible = false, visTime = 0, stacking = false},
		{position = Vector(4026,-709.943,128), stackPosition = Vector(2228.46,-1046.78,128), waitPosition = Vector(3122,-1158.69,128), team = 3, id = 12, farmed = false, lvlReq = 12, visible = false, visTime = 0,  ancients = true, stacking = false}
	}
	campSigns = {}
	collectgarbage("collect")
	if reg then
		script:UnregisterEvent(Main)
		-- script:UnregisterEvent(meepoAdd)
		-- script:UnregisterEvent(meepoUpdate)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

--Registering our Load and Close functions

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)

--END of GLOBAL CONSTANTS--

--FUNCTIONS--

----Determining if given spell can be casted by meepo

function canCast(meepo, spell) 
	return meepo and spell and spell:CanBeCasted() and meepo:CanCast()
end

----Determining if victim will get hit by Poof

function willHit(meepo, victim, radius, n)
	local near,dist,nearMeepo = anyMeepoisNear(victim, radius, meepo)
	return ((radius and GetDistance2D(meepo, victim) <= radius+150) or (n and near and dist <= radius+150)) and 
	(victim:IsStunned() or victim:IsRooted() or victim.creep or victim.classId == CDOTA_BaseNPC_Creep_Neutral or 
	(Animations.isAttacking(victim) and victim.hero) or 
	(n and near and nearMeepo.handle ~= meepo.handle) or victim.activity == LuaEntityNPC.ACTIVITY_IDLE)
end

----Determining when to use earthbind to ensure 100% chaining

function chainEarthbind(meepo, victim, delay)
	local chain = false
	local stunned = false
	local modifiers_table = {"modifier_shadow_demon_disruption", "modifier_obsidian_destroyer_astral_imprisonment_prison", 
		"modifier_eul_cyclone", "modifier_invoker_tornado", "modifier_bane_nightmare", "modifier_shadow_shaman_shackles", 
		"modifier_crystal_maiden_frostbite", "modifier_ember_spirit_searing_chains", "modifier_axe_berserkers_call",
		"modifier_lone_druid_spirit_bear_entangle_effect", "modifier_meepo_earthbind", "modifier_naga_siren_ensnare",
		"modifier_storm_spirit_electric_vortex_pull", "modifier_treant_overgrowth"}
	local modifiers = victim.modifiers
	for i,m in pairs(modifiers) do
		for i,k in pairs(modifiers_table) do
			if m and (m.stunDebuff or m.name == k) then
				stunned = true
				if m.remainingTime < delay then
					chain = true
				end
			end
		end
	end
	local isFacing = isFacingAnyMeepo(victim)
	return not (Animations.isAttacking(victim) and (isFacing or (victim.hero and (math.max(math.abs(FindAngleR(victim) - math.rad(FindAngleBetween(victim, meepo))) - 0.20, 0)) <= 0.01))) and (not (stunned or victim:IsStunned()) or chain)
end

----Collecting our meepos

function collectMeepos(nofarm)
	local me = entityList:GetMyHero()
	local meepos = entityList:GetEntities({type=LuaEntity.TYPE_MEEPO, team=me.team})
	for i,meepo in ipairs(meepos) do
		if not meepoTable[meepo.handle] then
			meepoTable[meepo.handle] = meepo
			if nofarm then
				meepoTable[meepo.handle].state = STATE_NONE
			else
				meepoTable[meepo.handle].state = STATE_FARM_JUNGLE
			end
			meepoTable[meepo.handle].lastState = nil
			meepoTable[meepo.handle].victim = nil
			meepoTable[meepo.handle].lastcamp = nil
			meepoTable[meepo.handle].foundCreep = false
			meepoTable[meepo.handle].camp = nil
			meepoTable[meepo.handle].victimFogTime = 0
			meepoTable[meepo.handle].poof = meepo:GetAbility(2)
			meepoTable[meepo.handle].earthbind = meepo:GetAbility(1)
		end
	end
end

----Checking if any meepo is casting Earthbind right now

function earthbindAnimation()
	local me = entityList:GetMyHero()
	for i,meepo in pairs(meepoTable) do
		local earthbind = meepo:GetAbility(1)
		if earthbind and earthbind.abilityPhase then
			return true
		end
	end
	return false
end

----Checking if any meepo is farming

function anyMeepoIsPushing()
	for i,meepo in pairs(meepoTable) do
		if meepo.state == STATE_PUSH then
			return true
		end
	end
	return false
end

----Getting position where to move for meepos to attempt blocking victim

function getBlockPositions(victim,rotR,meepo)
	local me = entityList:GetMyHero()
	local rotR1,rotR2 = -rotR,(-3-rotR)
	local infront = Vector(victim.position.x+me.movespeed*math.cos(rotR), victim.position.y+me.movespeed*math.sin(rotR), victim.position.z)
	local behind = Vector(victim.position.x+(-me.movespeed/2)*math.cos(rotR), victim.position.y+(-me.movespeed/2)*math.sin(rotR), victim.position.z)
	return Vector(infront.x+90*math.cos(rotR1), infront.y+90*math.sin(rotR1), infront.z),
	Vector(infront.x+90*math.cos(rotR2), infront.y+90*math.sin(rotR2), infront.z),
	Vector(behind.x+120*math.cos(rotR1), behind.y+120*math.sin(rotR1), behind.z),
	Vector(behind.x+120*math.cos(rotR2), behind.y+120*math.sin(rotR2), behind.z),infront
end

----Checking if victim is facing any of our meepos

function isFacingAnyMeepo(victim)
	for i,m in pairs(meepoTable) do
		if (math.max(math.abs(FindAngleR(victim) - math.rad(FindAngleBetween(victim, m))) - 0.20, 0)) <= 0.01 then
			return true
		end
	end
	return false
end

----Checking if we have any meepo near victim

function anyMeepoisNear(victim, range, meepo)
	local closest = nil
	for i,m in pairs(meepoTable) do
		if victim then
			local pos = victim
			if GetType(pos) ~= "Vector" then pos = victim.position end
			local mpos = m.position
			local dist = GetDistance2D(mpos,pos)
			if not closest or dist < GetDistance2D(closest,pos) then
				closest = m
			end	
		end
	end
	if closest then
		local pos = victim
		if GetType(pos) ~= "Vector" then pos = victim.position end
		local mpos = closest.position
		if victim.activity == LuaEntityNPC.ACTIVITY_MOVE then
			pos = Vector(victim.position.x+(victim.movespeed*1.5)*math.cos(victim.rotR), victim.position.y+(victim.movespeed*1.5)*math.sin(victim.rotR), victim.position.z)
		end
		if closest.activity == LuaEntityNPC.ACTIVITY_MOVE then
			mpos = Vector(closest.position.x+(closest.movespeed)*math.cos(closest.rotR), closest.position.y+(closest.movespeed)*math.sin(closest.rotR), closest.position.z)
		end
		local dist = GetDistance2D(mpos,pos)
		if (range and dist < range) and (not meepo or closest.handle ~= meepo.handle) then
			return true,dist,closest
		end
	end
	return false,0,nil
end

----Returns closest meepo to victim

function getClosest(victim, num, net)
	local me = entityList:GetMyHero()
	--local meepos = entityList:GetEntities({type=LuaEntity.TYPE_MEEPO, team=me.team, alive=true})
	if net then
		local closest = nil
		for i, meepo in pairs(meepoTable) do
			if meepo.alive and (meepo:GetAbility(1) and canCast(meepo, meepo:GetAbility(1))) and (not closest or GetDistance2D(meepo,victim) < GetDistance2D(closest,victim)) then
				closest = meepo
			end
		end
		return closest
	elseif num > 1 then
		--table.sort(meepos, function (a,b) return GetDistance2D(a,victim) < GetDistance2D(b,victim) end)		
		local returnTable = {}
		local number = 0
		for i, meepo in pairs(meepoTable) do
			number = number + 1
			local vic = meepoTable[i].victim
			if meepo.alive and number <= num and not vic then
				returnTable[i] = meepo
			end
		end
		return returnTable 
	else
		--table.sort(meepos, function (a,b) return GetDistance2D(a,victim) < GetDistance2D(b,victim) end)
		local returnTable = {}
		for i, meepo in pairs(meepoTable) do
			local vic = meepoTable[i].victim
			if meepo.alive and not vic then
				returnTable[i] = meepo
				return returnTable
			end
		end
	end
	return nil
end

----Returns number of alive meepos

function getAliveNumber(all)
	local number = 0
	for i, meepo in pairs(meepoTable) do
		if meepo.alive and (meepo.state ~= STATE_HEAL or all) then
			number = number + 1
		end
	end
	return number
end		

----Checks if main meepo has items for heal and is close to given meepo

function haveHealingItems(meepo)
	local me = entityList:GetMyHero()
	local isMe = false
	if meepo.handle == me.handle then
		me = meepo
		isMe = true
	end
	local salve = me:FindItem("item_flask")
	local bottle = me:FindItem("item_bottle")
	local items = {}
	if salve then
		items[#items+1] = salve
	end
	if bottle and bottle.charges > 0 then
		items[#items+1] = bottle
	end
	if items[1] and (GetDistance2D(me, meepo) < 1000 or isMe) then
		return false, items, isMe
	end
	return true, nil
end


----Checks if given meepo is in danger

function IsInDanger(meepo,except)
	if meepo and meepo.alive and meepo.health > 0 then
		for k,z in pairs(entityList:GetProjectiles({target=meepo})) do
			if z and z.source and z.target == meepo and (not except or z.source.handle ~= except.handle) and (GetDistance2D(z,z.source) < 1000 or z.source.dmgMin > meepo.health) then
				return true
			end
		end
		for i,v in pairs(enemies) do	
			if v.alive and v.visible and GetDistance2D(meepo,v) < 1000 and (not except or v.handle ~= except.handle) then
				return true
			end
		end
		for i,v in pairs(entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Neutral,alive=true,visible=true})) do	
			if GetDistance2D(meepo,v) < v.attackRange+50 and (not except or v.handle ~= except.handle) and v.activity == LuaEntityNPC.ACTIVITY_ATTACK then
				return true
			end
			for i,k in pairs(v.abilities) do
				if GetDistance2D(meepo,v) < math.min(k.castRange+50,1000) and (not except or v.handle ~= except.handle) then
					return true
				end
			end
		end
		local modifiers = {"modifier_item_urn_damage","modifier_doom_bringer_doom","modifier_axe_battle_hunger",
		"modifier_queenofpain_shadow_strike","modifier_phoenix_fire_spirit_burn","modifier_venomancer_poison_nova",
		"modifier_venomancer_venomous_gale","modifier_silencer_curse_of_the_silent","modifier_silencer_last_word","modifier_spirit_breaker_charge_of_darkness_vision",
		"modifier_bloodseeker_thirst"}
		for i,v in pairs(modifiers) do 
			if meepo:DoesHaveModifier(v) then
				return true
			end
		end
	end
end

----Return how many meepos are farming this camp

function getFarmingMeeposCamp(camp,current)
	if camp then
		local number = 0
		for meepoHandle, meepo in pairs(meepoTable) do
			local meepo = meepoTable[meepoHandle]
			if meepo.camp and meepo.camp == camp then
				number = number + 1
			end
		end
		return number
	end
end

----Returns closest jungle camp for given meepo

function getClosestCamp(meepo, stack, num)
	if meepo and meepo.alive then
		local closest = nil
		for i, camp in ipairs(JungleCamps) do
			local number = getFarmingMeeposCamp(camp,meepo)
			local cnumber = 0
			if closest then 
				cnumber = getFarmingMeeposCamp(closest,meepo)
			end
			local reqNum = 1
			if camp.ancients then
				reqNum = 2
			elseif meepo.level < 10 then
				reqNum = 3
			end
			if (camp.team == meepo.team or ((not num or num < 2) and client.gameTime > 2400)) and ((not camp.visible and ((not stack and meepo.level >= camp.lvlReq) or (stack and camp.lvlReq == 8)) and (camp.team == meepo.team or meepo.level >= 17) and (number < reqNum and (not camp.ancients or (meepo.level >= 17 or entityList:GetMyHero():AghanimState()))))) and 
			(not closest or GetDistance2D(meepo,camp.position) < GetDistance2D(meepo,closest.position) or cnumber > 2 or closest.farmed or closest.visible) and not camp.farmed and not camp.visible then
				
				closest = camp
			end
		end
		return closest
	end
end

----Returns closest wait position

function getClosestPos(meepo)
	if meepo and meepo.alive then
		local closest = nil
		for i, camp in ipairs(JungleCamps) do	
			if camp.team == meepo.team and (not closest or GetDistance2D(meepo,camp.waitPosition) < GetDistance2D(meepo,closest.waitPosition)) then
				closest = camp
			end
		end
		return closest
	end
end

----Returns farrest meepo

function getFarrestMeepo(meepo)
	if meepo and meepo.alive then
		local farrest = nil
		for i, farMeepo in pairs(meepoTable) do
			if farMeepo.handle ~= meepo.handle and (not farrest or (GetDistance2D(farMeepo,meepo) > GetDistance2D(farrest,meepo))) then
				farrest = farMeepo
			end
		end
		return farrest
	end
end

----Returns number of near victims

function getNearVictims(meepo)
	if meepo and meepo.alive then
		local number = 0
		for i, v in ipairs(enemies) do
			if v.alive and GetDistance2D(v,meepo) <= v.dayVision then
				number = number + 1 
			end
		end
		return number
	end
end

----Use TP

function useTP(meepo, meepoHandle, position, nopoof)
	if SleepCheck(meepoHandle.."-casting") and position and GetDistance2D(meepo,position) > 5000 then
		local travels = meepo:FindItem("item_travel_boots")
		local tp = meepo:FindItem("item_tpscroll")
		local item = nil
		local poof = meepoTable[meepoHandle].poof
		local near,dist,nearMeepo = anyMeepoisNear(position, 5000, meepo)
		local victim = meepoTable[meepoHandle].victim
		if victim and victim.hero then
			near,dist,nearMeepo = anyMeepoisNear(position, 1000, meepo)
		end
		if not nopoof and poof and poof.level > 0 and canCast(meepo, poof) and near and GetDistance2D(nearMeepo,meepo) > 1000 then
			meepo:CastAbility(poof,position)
			meepo:Move(position, true)
			meepoTable[meepoHandle].lastState = meepoTable[meepoHandle].state
			meepoTable[meepoHandle].state = STATE_POOF_OUT
			Sleep(poof:FindCastPoint()*1000,meepoHandle.."-casting")
			return true
		end
		if travels then item = travels else item = tp end
		if item and canCast(meepo, item) then
			meepo:CastAbility(item,position)
			meepo:Move(position, true)	
			Sleep(3000,meepoHandle.."-casting")
			return true
		end
	end
end

function GetAttackRange(hero)
	local bonus = 0
	if hero.classId == CDOTA_Unit_Hero_TemplarAssassin then		
		local psy = hero:GetAbility(3)
		psyrange = {60,120,180,240}			
		if psy and psy.level > 0 then			
			bonus = psyrange[psy.level]				
		end			
	elseif hero.classId == CDOTA_Unit_Hero_Sniper then		
		local aim = hero:GetAbility(3)
		aimrange = {100,200,300,400}			
		if aim and aim.level > 0 then		
			bonus = aimrange[aim.level]				
		end			
	end		
	return hero.attackRange + bonus
end

----returns damage going on meepo

function IncomingDamage(unit,onlymagic,lane)
	if unit and unit.alive and unit.health > 0 then
		local result = 0
		local results = {}
		local resultsMagic = {}
		local enemy = enemies
		if #enemies > 0 and unit.team == enemy[1].team then
			enemy = allies
		end		
		for i,v in pairs(enemy) do	
			if v.alive and v.visible then
				if not onlymagic and not results[v.handle] and (Animations.isAttacking(v) or GetDistance2D(unit,v) < 200) and GetDistance2D(unit,v) <= GetAttackRange(v) + 50 and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, unit))) - 0.20, 0)) == 0 then
					local dmg = math.floor(unit:DamageTaken((v.dmgMax+v.dmgBonus)*(4/(Animations.getBackswingTime(v)+Animations.GetAttackTime(v)) + client.latency/1000),DAMAGE_PHYS,v))
					if v.type == LuaEntity.TYPE_MEEPO then
						dmg = dmg*getAliveNumber()
					end
					result = result + dmg
					results[v.handle] = true
				end
				for i,k in pairs(unit.modifiers) do
					local spell = v:FindSpell(k.name:gsub("modifier_",""))
					if spell then
						local dmg
						if not spellDamageTable[spell.handle] or spellDamageTable[spell.handle][2] ~= spell.level or spellDamageTable[spell.handle][3] ~= v.dmgMin+v.dmgBonus or spellDamageTable[spell.handle][4] ~= v.attackSpeed then
							spellDamageTable[spell.handle] = { AbilityDamage.GetDamage(spell), spell.level, v.dmgMin+v.dmgBonus, v.attackSpeed }
						end
						dmg = spellDamageTable[spell.handle][1]
						if v.type == LuaEntity.TYPE_MEEPO then
							dmg = dmg*getAliveNumber()
						end
						if dmg and dmg > 0 and not resultsMagic[spell.handle] and not resultsMagic[k.handle] then
							result = result + math.floor(unit:DamageTaken(dmg,AbilityDamage.GetDmgType(spell),v))
							resultsMagic[k.handle] = true
							resultsMagic[spell.handle] = true
						end
					end
				end
				for i,k in pairs(v.abilities) do
					if k.level > 0 and (k.abilityPhase or (k:CanBeCasted() and k:FindCastPoint() < 0.4)) and not resultsMagic[k.handle] and GetDistance2D(v,unit) <= k.castRange+100 and (((math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, unit))) - 0.20, 0)) == 0 
					and (k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_UNIT_TARGET) or k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_POINT))) or k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_NO_TARGET)) then
						local dmg
						if not spellDamageTable[k.handle] or spellDamageTable[k.handle][2] ~= k.level or spellDamageTable[k.handle][3] ~= v.dmgMin+v.dmgBonus or spellDamageTable[k.handle][4] ~= v.attackSpeed then
							spellDamageTable[k.handle] = { AbilityDamage.GetDamage(k), k.level, v.dmgMin+v.dmgBonus, v.attackSpeed }
						end
						dmg = spellDamageTable[k.handle][1]
						if dmg then
							result = result + math.floor(unit:DamageTaken(dmg,AbilityDamage.GetDmgType(k),v))
							resultsMagic[k.handle] = true
						end
					end
				end
				for i,k in pairs(v.items) do
					local dmg
					if not spellDamageTable[k.handle] or spellDamageTable[k.handle][2] ~= v.level or spellDamageTable[k.handle][3] ~= v.dmgMin+v.dmgBonus or spellDamageTable[k.handle][4] ~= v.attackSpeed then
						spellDamageTable[k.handle] = { AbilityDamage.GetDamage(k), v.level, v.dmgMin+v.dmgBonus, v.attackSpeed }
					end
					dmg = spellDamageTable[k.handle][1]
					if dmg and dmg > 0 and k.castRange and not resultsMagic[k.handle] and GetDistance2D(v,unit) <= k.castRange+200 then
						result = result + math.floor(unit:DamageTaken(dmg,DAMAGE_MAGC,v))
						resultsMagic[k.handle] = true
					end
				end
			end
		end	
		for i,k in pairs(entityList:GetProjectiles({target=unit})) do
			if k.source then
				local spell = k.source:FindSpell(k.name)
				if spell and not resultsMagic[k.source.handle] and not resultsMagic[k.name] then
					local dmg
					if not spellDamageTable[spell.handle] or spellDamageTable[spell.handle][2] ~= spell.level or spellDamageTable[spell.handle][3] ~= k.source.dmgMin+k.source.dmgBonus or spellDamageTable[spell.handle][4] ~= k.source.attackSpeed then
						spellDamageTable[spell.handle] = { AbilityDamage.GetDamage(spell), spell.level, k.source.dmgMin+k.source.dmgBonus, k.source.attackSpeed }
					end
					dmg = spellDamageTable[spell.handle][1]
					if k.source.type == LuaEntity.TYPE_MEEPO then
						dmg = dmg*getAliveNumber()
					end
					if dmg then
						result = result + math.floor(unit:DamageTaken(dmg,AbilityDamage.GetDmgType(spell),k.source))
						resultsMagic[k.source.handle] = true
						resultsMagic[k.name] = true
					end
				elseif not onlymagic and k.source and not results[k.source.handle] and k.source.dmgMax then
					local dmg = math.floor(unit:DamageTaken((k.source.dmgMax+k.source.dmgBonus)*(4/(Animations.getBackswingTime(k.source)+Animations.GetAttackTime(k.source)) + client.latency/1000),DAMAGE_PHYS,k.source))
					if k.source.type == LuaEntity.TYPE_MEEPO then
						dmg = dmg*getAliveNumber()
					end
					result = result + dmg
					results[k.source.handle] = true
				end
			end
		end		
		if result and (not lane or unit.health < 300) then
			return result
		else
			return 0
		end
	end
end

----Switching treads for mana

function SwitchTreads(back)
	local me = entityList:GetMyHero()
	local treads = me:FindItem("item_power_treads")
	if treads and SleepCheck("treads") and me.alive then
		local state = treads.bootsState
		if back then
			if state == 1 then
				me:CastAbility(treads)
				Sleep(200+client.latency,"treads")
			elseif state == 0 then
				me:CastAbility(treads)
				me:CastAbility(treads)
				Sleep(200+client.latency,"treads")
			end
		else
			if state == 2 then
				me:CastAbility(treads)
				me:CastAbility(treads)
				Sleep(2000+client.latency,"treads")
			elseif state == 0 then
				me:CastAbility(treads)
				Sleep(2000+client.latency,"treads")
			end
		end
	end
end

----OrbWalks on victim, uses spells and abilities

function OrbWalk(meepo, meepoHandle, victim, usePoof)
	local player = entityList:GetMyPlayer()
	local me = entityList:GetMyHero()
	local poof = meepoTable[meepoHandle].poof

	if meepo:IsChanneling() then return end
	local infront = Vector(victim.position.x+150*math.cos(victim.rotR), victim.position.y+150*math.sin(victim.rotR), victim.position.z)
	local position = nil

	if not Animations.CanMove(meepo) and victim and victim.alive then
					
		--Cast Poof global
		if poof and SleepCheck(meepoHandle.."-casting") and victim and victim.visible and meepo.health > meepo.maxHealth/2.5 then
			local radius = poof:GetSpecialData("radius", poof.level)
			local near,dist,nearMeepo = anyMeepoisNear(victim, radius, meepo)
			if near and poof.level > 0 and GetDistance2D(meepo,nearMeepo) > 700 and (willHit(meepo, victim, radius, true) or GetDistance2D(meepo,victim) > radius*1.5) then
				if canCast(meepo, poof) then
					SwitchTreads()
					meepo:CastAbility(poof,nearMeepo)
					meepoTable[meepoHandle].lastState = meepoTable[meepoHandle].state
					meepoTable[meepoHandle].state = STATE_POOF_OUT
					Sleep(poof:FindCastPoint()*1000,meepoHandle.."-casting")
				elseif poof.state == LuaEntityAbility.STATE_NOMANA then
					SwitchTreads()
				end
			end
		end	
			
		--Attack
		if SleepCheck(meepoHandle.."-attack") and SleepCheck(meepoHandle.."-casting") then
			meepo:Attack(victim)
			Sleep(Animations.GetAttackTime(meepo)*1000,meepoHandle.."-attack")
		end
	else
			
		--Cast Poof
		if poof and SleepCheck(meepoHandle.."-casting") and victim and victim.visible and not victim:IsMagicImmune() and victim.alive and usePoof and not victim.ancient and 
		victim.classId ~= CDOTA_BaseNPC_Tower and victim.classId ~= CDOTA_BaseNPC_Creep_Siege then
			local hitDmg = math.ceil(victim:DamageTaken((meepo.dmgMin + meepo.dmgMax)/2,DAMAGE_PHYS,meepo))
			local poofDmg = math.ceil(victim:DamageTaken(poofDamage[1],DAMAGE_MAGC,meepo))
			local radius = poof:GetSpecialData("radius", poof.level)
			local near,dist,nearMeepo = anyMeepoisNear(victim, radius, meepo)
			local near2,dist2,nearMeepo2 = anyMeepoisNear(victim, 1300, meepo)

			if poofDmg/1.5 > hitDmg and ((not chainEarthbind(meepo, victim, poof:FindCastPoint()+0.4) and victim:IsInvisible()) or not victim:IsInvisible() or victim.creep or 
			victim.classId == CDOTA_BaseNPC_Creep_Neutral or victim.classId == CDOTA_BaseNPC_Creep_Lane or (not meepo:GetAbility(1) or not canCast(meepo, meepo:GetAbility(1)))) and poof.level > 0 
			and willHit(meepo, victim, radius, false) and (not meepo.camp or (GetDistance2D(meepo, meepo.camp.position) < radius+25) or meepo.state == STATE_PUSH) then
				if canCast(meepo, poof) then					
					SwitchTreads()
					if (near and (dist and GetDistance2D(meepo,victim) > dist)) or near2 then
						meepo:CastAbility(poof,nearMeepo)
						Sleep(poof:FindCastPoint()*1000,meepoHandle.."-casting")
					elseif willHit(meepo, victim, radius, false) then
						meepo:CastAbility(poof,meepo)
						Sleep(poof:FindCastPoint()*1000,meepoHandle.."-casting")
					end
				elseif poof.state == LuaEntityAbility.STATE_NOMANA then
					SwitchTreads()
				end
			end
		end
		
		--Block victim if there is any, or try to get in better position
		if SleepCheck(meepoHandle.."-casting") and SleepCheck(meepoHandle.."-move") then
			if victim and victim.alive then
				meepo:Follow(victim)
			else
				meepoTable[meepoHandle].state = 10
				meepo:Move(client.mousePosition)
			end	
			Sleep(Animations.getBackswingTime(meepo)*1000,meepoHandle.."-move")
			if meepoHandle == me.handle then
				start = false
			end
		end
	end
end

--Shop Opened ((C) Nyan)

function shop()
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y	
	local ShopPanel = {1920-565,76,1920,80+774}
	if client.shopOpen and mx >= ShopPanel[1] and mx <= ShopPanel[3] and my >= ShopPanel[2] and my <= ShopPanel[4] then 
		return false 
	end
	return true
end
				
--END of FUNCTIONS--
