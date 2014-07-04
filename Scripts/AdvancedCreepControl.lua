require("libs.ScriptConfig")
require("libs.Utils")
require("libs.SideMessage")
require("libs.HeroInfo")
require("libs.EasyHUD")

local config = ScriptConfig.new()
config:SetParameter("CustomMove", "G", config.TYPE_HOTKEY)
config:SetParameter("Menu", "H", config.TYPE_HOTKEY)
config:SetParameter("Spaceformove", true)
config:SetParameter("enableLasthits", true)
config:SetParameter("enableDenies", true)
config:SetParameter("AutoUnAggro", true)
config:SetParameter("ActiveFromStart", true)
config:SetParameter("UseAttackModifiers", true)
config:Load()
	
custommove = config.CustomMove
menu = config.Menu
spaceformove = config.Spaceformove
enablelasthits = config.enableLasthits
enabledenies = config.enableDenies
autounaggro = config.AutoUnAggro
active = config.ActiveFromStart
attackmodifiers = config.UseAttackModifiers

creepTable = {} myAttackTickTable = {}

sleep = 0 myAttackTickTable.attackRateTick = 0

local myhero = nil local lasthit = false local reg = false local HUD = nil

local monitor = client.screenSize.x/1600
local F15 = drawMgr:CreateFont("F15","Tahoma",15*monitor,550*monitor)
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText = drawMgr:CreateText(10*monitor,600*monitor,-1,"AdvancedCreepControl: Press " .. string.char(menu) .. " to open Menu",F14) statusText.visible = false

armorTypeModifiers = { Normal = {Unarmored = 1.00, Light = 1.00, Medium = 1.50, Heavy = 1.25, Fortified = 0.70, Hero = 0.75}, Pierce = {Unarmored = 1.50, Light = 2.00, Medium = 0.75, Heavy = 0.75, Fortified = 0.35, Hero = 0.50},	Siege = {Unarmored = 1.00, Light = 1.00, Medium = 0.50, Heavy = 1.25, Fortified = 1.50, Hero = 0.75}, Chaos = {Unarmored = 1.00, Light = 1.00, Medium = 1.00, Heavy = 1.00, Fortified = 0.40, Hero = 1.00},	Hero = {Unarmored = 1.00, Light = 1.00, Medium = 1.00, Heavy = 1.00, Fortified = 0.50, Hero = 1.00}, Magic = {Unarmored = 1.00, Light = 1.00, Medium = 1.00, Heavy = 1.00, Fortified = 1.00, Hero = 0.75} }


function activeCheck()	
	if PlayingGame() then
		if not active then
			active = true
			GenerateSideMessage(entityList:GetMyHero().name,"     Advanced CreepControl is ON!")
		else
			active = false
			GenerateSideMessage(entityList:GetMyHero().name,"    Advanced CreepControl is OFF!")
		end
	end
end

function lhCheck()
	if PlayingGame() then
		if not enablelasthits then
			enablelasthits = true
			GenerateSideMessage(entityList:GetMyHero().name,"             Lasthitting is ON!")
		else 
			enablelasthits = nil
			GenerateSideMessage(entityList:GetMyHero().name,"            Lasthitting is OFF!")
		end
	end
end

function dCheck()
	if PlayingGame() then
		if not enabledenies then
			enabledenies = true
			GenerateSideMessage(entityList:GetMyHero().name,"                Denying is ON!")
		else
			enabledenies = nil
			GenerateSideMessage(entityList:GetMyHero().name,"               Denying is OFF!")
		end
	end
end

function aCheck()
	if PlayingGame() then
		if not autounaggro then
			autounaggro = true
			GenerateSideMessage(entityList:GetMyHero().name,"            AutoUnAggro is ON!")
		else
			autounaggro = nil
			GenerateSideMessage(entityList:GetMyHero().name,"           AutoUnAggro is OFF!")
		end
	end
end

