--<<Shoot Arrow Hit Arrow Script by Moones version 1.5.1>>
--[[
	-------------------------------------
	| Shoot Arrow Hit Arrow Script by Moones |
	-------------------------------------
	========== Version 1.5.1 ============
	 
	Description:
	------------
	
		AutoArrow with prediction:
			- When hotkey is pressed Mirana will shoot arrow at enemy within Arrow range and with lowest HP.
		Auto shoot perfectly timed Arrow:
			- When enemy is stunned or rooted.
	   
	Changelog:
	----------
		Update 1.5.1:
			Fixed timed arrow when theres more stunned enemies
			
		Update 1.5:
			Improved timing for shooting stunned or rooted enemies.
			Added AutoArrow canceling.
		
		Update 1.4a:
			Fixed not shooting into fog.
		Update 1.4:
			Added check if arrow can be blocked by units. Added checking if enemy in range of arrow is stunned, in that case Mirana will auto shoot perfectly timed arrow(with block check).
		Update 1.3:
			Added Blind Prediction - when enemy goes to fog or becomes invisible, Shoot BLIND Arrow! sign will appear and when you press the hotkey Mirana will shoot arrow with prediction based on enemy last facing angle and movement speed. If you also want to see what is prediction based on and current predicted enemy position enable with this script Blind Prediction script
		Update 1.2:
			Improved prediction, fixed arrow being too distant, updated SkillShot lib
		Update 1.1b:
			Added combo with Disruption, Astral Imprisonment, Nightmare, Shackles, Euls Cyclone: When one of these is used on enemy, Mirana will shoot the perfectly timed Arrow on it 
		Update 1.0b:
			First release. Bugs may appear, so feel free to report them.
]]--


require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.SkillShot")
require("libs.VectorOp")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Arrowkey", "D", config.TYPE_HOTKEY)
config:SetParameter("StopKey", "S", config.TYPE_HOTKEY)
config:SetParameter("ArrowTolerancy", 800)
config:SetParameter("LineSleep", 500)
config:SetParameter("ShowLineAlways", false)
config:SetParameter("ShowLinefortimedArrow", true)
config:Load()

local key = config.Hotkey
local arrowkey = config.Arrowkey

victimHandle = nil

local myFont = drawMgr:CreateFont("Mirana","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Shoot Arrow hit Arrow!",myFont);
local active = true
local shoot = nil
local victim = nil
local timing = false
local xyz = nil
local line = {}
local pos = nil

function ArrowKey(msg,code)	
	if msg ~= KEY_UP or client.chat then return end

	if code == arrowkey and active and victim and victim.visible then     
		if not shoot then
			shoot = true
			return true
		else
			shoot = nil
			return true
		end
	elseif code == key then
		if not active then
			active = true
			statusText.text = "Shoot Arrow hit Arrow!"
			return true
		else
			active = nil
			statusText.text = "   OFF!"
			return true
		end
	end
end

