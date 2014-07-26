require("libs.ScriptConfig")
require("libs.Utils")
require("libs.HeroInfo")
require("libs.EasyHUD")
require("libs.TargetFind")

local config = ScriptConfig.new()
config:SetParameter("CustomMove", "J", config.TYPE_HOTKEY)
config:SetParameter("Menu", "H", config.TYPE_HOTKEY)
config:SetParameter("ModifiersTogglekey", "A", config.TYPE_HOTKEY)
config:SetParameter("AutoAttackKey", "S", config.TYPE_HOTKEY)
config:SetParameter("Spaceformove", true)
config:SetParameter("DontOrbwalkWhenIdle", true)
config:SetParameter("ActiveFromStart", true)
config:SetParameter("ShowMenuAtStart", true)
config:SetParameter("EnableAttackModifiers", true)
config:SetParameter("ShowSign", true)
config:Load()
	
custommove = config.CustomMove
menu = config.Menu
modifhotkey = config.ModifiersTogglekey
noorbwalkidle = config.DontOrbwalkWhenIdle
spaceformove = config.Spaceformove
active = config.ActiveFromStart
showmenu = config.ShowMenuAtStart
enablemodifiers = config.EnableAttackModifiers
showSign = config.ShowSign
aakey = config.AutoAttackKey

myAttackTickTable = {}

sleep = 0 myAttackTickTable.attackRateTick = 0 myAttackTickTable.attackPointTick = nil

local attacking = false local reg = false local HUD = nil local myhero = nil local victim = nil local myId = nil

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText = drawMgr:CreateText(10*monitor,580*monitor,-1,"",F14) statusText.visible = false

function activeCheck()	
	if PlayingGame() then
		if not active then
			active = true
		else
			active = false
		end
	end
end

function smCheck()
	if PlayingGame() then
		if not showmenu then
			showmenu = true
		else
			showmenu = nil
		end
	end
end

function owCheck()
	if PlayingGame() then
		if not noorbwalkidle then
			noorbwalkidle = true
		else
			noorbwalkidle = false
		end
	end
end

function modCheck()
	if PlayingGame() then
		if not enablemodifiers then
			enablemodifiers = true
		else
			enablemodifiers = false
		end
	end
end

function ssCheck()
	if PlayingGame() then
		if not showSign then
			showSign = true
		else
			showSign = false
		end
	end
end

function Key(msg, code)
	if msg ~= KEY_UP or client.chat or client.console then return end
	if code == menu and HUD then 
		if HUD:IsClosed() then
			HUD:Open()
			statusText.visible = false
		else
			HUD:Close()
			if showSign then
				statusText.visible = true
			end
		end
	elseif code == modifhotkey then
		modCheck()
	end