function Key(msg, code)
	if msg ~= KEY_UP or client.chat then return end
	if code == menu and HUD then 
		if HUD:IsClosed() then
			HUD:Open()
			statusText.visible = false
		else
			HUD:Close()
			statusText.visible = true
		end
	end
end

function Main(tick)

	if not PlayingGame() then return end
	
	local me = entityList:GetMyHero()
	
	if not me then return end
	
	if spaceformove then
		movetomouse = 0x20
	else
		movetomouse = spaceformove
	end
	
	if not HUD then 
		CreateHUD()
	end

	if HUD and HUD:IsClosed() then
		statusText.visible = true
	end

		if active then

			if not myhero then
			
				myhero = Hero(me)

			else
			
			GetHeroes()
			GetCreeps(me)
		
			if IsKeyDown(movetomouse) and not client.chat then
			
				if not lasthit and tick > sleep and me.activity ~= LuaEntityNPC.ACTIVITY_ATTACK then
				
					me:Move(client.mousePosition)
					sleep = tick + 100	
					
				end	
				
				GetLasthit(me)	
				
			end
		
			if autounaggro and not lasthit then
		
				local creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane})
			
				for i,v in ipairs(creeps) do
			
					local projectiles = entityList:GetProjectiles({target=me})
				
					for k,z in ipairs(projectiles) do
						if z.source then
							if z.source.type ~= LuaEntity.TYPE_HERO then
								if me.activity ~= LuaEntityNPC.ACTIVITY_ATTACK and v.team == me.team and v.visible and v.alive and tick > sleep then
								
									if (myhero.isRanged and GetDistance2D(v,me) < myhero.attackRange - 50) or (not myhero.isRanged and GetDistance2D(v,me) < myhero.attackRange + 200) then
								
										entityList:GetMyPlayer():Attack(v)
										me:Move(client.mousePosition)		
										sleep = tick + 100										
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function GetLasthit(me)
	
	for creepHandle, creepClass in pairs(creepTable) do

		if (GetTick() >= myAttackTickTable.attackRateTick) and ((enablelasthits and me.team ~= creepClass.creepEntity.team) or (enabledenies and me.team == creepClass.creepEntity.team and creepClass.creepEntity.health < creepClass.creepEntity.maxHealth*0.50)) then
			local Dmg = myhero:GetDamage(creepClass)
			local timeToHealth = creepClass:GetTimeToHealth(Dmg)

			if myhero.isRanged then
			
				if Dmg >= creepClass.creepEntity.health or (timeToHealth and timeToHealth <= (GetTick() + myhero.attackPoint*1000 + client.latency + ((GetDistance2D(me, creepClass.creepEntity)-math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0))/myhero.projectileSpeed)*1000 + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, creepClass.creepEntity))) - 0.69, 0)/(myhero.turnRate*(1/0.03)))*1000 + (math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0)/me.movespeed)*1000)) then
					myhero:Hit(creepClass.creepEntity)
					
					myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000
					
					myAttackTickTable.attackPointTick = (GetTick() + myhero.attackPoint*1000 + client.latency + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, creepClass.creepEntity))) - 0.69, 0)/(myhero.turnRate*(1/0.03)))*1000 + (math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0)/me.movespeed)*1000)
					
					lasthit = true

				end

			else

				if Dmg >= creepClass.creepEntity.health or (timeToHealth and timeToHealth <= (GetTick() + myhero.attackPoint*1000 + client.latency + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, creepClass.creepEntity))) - 0.69, 0)/(myhero.turnRate*(1/0.03)))*1000 + (math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0)/me.movespeed)*1000)) then
					myhero:Hit(creepClass.creepEntity)
					
					myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000

					myAttackTickTable.attackPointTick = (GetTick() + myhero.attackPoint*1000 + client.latency + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, creepClass.creepEntity))) - 0.69, 0)/(myhero.turnRate*(1/0.03)))*1000 + (math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0)/me.movespeed)*1000)

					lasthit = true

				end
			end
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

	if not heroInfo[name].projectileSpeed then
		self.isRanged = false
	else
		self.isRanged = true
		self.projectileSpeed = heroInfo[name].projectileSpeed
	end

	self.attackType = "Hero"
	self.armorType = "Hero"
	self.baseAttackRate = heroInfo[name].attackRate
	self.baseAttackPoint = heroInfo[name].attackPoint
	self.aggroRange = 1000
	self.baseTurnRate = heroInfo[name].turnRate
