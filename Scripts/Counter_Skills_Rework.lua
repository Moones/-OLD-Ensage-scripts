--intest 0.5



require("libs.Utils")

radiant=Vector(-7264,-6752,270)
dire=Vector(6975,6742,256)


wait = 0
waittime = 0
sleepTick = nil
sleep1 = 0 



function Tick( tick )
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end


	--if not engineClient.inGame or engineClient.console or not me then return end        
	--if me.name == nil then return end
	if sleepTick and sleepTick > tick then return end
	--if me.team == TEAM_RADIANT then home = radiant else home = dire end





	actived =0
        --local player = entityList:GetMyPlayer()
        --local me = entityList:GetMyHero()	
        me = entityList:GetMyHero()	
        if not me then
        	return 
        end
        herotab = {}
        for i,v in ipairs(entityList:FindEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
        	if v.team ~= me.team then
        		target = v



				if v.name == "npc_dota_hero_shadow_shaman" then
					--print(v:GetProperty("CBaseAnimating","m_nSequence"))
					if v:GetProperty("CBaseAnimating","m_nSequence") ==13 then
						if GetDistance2D(v,me) < 610 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Nyx()
								Abaddonult()
								--TemplarRefraction()
							end
						end
					end
				end



				if v.name == "npc_dota_hero_sven" then
					--print(v:GetProperty("CBaseAnimating","m_nSequence"))
					if v:GetProperty("CBaseAnimating","m_nSequence") ==15 then
						if GetDistance2D(v,me) < 680 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Nyx()
								Useshadowamulet()
							end
						end
					end
				end

---updtaee










		if v.name == "npc_dota_bloodseeker" then
			if v:GetProperty("CBaseAnimating","m_nSequence") ==14 then
				if GetDistance2D(v,me) < 1000 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						Nyx()
						TemplarMeld()
						TemplarRefraction()
						UseShadowBlade()
						Useshadowamulet()
					end
				end
			end
		end


		if v.name == "npc_dota_hero_night_stalker" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==5 then
				if GetDistance2D(v,me) < 535 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						Nyx()
					end
				end
			end
		end

		if v.name == "npc_dota_hero_luna" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==8 or v:GetProperty("CBaseAnimating","m_nSequence") ==10 then
				if GetDistance2D(v,me) < 810 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						Nyx()

					end
				end
			end
		end
--[[
		if v.name == "npc_dota_hero_sven" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==12 then
				if GetDistance2D(v,me) < 680 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						--Nyx()
						StormUltfront()
						Nyx()
						--TemplarMeld()
						if GetDistance2D(v,me) > 330 then

							Antiblinkfront()
							--print(GetDistance2D(v,me))
						end

					end
				end
			end
		end
]]
		if v.name == "npc_dota_hero_chaos_knight" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==11 then
				if GetDistance2D(v,me) < 680 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then

						if wait == 0 then
							waittime = GetTick() +80 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								--print("ok")
								StormUltfront()
								Nyx()
								Useshadowamulet()
								wait =0
								sleepTick= GetTick() +1000
							end

						end

					end

				end
			end
		end

		if v.name == "npc_dota_hero_magnataur" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==11 then
				if GetDistance2D(v,me) < 500 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						Nyx()
						StormUltfront2(300)
					end
				end
				if GetDistance2D(v,me) < 160 then
					Nyx()
				end
			end

			if v:GetProperty("CBaseAnimating","m_nSequence") ==21 then
				if GetDistance2D(v,me) < 420 then
					Nyx()
				end
			end


		end





--22 11 21

--[[		if v.name == "Tinker" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==5 then
				if GetDistance2D(v,me) < 600 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.25, 0))
					if turntime == 0 then
						Nyx()
					end
				end
			end
		end]]

		if v.name == "npc_dota_hero_tinker" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==5 then
				if GetDistance2D(v,me) < 680 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +200 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								Puck()
								Lifestealerrage()
								--TusksnowballTarget()
								wait =0

								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end

		if v.name == "npc_dota_hero_earthshaker" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==10 then
				if GetDistance2D(v,me) < 1400 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +400 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								Puck()
								Useshadowamulet()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end

		if v.name == "npc_dota_hero_ogre_magi" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==9 then
				if GetDistance2D(v,me) < 650 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +200 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end

		if v.name == "npc_dota_hero_zuus" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==11 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								UseShadowBlade()
								--WeaverShukuchi()
								TemplarMeld()
								PhantomlancerDoppelwalk()
								SandkinSandstorm()
								NyxVendetta()
								Puck()
								Lifestealerrage()
								Useblackking()
								UseEulScepterSelf()

								wait =0
							end
						end
			end
		end

		if v.name == "npc_dota_hero_templar_assassin" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
--			for i=1,v.modifierCount do
--				if v:GetModifierName(i) == "modifier_templar_assassin_meld" then
		        if v:DoesHaveModifier("modifier_templar_assassin_meld") then                                                      

					if v:GetProperty("CBaseAnimating","m_nSequence") ==4 or v:GetProperty("CBaseAnimating","m_nSequence") ==5 or v:GetProperty("CBaseAnimating","m_nSequence") ==6 then
						if GetDistance2D(v,me) < 390 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() +1 -(client.avgLatency / 1000)
									wait =1 
								else
									if GetTick()>waittime then
										Nyx()
										wait =0
										--sleepTick= GetTick() +1000
									end
								end
							end
						end
					end
				end
			--end
		end



		if v.name == "npc_dota_hero_clinkz" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
--			for i=1,v.modifierCount do
--				if v:GetModifierName(i) == "modifier_clinkz_strafe" then
		        if v:DoesHaveModifier("modifier_clinkz_strafe") then                                                      

					if v:GetProperty("CBaseAnimating","m_nSequence") ==4 then
						if GetDistance2D(v,me) < 650 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() +10 -(client.avgLatency / 1000)
									wait =1 
								else
									if GetTick()>waittime then
										Nyx()
										wait =0
										--sleepTick= GetTick() +1000
									end
								end
							end
						end
					end
				end
			--end
		end



		if v.name == "npc_dota_hero_faceless_void" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==16 then
				if GetDistance2D(v,me) < 950 then
					--turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 1.20, 0))
					--if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					--end
				end
			end
		end


		if v.name == "npc_dota_hero_phantom_assassin" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			--for i=1,v.modifierCount do
				--if v:GetModifierName(i) == "modifier_tusk_walrus_punch" then
					if v:GetProperty("CBaseAnimating","m_nSequence") ==10 then

						if GetDistance2D(v,me) < 360 then

--[[						local ultx=1
						if v:GetAbility(4).level == 1 then
							ultx=2.5
						elseif v:GetAbility(4).level == 2 then
							ultx=3.5
							elseif v:GetAbility(4).level == 3 then
								ultx=4.5
						end
]]
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.60, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() +10 -(client.avgLatency / 1000)
									wait =1 
								else
									if GetTick()>waittime then
										Nyx()
										TemplarMeld()
										TemplarRefraction()
										SandkinSandstorm()
										PhantomlancerDoppelwalk()

										UseBladeMail()
										wait =0
										--sleepTick= GetTick() +1000
									end
								end
							end
						end
					end
				--end
			--end
		end



		if v.name == "npc_dota_hero_tusk" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			--for i=1,v.modifierCount do
				--if v:GetModifierName(i) == "modifier_tusk_walrus_punch" then
		        if v:DoesHaveModifier("modifier_tusk_walrus_punch") then                                                      

					if v:GetProperty("CBaseAnimating","m_nSequence") ==7 or v:GetProperty("CBaseAnimating","m_nSequence") ==8 then
						if GetDistance2D(v,me) < 360 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.60, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() +10 -(client.avgLatency / 1000)
									wait =1 
								else
									if GetTick()>waittime then
										Nyx()
										wait =0
										--sleepTick= GetTick() +1000
									end
								end
							end
						end
					end
				end
			--end
		end

		if v.name == "npc_dota_hero_ursa" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
--			for i=1,v.modifierCount do
--				if v:GetModifierName(i) == "modifier_ursa_overpower" then
		        if v:DoesHaveModifier("modifier_ursa_overpower") then                                                      

					if v:GetProperty("CBaseAnimating","m_nSequence") ==8 or v:GetProperty("CBaseAnimating","m_nSequence") ==9 then
						if GetDistance2D(v,me) < 360 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.60, 0))
							if turntime == 0 then
								if wait == 0 then
									waittime = GetTick() +10 -(client.avgLatency / 1000)
									wait =1 
								else
									if GetTick()>waittime then
										Nyx()
										wait =0
										--sleepTick= GetTick() +1000
									end
								end
							end
						end
					end
				end
			--end
			if v:GetProperty("CBaseAnimating","m_nSequence") ==10 then
				if GetDistance2D(v,me) < 389 then
						if wait == 0 then
							waittime = GetTick() +10 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
				end
			end

		end




		if v.name == "npc_dota_hero_undying" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==17 then
				if GetDistance2D(v,me) < 760 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end



		if v.name == "npc_dota_hero_abaddon" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==8 then
				if GetDistance2D(v,me) < 820 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end


		if v.name == "npc_dota_hero_bounty_hunter" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==4 then
				if GetDistance2D(v,me) < 660 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end



		if v.name == "npc_dota_hero_troll_warlord" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==37 then
				if GetDistance2D(v,me) < 450 then
					--turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					--if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					--end
				end
			end
		end

		if v.name == "npc_dota_hero_juggernaut" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==17 then
				if GetDistance2D(v,me) < 760 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +310 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								--Nyx()
								TemplarMeld()
								Puck()
								UseGhostScepter()
								UseEulScepterSelf()

								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end


		if v.name == "npc_dota_hero_zuus" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==10 then
				if GetDistance2D(v,me) < 760 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end

		if v.name == "npc_dota_hero_queenofpain" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==8 then
				if GetDistance2D(v,me) < 760 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
				if v:GetProperty("CBaseAnimating","m_nSequence") ==7 then
					if GetDistance2D(v,me) < 475 then
						Nyx()


					end
				end





		end








		if v.name == "npc_dota_hero_crystal_maiden" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==7 then
				if GetDistance2D(v,me) < 1050 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end



		if v.name == "npc_dota_hero_obsidian_destroyer" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==11 then
				if GetDistance2D(v,me) < 1275 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end

		if v.name == "npc_dota_hero_lich" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==6 then
				if GetDistance2D(v,me) < 610 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +100 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end

