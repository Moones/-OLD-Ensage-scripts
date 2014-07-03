require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.SkillShot")
require("libs.VectorOp")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Arrowkey", "D", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local arrowkey = config.Arrowkey

victimHandle = nil

local myFont = drawMgr:CreateFont("Mirana","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Shoot Arrow hit Arrow!",myFont);
local active = true
local shoot = nil

function ArrowKey(msg,code)	
	if msg ~= KEY_UP or client.chat then return end

	if code == arrowkey and active then     
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

	if not statusText.entity then
		statusText.entity = me
		statusText.entityPosition = Vector(0,0,offset)
	end

	local arrow = me:GetAbility(2)

	if active then  

		local victim = targetFind:GetLowestEHP(3057.5, magic)

		if victim and GetDistance2D(victim,me) < 3057.5 then
			statusText.text = "Shoot: " .. client:Localize(victim.name)
			if shoot and arrow.level > 0 and me.alive then shoot = nil            
				if not victim:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
					local speed = 857 
					local distance = GetDistance2D(victim, me)
					local castPoint = (arrow:GetCastPoint(arrow.level)*1000)+client.latency
					local xyz = SkillShot.SkillShotXYZ(me,victim,speed,castPoint)
					if xyz and distance <= 3057.5 then  
						if xyz:GetDistance2D(me) > 3057.5 then
							xyz = (xyz - me.position) * 2900 / xyz:GetDistance2D(me) + me.position
						end
						me:SafeCastAbility(arrow, xyz)
						Sleep(250)  
					end
				end
			end 
		else
			statusText.text = "Shoot Arrow hit Arrow!"
		end

		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do

			if v.team ~= me.team and GetDistance2D(v,me) < 3057.5 then

				local disruption = v:FindModifier("modifier_shadow_demon_disruption")
				local astral = v:FindModifier("modifier_obsidian_destroyer_astral_imprisonment_prison")
				local eul = v:FindModifier("modifier_eul_cyclone")
				local nightmare = v:FindModifier("modifier_bane_nightmare")
				local shackles = v:FindModifier("modifier_shadow_shaman_shackles")

				if disruption then              
					if GetDistance2D(v,me) <= 2200 then
						if (disruption.remainingTime * 857) == GetDistance2D(v,me)+115 or ((disruption.remainingTime * 857) < GetDistance2D(v,me)+115 and (disruption.remainingTime * 857)+25 > GetDistance2D(v,me)) then
							me:SafeCastAbility(arrow, v.position)
						end
					end             
				elseif astral then
					if GetDistance2D(v,me) <= (astral.remainingTime*857+57.5) then
						if (astral.remainingTime * 857) == GetDistance2D(v,me)+200 or ((astral.remainingTime * 857) < GetDistance2D(v,me)+200 and (astral.remainingTime * 857)+25 > GetDistance2D(v,me)) then
							me:SafeCastAbility(arrow, v.position)
						end
					end
				elseif eul then
					if GetDistance2D(v,me) <= ( eul.remainingTime*857+57.5) then
						if (eul.remainingTime * 857) == GetDistance2D(v,me)+140 or (( eul.remainingTime * 857) < GetDistance2D(v,me)+140 and ( eul.remainingTime * 857)+25 > GetDistance2D(v,me)) then
							me:SafeCastAbility(arrow, v.position)
						end
					end
				elseif nightmare then
					if GetDistance2D(v,me) <= ( nightmare.remainingTime*857+57.5) then
						if (nightmare.remainingTime * 857) == GetDistance2D(v,me)+160 or (( nightmare.remainingTime * 857) < GetDistance2D(v,me)+160 and ( nightmare.remainingTime * 857)+25 > GetDistance2D(v,me)) then
							me:SafeCastAbility(arrow, v.position)
						end
					end
				elseif shackles then
					if GetDistance2D(v,me) <= ( shackles.remainingTime*857+57.5) then
						if (shackles.remainingTime * 857) == GetDistance2D(v,me)+180 or (( shackles.remainingTime * 857) < GetDistance2D(v,me)+180 and ( shackles.remainingTime * 857)+25 > GetDistance2D(v,me)) then
							me:SafeCastAbility(arrow, v.position)
						end
					end
				end
			end
		end
	end
end


script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_KEY,ArrowKey)
