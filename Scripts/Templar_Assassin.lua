require("libs.ScriptConfig")
require("libs.Utils")
require("libs.HeroInfo")
require("libs.TargetFind")

local config = ScriptConfig.new()
config:SetParameter("Move", 32, config.TYPE_HOTKEY)
config:SetParameter("Hotkey", "N", config.TYPE_HOTKEY)
config:SetParameter("ActiveFromStart", true)
config:SetParameter("ShowSign", true)
config:SetParameter("DontOrbwalkWhenIdle", true)
config:Load()
	
movetomouse = config.Move
hotkey = config.Hotkey
active = config.ActiveFromStart
showsign = config.ShowSign
noorbwalkidle = config.DontOrbwalkWhenIdle

local myAttackTickTable = {}

local sleep = 0 myAttackTickTable.attackRateTick = 0 myAttackTickTable.attackRateTick2 = 0 myAttackTickTable.attackPointTick = nil

local myhero = nil local reg = false local myId = nil local victim = nil local psivictim = nil local attacking = false local combo = false local psi = false

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText = drawMgr:CreateText(10*monitor,600*monitor,-1,"Templar Assassin Script: ON, Hotkey: " .. string.char(hotkey),F14) statusText.visible = false

function Key(msg, code)
	if msg ~= KEY_UP or client.chat or client.console then return end
	if code == hotkey then 
		active = not active
	end
end

function Main(tick)
	if not PlayingGame() or client.paused then return end	
	local me = entityList:GetMyHero() if not me then return end	
	local ID = me.classId if ID ~= myId then Close() end
	statusText.visible = true
	statusText.text = "Templar Assassin Script: "..IsActive()..", Hotkey: " .. string.char(hotkey)
	if active and not me:IsChanneling() then
		if not myhero then
			myhero = Hero(me)
		else		
			UpdateMyHero(me)
			local dmg = me.dmgMin + me.dmgBonus
			local blink = me:FindItem("item_blink")
			local meld = me:GetAbility(2)	
			local meldDmg = meld:GetSpecialData("bonus_damage", meld.level)			
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),visible=true})
			for i, v in ipairs(enemies) do
				if GetDistance2D(v,me) <= 1200 and not v:IsIllusion() and v.health <= ((dmg + meldDmg)*(1-v.dmgResist)+1) then
					if v.alive then
						if meld and meld.state == LuaEntityAbility.STATE_READY and SleepCheck("meld2") and me:CanAttack() and not v:IsAttackImmune() then
							if blink and blink.cd == 0 and GetDistance2D(me,v) > myhero.attackRange+25 then
								local bpos = (v.position - me.position) * 1100 / GetDistance2D(me,v) + me.position
								local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, v))) - 0.69, 0)/(0.5*(1/0.03)))*1000 + client.latency
								if GetDistance2D(me, v) <= 1100 then
									me:SafeCastAbility(blink, v.position)
								elseif v:CanMove() and v.activity == LuaEntityNPC.ACTIVITY_MOVE then
									me:SafeCastAbility(blink, bpos)
								else
									me:SafeCastAbility(blink, bpos)
								end
								combo = true
							end
							if GetDistance2D(me, v) <= myhero.attackRange-25 then
								if v.health > ((dmg)*(1-v.dmgResist)+1) then
									me:SafeCastAbility(meld)
								end
								entityList:GetMyPlayer():Attack(v)
								Sleep(myhero.attackRate*1000, "meld2")
								combo = true
							end
						end
					else
						combo = false
					end
				end
			end
			if IsKeyDown(movetomouse) and not client.chat and not combo then				
				local traps = entityList:GetEntities({classId=CDOTA_BaseNPC_Additive,alive=true,team=me.team,visible=true})
				local closestTrap = nil
				for i,v in ipairs(traps) do
					if (v:GetAbility(1) and v:GetAbility(1).name == "templar_assassin_self_trap" and v:GetAbility(1).state == LuaEntityAbility.STATE_READY) then
						if not closestTrap or GetDistance2D(closestTrap, victim) > GetDistance2D(v, victim) then
							if GetDistance2D(v, victim) <= 400 then
								closestTrap = v
							end
							if closestTrap and GetDistance2D(closestTrap, victim) > 400 then
								closestTrap = nil
							end
						end
					end
				end
				local trap = me:GetAbility(5)
				if not me:DoesHaveModifier("modifier_templar_assassin_meld") and (not victim or GetDistance2D(me, victim) > (myhero.attackRange + 50)) or (not noorbwalkidle and not attacking) or (not attacking and (victim and (victim.activity ~= LuaEntityNPC.ACTIVITY_IDLE and victim.activity ~= LuaEntityNPC.ACTIVITY_IDLE1) or (victim and victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE))) then
					if tick > sleep then
						if blink and blink.cd == 0 and (victim and victim.hero and GetDistance2D(me,victim) > myhero.attackRange+200 and GetDistance2D(me,victim) < 1500) then
							local bpos = (victim.position - me.position) * 1100 / GetDistance2D(me,victim) + me.position
							local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, victim))) - 0.69, 0)/(0.5*(1/0.03)))*1000 + client.latency
							if GetDistance2D(me, victim) <= 1100 then
								me:SafeCastAbility(blink, victim.position)
							elseif victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE then
								me:SafeCastAbility(blink, bpos)
							else
								me:SafeCastAbility(blink, bpos)
							end
							sleep = tick + turn
						end
						if victim and victim.hero then
							local trapslow = victim:FindModifier("modifier_templar_assassin_trap_slow")
							if (victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE and (not victim:DoesHaveModifier("modifier_templar_assassin_trap_slow") or (trapslow and trapslow.remainingTime <= trap:FindCastPoint()))) and ((closestTrap and GetDistance2D(closestTrap, victim) <= 400) or trap.state == LuaEntityAbility.STATE_READY) then
								if closestTrap then
									closestTrap:SafeCastAbility(closestTrap:GetAbility(1))
								elseif SleepCheck("trap") then
									local p = Vector(victim.position.x + 375 * math.cos(victim.rotR), victim.position.y + 375 * math.sin(victim.rotR), victim.position.z)
									me:SafeCastAbility(trap, p)
									Sleep(250, "trap")
								end
							end
						end
						me:Move(client.mousePosition)
						sleep = tick + 30 + client.latency
					end
				end
				if victim then				
					if me:DoesHaveModifier("modifier_templar_assassin_meld") and SleepCheck("meld") and me:CanAttack() and not victim:IsAttackImmune() then
						entityList:GetMyPlayer():Attack(victim)
						attacking = true
						Sleep(myhero.attackRate*1000, "meld")
					end
					if (victim.classId ~= CDOTA_BaseNPC_Tower and victim.classId ~= CDOTA_BaseNPC_Barracks and victim.classId ~= CDOTA_BaseNPC_Building) and meld and meld.state == LuaEntityAbility.STATE_READY and GetDistance2D(me, victim) <= myhero.attackRange-25 and not isAttacking(me) and SleepCheck("meld2") and me:CanAttack() and not victim:IsAttackImmune() and victim.health > ((dmg)*(1-victim.dmgResist)+1) then
						me:SafeCastAbility(meld)
						entityList:GetMyPlayer():Attack(victim)
						attacking = true
						Sleep(myhero.attackRate*1000, "meld2")
					end
				end
				OrbWalk(me)			
			else
				myAttackTickTable.attackRateTick = 0 
				myAttackTickTable.attackPointTick = nil 
				attacking = false 
				victim = nil
			end
		end
	end