end

function Hero:Update()

	self:GetModifiers()
	
	self.attackRate = self:GetAttackRate()
	self.attackPoint = self:GetAttackPoint()
	self.attackRange = self:GetAttackRange()
	self.turnRate = self:GetTurnRate()


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

	if self.heroEntity.name == "npc_dota_hero_templar_assassin" then
	
		local psy = self.heroEntity:GetAbility(3)
		psyrange = {60,120,180,240}
		
		if psy and psy.level > 0 then
		
			bonus = psyrange[psy.level]
			
		end
		
	elseif self.heroEntity.name == "npc_dota_hero_sniper" then
	
		local aim = self.heroEntity:GetAbility(3)
		aimrange = {100,200,300,400}
		
		if aim and aim.level > 0 then
		
			bonus = aimrange[aim.level]
			
		end
		
	end
	
	return self.heroEntity.attackRange + bonus

end

function Hero:GetAttackPoint()

	return self.baseAttackPoint / (1 + (self.heroEntity.attackSpeed / 100))

end

function Hero:GetAttackRate()

	return self.heroEntity.attackBaseTime / (1 + (self.heroEntity.attackSpeed / 100))
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

function Hero:GetDamage(target)
	local dmg = self.heroEntity.dmgMin + self.heroEntity.dmgBonus
	local qblade = self.heroEntity:FindItem("item_quelling_blade")
	local magical = nil
	if attackmodifiers and target.creepEntity.team ~= self.heroEntity.team then
		if self.heroEntity.classId == CDOTA_Unit_Hero_Clinkz then
		
			local searinga = self.heroEntity:GetAbility(2)
			searingDmg = {30,40,50,60}
			
			if searinga.level > 0 then
				dmg = dmg + searingDmg[searinga.level]
			end
		elseif self.heroEntity.classId == CDOTA_Unit_Hero_Anti_Mage then
		
			local manabreak = self.heroEntity:GetAbility(1)
			manaburned = {28,40,52,64}
			
			if manabreak.level > 0 and target.creepEntity.maxMana > 0 and target.creepEntity.mana > 0 then
				dmg = dmg + manaburned[manabreak.level]*0.6
			end
		elseif self.heroEntity.classId == CDOTA_Unit_Hero_Viper then
			local nethertoxin = self.heroEntity:GetAbility(2)
			nethertoxindmg = {2.5,5,7.5,10}
			if nethertoxin.level > 0 then
				
				local hplosspercent = target.creepEntity.health/(target.creepEntity.maxHealth / 100)
				local netherdmg = nil
				
				if hplosspercent > 80 and hplosspercent <= 100 then
					netherdmg = nethertoxindmg[nethertoxin.level]*0.5
				elseif hplosspercent > 60 and hplosspercent <= 80 then
					netherdmg = nethertoxindmg[nethertoxin.level]*1
				elseif hplosspercent > 40 and hplosspercent <= 60 then
					netherdmg = nethertoxindmg[nethertoxin.level]*2
				elseif hplosspercent > 20 and hplosspercent <= 40 then
					netherdmg = nethertoxindmg[nethertoxin.level]*4
				elseif hplosspercent > 0 and hplosspercent <= 20 then
					netherdmg = nethertoxindmg[nethertoxin.level]*8
				end
				
				if netherdmg then
					dmg = dmg + netherdmg
				end
				
			end
		elseif self.heroEntity.classId == CDOTA_Unit_Hero_Ursa then
			local furyswipes = self.heroEntity:GetAbility(3)
			local furymodif = target.creepEntity:FindModifier("modifier_ursa_fury_swipes_damage_increase")
			furydmg = {15,20,25,30}
			if furyswipes.level > 0 then
				if furymodif then
					dmg = dmg + furydmg[furyswipes.level]*furymodif.stacks
				else
					dmg = dmg + furydmg[furyswipes.level]
				end
			end
		end
	end
	
	if qblade then
		if not self.isRanged then
			dmg = dmg*1.32
		else
			dmg = dmg*1.12
		end
	end

	dmg = (math.floor(dmg * armorTypeModifiers["Hero"][target.armorType] * (1 - target.creepEntity.dmgResist)))
	
	return dmg
