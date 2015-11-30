function menu_load(x, y)
	gamestate = "menu"
	
	musicvolume = 0
	menumusic:setVolume(musicvolume)
	playsound(menumusic)
	
	pl = nil
	coins = {}
	
	menuoffset = y or 0
	menuoffsett = y or 0
	menuoffsetx = x or 0
	menuoffsetxt = x or 0
	
	pitch = 0
	rotation = pi075
	
	wantedbackground = {0, 0, 0}
	
	coincount = 0
	
	drawcenterX = screenwidth/2
	drawcenterY = 140
	boxwidth = 45
	
	rotcenterX = menurotcenterX
	rotcenterY = menurotcenterY
	rotcenterZ = menurotcenterZ
	
	calculatevars()
	
	creditstext = {	"'Ortho Robot'",
					"An awesome game by",
					"Maurice Guegan",
					"Level design help by        ",
					"Visit Stabyourself.net for more"}
					
	helptext = {	"You're a robot        ",
					"You have to recharge yourself     ",
					"Collect     for bonus points",
					"Drag the view to activate the FSWD   ",
					"If you're not blocked (background green),",
					"you can walk without depth!"}
					
	wintext = { 	"Congratulations!",
					"You have beaten every",
					"level and successfully",
					"recharged yourself!",
					"Try to get a gold star",
					"for every level!"}
	
	if x == nil and y == nil then
		backgroundblocks = {}
		for i = 1, 500 do
			table.insert(backgroundblocks, backgroundblock:new(unpack(newBox(true))))
		end
		
		menubuttons = {}
		table.insert(menubuttons, menubutton:new(screenwidth/2, 300, "Play levels", button_start))
		table.insert(menubuttons, menubutton:new(screenwidth/2, 400, "Help", button_help))
		table.insert(menubuttons, menubutton:new(screenwidth/2, 500, "Credits", button_credits))
		table.insert(menubuttons, menubutton:new(screenwidth/2, 600, "Exit", button_exit))
		table.insert(menubuttons, menubutton:new(screenwidth/2, -45, "Back", button_back))
		table.insert(menubuttons, menubutton:new(screenwidth/2-100, 1100, "Yes", button_yes))
		table.insert(menubuttons, menubutton:new(screenwidth/2+100, 1100, "No", button_no))
		table.insert(menubuttons, menubutton:new(screenwidth/2+screenwidth, 650, "< Okay I get it", button_creditsback))
		table.insert(menubuttons, menubutton:new(-screenwidth/2, 685, "Let's do this >", button_creditsback))
		table.insert(menubuttons, menubutton:new(screenwidth-141, -45, "Next >", button_nextpage))
		table.insert(menubuttons, menubutton:new(198, -45, "< Previous", button_prevpage))
		table.insert(menubuttons, menubutton:new(screenwidth/2+screenwidth, 0, "< Awesome", button_winback))
		
		if scale == 1 then
			sizebutton = pausebutton:new(0, 0, "Help, this game doesn't fit on my screen!", scalebutton)
		else
			sizebutton = pausebutton:new(0, 0, "Nevermind, the game does fit on my screen.", scalebutton)
		end
		
		sizebutton.width = 680
		sizebutton.active = true
	else
		menubuttons[5].active = true
	end
	
	pausebuttons = {}
	if soundenabled then
		pausebuttons["menutogglesound"] = pausebutton:new(109, 0, "Sound ON", menu_togglesound)
	else
		pausebuttons["menutogglesound"] = pausebutton:new(109, 0, "Sound OFF", menu_togglesound)
	end
	pausebuttons["menutogglesound"].active = true
	
	currentpage = math.min(math.ceil(currentmap/16), math.ceil(#filetable/16))
	pages = math.ceil(#filetable/16)
	
	menubuttons[11].active = true
	menubuttons[10].active = true
	if currentpage == 1 then
		menubuttons[11].active = false
	end
	
	if currentpage == pages then
		menubuttons[10].active = false
	end
	
	levelbuttons = {}
	for i = 1, #filetable do
		if i >= (currentpage-1)*16+1 and i <= math.min(currentpage*16, #filetable) then
			local j = math.mod(i-1, 16)+1
			local x = round(((math.mod(j-1, 4)-1)+1) * 247.5 + 125)
			local y = math.ceil(j/4) * 100 - 570
			if i <= unlockedlevels then
				table.insert(levelbuttons, levelbutton:new(x, y, filetable[i].name, i, true))
			else
				table.insert(levelbuttons, levelbutton:new(x, y, filetable[i].name, i, false))
			end
		else
			if i < (currentpage-1)*16+1 then
				local j = math.mod(i-1, 16)+1
				local x = round(((math.mod(j-1, 4)-1)+1) * 247.5 + 125 -screenwidth*math.ceil(((currentpage-1)*16+1 - i)/16))
				local y = math.ceil(j/4) * 100 - 570
				if i <= unlockedlevels then
					table.insert(levelbuttons, levelbutton:new(x, y, filetable[i].name, i, true))
				else
					table.insert(levelbuttons, levelbutton:new(x, y, filetable[i].name, i, false))
				end
			else
				local j = math.mod(i-1, 16)+1
				local x = round(((math.mod(j-1, 4)-1)+1) * 247.5 + 125 + screenwidth*math.floor((i - ((currentpage-1)*16+1))/16))
				local y = math.ceil(j/4) * 100 - 570
				
				if i <= unlockedlevels then
					table.insert(levelbuttons, levelbutton:new(x, y, filetable[i].name, i, true))
				else
					table.insert(levelbuttons, levelbutton:new(x, y, filetable[i].name, i, false))
				end
			end
		end
	end
	
	fadetimer = 0
	fadecolor = 0
	fadetimert = 1
	
	skipupdate = true
end

function scalebutton()
	if scale == 1 then
		changescale(0.75)
		sizebutton:changetext("Nevermind, the game does fit on my screen.")
	else
		changescale(1)
		sizebutton:changetext("Help, this game doesn't fit on my screen!")
	end
end

function menu_update(dt)	
	if fadetimer ~= fadetimert then
		if fadetimert > fadetimer then
			fadetimer = fadetimer + dt
			if fadetimer >= fadetimert then
				fadetimer = fadetimert
				fadecolor = fadetimer
				menumusic:setVolume(1)
			else
				menumusic:setVolume(fadetimer)
				fadecolor = fadetimer
			end
		else 
			fadetimer = fadetimer - dt
			if fadetimer <= fadetimert then
				fadetimer = fadetimert
				fadecolor = fadetimer
				menumusic:stop()
				if fadegoal == "startlevel" then
					game_load(fadei)
					return
				elseif fadegoal == "quit" then
					savesave()
					love.event.quit()
					return
				end
			else
				if menuoffsett < 0 then
					menumusic:setVolume(fadetimer*0.3)
				else
					menumusic:setVolume(fadetimer)
				end
				fadecolor = fadetimer
			end
		end
	else
		if menuoffsett >= 0 then
			menumusic:setVolume(menumusic:getVolume()+dt)
			if menumusic:getVolume() > 1 then
				menumusic:setVolume(1)
			end
		end
	end
	
	if menuoffsett < 0 and fadetimert ~= 0 then
		menumusic:setVolume(menumusic:getVolume()-dt)
		if menumusic:getVolume() < 0.3 then
			menumusic:setVolume(0.3)
		end
	end

	--get closest full rot
	local rot = rotation+pi025
	while rot > math.pi/4 do
		rot = rot - math.pi/2
	end
	
	local speed = math.abs(rot)*2+0.005
	
	--pitch = (math.abs(rot))/pi05*0.3
	pitchadd = ((love.mouse.getY()-menuoffset)-330)/screenheight * 0.2
	pitchadd = math.max(math.min(pitchadd, 1), 0)
	pitch = pitchadd
	
	rotation = rotation + speed*dt
	
	while rotation > math.pi*2 do
		rotation = rotation - math.pi*2
	end
	while rotation < 0 do
		rotation = rotation + math.pi*2
	end
	calculatevars()
	
	if menuoffset ~= menuoffsett then
		if menuoffset < menuoffsett then
			menuoffset = menuoffset + (menuoffsett-menuoffset)*4*dt + 2*dt
			if menuoffset > menuoffsett then
				menuoffset = menuoffsett
			end
		else
			menuoffset = menuoffset + (menuoffsett-menuoffset)*4*dt - 2*dt
			if menuoffset < menuoffsett then
				menuoffset = menuoffsett
			end
		end
	end
	
	if menuoffsetx ~= menuoffsetxt then
		if menuoffsetx < menuoffsetxt then
			menuoffsetx = menuoffsetx + (menuoffsetxt-menuoffsetx)*4*dt + 2*dt
			if menuoffsetx > menuoffsetxt then
				menuoffsetx = menuoffsetxt
			end
		else
			menuoffsetx = menuoffsetx + (menuoffsetxt-menuoffsetx)*4*dt - 2*dt
			if menuoffsetx < menuoffsetxt then
				menuoffsetx = menuoffsetxt
			end
		end
	end
	
	for i, v in pairs(menubuttons) do
		v:update(dt)
	end
	
	for i, v in pairs(levelbuttons) do
		v:update(dt)
	end
	pausebuttons["menutogglesound"]:update(dt)
	sizebutton.x = menuoffsetx-screenwidth/2
	sizebutton.y = menuoffset+615
	sizebutton:update(dt)
end

function menu_draw()
	love.graphics.translate(menuoffsetx, menuoffset)
	
	love.graphics.setColor(100, 100, 100, 100*fadecolor)
	love.graphics.rectangle("fill", 30, 30, 964, 230)
	
	gridfadecolor = fadecolor
	fillfadecolor = fadecolor
	playerfadecolor = fadecolor
	
	local lmap = menumap
	--ISOMETRIC WORLD
	if rotation >= pi125 and rotation < pi175 then
		--DRAW ORDER: X, -Z, Y
		for cox = 1, menumapwidth do
			for coz = menumapdepth, 1, -1 do
				for coy = 1, menumapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz])
				end
			end
		end
	elseif rotation >= pi175 or rotation < pi025 then
		--DRAW ORDER: Z, X, Y
		for coz = 1, menumapdepth do
			for cox = 1, menumapwidth do
				for coy = 1, menumapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz])
				end
			end
		end
	elseif rotation >= pi025 and rotation < pi075 then
		--DRAW ORDER: -X, Z, Y	
		for cox = menumapwidth, 1, -1 do
			for coz = 1, menumapdepth do
				for coy = 1, menumapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz])
				end
			end
		end
	elseif rotation >= pi075 and rotation < pi125 then
		--DRAW ORDER: -Z, -X, Y
		for coz = menumapdepth, 1, -1 do
			for cox = menumapwidth, 1, -1 do
				for coy = 1, menumapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz])
				end
			end
		end
	end
	
	love.graphics.setFont(menufont)
	
	if menuoffset < 500 and menuoffset > -650 then --MAIN MENU
		menubuttons[1]:draw()
		menubuttons[2]:draw()
		menubuttons[3]:draw()
		menubuttons[4]:draw()
	end
	
	if menuoffset > 0 then --LEVEL LIST
		if menuoffsetx < screenwidth then
			love.graphics.setFont( levelselectfont )
			for i, v in pairs(levelbuttons) do
				v:draw()
			end
			love.graphics.setFont( menufont )
			menubuttons[5]:draw()
			if currentpage ~= pages then
				menubuttons[10]:draw()
			end
			if currentpage ~= 1 then
				menubuttons[11]:draw()
			end
		end
		
	end
	
	if menuoffset > 0 and menuoffsetx < 0 and menuoffsett == 500 then --win screen
		love.graphics.setColor(255, 255, 255, 255*fadecolor)
		for x = 2, 6 do --0-4
			love.graphics.draw(winplayerimg, screenwidth+screenwidth/7*x, screenheight/5-500, math.sin(creditss+(x-2)/16*math.pi*2)*0.2, 1, 1, 42, 66)
		end
		for y = 2, 4 do --5-7
			love.graphics.draw(winplayerimg, screenwidth+screenwidth/7*6, screenheight/5*y-500, math.sin(creditss+(y+3)/16*math.pi*2)*0.2, 1, 1, 42, 66)
		end
		for x = 2, 6 do --8-12
			love.graphics.draw(winplayerimg, screenwidth+screenwidth/7*(7-x), screenheight/5*4-500, math.sin(creditss+(x+6)/16*math.pi*2)*0.2, 1, 1, 42, 66)
		end
		for y = 2, 4 do --13-15
			love.graphics.draw(winplayerimg, screenwidth+screenwidth/7, screenheight/5*(5-y)-500, math.sin(creditss+(y+11)/16*math.pi*2)*0.2, 1, 1, 42, 66)
		end
		love.graphics.setFont(helpfont)
		
		local r, g, b = unpack(getrainbowcolor(math.mod(rainbowi, 1)))
		love.graphics.setColor(r, g, b, 255*fadecolor)
		for i = 1, #wintext do
			love.graphics.print(wintext[i], screenwidth+screenwidth*0.5 - helpfont:getWidth(wintext[i])/2, i*45+150-500)
		end
		
		menubuttons[12]:draw()
	end
	
	if menuoffset < 0 then --ARE YOU SURE? (well are you?)
		love.graphics.print("Are you sure?", screenwidth/2-areyousurewidth/2, 950)
		menubuttons[6]:draw()
		menubuttons[7]:draw()
	end
	
	if menuoffsetx < 0 and menuoffset < 500 then --CREDITS
		love.graphics.translate(screenwidth+screenwidth/2, (#creditstext-1)*100-70)
		love.graphics.rotate(creditsr)
		love.graphics.translate(-screenwidth-screenwidth/2, -(#creditstext-1)*100+70)
		love.graphics.setColor(100, 100, 100, 100*fadecolor)
		love.graphics.rectangle("fill", screenwidth*1.5-480, 50, 960, 510)
		
		for i = 1, #creditstext do
			love.graphics.setColor(255, 255, 255, 255*fadecolor)
			if i == 3 then
				local r, g, b = unpack(getrainbowcolor(math.mod(rainbowi+.66, 1)))
				love.graphics.setColor(r, g, b, 255*fadecolor)
				love.graphics.draw(accentimg, screenwidth*1.5+100, 266)
			end
			love.graphics.print(creditstext[i], screenwidth*1.5 - menufont:getWidth(creditstext[i])/2, i*100-50)
		end
		
		love.graphics.setFont(winwindowfont)
		love.graphics.print("Menu Music: 'Trooped' by BlueAngelEagle         Game Music: 'oh' by CapsAdmin", screenwidth+83, 530)
		love.graphics.setFont(menufont)
		
		local r, g, b = unpack(getrainbowcolor(math.mod(rainbowi+.33, 1)))
		love.graphics.setColor(r, g, b, 255*fadecolor)
		love.graphics.print("Saso", screenwidth*1.5 + 230, 350)
		love.graphics.draw(ssssimg, screenwidth*1.5+307, 366)
		
		love.graphics.translate(screenwidth+screenwidth/2, (#creditstext-1)*100-70)
		love.graphics.rotate(-creditsr)
		love.graphics.translate(-screenwidth-screenwidth/2, -(#creditstext-1)*100+70)
		menubuttons[8]:draw()
	end
	
	if menuoffsetx > 0 then --HELP
		--[[love.graphics.setFont(helpfont)
		for i = 1, #helptext do
			love.graphics.setColor(255, 255, 255, 255*fadecolor)
			love.graphics.print(helptext[i], -screenwidth*0.5 - helpfont:getWidth(helptext[i])/2, (i-1)*65+20)
		end
		love.graphics.setFont(menufont)--]]
		
		love.graphics.setColor(255, 255, 255, 255*fadecolor)
		love.graphics.draw(helptextimg, -screenwidth, 0)
		love.graphics.draw(helpplayerimg, -350, 60, creditsr, 1, 1, 28, 64)
		love.graphics.draw(helpgoalimg, -200, 80)
		love.graphics.draw(coinimg, -665, 130+creditsr*50, 0, 4, 4)
		love.graphics.draw(helpcursorimg, -110+math.cos(creditss)*10, 225+math.sin(creditss)*10, 0, 2, 2)
		love.graphics.draw(helpfswdimg, -900, 380, 0, 1, 1)
		menubuttons[9]:draw()
	end
	
	love.graphics.translate(-menuoffsetx, -menuoffset)
	
	pausebuttons["menutogglesound"]:draw()
	sizebutton:draw()
	
	love.graphics.setFont(winwindowfont)
	love.graphics.setColor(255, 255, 255, 100*fadecolor)
	love.graphics.print("2011 Stabyourself.net (v1.1)", screenwidth/2-140, 730)
	
	love.graphics.setColor(fillcolor[1], fillcolor[2], fillcolor[3], 255)
	love.graphics.draw(scanlineimg, 0, math.mod(creditss*3, 5)-5)
end

function loadlevels()
	filetable = love.filesystem.getDirectoryItems( "maps/" )
	for i = 1, #filetable do
		local path = filetable[i]
		filetable[i] = {}
		local v = filetable[i]
		v.path = path
	end
	
	for i = #filetable, 1, -1 do
		if string.sub(filetable[i].path, -4 ) ~= ".txt" or filetable[i].path == "menu.txt" then
			table.remove(filetable, i)
		end
	end
	
	for i = 1, #filetable do
		local v = filetable[i]
		local txtcontents = love.filesystem.read("maps/" .. v.path)
		v.collectedcoins = {}
		v.coins = 0
	
		local s1 = txtcontents:split("\n")
		for i = 1, #s1 do
			local s2 = s1[i]:split("=")
			if s2[1] == "name" then
				v.name = s2[2]
			elseif s2[1] == "text" then
				v.text = s2[2]
			elseif s2[1] == "time" then
				v.goaltime = tonumber(s2[2])
			elseif s2[1] == "steps" then
				v.goalsteps = tonumber(s2[2])
			elseif s2[1] == "warps" then
				v.goalwarps = tonumber(s2[2])
			elseif s2[1] == "coins" then
				v.coins = tonumber(s2[2])
			end
		end
	end
end

function button_start()
	playsound(proceedsound)
	menuoffsett = 500
	menuoffsetxt = 0
end

function button_back()
	playsound(backsound)
	menuoffsett = 0
end

function button_exit()
	playsound(proceedsound)
	menuoffsett = -650
	menuoffsetxt = 0
end

function button_credits()
	playsound(proceedsound)
	menuoffsetxt = -screenwidth
	menuoffsett = 0
end

function button_help()
	playsound(proceedsound)
	menuoffsetxt = screenwidth
	menuoffsett = 0
end

function button_no()
	playsound(backsound)
	button_back()
end	

function button_yes()
	menubuttons[6].active = false
	menubuttons[7].active = false
	playsound(proceedsound)
	fadetimer = 1
	fadetimert = 0
	fadegoal = "quit"
end

function button_creditsback()
	playsound(backsound)
	menuoffsetxt = 0
end

function button_prevpage()
	playsound(backsound)
	currentpage = currentpage - 1
	for i, v in pairs(levelbuttons) do
		v.xt = v.xt + screenwidth
	end
	
	if menubuttons[10].active == false then
		menubuttons[10].active = true
		menubuttons[10].value = 0
	end
	
	if currentpage == 1 then
		menubuttons[11].active = false
	end
end

function button_nextpage()
	playsound(proceedsound)
	currentpage = currentpage + 1
	for i, v in pairs(levelbuttons) do
		v.xt = v.xt - screenwidth
	end
	
	if menubuttons[11].active == false then
		menubuttons[11].active = true
		menubuttons[11].value = 0
	end
	
	if currentpage == pages then
		menubuttons[10].active = false
	end
end

function button_winback()
	menuoffsetxt = 0
end

function startlevel(i)
	playsound(proceedsound)
	fadetimert = 0
	fadegoal = "startlevel"
	fadei = i
end

function newBox(first)
	local rand = math.random(4)
	local dir = "hor"
	if math.mod(rand, 2) == 1 then
		dir = "ver"
	end
	local x, y, width, height
	local speed = math.random(300, 400)
	if dir == "hor" then
		width = math.random(30, 100)
		height = math.random(10, 20)
		if first then
			x = math.random(-screenwidth*3-width, -width)
		else
			x = -screenwidth-width
		end
		y = math.random(-screenheight, screenheight*2)
		if rand/2 == 2 then
			if first then
				x = math.random(screenwidth, screenwidth*4)
			else
				x = screenwidth*2+width
			end
			speed = -speed
		end
	else
		width = math.random(10, 20)
		height = math.random(30, 100)
		if first then
			y = math.random(-screenheight*3-height, -height)
		else
			y = -screenheight - height
		end
		x = math.random(-screenwidth, screenwidth*2)
		if rand/2 == 1.5 then
			if first then
				y = math.random(screenheight, screenheight*4)
			else
				y = screenheight*2+height
			end
			speed = -speed
		end
	end
	
	return {x, y, width, height, dir, speed}	
end

function menu_keypressed(key)

end

function menu_mousepressed(x, y, button)
	y = y - menuoffset
	x = x - menuoffsetx
	for i, v in pairs(levelbuttons) do
		if v:mousepressed(x, y, button) then
			return
		end
	end
	for i, v in pairs(menubuttons) do
		if v:mousepressed(x, y, button) then
			return
		end
	end
	pausebuttons["menutogglesound"]:mousepressed(x + menuoffsetx, y + menuoffset, button)
	sizebutton:mousepressed(x + menuoffsetx, y + menuoffset, button)
end

function menu_togglesound()
	if soundenabled then
		soundenabled = false
		menumusic:stop()
		pausebuttons["menutogglesound"].text = "Sound OFF"
		pausebuttons["menutogglesound"].textwidth = levelselectfont:getWidth(pausebuttons["menutogglesound"].text)
	else
		soundenabled = true
		playsound(menumusic)
		pausebuttons["menutogglesound"].text = "Sound ON"
		pausebuttons["menutogglesound"].textwidth = levelselectfont:getWidth(pausebuttons["menutogglesound"].text)
	end
end