end

function OrbWalk(me)
	victim = targetFind:GetClosestToMouse(500)	
	local dmg = me.dmgMin + me.dmgBonus	
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),alive=true})
	local courier = entityList:GetEntities({classId=CDOTA_Unit_Courier,team=me:GetEnemyTeam(),alive=true,visible=true})[1]
	table.sort( enemies, function (a,b) return GetDistance2D(a,me) < GetDistance2D(b,me) end )
	for i=1,#enemies do
		if enemies[i]:IsIllusion() then
			enemies[i] = enemies[i+1]
		end
	end	
	if (victim and GetDistance2D(me,victim) > (myhero.attackRange + 25)) and enemies[2] and GetDistance2D(enemies[2], me) < (myhero.attackRange + 1200) then
		victim = targetFind:GetLowestEHP(1200 + myhero.attackRange, phys)
	end	
	--local psiUnits = entityList:GetEntities({classId={CDOTA_BaseNPC_Hero or CDOTA_BaseNPC_Creep_Neutral or CDOTA_BaseNPC_Creep_Lane or CDOTA_BaseNPC_Creep_Siege or CDOTA_BaseNPC_Invoker_Forged_Spirit or CDOTA_BaseNPC_Creep or CDOTA_BaseNPC_Warlock_Golem},alive=true,visible=true})
	--local farm = entityList:GetEntities(function (v) return (v.classId == CDOTA_BaseNPC_Creep_Neutral or v.classId == CDOTA_BaseNPC_Creep_Lane or v.classId == CDOTA_BaseNPC_Creep_Siege) and v.alive and v.visible and v.spawned end)
	local farm = {}
	local creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,team=me:GetEnemyTeam(),visible=true,spawned=true})
	local siege = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Siege,alive=true,team=me:GetEnemyTeam(),visible=true,spawned=true})
	local neutrals = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Neutral,alive=true,visible=true,spawned=true})
	local towers = entityList:GetEntities({classId=CDOTA_BaseNPC_Tower,alive=true,team=me:GetEnemyTeam(),visible=true})
	local barracks = entityList:GetEntities({classId=CDOTA_BaseNPC_Barracks,alive=true,team=me:GetEnemyTeam(),visible=true})
	local others = entityList:GetEntities({classId=CDOTA_BaseNPC_Building,alive=true,team=me:GetEnemyTeam(),visible=true})
	for k,v in pairs(creeps) do if GetDistance2D(me, v) < myhero.attackRange+500 and v.spawned then farm[#farm + 1] = v end end
	for k,v in pairs(siege) do if GetDistance2D(me, v) < myhero.attackRange+500 and v.spawned then farm[#farm + 1] = v end end
	for k,v in pairs(neutrals) do if GetDistance2D(me, v) < myhero.attackRange+500 and v.spawned then farm[#farm + 1] = v end end
	for k,v in pairs(towers) do if GetDistance2D(me, v) < myhero.attackRange+500 then farm[#farm + 1] = v end end
	for k,v in pairs(barracks) do if GetDistance2D(me, v) < myhero.attackRange+500 then farm[#farm + 1] = v end end
	for k,v in pairs(others) do if GetDistance2D(me, v) < myhero.attackRange+500 then farm[#farm + 1] = v end end
	table.sort( farm, function (a,b) return GetDistance2D(a,me) < GetDistance2D(b,me) end )
	if not victim or GetDistance2D(me, victim) > myhero.attackRange+500 or not victim.alive then
		if farm[1] and GetDistance2D(client.mousePosition, farm[1]) < 300 then
			victim = farm[1]
		end
	end
		-- for i, v in ipairs(farm) do
			-- if v.health and v.health > 0 and v.maxHealth and v.alive and (v.team == me:GetEnemyTeam() or (v.team == me.team and v.health < v.maxHealth*0.4)) and GetDistance2D(me,v) <= myhero.attackRange+150 then
				-- if AngleBelow(me,v,victim,5.5) then
					-- psivictim = v
					-- psi = true
				-- else
					-- psivictim = nil
					-- psi = false
				-- end
				
			-- end
			-- if v.alive and v.team ~= me.team and GetDistance2D(me,v) <= myhero.attackRange+150 and (not victim or GetDistance2D(me, victim) > myhero.attackRange+500) then
				-- victim = v
			-- end
		-- end
	-- end
	if courier and GetDistance2D(me, courier) < myhero.attackRange+50 then
		victim = courier
	end
	local meld = me:GetAbility(2)	
	if (victim and victim.alive and victim.health > 0 and GetDistance2D(me, victim) <= myhero.attackRange) and me.alive and (not meld or meld.state ~= LuaEntityAbility.STATE_READY or victim.health <= ((dmg)*(1-victim.dmgResist)+1) or (victim.classId == CDOTA_BaseNPC_Tower or victim.classId == CDOTA_BaseNPC_Barracks or victim.classId == CDOTA_BaseNPC_Building)) then			
		if (GetTick() >= myAttackTickTable.attackRateTick) and me:CanAttack() and not victim:IsAttackImmune() then
			myhero:Hit(victim)
			myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000 + (math.max((GetDistance2D(me, victim) - myhero.attackRange), 0)/me.movespeed)*1000 + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, victim))) - 0.69, 0))/(myhero.turnRate*(1/0.03))*1000						
			attacking = true
		end
	end
end	

class 'Hero'

	function Hero:__init(heroEntity)   
		self.heroEntity = heroEntity
		local name = heroEntity.name
		if not heroInfo[name] then
			return nil
		end
		self.projectileSpeed = heroInfo[name].projectileSpeed
		self.attackType = "Hero"
		self.armorType = "Hero"
		self.baseAttackRate = heroInfo[name].attackRate
		self.baseAttackPoint = heroInfo[name].attackPoint
		self.baseTurnRate = heroInfo[name].turnRate
		self.baseBackswing = heroInfo[name].attackBackswing
	end

	function Hero:Update()
		self:GetModifiers()		
		self.attackSpeed = myhero:GetAttackSpeed()
		self.attackRate = self:GetAttackRate()
		self.attackPoint = self:GetAttackPoint()
		self.attackRange = self:GetAttackRange()
		self.turnRate = self:GetTurnRate()
		self.attackBackswing = self:GetBackswing()
	end

	function Hero:GetTurnRate()
		turnRateModifiers = {modifier_batrider_sticky_napalm = .70}
		if self.modifierList then
			for modifierName, modifierPercent in pairs(turnRateModifiers) do
				if self.modifierList[modifierName] then
					return (1 - modifierPercent) * self.baseTurnRate
				end
			end
		end
		return self.baseTurnRate
	end

	function Hero:GetAttackRange()
		local bonus = 0
		local psy = self.heroEntity:GetAbility(3)
		psyrange = {60,120,180,240}		
		if psy and psy.level > 0 then		
			bonus = psyrange[psy.level]			
		end
		return self.heroEntity.attackRange + bonus + 25
	end
	
	function Hero:GetAttackSpeed()
		if self.heroEntity.attackSpeed > 500 then
			return 500
		end
		return self.heroEntity.attackSpeed
	end

	function Hero:GetAttackPoint()
		return self.baseAttackPoint / (1 + (self.heroEntity.attackSpeed) / 100)
	end

	function Hero:GetAttackRate()
		return self.heroEntity.attackBaseTime / (1 + (self.heroEntity.attackSpeed - 100) / 100)
	end
	
	function Hero:GetBackswing()
		return self.baseBackswing / (1 + (self.heroEntity.attackSpeed - 100) / 100)
	end
	
	function Hero:GetModifiers()
		local modifierCount = self.heroEntity.modifierCount
		if modifierCount == 0 then
				self.modifierList = nil
				return
		end
		self.modifierList = {}
		if self.heroEntity.modifiers then
			for i,v in ipairs(self.heroEntity.modifiers) do
				local name = v.name
				if name then
					self.modifierList[name] = true
				end
			end
		end
	end

	function Hero:Hit(target)
		if target.team ~= self.heroEntity.team then
			local meld = self.heroEntity:GetAbility(2)
			if (target.classId ~= CDOTA_BaseNPC_Tower and target.classId ~= CDOTA_BaseNPC_Barracks and target.classId ~= CDOTA_BaseNPC_Building) and meld and meld.state == LuaEntityAbility.STATE_READY and GetDistance2D(self.heroEntity, target) <= self.attackRange-25 then
				self.heroEntity:SafeCastAbility(meld)
			else
				entityList:GetMyPlayer():Attack(target)
			end
		end
	end

function FindAngleR(entity)
	if entity.rotR < 0 then
		return math.abs(entity.rotR)
	else
		return 2 * math.pi - entity.rotR
	end
end

function FindAngleBetween(first, second)
	local xAngle = math.deg(math.atan(math.abs(second.position.x - first.position.x)/math.abs(second.position.y - first.position.y)))
	if first.position.x <= second.position.x and first.position.y >= second.position.y then
		return 90 - xAngle
	elseif first.position.x >= second.position.x and first.position.y >= second.position.y then
		return xAngle + 90
	elseif first.position.x >= second.position.x and first.position.y <= second.position.y then
		return 90 - xAngle + 180
	elseif first.position.x <= second.position.x and first.position.y <= second.position.y then
		return xAngle + 90 + 180
	end
	return nil
end

function AngleBelow(myHero,nearestHero,targetHero,angle)
	local myPos = Vector2D(myHero.position.x,myHero.position.y)
	local nearestHeroPos = Vector2D(nearestHero.position.x,nearestHero.position.y)
	local targetHeroPos = Vector2D(targetHero.position.x,targetHero.position.y)
	local t1 = (nearestHeroPos - myPos)
	local t2 = (targetHeroPos - myPos)
	return math.abs(math.deg(math.atan2(t2.y, t2.x) - math.atan2(t1.y, t1.x))) <= angle
end

function UpdateMyHero(me)
	myhero:Update()	
	local myprojectiles = entityList:GetProjectiles({source=me})
	for k,z in ipairs(myprojectiles) do
		if myAttackTickTable.attackPointTick == nil and (myAttackTickTable.attackRateTick == 0 or myAttackTickTable.attackRateTick > GetTick()) and (victim and GetDistance2D(z.position, victim) > GetDistance2D(z.position, me)) then
			myAttackTickTable.attackPointTick = GetTick()
		end			
	end	
	if isAttacking(me) then
		if myAttackTickTable.attackRateTick == 0 then
			myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000
		end
	end
	if myAttackTickTable.attackPointTick and GetTick() >= myAttackTickTable.attackPointTick then
		myAttackTickTable.attackPointTick = nil
		attacking = false
	end
end

function isAttacking(ent)
	if ent.activity == LuaEntityNPC.ACTIVITY_ATTACK or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK1 or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK2 then
		return true
	end
	return false
end

function IsActive()
	if active then
		return "ON"
	else
		return "OFF"
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_TemplarAssassin then 
			script:Disable()
		else
			statusText.visible = false
			myhero = nil
			reg = true
			myId = me.classId
			combo = false
			psi = false
			victim = nil
			psivictim = nil
			script:RegisterEvent(EVENT_TICK, Main)
			script:RegisterEvent(EVENT_KEY, Key)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	statusText.visible = false
	myhero = nil
	myId = nil
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)