function Main(tick)
	if not IsIngame() or client.console or not SleepCheck() then return end

	local me = entityList:GetMyHero()

	if not me then return end

	if me.classId ~= CDOTA_Unit_Hero_Mirana then
		statusText.visible = false
		script:Disable()
		return
	end	

	local offset = me.healthbarOffset

	statusText.entity = me
	statusText.entityPosition = Vector(0,0,offset)

	local arrow = me:GetAbility(2)

	if active then  
		
		if (IsKeyDown(config.StopKey) or IsKeyDown(key)) and ((arrow.abilityPhase and not SleepCheck("arrow")) and math.ceil(arrow.cd) ~= math.ceil(arrow:GetCooldown(arrow.level)) or not SleepCheck("arrow")) then
			xyz = nil
			shoot = nil
			if SleepCheck("stopkey") and not client.chat then
				entityList:GetMyPlayer():HoldPosition()
				Sleep(client.latency + 200, "stopkey")
				Sleep(client.latency + 200, "testarrow")
			end
			return
		end
		
		if not arrow:CanBeCasted() then
			timing = false
			xyz = false
			shoot = nil
		end
		
		if not IsKeyDown(config.StopKey) and ((arrow.abilityPhase and not SleepCheck("arrow")) and math.ceil(arrow.cd) ~= math.ceil(arrow:GetCooldown(arrow.level)) or not SleepCheck("arrow")) and xyz and victim and SleepCheck("testarrow") then
			local speed = 857.14 
			local delay = (500+client.latency)
			local testxyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
			if testxyz and (GetType(testxyz) == "Vector" or GetType(testxyz) == "Vector2D") and GetDistance2D(me,testxyz) <= 3115 and victim.alive then	
				if GetDistance2D(testxyz,me) > 3115 then
					testxyz = (testxyz - me.position) * (arrow.castRange - 100) / GetDistance2D(testxyz,me) + me.position
				end
				if not victim:DoesHaveModifier("modifier_eul_cyclone") and (((GetDistance2D(testxyz,xyz) > math.max(GetDistance2D(SkillShot.PredictedXYZ(victim,math.max(arrow:FindCastPoint()*1000-(GetDistance2D(me,victim)/speed)*1000+client.latency-100+config.ArrowTolerancy, client.latency+arrow:FindCastPoint()*1000+100)),victim), 25))) or SkillShot.__GetBlock(me.position,testxyz,victim,115,false)) then
					me:Stop()
					me:SafeCastAbility(arrow, testxyz)
					xyz = testxyz
					Sleep(math.max(arrow:FindCastPoint()*500 - client.latency,0),"testarrow")
					Sleep(arrow:FindCastPoint()*1000+client.latency,"arrow")
					return
				end
			elseif GetDistance2D(me,victim) > 3115 + 200 then
				me:Stop()
				shoot = nil
				Sleep(math.max(arrow:FindCastPoint()*500 - client.latency,0),"testarrow")
				Sleep(arrow:FindCastPoint()*1000+client.latency,"arrow")
				return
			end
		end
		
		if not timing then
			victim = targetFind:GetLowestEHP(3115, magic)
		end
		
		if arrow and arrow:CanBeCasted() and victim and GetDistance2D(victim,me) < 3115 then
			if not timing then
				statusText.text = "Shoot: " .. client:Localize(victim.name)
			end
			if SleepCheck("arrow") and arrow.level > 0 and me.alive then          
				if not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
					local speed = 857.14 
					local distance = GetDistance2D(victim, me)
					local delay = (500+client.latency)
					if xyz and SleepCheck("line") and (config.ShowLineAlways or (timing and config.ShowLinefortimedArrow)) then
						for z = 1,(GetDistance2D(victim,me)+500)/50 do
							local p = FindAB(me.position,xyz,50*z+50)
							if p then
								line[z] = Effect(p,"draw_commentator")
								line[z]:SetVector(1,Vector(65,105,255))
								line[z]:SetVector(0,p)
							end
						end
						Sleep(config.LineSleep, "line")
					else
						line = {}
					end
					xyz = SkillShot.BlockableSkillShotXYZ(me,victim,speed,delay,115,false)
					if shoot and xyz and distance <= 3115 then
						me:SafeCastAbility(arrow, xyz)
						Sleep(250,"arrow") 
					elseif not xyz and timing then
						statusText.text = "Shoot Arrow hit Arrow!"
						shoot = nil
						timing = nil
					end
				end
			end 
		else
			statusText.text = "Shoot Arrow hit Arrow!"
			if line then
				line = {}
				collectgarbage("collect")
			end
		end

		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true})) do
		
			if not v:IsIllusion() then

				if v.team ~= me.team and GetDistance2D(v,me) < 3115 then

					local modifiers_table = {"modifier_shadow_demon_disruption", "modifier_obsidian_destroyer_astral_imprisonment_prison", 
					"modifier_eul_cyclone", "modifier_invoker_tornado", "modifier_bane_nightmare", "modifier_shadow_shaman_shackles", 
					"modifier_crystal_maiden_frostbite", "modifier_ember_spirit_searing_chains", "modifier_axe_berserkers_call",
					"modifier_lone_druid_spirit_bear_entangle_effect", "modifier_meepo_earthbind", "modifier_naga_siren_ensnare",
					"modifier_storm_spirit_electric_vortex_pull", "modifier_treant_overgrowth"}
					
					if not shoot and arrow and arrow:CanBeCasted() then
						for i,m in ipairs(v.modifiers) do
							for i,k in ipairs(modifiers_table) do
								if m and m.name == "modifier_legion_commander_duel" then
									statusText.text = "Shooting dueling" .. client:Localize(victim.name)
									victim = v shoot = true timing = true break
								end
								if m and (m.stunDebuff or m.name == k) then
									if GetDistance2D(v,me) <= ( m.remainingTime*857+57.5) then
										if not timing then
											victim = v 
										end
										timing = true
										if victim then
											statusText.text = "Shooting timed Arrow on " .. client:Localize(victim.name) .. " in " .. math.max(math.floor((((m.remainingTime) * 857) - (GetDistance2D(victim,me)+428))/10)/100,0) .. " secs"
										end
									end
									if victim and v.handle == victim.handle and (m.remainingTime * 857) == GetDistance2D(v,me)+428+((client.latency/1000 + me:GetTurnTime(v)) * 857) or (( m.remainingTime * 857) < GetDistance2D(v,me)+428+((client.latency/1000 + me:GetTurnTime(v)) * 857) and ( m.remainingTime * 857)+25 > GetDistance2D(v,me)) then
										shoot = true break
									end
								end
							end
							if m.name == "modifier_naga_siren_song_of_the_siren" then
								local mynaga = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,classId=CDOTA_Unit_Hero_Naga_Siren})[1]
								local song = mynaga:FindModifier("modifier_naga_siren_song_of_the_siren_aura")
								if song and GetDistance2D(v,me) <= ( (song.remainingTime+0.55)*857+57.5) then
									if not timing then
										victim = v 
									end
									timing = true
									if victim then
										statusText.text = "Shooting timed Arrow on " .. client:Localize(victim.name) .. " in " .. math.max(math.floor((((song.remainingTime+0.55) * 857) - (GetDistance2D(victim,me)+428))/10)/100,0) .. " secs"
									end
								end
								if song and victim and v.handle == victim.handle and (((song.remainingTime+0.55) * 857) == GetDistance2D(v,me)+428+((client.latency/1000 + me:GetTurnTime(v)) * 857) or (( (song.remainingTime+0.55) * 857) < GetDistance2D(v,me)+428+((client.latency/1000 + me:GetTurnTime(v)) * 857) and ( (song.remainingTime+0.55) * 857)+25 > GetDistance2D(v,me))) then
									shoot = true break
								end
							end
							if not timing and arrow and arrow:CanBeCasted() and m.name == "modifier_kunkka_x_marks_the_spot" then
								if not pos then
									pos = v.position
								end
								if GetDistance2D(pos,me) <= ( m.remainingTime*857+57.5) then
									statusText.text = "Shooting timed Arrow on XMARKED " .. client:Localize(v.name) .. " in " .. math.max(math.floor((((m.remainingTime) * 857) - (GetDistance2D(pos,me)+428))/10)/100,0) .. " secs"
								end
								if (m.remainingTime * 857) == GetDistance2D(pos,me)+428+((client.latency/1000 + me:GetTurnTime(pos)) * 857) or (( m.remainingTime * 857) < GetDistance2D(pos,me)+428+((client.latency/1000 + me:GetTurnTime(pos)) * 857) and ( m.remainingTime * 857)+25 > GetDistance2D(pos,me)) then
									me:SafeCastAbility(arrow,pos) pos = nil timing = true break
								end
							end
						end
					end
				end
				if v.team ~= me.team and not v.visible and arrow.level > 0 and me.alive and not victim then
					local speed = 857.14
					local castPoint = 0.55 + client.latency/10
					local blindvictim
					if not blindvictim or v.health < blindvictim.health then
						blindvictim = v
					end
					local blindxyz = SkillShot.BlindSkillShotXYZ(me,blindvictim,speed,castPoint)
					if blindxyz and blindxyz:GetDistance2D(me) <= 3115 then 
						statusText.text = "Shoot BLIND Arrow!"
						if IsKeyDown(arrowkey) then
							me:SafeCastAbility(arrow, blindxyz)
							Sleep(250)
						end
					end
				end
			end
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

script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_KEY,ArrowKey)