end

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero() if not me then return end
	local ID = me.classId if ID ~= myId then Close() end
	
	if spaceformove then
		movetomouse = 0x20
	else
		movetomouse = custommove
	end
	
	if not HUD then 
		CreateHUD()
		if not showmenu then
			HUD:Close()
		end
	elseif HUD and HUD:IsClosed() and showSign then
		statusText.visible = true
	end
	
	if string.byte("A") <= menu and menu <= string.byte("Z") then
		statusText.text = "Orb Walker: Press " .. string.char(menu) .. " to open Menu"
	else
		statusText.text = "Orb Walker: Press " .. menu .. " to open Menu"
	end

	if active then
		if not myhero then	
			myhero = MyHero(me)
		else
			
			myhero:GetModifiers()
			myhero.attackSpeed = myhero:GetAttackSpeed()
			myhero.attackRate = myhero:GetAttackRate()
			myhero.attackPoint = myhero:GetAttackPoint()
			myhero.attackRange = myhero:GetAttackRange()
			myhero.turnRate = myhero:GetTurnRate()
			myhero.attackBackswing = myhero:GetBackswing()
			
			if myAttackTickTable.attackPointTick and GetTick() >= myAttackTickTable.attackPointTick then
				myAttackTickTable.attackPointTick = nil
				attacking = false
			end
			
			if (IsKeyDown(movetomouse) or IsKeyDown(aakey)) and not client.chat then
				if not IsKeyDown(aakey) then
					victim = targetFind:GetClosestToMouse(100)	
					if not victim then
						victim = targetFind:GetLowestEHP(myhero.attackRange, phys)
					end
				end
				if not IsKeyDown(aakey) and (not victim or (victim and GetDistance2D(me, victim) > myhero.attackRange)) or (not noorbwalkidle and not attacking) and tick > sleep then
					me:Move(client.mousePosition)
					sleep = tick + client.latency
				end
				if not attacking and tick > sleep then
					if IsKeyDown(aakey) or (victim and (victim.activity ~= LuaEntityNPC.ACTIVITY_IDLE and victim.activity ~= LuaEntityNPC.ACTIVITY_IDLE1) or (victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE)) then
						me:Move(client.mousePosition)
						sleep = tick + client.latency
					end
				end
				if IsKeyDown(aakey) or (victim and victim.alive and victim.visible and victim.health > 0 and GetDistance2D(me, victim) < myhero.attackRange) and me.alive then
					if myhero.isRanged then
						local projectiles = entityList:GetProjectiles({source=me})
						if not IsKeyDown(aakey) then
							projectiles = entityList:GetProjectiles({target=victim})
						end
						for k,z in ipairs(projectiles) do
							if z.source then
								if z.source.name == me.name then							
									if myAttackTickTable.attackPointTick == nil and myAttackTickTable.attackRateTick == 0 or myAttackTickTable.attackRateTick > GetTick() and ((victim and GetDistance2D(z.position, victim) > GetDistance2D(z.position, me)) or IsKeyDown(aakey)) then
										myAttackTickTable.attackPointTick = GetTick()
										if not IsKeyDown(aakey) then
											myAttackTickTable.attackRateTick = myAttackTickTable.attackRateTick + (math.max((GetDistance2D(me, victim) - myhero.attackRange), 0)/z.speed)*1000
										else
											myAttackTickTable.attackRateTick = myAttackTickTable.attackRateTick
										end
									end
								end
							elseif not z then
								myAttackTickTable.attackRateTick = 0
							end							
						end						
					end
					if (GetTick() >= myAttackTickTable.attackRateTick) then
						if not IsKeyDown(aakey) then
							myhero:Hit(victim)
						else
							entityList:GetMyPlayer():AttackMove(client.mousePosition)
						end
						if not myhero.isRanged then
							myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000
							if not IsKeyDown(aakey) then
								myAttackTickTable.attackPointTick = GetTick() + (myhero.attackRate*(myhero.baseAttackPoint/(myhero.baseAttackPoint+myhero.baseBackswing)) + myhero.attackPoint)*1000 + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, victim))) - 0.69, 0))/(myhero.turnRate*(1/0.03))*1000
							else
								myAttackTickTable.attackPointTick = GetTick() + (myhero.attackRate*(myhero.baseAttackPoint/(myhero.baseAttackPoint+myhero.baseBackswing)) + myhero.attackPoint)*1000
							end
						else
							myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000
						end
						attacking = true	
					end
				end		
			else
				myAttackTickTable.attackRateTick = 0 
				myAttackTickTable.attackPointTick = nil 
				attacking = false 
				victim = nil
			end 
		end
	end
end

