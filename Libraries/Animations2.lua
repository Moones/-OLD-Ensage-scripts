require("libs.Utils")
require("libs.HeroInfo")
--[[
                         '''''''''''                               
                     ''''```````````'''''''''''.                   
                 ''''`````````````````````..../.                   
              '''``````````````````````.../////.                   
          ''''``````````````````````...////////.                   
        ''wwwwwwwwww````````````....///////////.                   
         weeeeeeeeeewwwwwwwwww..//////////////.                    
         weeeeeeeeeeeeeeeeeeeew///////////////.                    
          weeeeeeeeeeeeeeeeeeew///////////////.                    
           weeeeeeeeeeeeeeeeeew///////////////.                    
           weeeeeeeeeeeeeeeeeeew//////////////.                    
            weeeeeeeeeeeeeeeeeew/////////////.                     
             weeeeeeeeeeeeeeeeew/////////////.                     
             weeeeeeeeeeeeeeeeew/////////////.                     
              weeeeeeeeeeeeeeeew/////////////.                     
               weeeeeeeeeeeeeeeew////////////.                     
               weeeeeeeeeeeeeeeew///////////.                      
                weeeeeeeeeeeeeeew//////////.                       
                 weeeeeeeeeeeeeew////////..                        
                 weeeeeeeeeeeeeeew//////.                          
                  wweeeeeeeeeeeeew/////.                           
                    wwwweeeeeeeeew////.                              *           
                        wwwweeeeew//..                    *       *              
                            wwwwew/.            * *     **    **      *    
                                ww.             *      **    *     **          
                                                 *      **   * *****    * **   
                                                   *      ****** ** * *     ***
                                                      *** *********           *
        +-------------------------------------------------+   * *  *            
        |                                                 |    *  *** **        
        |       ANIMATIONS LIBRARY - Made by Moones       |    *   *    **      
        |       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^       |    *    *     **    
        +-------------------------------------------------+    *   **      **   
                                                                            *       
        =+=+=+=+=+=+=+=+= VERSION 1.0.2.1 =+=+=+=+=+=+=+=+=
	 
        Description:
        ------------
	
             - This library tracks animations duration of all heroes.
             - Tracks attack animations as well as spell animations.
			 
        Usage:
        ------
		
             - Animations.getDuration(ability) - If specified ability is animating then returns how much time left since ability started its animation.
             - Animations.getAttackDuration(hero) - If specified hero is attacking then returns how much time left since his current attack animation started.
             - Animations.isAttacking(hero) - Returns true if specified hero is currently attacking.
             - Animations.CanMove(hero) - If specified hero already finished his attack and is in his backswing animation then true is returned.
             - Animations.maxCount - Returns how much times per second is library checking. Can be used for sleeps in EVENT_FRAME function.
			 
        Example:
        --------
        
             - Simple OrbWalker:
			 
                 require("libs.Animations")
                 require("libs.Utils")
				 
                 local attack = 0
                 local move = 0
				 
                 function Tick(tick)
                     if PlayingGame() then
                         local me = entityList:GetMyHero()
                         if IsKeyDown(49) then
                             if not Animations.CanMove(me) then
                                 for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team = me:GetEnemyTeam()})) do
                                     if tick > attack GetDistance2D(me, v) <= me.attackRange*2 then
                                         me:Attack(v)
                                         attack = tick + Animations.maxCount/1.5
                                     end
                                 end
                             elseif tick > move then
                                 me:Move(client.mousePosition)
                                 move = tick + Animations.maxCount/1.5
                             end
                         end
                     end
                 end

                 script:RegisterEvent(EVENT_FRAME,Tick)
			 
	   
        Changelog:
        ----------
		
			 - 27. 1.  2015 - Version 1.0.2.1 Fixed for Metamorphosis and Elder dragon form
		
             - 21. 11. 2014 - Version 1.0.2 Fixed bug with tick count.
		
             - 21. 11. 2014 - Version 1.0.1 Now CanMove returning false when hero is casting an ability.
	
             - 21. 11. 2014 - Version 1.0 First Release
]]--

Animations = {}

Animations.table = {}
Animations.attacksTable = {}
Animations.entities = {}
Animations.startTime = nil
Animations.count = 0
Animations.maxCount = 0