end 

function Hero:Hit(target)
	if attackmodifiers and target.team ~= self.heroEntity.team then
		if self.heroEntity.classId == CDOTA_Unit_Hero_Clinkz then
			local searinga = self.heroEntity:GetAbility(2)
			if searinga.level > 0 then
				self.heroEntity:SafeCastAbility(searinga, target)
			end
		else
			entityList:GetMyPlayer():Attack(target)
		end
	else
		entityList:GetMyPlayer():Attack(target)
	end
end

class 'Creep'

function Creep:__init(creepEntity)

	self.creepEntity = creepEntity
	self.HP = {}

	if self.creepEntity.classId == CDOTA_BaseNPC_Creep_Siege then
		self.creepType = "Siege Creep"
		self.attackType = "Siege"
		self.armorType = "Fortified"
		self.isRanged = true
		self.baseAttackPoint = 0.7
		self.baseAttackRate = 2.7
		self.attackRange = creepEntity.attackRange + 25
		self.projectileSpeed = 1100
	elseif self.creepEntity.classId == CDOTA_BaseNPC_Creep_Lane and (self.creepEntity.armor == 0 or self.creepEntity.armor == 1) then
		self.creepType = "Ranged Creep"
		self.attackType = "Pierce"
		self.armorType = "Unarmored"
		self.isRanged = true
		self.baseAttackPoint = 0.5
		self.baseAttackRate = 1
		self.attackRange = creepEntity.attackRange + 25
		self.projectileSpeed = 900
	elseif self.creepEntity.classId == CDOTA_BaseNPC_Creep_Lane and (self.creepEntity.armor == 2 or self.creepEntity.armor == 3) then
		self.creepType = "Melee Creep"
		self.attackType = "Normal"
		self.armorType = "Unarmored"
		self.isRanged = false
		self.baseAttackPoint = 0.467
		self.baseAttackRate = 1
		self.attackRange = creepEntity.attackRange + 25
	end

	self.nextAttackTicks = {}

end

function Creep:GetTimeToHealth(health)

	numItems = 0
	for k,v in pairs(self.nextAttackTicks) do
		numItems = numItems + 1
	end

	if numItems > 0 then

		local sortedTable = { }
		for k, v in pairs(self.nextAttackTicks) do table.insert(sortedTable, v) end

		table.sort(sortedTable, function(a,b) return a[2] < b[2] end)
		
		local totalDamage = 0

		for i = 0, 2 do
			for _, nextAttackTickTable in ipairs(sortedTable) do
				
				local hploss = (self.HP.previous - self.HP.current)

				if nextAttackTickTable[2] > GetTick() then

					if (hploss*nextAttackTickTable[1].baseAttackPoint) > 0 and (hploss*nextAttackTickTable[1].baseAttackPoint) > nextAttackTickTable[1].creepEntity.dmgMin and (hploss*nextAttackTickTable[1].baseAttackPoint) < nextAttackTickTable[1].creepEntity.dmgMax then
						totalDamage = totalDamage + (math.floor((((hploss*nextAttackTickTable[1].baseAttackPoint) + nextAttackTickTable[1].creepEntity.dmgMin)/2) * armorTypeModifiers[nextAttackTickTable[1].attackType][self.armorType] * (1 - self.creepEntity.dmgResist)))
					end
					if (hploss*nextAttackTickTable[1].baseAttackPoint) == 0 or (hploss*nextAttackTickTable[1].baseAttackPoint) < nextAttackTickTable[1].creepEntity.dmgMin or (hploss*nextAttackTickTable[1].baseAttackPoint) > nextAttackTickTable[1].creepEntity.dmgMax then
						totalDamage = totalDamage + (math.floor(nextAttackTickTable[1].creepEntity.dmgMin * armorTypeModifiers[nextAttackTickTable[1].attackType][self.armorType] * (1 - self.creepEntity.dmgResist)))
					end

					if (self.creepEntity.health - totalDamage) <= health then
						return nextAttackTickTable[2] + (nextAttackTickTable[4] * i)
					end
				end

			end
		end
	end

	return nil