--[[
		if v.name == "Shredder" then
			print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==17 then--17
				if GetDistance2D(v,me) < 1200 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 1.80, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +150 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end
]]

		if v.name == "npc_dota_hero_slardar" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==6 then
				if GetDistance2D(v,me) < 360 then
					--turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					--if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +150 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					--end
				end
			end
		end

		if v.name == "npc_dota_hero_centaur" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==6 then
				if GetDistance2D(v,me) < 320 then
					--turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					--if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +150 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					--end
				end
			end

			if v:GetProperty("CBaseAnimating","m_nSequence") ==8 then
				if GetDistance2D(v,me) < 340 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 1.7, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +150 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end





		end



		if v.name == "npc_dota_hero_dragon_knight" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==10 then
				if GetDistance2D(v,me) < 600 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
					if turntime == 0 then
						Nyx()
					end
				end
			end
		end




		if v.name == "npc_dota_hero_riki" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==35 then
				if GetDistance2D(v,me) < 600 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
					if turntime == 0 then
						Nyx()
					end
				end
			end
		end

		if v.name == "npc_dota_hero_mirana" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==11 then
				if GetDistance2D(v,me) < 630 then
						Nyx()
						UseShadowBlade()
						SandkinSandstorm()
						PhantomlancerDoppelwalk()
						WeaverShukuchi()

				end
			end
		end



		if v.name == "npc_dota_hero_legion_commander" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==17 then
				if GetDistance2D(v,me) < 400 then
						Nyx()
				end
			end
		end




		if v.name == "npc_dota_hero_necrolyte" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==2 then
				if GetDistance2D(v,me) < 650 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						Nyx()
						Useblackking()

					end
				end
			end
		end



		if v.name == "npc_dota_hero_spirit_breaker" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==16 then
				if GetDistance2D(v,me) < 720 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						if wait == 0 then
							waittime = GetTick() +400 -(client.avgLatency / 1000)
							wait =1 
						else
							if GetTick()>waittime then
								Nyx()
								wait =0
								--sleepTick= GetTick() +1000
							end
						end
					end
				end
			end
		end


		if v.name == "npc_dota_hero_doom_bringer" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==9 then
				if GetDistance2D(v,me) < 570 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						Nyx()			
					end
				end
			end
		end



		if v.name == "npc_dota_hero_bane" then
			--print(v:GetProperty("CBaseAnimating","m_nSequence"))
			if v:GetProperty("CBaseAnimating","m_nSequence") ==12  or v:GetProperty("CBaseAnimating","m_nSequence") ==14 or v:GetProperty("CBaseAnimating","m_nSequence") ==13  then
				if GetDistance2D(v,me) < 570 then
					turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
					if turntime == 0 then
						StormUltfront()
						Nyx()
					end
				end
			end
		end



---upddate






			--for i=1,me.modifierCount do
--				if me:GetModifierName(i) == "modifier_lina_laguna_blade" then
		        if me:DoesHaveModifier("modifier_lina_laguna_blade") then                                                      