function Animations.trackingTick()
	if not PlayingGame() or client.paused then return end
	local Animations = Animations
	local tick = GetTick()
	if not Animations.startTime then Animations.startTime = tick
	elseif (tick - Animations.startTime) >= 500 then Animations.startTime = tick Animations.maxCount = Animations.count Animations.count = 0
	else Animations.count = Animations.count + 1 end
	-- local entities = {}
	-- local me = entityList:GetMyHero()
	-- local spider = entityList:GetEntities({classId=CDOTA_Unit_Broodmother_Spiderling,alive=true,visible=true,team=me.team,controllable=true})
	-- local boar = entityList:GetEntities({classId=CDOTA_Unit_Hero_Beastmaster_Boar,alive=true,visible=true,team=me.team,controllable=true})
	-- local forg = entityList:GetEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,alive=true,visible=true,team=me.team,controllable=true})
	-- local heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=me:GetEnemyTeam()})
	-- local heroesillusions = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=me.team,controllable=true,illusion=true})
	-- local neutral = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Neutral,alive=true,visible=true,team=me.team,controllable=true})
	-- local bear = entityList:GetEntities({classId=CDOTA_Unit_SpiritBear,alive=true,visible=true,team=me.team,controllable=true})[1]
	-- local earth = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalEarth,alive=true,visible=true,team=me.team,controllable=true})[1]
	-- local fire = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalFire,alive=true,visible=true,team=me.team,controllable=true})[1]
	-- local storm = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalStorm,alive=true,visible=true,team=me.team,controllable=true})[1]
	-- local necorwarriors = entityList:GetEntities(function (v) return ((v.name == "npc_dota_necronomicon_archer_1" or v.name == "npc_dota_necronomicon_archer_2" or v.name == "npc_dota_necronomicon_archer_3" or v.name == "npc_dota_necronomicon_warrior_1" or 
	-- v.name == "npc_dota_necronomicon_warrior_2" or v.name == "npc_dota_necronomicon_warrior_3") and v.alive and v.visible and v.team == me.team and v.controllable) end)
	-- local entitiesCount = 0
	-- for i = 1, #heroes do local v = heroes[i] entitiesCount = entitiesCount + 1 entities[entitiesCount] = v end
	-- for i = 1, #heroesillusions do local v = heroesillusions[i] entitiesCount = entitiesCount + 1 entities[entitiesCount] = v end
	-- if earth then
		-- entitiesCount = entitiesCount + 1 entities[entitiesCount] = earth 
	-- end
	-- if fire then
		-- entitiesCount = entitiesCount + 1 entities[entitiesCount] = fire 
	-- end
	-- if storm then
		-- entitiesCount = entitiesCount + 1 entities[entitiesCount] = storm 
	-- end
	-- if me then
		-- entitiesCount = entitiesCount + 1 entities[entitiesCount] = me
	-- end
	-- for i = 1, #necorwarriors do local v = necorwarriors[i] entitiesCount = entitiesCount + 1 entities[entitiesCount] = v end
	-- for i = 1, #spider do local v = spider[i] entitiesCount = entitiesCount + 1 entities[entitiesCount] = v end
	-- for i = 1, #boar do local v = boar[i] entitiesCount = entitiesCount + 1 entities[entitiesCount] = v end 
	-- for i = 1, #forg do local v = forg[i] entitiesCount = entitiesCount + 1 entities[entitiesCount] = v end
	-- for i = 1, #neutral do local v = neutral[i] entitiesCount = entitiesCount + 1 entities[entitiesCount] = v end
	if not Animations.entities then return end
	for i = 1, #Animations.entities do	
		local v = Animations.entities[i]
		if v then
			if not Animations.table[v.handle] then
				Animations.table[v.handle] = {}
			end
			--SleepCheck
			if Animations.table[v.handle].canmove then
				if not Animations.table[v.handle].sleepM or (Animations.startTime and (client.gameTime < 0 and Animations.startTime > 0)) then
					if Animations.maxCount and Animations.maxCount > 0 then
						Animations.table[v.handle].sleepM = tick + math.max((100/Animations.maxCount)*client.latency, 100)
					end
				end
				if Animations.table[v.handle].sleepM then
					if tick < Animations.table[v.handle].sleepM then
						Animations.table[v.handle].sleepingM = true
					end
					if tick > Animations.table[v.handle].sleepM then
						Animations.table[v.handle].sleepingM = false
						Animations.table[v.handle].sleepM = tick + math.max((100/Animations.maxCount)*client.latency, 100)
					end
				end
			end
			if not Animations.table[v.handle].canmove then
				if not Animations.table[v.handle].sleepA or (Animations.startTime and (client.gameTime < 0 and Animations.startTime > 0)) then
					if Animations.maxCount and Animations.maxCount > 0 then
						Animations.table[v.handle].sleepA = tick + math.max((100/Animations.maxCount)*client.latency, 100)
					end
				end
				if Animations.table[v.handle].sleepA then
					if tick < Animations.table[v.handle].sleepA then
						Animations.table[v.handle].sleepingA = true
					end
					if tick > Animations.table[v.handle].sleepA then 
						Animations.table[v.handle].sleepingA = false
						Animations.table[v.handle].sleepA = tick + math.max((100/Animations.maxCount)*client.latency, 100)
					end
				end
			end
			--SpellAnimationCheck
			local abilities = v.abilities
			if abilities then
				for i = 1, #abilities do
					local k = abilities[i]
					if k.abilityPhase then
						if not Animations.table[k.handle] then                                   
							Animations.table[k.handle] = {}
							Animations.table[k.handle].startTime = tick
							Animations.table[k.handle].duration = tick - Animations.table[k.handle].startTime
							Animations.table[v.handle].canmove = false
						end
					else
						Animations.table[k.handle] = nil
					end
					if Animations.table[k.handle] then
						Animations.table[k.handle].duration = tick - Animations.table[k.handle].startTime
						Animations.table[v.handle].canmove = false
					end
				end
			end
			local hero = HeroInfo(v)
			hero:Update()
			
			Animations.table[v.handle].attackTime = hero.attackPoint - ((client.latency/1000)/(1 + (1 - 1/Animations.maxCount))) + (1/Animations.maxCount)*3*(1 + (1 - 1/Animations.maxCount))
			Animations.table[v.handle].moveTime = (hero.attackRate) - (client.latency/1000) - (1/Animations.maxCount)*3
			
			--AttackAnimationCheck
			if Animations.isAttacking(v) then
				if not Animations.table[v.handle].startTime then
					Animations.table[v.handle].startTime = client.gameTime
				end
				Animations.table[v.handle].endTime = Animations.table[v.handle].startTime + (hero.attackRate) - (client.latency/1000) - (1/Animations.maxCount)*3
				Animations.table[v.handle].canmoveTime = Animations.table[v.handle].startTime + hero.attackPoint - ((client.latency/1000)/(1 + (1 - 1/Animations.maxCount))) + (1/Animations.maxCount)*3*(1 + (1 - 1/Animations.maxCount))
			end
			--FlyingProjectilesCheck
			local projs = entityList:GetProjectiles({source=v})
			if v:IsRanged() then
				for k = 1, #projs do
					local z = projs[k]
					if (GetDistance2D(z.position, v.position) < 127 or (z.target and GetDistance2D(z,z.target) < 127)) and not Animations.table[v.handle].canmove then
						Animations.table[v.handle].canmove = true
						-- if v.name == "npc_dota_hero_dragon_knight" then	
							-- print("Asd")
							Animations.table[v.handle].endTime = client.gameTime + Animations.table[v.handle].moveTime - Animations.table[v.handle].attackTime
						-- else
							-- Animations.table[v.handle].endTime = client.gameTime + (hero.attackBackswing) - (client.latency/1000) - (1/Animations.maxCount)*3
						-- end
					end
				end
			end
			if Animations.table[v.handle].endTime and Animations.table[v.handle].endTime <= client.gameTime then
				Animations.table[v.handle].startTime = nil
				Animations.table[v.handle].canmoveTime = nil
				Animations.table[v.handle].endTime = nil
				Animations.table[v.handle].canmove = false
			end
			if Animations.table[v.handle].startTime then
				Animations.table[v.handle].duration = client.gameTime - Animations.table[v.handle].startTime + 1/Animations.maxCount + client.latency/1000
			end
			if Animations.table[v.handle].canmoveTime and client.gameTime >= Animations.table[v.handle].canmoveTime then
				Animations.table[v.handle].canmove = true
			end
		end
	end
