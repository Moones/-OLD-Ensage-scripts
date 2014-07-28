require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.SkillShot")
require("libs.VectorOp")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("SkillShotKey", "D", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local skillshotkey = config.SkillShotKey

victimHandle = nil

local myFont = drawMgr:CreateFont("GlobalSkillShot","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Global SkillShot!",myFont); statusText.visible = false
local victimText = drawMgr:CreateText(-20,-10,-1,"Shoot!",myFont); victimText.visible = false
local active = true
local shoot = false
local victim = nil
local blindxyz = nil

SkillShots = {
	{
	spellname = "ancient_apparition_ice_blast",
	spellnamelocal = "Ice Blast",
	speed = "speed",
	extratime = 2,
	},
	{
	spellname = "rattletrap_rocket_flare",	
	spellnamelocal = "Rocket Flare",
	speed = "speed",
	extratime = 0,
	},
}

function Skillshotkey(msg,code)	
	if msg ~= KEY_UP or client.chat then return end
	if code == skillshotkey and active and victim and victim.visible then 
		if not shoot then
			shoot = true
			return true
		else
			shoot = false
			return true
		end
	elseif code == key then
		if not active then
			active = true
			statusText.text = "Global SkillShot!"
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

	if not (me.classId == CDOTA_Unit_Hero_Rattletrap or me.classId == CDOTA_Unit_Hero_AncientApparition or me.classId == CDOTA_Unit_Hero_Rubick) then
		statusText.visible = false
		script:Disable()
		return
	end

	local offset = me.healthbarOffset
	if me.alive then
		statusText.visible = true
	else	
		statusText.visible = false
	end
	statusText.entity = me
	statusText.entityPosition = Vector(0,0,offset)
	
	for i,v in ipairs(SkillShots) do
		local spell = me:FindSpell(v.spellname)
		if active then  			
			victim = targetFind:GetLowestEHP(22000, magic)			
			if victim and spell and spell.level > 0 and GetDistance2D(victim,me) < 22000 then
				victimText.entity = victim
				victimText.entityPosition = Vector(0,0,victim.healthbarOffset)
				victimText.visible = true
				statusText.text = "Shoot: "..client:Localize(victim.name)
				if shoot and me.alive then shoot = false    
					local speed = spell:GetSpecialData(v.speed,spell.level)
					local delay = (spell:GetCastPoint(spell.level)+client.latency+v.extratime)*1000
					local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
					if xyz then  
						me:SafeCastAbility(spell, xyz)
						Sleep(250) 
					end
				end 
			elseif not (victim and victim.visible and victim.alive) or not victim or not me.alive then
				statusText.text = "Global SkillShot!"
				victimText.visible = false
			end
			for i,k in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true})) do		
				if not k:IsIllusion() then
					if k.team ~= me.team and not k.visible and spell and spell.level > 0 and me.alive and not victim then
						local speed = spell:GetSpecialData(v.speed,spell.level)
						local castPoint = (spell:GetCastPoint(spell.level)+client.latency+v.extratime)
						local blindvictim
						if not blindvictim or k.health < blindvictim.health then
							blindvictim = k
						end
						blindxyz = SkillShot.BlindSkillShotXYZ(me,blindvictim,speed,castPoint)
						if blindxyz then 
							statusText.text = "BLIND Global SkillShot!"
							if IsKeyDown(skillshotkey) then
								me:SafeCastAbility(spell, blindxyz)
								Sleep(250)
							end
						end
					end
				end	
			end
		end
	end
end

script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_KEY,Skillshotkey)