local scepter = 0
					Puck()
					Nyx()
					--AlchemistRage()
					TemplarRefraction()
					Embersleighttargetcal()
					Emberremnantnow()
					EmberGuard()
					UseEulScepterSelf()
					
					
					Useblackking()
					

			        for i,v in ipairs(entityList:FindEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
			        	if v.team ~= me.team then
							for t=1,6 do
								if v:GetAbility(t) and v:GetAbility(t).name == "lina_laguna_blade" then
				        		target = v
				        		TusksnowballTarget()


									local lionultdamage = 0
									if v:GetAbility(t).level == 1 then
										lionultdamage = 450*3/4
										elseif v:GetAbility(t).level == 2 then
											lionultdamage = 675*3/4
											elseif v:GetAbility(t).level == 3 then
												lionultdamage = 950*3/4
									end
										for d = 1, 6 do
											if v:HasItem(d) and v:GetItem(d).name == "item_ultimate_scepter" then
												scepter = 1

												if v:GetAbility(t).level == 1 then
													lionultdamage = 600*3/4
													elseif v:GetAbility(t).level == 2 then
														lionultdamage = 925*3/4
														elseif v:GetAbility(t).level == 3 then
															lionultdamage = 1250*3/4
											

												end



											end


										if lionultdamage > me.health then
											Phoenixsupernova()
											Abaddonult()
											UseBloodStone()
										else
										sleepTick= GetTick() +550	
										end
									end
								end
							end
						end
					end

					if scepter == 0 then
						Jugernautfury()
						Lifestealerrage()
					end

					UseBladeMail()
					return	
				end
			--end




			--for i=1,me.modifierCount do
		        if me:DoesHaveModifier("modifier_pudge_meat_hook") then                                                      

				--if me:GetModifierName(i) == "modifier_pudge_meat_hook" then

					--Puck()
					--Nyx()
					--Lifestealerrage()
					UseShadowBlade()
			        for i,v in ipairs(entityList:FindEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
			        	if v.team ~= me.team then
							for t=1,6 do
								if v:GetAbility(t) and v:GetAbility(t).name == "pudge_meat_hook" then
								target = v
								--Puck()

								UseEulScepterTarget()
								UseOrchidtarget()
								UseSheepStickTarget()
								

								end
							end
						end
					end
					UseManta()
					--UseGhostScepter()
					
					
						
				end
			--end


--			for i=1,me.modifierCount do
		        if me:DoesHaveModifier("modifier_crystal_maiden_freezing_field_slow") then                                                      

				--if me:GetModifierName(i) == "modifier_crystal_maiden_freezing_field_slow" then

					Nyx()
					Useblackking()
					
				end
--			end

--			for i=1,me.modifierCount do
		        if me:DoesHaveModifier("modifier_pugna_life_drain") then                                                      
--				if me:GetModifierName(i) == "modifier_pugna_life_drain" then

					Nyx()
					--Useblackking()
					
				end
--			end



--			for i=1,me.modifierCount do
		        if me:DoesHaveModifier("modifier_lion_finger_of_death") then                                                      

--				if me:GetModifierName(i) == "modifier_lion_finger_of_death" then
					
					Nyx()
					Jugernautfury()
					Puck()
					Lifestealerrage()
					TemplarRefraction()
					--Phoenixsupernova()
					Embersleighttargetcal()
					Emberremnantnow()
					EmberGuard()
					
					
					
					UseEulScepterSelf()
					Useblackking()
        		



			        for i,v in ipairs(entityList:FindEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
			        	if v.team ~= me.team then

							for t=1,6 do
								if v:GetAbility(t) and v:GetAbility(t).name == "lion_finger_of_death" then
			        			target = v
			        			TusksnowballTarget()

									local lionultdamage = 0
									if v:GetAbility(t).level == 1 then
										lionultdamage = 600*3/4
										elseif v:GetAbility(t).level == 2 then
											lionultdamage = 725*3/4
											elseif v:GetAbility(t).level == 3 then
												lionultdamage = 850*3/4
									end
										for d = 1, 6 do
											if v:HasItem(d) and v:GetItem(d).name == "item_ultimate_scepter" then
												if v:GetAbility(t).level == 1 then
													lionultdamage = 725*3/4
													elseif v:GetAbility(t).level == 2 then
														lionultdamage = 865*3/4
														elseif v:GetAbility(t).level == 3 then
															lionultdamage = 1025*3/4
											end
										end
										if lionultdamage > me.health then
											Phoenixsupernova()
											Abaddonult()
											UseBloodStone()
										else
										sleepTick= GetTick() +550	
										end
									end
								end
							end
						end
					end


					UseBladeMail()
					--ObsidianImprisonmentself()
					--ShadowdemonDisruptionself()
					return	
				end
--			end
--[[
			for i=1,me.modifierCount do
				if me:GetModifierName(i) == "modifier_juggernaut_omnislash" then
					Puck()
					TemplarMeld()
					UseGhostScepter()
					UseEulScepterSelf()
					
					return	
				end
			end
]]
--			for i=1,v.modifierCount do
--[[
		        if me:DoesHaveModifier("modifier_juggernaut_omnislash") then         --error--not work                                            

--				if v:GetModifierName(i) == "modifier_juggernaut_omnislash" then
					if GetDistance2D(v,me) < 100 then

						Puck()
						TemplarMeld()
						UseGhostScepter()
						UseEulScepterSelf()
						Useshadowamulet()
						
						return	
					end
				end
--			end
]]



--			for i=1,me.modifierCount do
		        if me:DoesHaveModifier("modifier_ember_spirit_sleight_of_fist_caster") then                                                      
--				if me:GetModifierName(i) == "modifier_ember_spirit_sleight_of_fist_caster" then
					--print("dfsdfsd")
					if 150 >GetDistance2D(engineClient.mousePosition,me) and me.level >5 then
					

					--tt = targetFind:GetClosestToMouse(100)
					--	if tt and 150 >GetDistance2D(tt,me) then
						Emberchains()
						--print(me.x)
					end
					--	tt=nil
					--	return	
					--	end
				end
--			end


            blink = v:FindItem("item_blink")
            if blink and blink.cd > 11 then                                 
				for s=1,6 do
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "tiny_avalanche" and GetDistance2D(v,me) < 300 and v:GetAbility(s).state == -1 then
							Puck()
							Jugernautomnitarget()
							Lifestealerrage()
							--Emberchains()
							Silencerult()

							--UseBlinkDagger()
							
							Slardar()

							UseEulScepterTarget()
							Jugernautfury()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "tidehunter_ravage" and GetDistance2D(v,me) < 1050 and v:GetAbility(s).state == -1 then
							
							Emberchains()
							Silencerult()
							TusksnowballTarget()
							UseSheepStickTarget()
							UseOrchidtarget()
							UseEulScepterTarget()

							Puck()
							--UseBlinkDagger()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "puck_waning_rift" and GetDistance2D(v,me) < 400 and v:GetAbility(s).state == -1 then
							Puck()
							Emberchains()
							--UseBlinkDagger()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "treant_overgrowth" and GetDistance2D(v,me) < 625 and v:GetAbility(s).state == -1 then
							Emberchains()
							
							UseSheepStickTarget()
							UseOrchidtarget()
							UseEulScepterTarget()
							Puck()
							--UseBlinkDagger()
							UseShadowBlade()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "centaur_hoof_stomp" and GetDistance2D(v,me) < 320 and v:GetAbility(s).state == -1 then
							Puck()

							Silencerult()
							Emberchains()
							UseEulScepterTarget()
							--UseBlinkDagger()
							Jugernautfury()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "slardar_slithereen_crush" and GetDistance2D(v,me) < 350 and v:GetAbility(s).state == -1 then
							Puck()
							
							Emberchains()
							UseEulScepterTarget()
							--UseBlinkDagger()
							Jugernautfury()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "brewmaster_thunder_clap" and GetDistance2D(v,me) < 400 and v:GetAbility(s).state == -1 then
							Puck()
							Emberchains()
							UseEulScepterTarget()
							--UseBlinkDagger()
							Jugernautfury()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "venomancer_poison_nova" and GetDistance2D(v,me) < 830 and v:GetAbility(s).state == -1 then
							Emberchains()
							Silencerult()
							
							UseSheepStickTarget()
							UseOrchidtarget()
							UseEulScepterTarget()
							Puck()
							--UseBlinkDagger()
							Jugernautfury()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "magnataur_reverse_polarity" and GetDistance2D(v,me) < 410 and v:GetAbility(s).state == -1 then
							Emberchains()
							Silencerult()
							
							UseSheepStickTarget()
							UseOrchidtarget()
							UseEulScepterTarget()
							Puck()
							--UseBlinkDagger()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "magnataur_skewer" and GetDistance2D(v,me) < 300 and v:GetAbility(s).state == -1 then
							Emberchains()

							UseEulScepterTarget()

							UseSheepStickTarget()
							UseOrchidtarget()
							Puck()
							--UseBlinkDagger()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "batrider_flaming_lasso" and GetDistance2D(v,me) < 200 and v:GetAbility(s).state == -1 then
							Emberchains()
							Silencerult()
							UseEulScepterTarget()
							UseSheepStickTarget()
							UseOrchidtarget()
							Puck()
							--UseBlinkDagger()
							Jugernautfury()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "axe_berserkers_call" and GetDistance2D(v,me) < 300 and v:GetAbility(s).state == -1 then
							Emberchains()
							Puck()
							UseEulScepterTarget()
							--UseBlinkDagger()
							Jugernautfury()
							return 
						end
					end
					if v:GetAbility(s) ~=nil then
						if v:GetAbility(s).name == "legion_commander_duel" and GetDistance2D(v,me) < 250 and v:GetAbility(s).state == -1 then
							
							Emberchains()
							UseEulScepterTarget()
							Silencerult()

							--UseBlinkDagger()
							return 
						end
					end


					if v.name == "npc_dota_hero_templar_assassin" and GetDistance2D(v,me) < 380 and v:GetAbility(2).state==-1 then
						--UseBlinkDagger()
						return
					end
					if v.name == "npc_dota_hero_ursa" and GetDistance2D(v,me) < 385 then
						--UseBlinkDagger()
						return
					end
					if v.name == "npc_dota_hero_meepo" and GetDistance2D(v,me) < 400 then
						--UseBlinkDagger()
						return
					end








				end
			end



			for t = 1, 4 do --skill check start
				if v:GetAbility(t) then
				if v:GetAbility(t).name == "tidehunter_ravage" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1025 then
							Embersleighttargetcal()
							Jugernautfury()
							Nyx()
							Puck()
							TusksnowballTarget()
							UseEulScepterSelf()
							--UseBlinkDagger()
							UseShadowBlade()
							Useshadowamulet()
						
						end
						
					end
				end

				if v:GetAbility(t).name == "luna_eclipse" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 675 then
							NyxVendetta()
							BountyhunterWindwalk()
							WeaverShukuchi()
							PhantomlancerDoppelwalk()
							SandkinSandstorm()
							UseShadowBlade()
							TusksnowballTarget()
							SlarkShadowDance()
							TemplarMeld()
							Useshadowamulet()

						end
					end
					
				end


				if v:GetAbility(t).name == "venomancer_poison_nova" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1025 then
							Jugernautfury()
							Puck()
							--UseBlinkDagger()
							
						end
					end
					
				end
				if v:GetAbility(t).name == "sven_storm_bolt" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 680 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()
								UseBlinkDaggerfront()

								--
	 							--SlarkDarkPact()

	 							TemplarMeld()
								Jugernautfury()
								Nyx()
								LoneDruidUlt()
								--UseManta()
								AlchemistRage()

									--if (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, v))) - 4.80, 0)) == 0 then
								Embersleighttargetcal()
									--end

								UseEulScepterSelf()
								UseShadowBlade()
								Useshadowamulet()
								UseManta()


							end
						end
					end
				end


				if v:GetAbility(t).name == "phantom_assassin_phantom_strike" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1100 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								UseEulScepterTarget()
								UseShadowBlade()
								UseEtherealtarget()
								--UseBlinkDagger()
							end
						end
					end
				end

				if v:GetAbility(t).name == "pugna_nether_blast" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 750 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
							if turntime == 0 then
								Nyx()	
							end
						end
					end
				end



				if v:GetAbility(t).name == "dazzle_poison_touch" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 650 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								UseBlinkDaggerfront()

								--UseShadowBlade()
								----UseBlinkDagger()
							end
						end
					end
				end






				if v:GetAbility(t).name == "sniper_assassinate" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 4000 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()

								UseBlinkDaggerfront()
								TemplarRefraction()
								AlchemistRage()
								Jugernautfury()
								Nyx()
								UseEulScepterSelf()
								LoneDruidUlt()
								SlarkPounce()
								--UseShadowBlade()
								UseManta()
								local sniperultdamage = 0
								if v:GetAbility(4).level == 1 then
									sniperultdamage = 350*3/4
								end
								if v:GetAbility(4).level == 2 then
									sniperultdamage = 505*3/4
								end
								if v:GetAbility(4).level == 3 then
									sniperultdamage = 655*3/4
								end
								if sniperultdamage > me.health then --deadly attack
									if GetDistance2D(v,me) > 1000 then
										ShadowdemonDisruptionself()
										ObsidianImprisonmentself()
									end

									Phoenixsupernova()
									UseBloodStone()--suiside
								end

							end
						end
					end
				end

				if v:GetAbility(t).name == "skeleton_king_hellfire_blast" then 
						--print(math.ceil(v:GetAbility(t).cd))
						--print(math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)))


					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 600 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								SlarkDarkPact()
								Puck()
								UseBlinkDaggerfront()
								AlchemistRage()
								Jugernautfury()
								Embersleighttargetcal()
								Nyx()
								LoneDruidUlt()
								UseEulScepterSelf()
								UseShadowBlade()
								Useshadowamulet()
								UseManta()

							end
						end
					end
				end

				if v:GetAbility(t).name == "medusa_mystic_snake" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 800 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
							UseShadowBlade()


							end
						end
					end
				end






--[[
				if v:GetAbility(t).name == "pudge_meat_hook" then
					--if math.ceil(v:GetAbility(t).cd - 0.7) <=  math.ceil(v:GetAbility(t).cooldown) - 1 and math.ceil(v:GetAbility(t).cd - 0.7) >=  math.ceil(v:GetAbility(t).cooldown) - 2  then
					if math.ceil(v:GetAbility(t).cd) <=  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) and math.ceil(v:GetAbility(t).cd) >=  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level))-2 then

						if GetDistance2D(v,me) < 1300 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
							if turntime == 0 then

								Nyx()
								Jugernautfury()
								Puck()
								UseBlinkDagger()
								if GetDistance2D(v,me)<300 then
								--Embersleighttargetcal()
								return
								end

								if sleep1 == 0 then
									sleepTick = GetTick() + (GetDistance2D(v,me)-300)*12/20 - (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, target))) - 0.1, 0)/(0.6*(1/0.03)))*900
									sleep1=1
									return
								end
								--sleep1 = 1
								--sleep1 = 0
								
								--Embersleighttargetcal()

								--sleep1 = 0
							end
						end
					end
					sleep1 = 0
				end

]]
				if v:GetAbility(t).name == "rattletrap_hookshot" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 3000 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Nyx()

								Jugernautfury()
								Puck()
								--UseBlinkDagger()
								
								Useshadowamulet()
							end
						end
					end
				end
				if v:GetAbility(t).name == "dragon_knight_breathe_fire" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 620 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then

								Nyx()
								Puck()
								Jugernautfury()
								--UseBlinkDagger()
								

							end
						end
					end
				end

				if v:GetAbility(t).name == "huskar_life_break" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 580 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Puck()
								Nyx()
								SlarkShadowDance()
								--Jugernautomnitarget()
								Jugernautfury()
								Lifestealerrage()
								Embersleighttargetcal()
								UseEulScepterSelf()
								--UseBlinkDagger()
								UseShadowBlade()
								Useshadowamulet()
								Useblackking()

							end
						end
					end
				end

				if v:GetAbility(t).name == "chaos_knight_chaos_bolt" then --error
					--print("dd")