end

function Animations.trackLoad()
	local Animations = Animations
	Animations.count = 0
	Animations.maxCount = 0
	Animations.entities = {}
end

function Animations.getCount()
	local Animations = Animations
	return Animations.count
end

function Animations.getDuration(ability)
	local Animations = Animations
	if ability and Animations.table[ability.handle] then return Animations.table[ability.handle].duration else return 0 end
end

function Animations.getAttackDuration(hero)
	local Animations = Animations
	if hero and Animations.table[hero.handle] then return Animations.table[hero.handle].duration else return 0 end
end

function Animations.isAnimating(ability)	
	return ability.abilityPhase
end

function Animations.isAttacking(hero)
	return hero.activity == LuaEntityNPC.ACTIVITY_ATTACK or hero.activity == LuaEntityNPC.ACTIVITY_ATTACK1 or hero.activity == LuaEntityNPC.ACTIVITY_ATTACK2 or hero.activity == LuaEntityNPC.ACTIVITY_CRIT
end

function Animations.isCriting(hero)
	return hero.activity == LuaEntityNPC.ACTIVITY_CRIT
end

function Animations.CanMove(hero)
	local Animations = Animations
	if Animations.table[hero.handle] then return Animations.table[hero.handle].canmove and HeroInfo(hero) and HeroInfo(hero).attackSpeed and HeroInfo(hero).attackSpeed < 250 end
	return false