class 'MyHero'

	function MyHero:__init(heroEntity)
		self.heroEntity = heroEntity
		local name = heroEntity.name

		if not heroInfo[name] then
			return nil
		end

		if not heroInfo[name].projectileSpeed then
			self.isRanged = false
		else
			self.isRanged = true
		end

		self.baseAttackPoint = heroInfo[name].attackPoint
		self.baseTurnRate = heroInfo[name].turnRate
		self.baseBackswing = heroInfo[name].attackBackswing
	end

	function MyHero:GetTurnRate()
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

	function MyHero:GetAttackRange()
		local bonus = 0
		if self.heroEntity.classId == CDOTA_Unit_Hero_TemplarAssassin then	
			local psy = self.heroEntity:GetAbility(3)
			psyrange = {60,120,180,240}		
			if psy and psy.level > 0 then		
				bonus = psyrange[psy.level]			
			end
		elseif self.heroEntity.classId == CDOTA_Unit_Hero_Sniper then	
			local aim = self.heroEntity:GetAbility(3)
			aimrange = {100,200,300,400}		
			if aim and aim.level > 0 then		
				bonus = aimrange[aim.level]			
			end		
		elseif self.heroEntity.classId == CDOTA_Unit_Hero_Enchantress then
			if enablemodifiers then
				local impetus = self.heroEntity:GetAbility(4)
				if impetus.level > 0 and self.heroEntity:AghanimState() then
					bonus = 190
				end
			end
		end
		return self.heroEntity.attackRange + bonus
	end

	function MyHero:GetAttackSpeed()
		if self.heroEntity.attackSpeed > 500 then
			return 500
		end
		return self.heroEntity.attackSpeed
	end


	function MyHero:GetAttackPoint()
		return self.baseAttackPoint / (1 + (self.attackSpeed) / 100)
	end

	function MyHero:GetAttackRate()
		return self.heroEntity.attackBaseTime / (1 + (self.attackSpeed - 100) / 100)
	end

	function MyHero:GetBackswing()
		return self.baseBackswing / (1 + (self.attackSpeed - 100) / 100)
	end

	function MyHero:GetModifiers()
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

	function MyHero:Hit(target)
		if target.team ~= self.heroEntity.team then
			if enablemodifiers and not target:IsMagicImmune() then
				if self.heroEntity.classId == CDOTA_Unit_Hero_Clinkz then
					local searinga = self.heroEntity:GetAbility(2)
					if searinga.level > 0 and self.heroEntity.mana > 10 then
						self.heroEntity:SafeCastAbility(searinga, target)
					else entityList:GetMyPlayer():Attack(target) end
				elseif self.heroEntity.classId == CDOTA_Unit_Hero_DrowRanger then
					local frost = self.heroEntity:GetAbility(1)
					if frost.level > 0 and self.heroEntity.mana > 12 then
						self.heroEntity:SafeCastAbility(frost, target)
					else entityList:GetMyPlayer():Attack(target) end
				elseif self.heroEntity.classId == CDOTA_Unit_Hero_Viper then
					local poison = self.heroEntity:GetAbility(1)
					if poison.level > 0 and self.heroEntity.mana > 21 then
						self.heroEntity:SafeCastAbility(poison, target)
					else entityList:GetMyPlayer():Attack(target) end
				elseif self.heroEntity.classId == CDOTA_Unit_Hero_Huskar then
					local burning = self.heroEntity:GetAbility(2)
					if burning.level > 0 and self.heroEntity.health > 15 then
						self.heroEntity:SafeCastAbility(burning, target)
					else entityList:GetMyPlayer():Attack(target) end
				elseif self.heroEntity.classId == CDOTA_Unit_Hero_Silencer then
					local glaives = self.heroEntity:GetAbility(2)
					if glaives.level > 0 and self.heroEntity.mana > 15 then
						self.heroEntity:SafeCastAbility(glaives, target)
					else entityList:GetMyPlayer():Attack(target) end
				elseif self.heroEntity.classId == CDOTA_Unit_Hero_Jakiro then
					local liquid = self.heroEntity:GetAbility(3)
					if liquid.level > 0 and liquid.state == LuaEntityAbilty.STATE_READY then
						self.heroEntity:SafeCastAbility(liquid, target)
					else entityList:GetMyPlayer():Attack(target) end
				elseif self.heroEntity.classId == CDOTA_Unit_Hero_Obsidian_Destroyer then
					local arcane = self.heroEntity:GetAbility(1)
					if arcane.level > 0 and self.heroEntity.mana > 100 then
						self.heroEntity:SafeCastAbility(arcane, target)
					else entityList:GetMyPlayer():Attack(target) end
				elseif self.heroEntity.classId == CDOTA_Unit_Hero_Enchantress then
					local impetus = self.heroEntity:GetAbility(4)
					local impemana = {55,60,65}
					if impetus.level > 0 and self.heroEntity.mana > impemana[impetus.level] then
						self.heroEntity:SafeCastAbility(impetus, target)
					else entityList:GetMyPlayer():Attack(target) end
				else
					entityList:GetMyPlayer():Attack(target)
				end
			else
				entityList:GetMyPlayer():Attack(target)
			end
		end
	end

function FindAngleR(entity)
	if entity.rotR < 0 then
		return math.abs(entity.rotR)
	else
		return 2*math.pi - entity.rotR
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