--					if math.ceil(v:GetAbility(t).cd-0.7) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)-0.1) then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.7) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then

						--print("@#232323")
--						print(v:GetAbility(t):GetCooldown(v:GetAbility(t).level))
--						print(v:GetAbility(t).cd)

						if GetDistance2D(v,me) < 580 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()
								LoneDruidUlt()
								UseBlinkDaggerfront()

								AlchemistRage()
								Nyx()


								SlarkDarkPact()
								
								Embersleighttargetcal()
								--Jugernautfury()
								UseEulScepterSelf()
								UseShadowBlade()
								Useshadowamulet()
								UseManta()


							end
						end
					end
				end


				if v:GetAbility(t).name == "shredder_timber_chain" then
--					print(v:GetAbility(t).cd)
--					print(v:GetAbility(t):GetCooldown(v:GetAbility(t).level))
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd-0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)-0.1) then
						print("232")
						if GetDistance2D(v,me) < 1400 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								

								Nyx()
								Jugernautfury()
								Puck()
							end
						end
					end
				end
--[[
				if v:GetAbility(t).name == "shredder_chakram" then

					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1100 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.70, 0))
							if turntime == 0 then
								

								Nyx()
								--Jugernautfury()
								--Puck()
							end
						end
					end
				end
]]




				if v:GetAbility(t).name == "magnataur_shockwave" then
					--local spell = v:GetAbility(t)

					--if math.ceil(v:GetAbility(t).cd - 0.8) ==  math.ceil(spell:GetCooldown(v:GetAbility(t).level)) then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.8) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then

						if GetDistance2D(v,me) < 600 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
							if turntime == 0 then
								Nyx()
								Puck()
							end
						end
					end
				end
--[[
				if v:GetAbility(t).name == "magnataur_skewer" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.8) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 900 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.80, 0))
							if turntime == 0 then
								Nyx()
								Puck()
							end
						end
					end
				end
]]

				if v:GetAbility(t).name == "phantom_lancer_spirit_lance" then --error
					--print("33")
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 820 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
								--UseShadowBlade()

							end
						end
					end
				end


				if v:GetAbility(t).name == "slark_pounce" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 600 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
								UseShadowBlade()
							end
						end
					end
				end




				if v:GetAbility(t).name == "vengefulspirit_magic_missile" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 550 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
								LoneDruidUlt()
								UseBlinkDaggerfront()
								AlchemistRage()
								UseManta()
							end
						end
					end
				end

				if v:GetAbility(t).name == "bounty_hunter_shuriken_toss" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 750 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
								LoneDruidUlt()
								SlarkPounce()
								Embersleighttargetcal()
								UseBlinkDaggerfront()
								AlchemistRage()
								UseShadowBlade()
								UseManta()

							end
						end
					end
				end

				if v:GetAbility(t).name == "viper_viper_strike" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 910 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()
								--Nyx()
								UseBlinkDaggerfront()
								SlarkPounce()
								LoneDruidUlt()
								Embersleighttargetcal()
								UseManta()

							end
						end
					end
				end

				if v:GetAbility(t).name == "naga_siren_ensnare" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 670 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								--Nyx()
								UseBlinkDaggerfront()
								Puck()
								SlarkDarkPact()
								Embersleighttargetcal()
								if v:GetAbility(t).level >= 2 then
								LoneDruidUlt()
								end

							end
						end
					end
				end

				if v:GetAbility(t).name == "witch_doctor_paralyzing_cask" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 720 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								--Nyx()
								Puck()
								Embersleighttargetcal()
								if v:GetAbility(t).level >= 2 then
								LoneDruidUlt()
								end
								UseShadowBlade()	
							end
						end
					end
				end



				if v:GetAbility(t).name == "spectre_spectral_dagger" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1000 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()
								Nyx()
							end
						end
					end
				end

				if v:GetAbility(t).name == "lich_chain_frost" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 900 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
								UseShadowBlade()
								SlarkShadowDance()

							end
						end
					end
				end

				if v:GetAbility(t).name == "juggernaut_omni_slash" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 900 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()
								TemplarMeld()
								PhantomlancerDoppelwalk()
								NyxVendetta()
								WeaverShukuchi()
								BountyhunterWindwalk()
								UseGhostScepter()
								UseShadowBlade()
								UseEulScepterSelf()
								SlarkShadowDance()

								UseShadowBlade()

							end
						end
					end
				end




				if v:GetAbility(t).name == "death_prophet_carrion_swarm" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1100 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
								Embersleighttargetcal()
							end
						end
					end
				end








				if v:GetAbility(t).name == "invoker_deafening_blast" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1100 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
								UseShadowBlade()

							end
						end
					end
				end


				if v:GetAbility(t).name == "skywrath_mage_concussive_shot" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1600 then
							Puck()
						end
					end
				end


				if v:GetAbility(t).name == "skywrath_mage_mystic_flare" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 1250 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()
								UseEulScepterSelf()
								UseManta()
							end
						end
					end
				end





				if v:GetAbility(t).name == "puck_illusory_orb" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 750 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								Puck()
								Nyx()
							end
						end
					end
				end





				if v:GetAbility(t).name == "tinker_heat_seeking_missile" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 2500 then

							Nyx()
							Puck()
							TemplarMeld()
							Embersleighttargetcal()
							LoneDruidUlt()
							UseBlinkDaggerfront()
							UseShadowBlade()
							Embersleighttargetcal()
						end
					end
				end



--[[
				if v:GetAbility(t).name == "windrunner_powershot" then
					if math.ceil(v:GetAbility(t).cd - 0.7) <=  math.ceil(v:GetAbility(t).cooldown) - 2 and math.ceil(v:GetAbility(t).cd - 0.7) >=  math.ceil(v:GetAbility(t).cooldown) - 3  then
						if GetDistance2D(v,me) < 2000 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								
								Nyx()
								Puck()
							end
						end
					end
				end
]]











--[[
				if v:GetAbility(t).name == "alchemist_unstable_concoction" then
					if math.ceil(v:GetAbility(t).cd - 0.7) <=  math.ceil(v:GetAbility(t).cooldown) - 1 and math.ceil(v:GetAbility(t).cd - 0.7) >=  math.ceil(v:GetAbility(t).cooldown) - 6  then
						if GetDistance2D(v,me) < 815 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.30, 0))
							if turntime == 0 then
								
								Puck()
								Nyx()
								Embersleighttargetcal()
								UseBlinkDagger()
								Jugernautfury()
								UseEulScepterSelf()
								UseShadowBlade()
								Useshadowamulet()

							end
						end
					end

				end
]]




				if v:GetAbility(t).name == "queenofpain_shadow_strike" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 400 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								UseBlinkDaggerfront()
								Puck()
								Embersleighttargetcal()
								--UseShadowBlade()

							end
						end
					end
				end

				if v:GetAbility(t).name == "queenofpain_sonic_wave" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 800 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.40, 0))
							if turntime == 0 then
								Nyx()
								--UseBlinkDagger()
								Jugernautfury()
								Embersleighttargetcal()
								Puck()
							end
						end
					end
				end




				if v:GetAbility(t).name == "disruptor_glimpse" then
					if v:GetAbility(t).level == 0 then
					return
					elseif math.ceil(v:GetAbility(t).cd - 0.1) ==  math.ceil(v:GetAbility(t):GetCooldown(v:GetAbility(t).level)) then
						if GetDistance2D(v,me) < 2000 then
							turntime = (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0))
							if turntime == 0 then
								UseEulScepterSelf()
								UseShadowBlade()
								Useshadowamulet()
							end
						end
					end
				end

end

--[[
				if v:GetAbility(t).name == "faceless_void_time_walk" then
					if math.ceil(v:GetAbility(t).cd - 0.7) <=  math.ceil(v:GetAbility(t).cooldown) - 1 and math.ceil(v:GetAbility(t).cd - 0.7) >=  math.ceil(v:GetAbility(t).cooldown) - 2  then
						if GetDistance2D(v,me) < 1050 then
							for t = 1, 4 do
								if v:GetAbility(t).name == "faceless_void_chronosphere" and v:GetAbility(t).state == STATE_READY then
									

									UseSheepStickTarget()
									UseEulScepterTarget()
									UseOrchidtarget()
									UseHalberdtarget()
									Puck()
									--UseBlinkDagger()
									
								end
							end
						end
					end
				end
]]








			end


















        	end
        end



actived =0

end
