end

function Animations.GetAttackTime(hero)
	local Animations = Animations
	if hero and Animations.table[hero.handle] and Animations.table[hero.handle].attackTime then return Animations.table[hero.handle].attackTime elseif HeroInfo(hero) and HeroInfo(hero).attackPoint then return HeroInfo(hero).attackPoint - ((client.latency/1000)/(1 + (1 - 1/Animations.maxCount))) + (1/Animations.maxCount)*3*(1 + (1 - 1/Animations.maxCount))
	end
	return 0
end

function Animations.getBackswingTime(hero)
	local Animations = Animations
	if hero and Animations.table[hero.handle] and Animations.table[hero.handle].attackTime and Animations.table[hero.handle].moveTime then return Animations.table[hero.handle].moveTime - Animations.table[hero.handle].attackTime elseif HeroInfo(hero) and HeroInfo(hero).attackPoint and HeroInfo(hero).attackRate then return (HeroInfo(hero).attackRate - (client.latency/1000) - (1/Animations.maxCount)*3) - (HeroInfo(hero).attackPoint - ((client.latency/1000)/(1 + (1 - 1/Animations.maxCount))) + (1/Animations.maxCount)*3*(1 + (1 - 1/Animations.maxCount)))
	end
	return 0 
end


class 'HeroInfo'

function HeroInfo:__init(entity)   
	if entity then
		self.entity = entity
		local name = entity.name
		if not heroInfo[name] then
			return nil
		end
		self.baseAttackPoint = heroInfo[name].attackPoint
		self.baseBackswing = heroInfo[name].attackBackswing
		self.attackSpeed = self:GetAttackSpeed()
		self.attackRate = self:GetAttackRate()
		self.attackPoint = self:GetAttackPoint()
		self.attackBackswing = self:GetBackswing()
	end
end

function HeroInfo:Update()	
	self.attackSpeed = self:GetAttackSpeed()
	self.attackRate = self:GetAttackRate()
	self.attackPoint = self:GetAttackPoint()
	self.attackBackswing = self:GetBackswing()
end

function HeroInfo:GetAttackSpeed()
	if self.entity.attackSpeed > 600 or self.entity:DoesHaveModifier("modifier_ursa_overpower") then
		return 600
	end
	return self.entity.attackSpeed
end

function HeroInfo:GetAttackPoint()
	if self.baseAttackPoint then
		return self.baseAttackPoint / (1 + (self.entity.attackSpeed - 100) / 100)
	else
		return 0.5 / (1 + (self.entity.attackSpeed - 100) / 100)
	end
end

function HeroInfo:GetAttackRate()
	local alchrage = self.entity:FindSpell("alchemist_chemical_rage")
	if alchrage and alchrage.level > 0 and self.entity:DoesHaveModifier("modifier_alchemist_chemical_rage") then
		return alchrage:GetSpecialData("base_attack_time",alchrage.level) / (1 + (self.entity.attackSpeed - 100) / 100)
	end
	local terrormorph = self.entity:FindSpell("terrorblade_metamorphosis")
	if terrormorph and terrormorph.level > 0 and self.entity:DoesHaveModifier("modifier_terrorblade_metamorphosis") then
		return terrormorph:GetSpecialData("base_attack_time",terrormorph.level) / (1 + (self.entity.attackSpeed - 100) / 100)
	end
	local lonetrue = self.entity:FindSpell("lone_druid_true_form")
	if lonetrue and lonetrue.level > 0 and self.entity:DoesHaveModifier("modifier_lone_druid_true_form") then
		return lonetrue:GetSpecialData("base_attack_time",lonetrue.level) / (1 + (self.entity.attackSpeed - 100) / 100)
	end
	local berserkers = self.entity:FindSpell("troll_warlord_berserkers_rage")
	if berserkers and berserkers.level > 0 and self.entity:DoesHaveModifier("modifier_troll_warlord_berserkers_rage") then
		return berserkers:GetSpecialData("base_attack_time",berserkers.level) / (1 + (self.entity.attackSpeed - 100) / 100)
	end
	return self.entity.attackBaseTime / (1 + (self.entity.attackSpeed - 100) / 100)
end

function HeroInfo:GetBackswing()
	if self.baseBackswing then
		return self.baseBackswing / (1 + (self.entity.attackSpeed - 100) / 100)
	else
		return 0.5 / (1 + (self.entity.attackSpeed - 100) / 100)
	end
end
	
scriptEngine:RegisterLibEvent(EVENT_FRAME,Animations.trackingTick)
scriptEngine:RegisterLibEvent(EVENT_LOAD,Animations.trackLoad)