end

function Creep:Update()

	self.attackRate = self:GetAttackRate()

	self:UpdateHealth()

	for k, nextAttackTickTable in pairs(self.nextAttackTicks) do
		if (GetTick() >= nextAttackTickTable[3]-25) then
			self.nextAttackTicks[k] = nil
		end
	end

	self:MapDamageSources()

end

function Creep:GetAttackRate()

	return self.baseAttackRate / (1 + (self.creepEntity.attackSpeed-100) / 100)

end

function Creep:MapDamageSources()

	for creepHandle, creepClass in pairs(creepTable) do
		if creepClass.baseAttackRate ~= nil and self.creepEntity.team ~= creepClass.creepEntity.team and creepClass.creepEntity.alive and GetDistance2D(self.creepEntity, creepClass.creepEntity) <= creepClass.attackRange then
			if math.abs(FindAngleR(creepClass.creepEntity) - math.rad(FindAngleBetween(creepClass.creepEntity, self.creepEntity))) < 0.015 then
				if not self.nextAttackTicks[creepClass.creepEntity.handle] then

					local nextAttackTick = creepClass.baseAttackRate*1000

					local timeToDamageHit = (((creepClass.projectileSpeed) and ((GetDistance2D(creepClass.creepEntity, self.creepEntity)/creepClass.projectileSpeed)*1000)) or 0) + GetTick() + creepClass.baseAttackPoint*1000

					self.nextAttackTicks[creepClass.creepEntity.handle] = {creepClass, timeToDamageHit, GetTick() + nextAttackTick, nextAttackTick}
				
				end
			end
		end
	end

end

function Creep:UpdateHealth()

	self.HP.previous = self.HP.current or 0
	self.HP.current = self.creepEntity.health
	
end

function FindAngleR(entity)

	if entity.rotR < 0 then

		return math.abs(entity.rotR)

	else

		return 2 * math.pi - entity.rotR

	end

end

function FindAngleBetween(first, second)

	xAngle = math.deg(math.atan(math.abs(second.position.x - first.position.x)/math.abs(second.position.y - first.position.y)))

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

function GetHeroes(me)

	myhero:Update()
	
	if myAttackTickTable.attackPointTick and GetTick() >= myAttackTickTable.attackPointTick then

		myAttackTickTable.attackPointTick = nil
		lasthit = false
	end
end

function GetCreeps(me)
	local entities = entityList:GetEntities({alive=true, visible=true, distance={me, myhero.aggroRange}})
	for _, dEntity in ipairs(entities) do
		if ((dEntity.classId == CDOTA_BaseNPC_Creep_Lane and (dEntity.armor >= 0 or dEntity.armor <= 3)) or (dEntity.classId == CDOTA_BaseNPC_Creep_Siege)) and not creepTable[dEntity.handle] then
			creepTable[dEntity.handle] = Creep(dEntity)
		end
	end

	for creepHandle, creepClass in pairs(creepTable) do

		if not creepClass.creepEntity.alive or GetDistance2D(me, creepClass.creepEntity) > myhero.aggroRange then
			creepTable[creepHandle] = nil
		else

			creepClass:Update()
		end
	end
end

function GenerateSideMessage(heroname,msg)
	local sidemsg = sideMessage:CreateMessage(300*monitor,60*monitor,0x111111C0,0x444444FF,150,1000)
	sidemsg:AddElement(drawMgr:CreateRect(10*monitor,10*monitor,72*monitor,40*monitor,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroname:gsub("npc_dota_hero_",""))))
	sidemsg:AddElement(drawMgr:CreateText(85*monitor,20*monitor,-1,"" .. msg,F15))