function Key(msg,code)

	if client.chat or start == nil then 
		return
	end
	
	for i,v in ipairs(herotab) do
		if IsMouseOnButton(xx-2+i*27,yy,16,16) then
			if msg == LBUTTON_DOWN and hero[v.handle] == nil then
				hero[v.handle] = v.name
			elseif msg == LBUTTON_DOWN and hero[v.handle] ~= nil then
				hero[v.handle] = nil
			end
		end
	end	

end

function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx > x and mx <= x + w and my > y and my <= y + h
end

function GetSpecial(spell,name,lvl)
	local specials = spell.specials
	for _,v in ipairs(specials) do
		if v.name == name then
			return v:GetData(lvl)
		else
			return 0
		end
	end
end

function Clear()
	icon = {}
	collectgarbage("collect")
end

function GameClose()
	Clear()
	start = nil
	herotab = {} hero = {} ls = {} ult = {}
	collectgarbage("collect")
	script:Reload()
end








function SmartSleep(ms,target)
		local me = entityList:GetMyHero()	

        if type(ms) == "string" then



                LatSleep(tonumber(ms)+(GetDistance2D(me,target)/9),lat)


        elseif type(ms) == "number" then
                LatSleep(ms,lat)
        end
        
end

function MySpell(tab)
		local me = entityList:GetMyHero()	
        for i,v in ipairs(tab) do
                for _,spell in ipairs(me.abilities) do
                        if spell and spell.name == v then
                                return spell
                        end
                end
        end
        return nil
end

function MySpell2(tab)
		local me = entityList:GetMyHero()	
        --for i,v in ipairs(tab) do
                for _,spell in ipairs(me.abilities) do
                        if spell and spell.name == v then
                                return spell
                        end
                end
        --end
        return nil
end



function MyItem(tab)
        for i,v in ipairs(tab) do
                for _,item in ipairs(me.items) do
                        if item and item.name == v then
                                return item
                        end
                end
        end
        return nil
end
--SmartCast(SpellA,AnimationList[v.name].ability,AnimationList[v.name].vector,v)
function SmartCast(spell,tab1,tab2,target)
		local me = entityList:GetMyHero()	
        for i,v in ipairs(tab2) do              
                for a, ability in ipairs(tab1) do
                        if ability == spell.name then
                                vector = tab2[a]
                                if vector == "aoe" then
                                        me:CastAbility(spell,target.position)
                                elseif vector == "me" then
                                        me:CastAbility(spell,me.position)
                                elseif vector == "target" then
                                        me:CastAbility(spell)
                                elseif vector == "non" then
                                        me:CastAbility(spell)
                                elseif vector == "specialE" then
                                        EmberSpecialCast(spell,target)
                                end
                        end
                end
        end
end

function EmberSpecialCast(spell,target)
			local me = entityList:GetMyHero()	

        bonusRange = {250,350,450,550}
        if GetDistance2D(me,target) < 750 + bonusRange[spell.level] and GetDistance2D(me,target) > 750 then
                LongCast(spell,me,target,bonusRange[spell.level])
        elseif GetDistance2D(me,target) < 750 then
                me:CastAbility(spell,target.position)
        end
end


function LongCast(spell,my,target,range)
        me:CastAbility(spell,Vector((my.position.x - target.position.x) * range / GetDistance2D(target,my) + target.position.x,(my.position.y - target.position.y) * range / GetDistance2D(target,my) + target.position.y,target.position.z))
end

function FrontCast(spell,my,target)
        me:CastAbility(spell,Vector(my.position.x + moverange * math.cos(alfa), my.position.y + moverange * math.sin(alfa),my.position.z))
end

function ToFace(my,t_)
        if ((FindAngle(my,t_)) % (2 * math.pi)) * 180 / math.pi >= 350 or ((FindAngle(my,t_)) % (2 * math.pi)) * 180 / math.pi <= 10 then
                return true
        end
        return false
end

function FindAngle(my,t_)
        return ((math.atan2(my.position.y-t_.position.y,my.position.x-t_.position.x) - t_.rotR + math.pi) % (2 * math.pi)) - math.pi
end
--[[
function GetDistance2D(a,b)
    --smartAssert(GetType(a) == "LuaEntity" or GetType(a) == "Vector" or GetType(a) == "Vector2D" or GetType(a) == "Projectile", "GetDistance2D: Invalid First Parameter:"..GetType(a))
    --smartAssert(GetType(b) == "LuaEntity" or GetType(b) == "Vector" or GetType(b) == "Vector2D" or GetType(a) == "Projectile" or GetType(b) == "nil", "GetDistance2D: Invalid Second Parameter:"..GetType(b))
    if not b then b = entityList:GetMyHero() end
    if a.x == nil or a.y == nil then
        return GetDistance2D(a.position,b)
    elseif b.x == nil or b.y == nil then
        return GetDistance2D(a,b.position)
    else
        return math.sqrt(math.pow(a.x-b.x,2)+math.pow(a.y-b.y,2))
    end
end
]]


function GetType(obj)
    if obj and (type(obj) == "userdata" or type(obj) == "table")then
        if type(obj.IsZero) == "function" then
            if type(obj.z) == "number" then
                return "Vector"
            else
                return "Vector2D"
            end
        elseif type(obj.SetPosition) == "function" then
            if type(obj.SetParameter) == "function" then
                return "LuaEffect"
            else
                return "DrawObject"
            end
        elseif type(obj.handle) == "number" or type(obj.selection) == "table" then
            return "LuaEntity"
        elseif type(obj.Unload) == "function" then
            return "script"
        elseif type(obj.IsLoaded) == "function" then
            return "scriptEngine"
        elseif type(obj.DrawText) == "function" then
            return "drawManager"
        elseif type(obj.FindEntities) == "function" then
            return "entityList"
        elseif type(obj.tall) == "number" then
            return "Font"
        elseif type(obj.dieTime) == "number" then
            return "Modifier"
        elseif type(obj.dataCount) == "number" then
            return "AbilitySpecial"
        elseif type(obj.speed) == "number" then
            return "Projectile"
        elseif type(obj.GetType) == "function" then
            return obj:GetType()
        else
            return type(obj)
        end
    else
        return type(obj)
    end
end

function smartAssert(bool,string)
    if not bool then
        --print(debug.traceback())
        assert(bool,string)
    end
end


function FindAngleR(entity)
	if entity.rotR < 0 then
		return math.abs(entity.rotR)
	else
		return 2 * math.pi - entity.rotR
	end
end

function FindAngle(my,t_)
        return ((math.atan2(my.position.y-t_.position.y,my.position.x-t_.position.x) - t_.rotR + math.pi) % (2 * math.pi)) - math.pi
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











--Use Skill funct ions
function Lifestealerrage()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "life_stealer_rage" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

function LoneDruidUlt()
	if actived == 0 then

		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "lone_druid_true_form" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
				if me:GetAbility(t).name == "lone_druid_true_form_druid" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end


			end
		end


	end
end
--[[

function BrewmasterUlt()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "brewmaster_primal_split" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

]]

function Jugernautfury()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "juggernaut_blade_fury" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end
function Phoenixsupernova()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "phoenix_supernova" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

function TemplarMeld()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "templar_assassin_meld" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					--QueueNextAction()
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

function TemplarRefraction()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "templar_assassin_refraction" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					--QueueNextAction()
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end



function NyxVendetta()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "nyx_assassin_vendetta" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end
function WeaverShukuchi()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "weaver_shukuchi" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end
function SandkinSandstorm()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "sandking_sand_storm" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end



function ClinkzWindwalk()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "clinkz_wind_walk" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end


function PhantomlancerDoppelwalk()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "phantom_lancer_doppelwalk" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end


function BountyhunterWindwalk()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "bounty_hunter_wind_walk" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end





function AlchemistRage()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "alchemist_chemical_rage" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

function NagaMirror()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "naga_siren_mirror_image" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end





function TusksnowballTarget()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "tusk_snowball" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 1250 then
						tusk_snowball=me:GetAbility(t)
						me:CastAbility(tusk_snowball,target)
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end


function Jugernautomnitarget()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "juggernaut_omni_slash" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 450 then
						juggernaut_omni_slash=me:GetAbility(t)
						me:CastAbility(juggernaut_omni_slash,target)
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function Doom()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "doom_bringer_doom" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 560 then
						doom_bringer_doom=me:GetAbility(t)
						me:CastAbility(doom_bringer_doom,target)
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end




function Emberchains()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "ember_spirit_searing_chains" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 400 then

					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
			end
		end
	end
end


function Embersleighttarget()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "ember_spirit_sleight_of_fist" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 710 then
						ember_spirit_sleight_of_fist=me:GetAbility(t)
						me:CastAbility(ember_spirit_sleight_of_fist,target.x,target.y,target.z)
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function Embersleighttargetcal()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "ember_spirit_sleight_of_fist" and me:GetAbility(t).state == -1 then
				local addrange =0
				if me:GetAbility(t).level == 1 then
					addrange = 250
				elseif me:GetAbility(t).level == 2 then
					addrange = 350
				elseif me:GetAbility(t).level == 3 then
					addrange = 450
				elseif me:GetAbility(t).level == 4 then
					addrange = 550
				end
					if target and GetDistance2D(me,target) < 750 + addrange then

						ember_spirit_sleight_of_fist=me:GetAbility(t)
						local p = Vector((me.x - target.x) * addrange / GetDistance2D(target,me) + target.x,(me.y - target.y) * addrange / GetDistance2D(target,me) + target.y,target.z)
						local close = math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, target))))
						local far = math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, p))))
						if GetDistance2D(me,target) < 720 and close < far then
							me:CastAbility(ember_spirit_sleight_of_fist,target.x,target.y,target.z)
						else
							me:CastAbility(ember_spirit_sleight_of_fist,p)
						end
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end