function CreateHUD()
	if not HUD then
		HUD = EasyHUD.new(5*monitor,100*monitor,250*monitor,300*monitor,"Orb Walker",0x111111C0,-1,true,true)
		if spaceformove then
			if string.byte("A") <= aakey and aakey <= string.byte("Z") then
				HUD:AddText(5*monitor,10*monitor,"Usage: Hold SPACE.(For AutoAttack hold "..string.char(aakey)..")")
			else
				HUD:AddText(5*monitor,10*monitor,"Usage: Hold SPACE.(For AutoAttack hold "..aakey..")")
			end
		else
			if string.byte("A") <= movetomouse and movetomouse <= string.byte("Z") and string.byte("A") <= aakey and aakey <= string.byte("Z") then
				HUD:AddText(5*monitor,10*monitor,"Usage: Hold "..string.char(movetomouse)..".(For AutoAttack hold "..string.char(aakey)..")")
			else
				HUD:AddText(5*monitor,10*monitor,"Usage: Hold "..movetomouse..".(For AutoAttack hold "..aakey..")")
			end
		end
		HUD:AddText(5*monitor,30*monitor,"Orb Walker Settings:")
		if string.byte("A") <= menu and menu <= string.byte("Z") then
			HUD:AddText(5*monitor,220*monitor,"Press " .. string.char(menu) .. " for Open / Close Menu")
		else
			HUD:AddText(5*monitor,220*monitor,"Press " .. menu .. " for Open / Close Menu")
		end
		HUD:AddCheckbox(5*monitor,50*monitor,35*monitor,20*monitor,"ENABLE SCRIPT",activeCheck,active)
		HUD:AddText(5*monitor,75*monitor,"Script Settings:")
		HUD:AddCheckbox(5*monitor,95*monitor,35*monitor,20*monitor,"SHOW MENU ON START",smCheck,showmenu)
		HUD:AddCheckbox(5*monitor,115*monitor,35*monitor,20*monitor,"NO OrbWalk on IDLE enemy",owCheck,noorbwalkidle)
		if string.byte("A") <= modifhotkey and modifhotkey <= string.byte("Z") then
			HUD:AddCheckbox(5*monitor,135*monitor,35*monitor,20*monitor,"ATTACK MODIFIERS - ToggleKey "..string.char(modifhotkey),modCheck,enablemodifiers)
		else
			HUD:AddCheckbox(5*monitor,135*monitor,35*monitor,20*monitor,"ATTACK MODIFIERS - ToggleKey "..modifhotkey,modCheck,enablemodifiers)
		end
		HUD:AddCheckbox(5*monitor,155*monitor,35*monitor,20*monitor,"Show Sign",ssCheck,showSign)
		HUD:AddButton(5*monitor,250*monitor,110*monitor,40*monitor, 0x60615FFF,"Save Settings",SaveSettings)
	end
end

function SaveSettings()
	local file = io.open(SCRIPT_PATH.."/config/Orb_Walker.txt", "w+")
	if file then
		if string.byte("A") <= custommove and custommove <= string.byte("Z") then
			file:write("CustomMove = "..string.char(custommove).."\n")
		else
			file:write("CustomMove = "..custommove.."\n")
		end
		if spaceformove then
			file:write("Spaceformove = true \n")
		else
			file:write("Spaceformove = false \n")
		end
		if showmenu then
			file:write("ShowMenuAtStart = true \n")
		else
			file:write("ShowMenuAtStart = false \n")
		end
		if active then
			file:write("ActiveFromStart = true \n")
		else
			file:write("ActiveFromStart = false \n")
		end
		if noorbwalkidle then
			file:write("DontOrbwalkWhenIdle = true \n")
		else
			file:write("DontOrbwalkWhenIdle = false \n")
		end
		if enablemodifiers then
			file:write("EnableAttackModifiers = true \n")
		else
			file:write("EnableAttackModifiers = false \n")
		end
		if showSign then
			file:write("ShowSign = true \n")
		else
			file:write("ShowSign = false \n")
		end
		if string.byte("A") <= menu and menu <= string.byte("Z") then
			file:write("Menu = "..string.char(menu))
		else
			file:write("Menu = "..menu)
		end
		if string.byte("A") <= aakey and aakey <= string.byte("Z") then
			file:write("AutoAttackKey = "..string.char(aakey))
		else
			file:write("AutoAttackKey = "..aakey)
		end
		if string.byte("A") <= modifhotkey and modifhotkey <= string.byte("Z") then
			file:write("ModifiersTogglekey = "..string.char(modifhotkey))
		else
			file:write("ModifiersTogglekey = "..modifhotkey)
		end
        file:close()
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
			victim = nil
			myId = me.classId
			sleep = 0 
			myAttackTickTable = {}
			myAttackTickTable.attackRateTick = 0 
			myAttackTickTable.attackPointTick = nil
			script:RegisterEvent(EVENT_TICK, Main)
			script:RegisterEvent(EVENT_KEY, Key)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	statusText.visible = false
	myhero = nil
	victim = nil
	myId = nil
	
	if HUD then
		HUD:Close()	
		HUD = nil
	end
	
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)