end

function CreateHUD()
	if not HUD then
		HUD = EasyHUD.new(550*monitor,300*monitor,500*monitor,300*monitor,"AdvancedCreepControl",0x111111C0,-1,true,true)
		HUD:AddText(5*monitor,10*monitor,"Hello, this is AdvancedCreepControl Menu and you might want to adjust settings")
		HUD:AddText(5*monitor,30*monitor,"Usage: Hold SPACE for Autolasthit / Autodeny while moving to your mouse position")
		HUD:AddText(300*monitor,270*monitor,"Press " .. string.char(menu) .. " for Open / Close Menu")
		if not active then
			HUD:AddCheckbox(5*monitor,50*monitor,35*monitor,20*monitor,"ENABLE SCRIPT",activeCheck,false)
		else
			HUD:AddCheckbox(5*monitor,50*monitor,35*monitor,20*monitor,"ENABLE SCRIPT",activeCheck,true)
		end
		HUD:AddText(5*monitor,75*monitor,"Script Settings:")
		if not enablelasthits then
			HUD:AddCheckbox(5*monitor,95*monitor,35*monitor,20*monitor,"ENABLE AUTO LASTHIT",lhCheck,false)
		else
			HUD:AddCheckbox(5*monitor,95*monitor,35*monitor,20*monitor,"ENABLE AUTO LASTHIT",lhCheck,true)
		end
		if not enabledenies then
			HUD:AddCheckbox(5*monitor,115*monitor,35*monitor,20*monitor,"ENABLE AUTO DENY",dCheck,false)
		else
			HUD:AddCheckbox(5*monitor,115*monitor,35*monitor,20*monitor,"ENABLE AUTO DENY",dCheck,true)
		end
		if not autounaggro then
			HUD:AddCheckbox(5*monitor,135*monitor,35*monitor,20*monitor,"ENABLE AUTO UNAGGRO",aCheck,false)
		else
			HUD:AddCheckbox(5*monitor,135*monitor,35*monitor,20*monitor,"ENABLE AUTO UNAGGRO",aCheck,true)
		end
		HUD:AddButton(5*monitor,250*monitor,110*monitor,40*monitor, 0x60615FFF,"Save Settings",SaveSettings)
	end
end

function SaveSettings()
	local file = io.open(SCRIPT_PATH.."/config/AdvancedCreepControl.txt", "w+")
	if file then
		if enabledenies then
			file:write("enableDenies = true \n")
		else
			file:write("enableDenies = false \n")
		end
		if enablelasthits then
			file:write("enableLasthits = true \n")
		else
			file:write("enableLasthits = false \n")
		end
		file:write("CustomMove = "..string.char(custommove).."\n")
		if spaceformove then
			file:write("Spaceformove = true \n")
		else
			file:write("Spaceformove = false \n")
		end
		if autounaggro then
			file:write("AutoUnAggro = true \n")
		else
			file:write("AutoUnAggro = false \n")
		end
		if active then
			file:write("Active = true \n")
		else
			file:write("Active = false \n")
		end
		file:write("Menu = "..string.char(menu))
        file:close()
		if PlayingGame() then
			GenerateSideMessage(entityList:GetMyHero().name,"          Settings succesfully saved!")
		end
    end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else
			statusText.visible = false
			myhero = nil
			HUD = nil
			reg = true
			creepTable = {}
			if active then
				GenerateSideMessage(entityList:GetMyHero().name,"     Advanced CreepControl is ON!")
			end
			script:RegisterEvent(EVENT_TICK, Main)
			script:RegisterEvent(EVENT_KEY, Key)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()

	statusText.visible = false
	myhero = nil
	
	SaveSettings()
	
	if HUD then
		HUD:Close()	
		HUD = nil
	end
	
	creepTable = {}
	
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)