function EmberGuard()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "ember_spirit_flame_guard" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end



function Emberremnantnow()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "ember_spirit_activate_fire_remnant" and me:GetAbility(t).state == -1 then
						alfa = me.rotR
						local p = Vector(me.x + 100 * math.cos(alfa), me.y + 100 * math.sin(alfa), me.z) 

						ember_spirit_fire_remnant=me:GetAbility(5)
						me:CastAbility(ember_spirit_fire_remnant,p)
						actived=1
						remnant = 1
						sleepTick= GetTick() +160
						return
				end
			end
		end
	end
end


function StormUltfront()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "storm_spirit_ball_lightning" and me:GetAbility(t).state == -1 then
						alfa = me.rotR
						local p = Vector(me.x + 100 * math.cos(alfa), me.y + 100 * math.sin(alfa), me.z) 
						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,p)
						actived=1
						sleepTick= GetTick() +600
						return
				end
			end
		end
	end
end
function StormUltfront2(moverange)
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "storm_spirit_ball_lightning" and me:GetAbility(t).state == -1 then
						alfa = me.rotR
						local p = Vector(me.x + moverange * math.cos(alfa), me.y + moverange * math.sin(alfa), me.z) 
						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,p)
						actived=1
						sleepTick= GetTick() +600
						return
				end
			end
		end
	end
end

function Antiblinkfront()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "antimage_blink" and me:GetAbility(t).state == -1 then
						alfa = me.rotR
						local p = Vector(me.x + 100 * math.cos(alfa), me.y + 100 * math.sin(alfa), me.z) 
						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,p)
						actived=1
						sleepTick= GetTick() +500
						return
				end
			end
		end
	end
end

function Antiblinkhome()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "antimage_blink" and me:GetAbility(t).state == -1 then

					local fountPos = entityList:FindEntities({team = me.team, classId = CDOTA_Unit_Fountain})[1].position
					local vector = ((fountPos - me.position) * 1150 / me:GetDistance2D(fountPos) ) + me.position


						storm_spirit_ball_lightning=me:GetAbility(t)
						me:CastAbility(storm_spirit_ball_lightning,vector)
						actived=1
						sleepTick= GetTick() +500
						return
				end
			end
		end
	end
end





function AbaddonShieldtarget()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "abaddon_aphotic_shield" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 510 then
						abaddon_aphotic_shield=me:GetAbility(t)
						me:CastAbility(abaddon_aphotic_shield,target)
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end

function LegionPresstarget()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "legion_commander_press_the_attack" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 810 then
						legion_commander_press_the_attack=me:GetAbility(t)
						me:CastAbility(legion_commander_press_the_attack,target)
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end










function Axe()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t) and me:GetAbility(t).name == "axe_berserkers_call" and me:GetAbility(t).state == -1 then
					me:CastAbility(me:GetAbility(t))
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end



function Puck()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t) and me:GetAbility(t).name == "puck_phase_shift" and me:GetAbility(t).state == -1 then
					--UseAbility(t)
					me:CastAbility(me:GetAbility(t))
					print("@$@$@$")
					--QueueNextAction()
					--UseBlinkDagger()
					--QueueNextAction()
					actived=1
					sleepTick= GetTick() +500
					return 
				end
			end
		end
	end
end

function Slardar()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slardar_slithereen_crush" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end


function SlarkDarkPact()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slark_dark_pact" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function SlarkPounce()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slark_pounce" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end
function SlarkShadowDance()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "slark_shadow_dance" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end


function ObsidianImprisonmentself()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "obsidian_destroyer_astral_imprisonment" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function ShadowdemonDisruptionself()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "shadow_demon_disruption" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function OmniknightRepelself()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "omniknight_repel" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t),me)
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end


function Abaddonult()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "abaddon_borrowed_time" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

--[[
function Nyx()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "nyx_assassin_spiked_carapace" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end
]]


function SilencerLastWord()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) ~= nil then
				if me:GetAbility(t).name == "silencer_last_word" and me:GetAbility(t).state == -1 then
					if target and GetDistance2D(me,target) < 920 then
						silencer_last_word=me:GetAbility(t)
						me:CastAbility(silencer_last_word,target)
						actived=1
						sleepTick= GetTick() +500
						return
					end
				end
			end
		end
	end
end


function Silencerult()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "silencer_global_silence" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function Nyx()
	if actived == 0 then
		for t=1,6 do
			if me:GetAbility(t) and me:GetAbility(t).name == "nyx_assassin_spiked_carapace" and me:GetAbility(t).state == -1 then
				me:CastAbility(me:GetAbility(t))
				actived=1
				sleepTick= GetTick() +500
				return 
			end
		end
	end
end

function Useblackking()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_black_king_bar" then
			item_black_king_bar = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_black_king_bar and item_black_king_bar.state== -1 then
			me:CastAbility(item_black_king_bar)
			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end


--useitem--------------------------------------------------------------------------------------------------------------------------------------
function UseBlinkDagger() --use blink to home
	if actived == 0 then

		for t = 1, 6 do
			if me:HasItem(t) and me:GetItem(t).name == "item_blink" then
				BlinkDagger = me:GetItem(t)
			end
		end


		--print("1")
		local fountPos = entityList:FindEntities({team = me.team, classId = CDOTA_Unit_Fountain})[1].position
		--print("2")
		local vector = ((fountPos - me.position) * 1190 / me:GetDistance2D(fountPos) ) + me.position
		--print("3")
		me:CastAbility(BlinkDagger,vector)
		--print("4")
		actived=1
		sleepTick= GetTick() +500
	end

end

function UseBlinkDaggerfront()--use blink to front of hero distance 100 
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_blink" then
			BlinkDagger = me:GetItem(t)
		end
	end
	if BlinkDagger then
		if actived == 0 then
			if BlinkDagger.state==-1 then
				alfa = me.rotR
				local p = Vector(me.position.x + 100 * math.cos(alfa), me.position.y + 100 * math.sin(alfa), me.position.z) 

				me:CastAbility(BlinkDagger,p)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end



function UseBlinkDaggertarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_blink" then
			item_blink = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_blink and item_blink.state==-1 then
			if target and GetDistance2D(me,target) < 1150 then

				me:CastAbility(item_blink,target.x,target.y,target.z)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end




function UseGhostScepter()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_ghost" then
			GhostScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if GhostScepter and GhostScepter.state==-1 then
			--UseAbility(GhostScepter)
			me:CastAbility(GhostScepter)

			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseEulScepterSelf()--self
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_cyclone" then
			UseEulScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if UseEulScepter and UseEulScepter and UseEulScepter.state==-1 then
			me:CastAbility(UseEulScepter,me)
			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseEulScepterTarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_cyclone" then
			UseEulScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if UseEulScepter and UseEulScepter.state==-1 then
			if target and GetDistance2D(me,target) < 700 then

				me:CastAbility(UseEulScepter,target)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end




function UseBladeMail()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_blade_mail" then
			item_blade_mail = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_blade_mail and item_blade_mail.state==-1 then
			me:CastAbility(item_blade_mail)
			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseBloodStone()--suiside
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_bloodstone" then
			item_bloodstone = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_bloodstone and item_bloodstone.state==-1 then
			--UseAbility(item_bloodstone)
			me:CastAbility(item_bloodstone)

			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseSheepStickTarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_sheepstick" then
			UseEulScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if UseEulScepter and UseEulScepter.state==-1 then
			if target and GetDistance2D(me,target) < 800 then

				me:CastAbility(UseEulScepter,target)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function UseOrchidtarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_orchid" then
			UseEulScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_orchid and item_orchid.state==-1 then
			if target and GetDistance2D(me,target) < 900 then

				me:CastAbility(item_orchid,target)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function UseAbyssaltarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_abyssal_blade" then
			UseEulScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_abyssal_blade and item_abyssal_blade.state==-1 then
			if target and GetDistance2D(me,target) < 140 then

				me:CastAbility(item_abyssal_blade,target)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end
function UseHalberdtarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_heavens_halberd" then
			UseEulScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_heavens_halberd and item_heavens_halberd.state==-1 then
			if target and GetDistance2D(me,target) < 600 then

				me:CastAbility(item_heavens_halberd,target)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end
function UseEtherealtarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_ethereal_blade" then
			UseEulScepter = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_ethereal_blade and item_ethereal_blade.state==-1 then
			if target and GetDistance2D(me,target) < 800 then

				me:CastAbility(item_ethereal_blade,target)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end

function Useblackking()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_black_king_bar" then
			item_black_king_bar = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_black_king_bar and item_black_king_bar.state==-1 then
			--UseAbility(item_black_king_bar)
			me:CastAbility(item_black_king_bar)
			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function UseManta()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_manta" then
			item_manta = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_manta and item_manta.state==-1 then
			--UseAbility(item_manta)
			me:CastAbility(item_manta)
			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end
function UseShadowBlade()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_invis_sword" then
			item_invis_sword = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_invis_sword and item_invis_sword.state==-1 then
			me:CastAbility(item_invis_sword)
			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end




function Useshadowamulet()
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_shadow_amulet" then
			item_shadow_amulet = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_shadow_amulet and item_shadow_amulet.state==-1 then
			me:CastAbility(item_shadow_amulet,me)
			actived=1
			sleepTick= GetTick() +500
			return
		end
	end
end

function Useshadowamulettarget()--target
	for t = 1, 6 do
		if me:HasItem(t) and me:GetItem(t).name == "item_shadow_amulet" then
			item_shadow_amulet = me:GetItem(t)
		end
	end
	if actived == 0 then
		if item_shadow_amulet and item_shadow_amulet.state==-1 then
			if target and GetDistance2D(me,target) < 600 then

				me:CastAbility(item_shadow_amulet,target)
				actived=1
				sleepTick= GetTick() +500
				return
			end
		end
	end
end


--useitemend

--[[


npc_dota_hero_abaddon
npc_dota_hero_alchemist
npc_dota_hero_ancient_apparition
npc_dota_hero_antimage
npc_dota_hero_axe
npc_dota_hero_bane
npc_dota_hero_batrider
npc_dota_hero_beastmaster
npc_dota_hero_bloodseeker
npc_dota_hero_bounty_hunter
npc_dota_hero_brewmaster
npc_dota_hero_bristleback
npc_dota_hero_broodmother
npc_dota_hero_centaur
npc_dota_hero_chaos_knight
npc_dota_hero_chen
npc_dota_hero_clinkz
npc_dota_hero_crystal_maiden
npc_dota_hero_dark_seer
npc_dota_hero_dazzle
npc_dota_hero_death_prophet
npc_dota_hero_disruptor
npc_dota_hero_doom_bringer
npc_dota_hero_dragon_knight
npc_dota_hero_drow_ranger
npc_dota_hero_earth_spirit
npc_dota_hero_earthshaker
npc_dota_hero_elder_titan
npc_dota_hero_ember_spirit
npc_dota_hero_enchantress
npc_dota_hero_enigma
npc_dota_hero_faceless_void
npc_dota_hero_furion
npc_dota_hero_gyrocopter
npc_dota_hero_huskar
npc_dota_hero_invoker
npc_dota_hero_jakiro
npc_dota_hero_juggernaut
npc_dota_hero_keeper_of_the_light
npc_dota_hero_kunkka
npc_dota_hero_legion_commander
npc_dota_hero_leshrac
npc_dota_hero_lich
npc_dota_hero_life_stealer
npc_dota_hero_lina
npc_dota_hero_lion
npc_dota_hero_lone_druid
npc_dota_hero_luna
npc_dota_hero_lycan
npc_dota_hero_magnataur
npc_dota_hero_medusa
npc_dota_hero_meepo
npc_dota_hero_mirana
npc_dota_hero_morphling
npc_dota_hero_naga_siren
npc_dota_hero_necrolyte
npc_dota_hero_nevermore
npc_dota_hero_night_stalker
npc_dota_hero_nyx_assassin
npc_dota_hero_obsidian_destroyer
npc_dota_hero_ogre_magi
npc_dota_hero_omniknight
npc_dota_hero_phantom_assassin
npc_dota_hero_phantom_lancer
npc_dota_hero_puck
npc_dota_hero_pudge
npc_dota_hero_pugna
npc_dota_hero_queenofpain
npc_dota_hero_rattletrap
npc_dota_hero_razor
npc_dota_hero_riki
npc_dota_hero_rubick
npc_dota_hero_sand_king
npc_dota_hero_shadow_demon
npc_dota_hero_shadow_shaman
npc_dota_hero_shredder
npc_dota_hero_silencer
npc_dota_hero_skeleton_king
npc_dota_hero_skywrath_mage
npc_dota_hero_slardar
npc_dota_hero_slark
npc_dota_hero_sniper
npc_dota_hero_spectre
npc_dota_hero_spirit_breaker
npc_dota_hero_storm_spirit
npc_dota_hero_sven
npc_dota_hero_templar_assassin
npc_dota_hero_tidehunter
npc_dota_hero_tinker
npc_dota_hero_tiny
npc_dota_hero_treant
npc_dota_hero_troll_warlord
npc_dota_hero_tusk
npc_dota_hero_undying
npc_dota_hero_ursa
npc_dota_hero_vengefulspirit
npc_dota_hero_venomancer
npc_dota_hero_viper
npc_dota_hero_visage
npc_dota_hero_warlock
npc_dota_hero_weaver
npc_dota_hero_windrunner
npc_dota_hero_wisp
npc_dota_hero_witch_doctor
npc_dota_hero_zuus




	"antimage_mana_break"
	"antimage_blink"
	"antimage_spell_shield"
	"axe_berserkers_call"
	"axe_battle_hunger"
	"axe_counter_helix"
	"bane_enfeeble"
	"bane_brain_sap"
	"bane_nightmare"
	"bloodseeker_bloodrage"
	"bloodseeker_blood_bath"
	"bloodseeker_thirst"
	"crystal_maiden_crystal_nova"
	"crystal_maiden_frostbite"
	"crystal_maiden_brilliance_aura"
	"drow_ranger_silence"
	"drow_ranger_trueshot"
	"drow_ranger_frost_arrows"
	"earthshaker_fissure"
	"earthshaker_enchant_totem"
	"earthshaker_aftershock"
	"juggernaut_blade_fury"
	"juggernaut_healing_ward"
	"juggernaut_blade_dance"
	"mirana_starfall"
	"mirana_arrow"
	"mirana_leap"
	"nevermore_necromastery"
	"nevermore_dark_lord"
	"nevermore_shadowraze1"
	"nevermore_shadowraze2"
	"nevermore_shadowraze3"
	"morphling_waveform"
	"morphling_adaptive_strike"
	"morphling_morph_agi"
	"morphling_morph_str"
	"morphling_morph_replicate"
	"phantom_lancer_spirit_lance"
	"phantom_lancer_doppelwalk"
	"phantom_lancer_juxtapose"
	"puck_waning_rift"
	"puck_phase_shift"
	"puck_illusory_orb"
	"pudge_meat_hook"
	"pudge_rot"
	"pudge_flesh_heap"
	"razor_plasma_field"
	"razor_static_link"
	"razor_unstable_current"
	"sandking_burrowstrike"
	"sandking_sand_storm"
	"sandking_caustic_finale"
	"storm_spirit_static_remnant"
	"storm_spirit_electric_vortex"
	"storm_spirit_overload"
	"sven_storm_bolt"
	"sven_great_cleave"
	"sven_warcry"
	"tiny_avalanche"
	"tiny_toss"
	"tiny_craggy_exterior"
	"vengefulspirit_magic_missile"
	"vengefulspirit_wave_of_terror"
	"vengefulspirit_command_aura"
	"windrunner_shackleshot"
	"windrunner_powershot"
	"windrunner_windrun"
	"zuus_arc_lightning"
	"zuus_lightning_bolt"
	"zuus_static_field"
	"kunkka_torrent"
	"kunkka_tidebringer"
	"kunkka_x_marks_the_spot"
	"lina_dragon_slave"
	"lina_light_strike_array"
	"lina_fiery_soul"
	"lich_frost_nova"
	"lich_frost_armor"
	"lich_dark_ritual"
	"lion_impale"
	"lion_voodoo"
	"lion_mana_drain"
	"shadow_shaman_ether_shock"
	"shadow_shaman_voodoo"
	"shadow_shaman_shackles"
	"slardar_sprint"
	"slardar_slithereen_crush"
	"slardar_bash"
	"tidehunter_gush"
	"tidehunter_kraken_shell"
	"tidehunter_anchor_smash"
	"witch_doctor_paralyzing_cask"
	"witch_doctor_voodoo_restoration"
	"witch_doctor_maledict"
	"riki_smoke_screen"
	"riki_blink_strike"
	"riki_backstab"
	"enigma_malefice"
	"enigma_demonic_conversion"
	"enigma_midnight_pulse"
	"tinker_laser"
	"tinker_heat_seeking_missile"
	"tinker_march_of_the_machines"
	"sniper_shrapnel"
	"sniper_headshot"
	"sniper_take_aim"
	"necrolyte_death_pulse"
	"necrolyte_sadist"
	"necrolyte_heartstopper_aura"
	"warlock_shadow_word"
	"warlock_upheaval"
	"warlock_fatal_bonds"
	"beastmaster_wild_axes"
	"beastmaster_inner_beast"
	"beastmaster_call_of_the_wild"
	"queenofpain_shadow_strike"
	"queenofpain_blink"
	"queenofpain_scream_of_pain"
	"venomancer_venomous_gale"
	"venomancer_poison_sting"
	"venomancer_plague_ward"
	"faceless_void_time_walk"
	"faceless_void_backtrack"
	"faceless_void_time_lock"
	"skeleton_king_hellfire_blast"
	"skeleton_king_vampiric_aura"
	"skeleton_king_mortal_strike"
	"death_prophet_carrion_swarm"
	"death_prophet_silence"
	"death_prophet_witchcraft"
	"phantom_assassin_stifling_dagger"
	"phantom_assassin_phantom_strike"
	"phantom_assassin_blur"
	"pugna_nether_blast"
	"pugna_decrepify"
	"pugna_nether_ward"
	"templar_assassin_meld"
	"templar_assassin_psi_blades"
	"templar_assassin_refraction"
	"viper_poison_attack"
	"viper_nethertoxin"
	"viper_corrosive_skin"
	"luna_lucent_beam"
	"luna_moon_glaive"
	"luna_lunar_blessing"
	"dragon_knight_breathe_fire"
	"dragon_knight_dragon_tail"
	"dragon_knight_dragon_blood"
	"dazzle_poison_touch"
	"dazzle_shallow_grave"
	"dazzle_shadow_wave"
	"rattletrap_power_cogs"
	"rattletrap_rocket_flare"
	"rattletrap_battery_assault"
	"leshrac_split_earth"
	"leshrac_diabolic_edict"
	"leshrac_lightning_storm"
	"furion_sprout"
	"furion_teleportation"
	"furion_force_of_nature"
	"life_stealer_rage"
	"life_stealer_feast"
	"life_stealer_open_wounds"
	"dark_seer_vacuum"
	"dark_seer_surge"
	"dark_seer_ion_shell"
	"clinkz_strafe"
	"clinkz_wind_walk"
	"clinkz_searing_arrows"
	"weaver_the_swarm"
	"weaver_shukuchi"
	"weaver_geminate_attack"
	"jakiro_dual_breath"
	"jakiro_ice_path"
	"jakiro_liquid_fire"
	"batrider_sticky_napalm"
	"batrider_flamebreak"
	"batrider_firefly"
	"chen_penitence"
	"chen_holy_persuasion"
	"chen_test_of_faith"
	"chen_test_of_faith_teleport"
	"spectre_spectral_dagger"
	"spectre_desolate"
	"spectre_dispersion"
	"doom_bringer_scorched_earth"
	"doom_bringer_lvl_death"
	"doom_bringer_devour"
	"ancient_apparition_cold_feet"
	"ancient_apparition_ice_vortex"
	"ancient_apparition_chilling_touch"
	"ursa_earthshock"
	"ursa_overpower"
	"ursa_fury_swipes"
	"spirit_breaker_charge_of_darkness"
	"spirit_breaker_empowering_haste"
	"spirit_breaker_greater_bash"
	"alchemist_goblins_greed"
	"alchemist_acid_spray"
	"alchemist_unstable_concoction"
	"gyrocopter_rocket_barrage"
	"gyrocopter_homing_missile"
	"gyrocopter_flak_cannon"
	"shadow_demon_disruption"
	"shadow_demon_soul_catcher"
	"shadow_demon_shadow_poison"
	"lone_druid_spirit_bear"
	"lone_druid_rabid"
	"lone_druid_synergy"
	"meepo_earthbind"
	"meepo_poof"
	"meepo_geostrike"
	"naga_siren_mirror_image"
	"naga_siren_ensnare"
	"naga_siren_rip_tide"
	"medusa_split_shot"
	"medusa_mystic_snake"
	"medusa_mana_shield"
	"troll_warlord_fervor"
	"troll_warlord_berserkers_rage"
	"troll_warlord_whirling_axes_ranged"
	"troll_warlord_whirling_axes_melee"
	"centaur_hoof_stomp"
	"centaur_double_edge"
	"centaur_return"
	"magnataur_shockwave"
	"magnataur_empower"
	"magnataur_skewer"
	"skywrath_mage_arcane_bolt"
	"skywrath_mage_concussive_shot"
	"skywrath_mage_ancient_seal"
	"treant_living_armor"
	"treant_leech_seed"
	"treant_natures_guise"
	"tusk_ice_shards"
	"tusk_snowball"
	"tusk_frozen_sigil"
	"disruptor_thunder_strike"
	"disruptor_glimpse"
	"disruptor_kinetic_field"
	"rubick_telekinesis"
	"rubick_fade_bolt"
	"rubick_null_field"
	"brewmaster_thunder_clap"
	"brewmaster_drunken_haze"
	"brewmaster_drunken_brawler"
	"enchantress_untouchable"
	"enchantress_enchant"
	"enchantress_natures_attendants"
	"huskar_inner_vitality"
	"huskar_berserkers_blood"
	"huskar_burning_spear"
	"night_stalker_void"
	"night_stalker_crippling_fear"
	"night_stalker_hunter_in_the_night"
	"broodmother_spin_web"
	"broodmother_incapacitating_bite"
	"broodmother_spawn_spiderlings"
	"omniknight_purification"
	"omniknight_repel"
	"omniknight_degen_aura"
	"bounty_hunter_shuriken_toss"
	"bounty_hunter_jinada"
	"bounty_hunter_wind_walk"
	//"invoker_quas"
	//"invoker_wex"
	//"invoker_exort"
	//"invoker_cold_snap"
	//"invoker_ghost_walk"
	//"invoker_tornado"
	//"invoker_emp"
	//"invoker_alacrity"
	//"invoker_chaos_meteor"
	//"invoker_sun_strike"
	//"invoker_forge_spirit"
	//"invoker_ice_wall"
	//"invoker_deafening_blast"
	"silencer_curse_of_the_silent"
	"silencer_last_word"
	"silencer_glaives_of_wisdom"
	"obsidian_destroyer_astral_imprisonment"
	"obsidian_destroyer_arcane_orb"
	"obsidian_destroyer_essence_aura"
	"lycan_summon_wolves"
	"lycan_howl"
	"lycan_feral_impulse"
	"chaos_knight_chaos_bolt"
	"chaos_knight_reality_rift"
	"chaos_knight_chaos_strike"
	"wisp_tether"
	"wisp_spirits"
	"wisp_overcharge"
	"ogre_magi_fireblast"
	"ogre_magi_ignite"
	"ogre_magi_bloodlust"
	"undying_decay"
	"undying_soul_rip"
	"undying_tombstone"
	"nyx_assassin_impale"
	"nyx_assassin_mana_burn"
	"nyx_assassin_spiked_carapace"
	"keeper_of_the_light_mana_leak"
	"keeper_of_the_light_chakra_magic"
	"keeper_of_the_light_illuminate"
	"visage_grave_chill"
	"visage_soul_assumption"
	"visage_gravekeepers_cloak"
	"slark_dark_pact"
	"slark_pounce"
	"slark_essence_shift"
	"shredder_whirling_death"
	"shredder_timber_chain"
	"shredder_reactive_armor"
	"bristleback_viscous_nasal_goo"
	"bristleback_quill_spray"
	"bristleback_bristleback"
	"elder_titan_natural_order"
	"elder_titan_ancestral_spirit"
	"elder_titan_echo_stomp"
	"abaddon_death_coil"
	"abaddon_aphotic_shield"
	"abaddon_frostmourne"
	"legion_commander_overwhelming_odds"
	"legion_commander_press_the_attack"
	"legion_commander_moment_of_courage"
]
"Ults"
[
	"earthshaker_echo_slam"
	"drow_ranger_marksmanship"
	"crystal_maiden_freezing_field"
	"bloodseeker_rupture"
	"bane_fiends_grip"
	"axe_culling_blade"
	"antimage_mana_void"
	"puck_dream_coil"
	"phantom_lancer_phantom_edge"
	"morphling_replicate"
	"nevermore_requiem"
	"mirana_invis"
	"juggernaut_omni_slash"
	"tiny_grow"
	"sven_gods_strength"
	"storm_spirit_ball_lightning"
	"sandking_epicenter"
	"razor_eye_of_the_storm"
	"pudge_dismember"
	"lina_laguna_blade"
	"windrunner_focusfire"
	"vengefulspirit_nether_swap"
	"zuus_thundergods_wrath"
	"kunkka_ghostship"
	"lion_finger_of_death"
	"lich_chain_frost"
	"shadow_shaman_mass_serpent_ward"
	"slardar_amplify_damage"
	"tidehunter_ravage"
	"riki_permanent_invisibility"
	"witch_doctor_death_ward"
	"enigma_black_hole"
	"tinker_rearm"
	"sniper_assassinate"
	"beastmaster_primal_roar"
	"necrolyte_reapers_scythe"
	"warlock_rain_of_chaos"
	"queenofpain_sonic_wave"
	"venomancer_poison_nova"
	"faceless_void_chronosphere"
	"pugna_life_drain"
	"phantom_assassin_coup_de_grace"
	"death_prophet_exorcism"
	"skeleton_king_reincarnation"
	"templar_assassin_psionic_trap"
	"viper_viper_strike"
	"dazzle_weave"
	"luna_eclipse"
	"dragon_knight_elder_dragon_form"
	"rattletrap_hookshot"
	"leshrac_pulse_nova"
	"furion_wrath_of_nature"
	"weaver_time_lapse"
	"life_stealer_infest"
	"dark_seer_wall_of_replica"
	"clinkz_death_pact"
	"jakiro_macropyre"
	"batrider_flaming_lasso"
	"doom_bringer_doom"
	"chen_hand_of_god"
	"spectre_haunt"
	"ancient_apparition_ice_blast"
	"spirit_breaker_nether_strike"
	"ursa_enrage"
	"shadow_demon_demonic_purge"
	"alchemist_chemical_rage"
	"gyrocopter_call_down"
	"lone_druid_true_form"
	"naga_siren_song_of_the_siren"
	"skywrath_mage_mystic_flare"
	"centaur_stampede"
	"troll_warlord_battle_trance"
	"magnataur_reverse_polarity"
	"medusa_stone_gaze"
	"rubick_spell_steal"
	"treant_overgrowth"
	"disruptor_static_storm"
	"tusk_walrus_punch"
	"brewmaster_primal_split"
	"enchantress_impetus"
	"huskar_life_break"
	"bounty_hunter_track"
	"night_stalker_darkness"
	"broodmother_insatiable_hunger"
	"omniknight_guardian_angel"
	"silencer_global_silence"
	//"invoker_invoke"
	"wisp_relocate"
	"obsidian_destroyer_sanity_eclipse"
	"ogre_magi_multicast"
	"lycan_shapeshift"
	"undying_flesh_golem"
	"chaos_knight_phantasm"
	"keeper_of_the_light_spirit_form"
	"nyx_assassin_vendetta"
	"visage_summon_familiars"
	"shredder_chakram"
	"slark_shadow_dance"
	"elder_titan_earth_splitter"
	"bristleback_warpath"
	"legion_commander_duel"
	"abaddon_borrowed_time"



]]





script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
