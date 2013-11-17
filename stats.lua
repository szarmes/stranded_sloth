-------------Stats.lua


--require "menu"
txt = {}
wine = 23 --holds length of array of images on the screen

function createStatsGO()

	createFromBoth()
	images:remove(refreshbutton)
	refreshbutton=display.newImage("refresh.png",rightX - 50,210)
	refreshbutton:scale(1,1)
	images:insert(refreshbutton)
	refreshbutton:addEventListener("tap",resetGameStats)
	build()
end

function createStatsGOBeach()

	createFromBoth()
	images:remove(refreshbutton)
	refreshbutton=display.newImage("refresh.png",rightX - 50,210)
	refreshbutton:scale(1,1)
	images:insert(refreshbutton)
	refreshbutton:addEventListener("tap",resetGameStatsBeach)
	build()
end

function createStatsGOSafari()

	createFromBoth()
	images:remove(refreshbutton)
	refreshbutton=display.newImage("refresh.png",rightX - 50,210)
	refreshbutton:scale(1,1)
	images:insert(refreshbutton)
	refreshbutton:addEventListener("tap",resetGameStatsSafari)
	build()
end

function createFromMenu()
	
	createFromBoth()
	buildBoth()
	clearbutton=display.newImage("clear.png",rightX-135,200)
	clearbutton:addEventListener("tap",areYouSure)
	clearbutton:scale(0.44,0.48)
	images:insert(clearbutton)
end

function areYouSure()

	images:remove(clearbutton)
	menubutton:removeEventListener("tap", menuFromStats)
	
	sure = display.newImage("areyousure.png",rightX-140,150)
	sure:scale(0.7,0.7)
	images:insert(sure)
	
	yes=display.newImage("yes.png", rightX-130,220)
	yes:scale(0.8,0.8)
	images:insert(yes)
	yes:addEventListener("tap",wipestats)
	
	no=display.newImage("no.png", rightX-60,220)
	no:scale(0.8,0.8)
	images:insert(no)
	no:addEventListener("tap",dontwipestats)
	


end

function dontwipestats()

	images:remove(sure)
	images:remove(yes)
	images:remove(no)
	
	menubutton:addEventListener("tap", menuFromStats)

	clearbutton=display.newImage("clear.png",rightX-135,200)
	clearbutton:addEventListener("tap",areYouSure)
	clearbutton:scale(0.44,0.48)
	images:insert(clearbutton)

end

function wipestats()

	dontwipestats()

	temp=fileName
	fileName = "normalStats.txt"
	programersWrite()
	fileName = "challengeStats.txt"	   
	programersWrite()
	remove()
	buildBoth()
	fileName=temp


end

function createFromBoth()
	bg = display.newImage("statsbackground.png", -235, -245)
	--bg:scale (2*alter,0.5)
	images:insert(bg)
	
	menubutton=display.newImage("menu.png",rightX - 100,240)
	menubutton:scale(0.5,0.5)
	images:insert(menubutton)
	menubutton:addEventListener("tap", menuFromStats)
	refreshbutton=display.newImage("menu.png",rightX - 100,240)
	refreshbutton:scale(0.5,0.5)
	images:insert(refreshbutton)
	
end

function resetGameStats()

	seconds = -1
	images:remove(bg)
	resetInstanceData()
	images:remove(menubutton)
	menubutton:removeEventListener("tap", menuFromStats)
	refreshbutton:removeEventListener("tap",resetGameStats)
	images:remove(refreshbutton)
	remove()
	run()
end
function resetGameStatsBeach()

	seconds = -1
	images:remove(bg)
	resetInstanceData()
	images:remove(menubutton)
	menubutton:removeEventListener("tap", menuFromStats)
	refreshbutton:removeEventListener("tap",resetGameStats)
	images:remove(refreshbutton)
	remove()
	runbeach()
end
function resetGameStatsSafari()

	seconds = -1
	images:remove(bg)
	resetInstanceData()
	images:remove(menubutton)
	menubutton:removeEventListener("tap", menuFromStats)
	refreshbutton:removeEventListener("tap",resetGameStats)
	images:remove(refreshbutton)
	remove()
	runsafari()
end

function menuFromStats()

	seconds = -1
	images:remove(bg)
	resetInstanceData()
	images:remove(menubutton)
	menubutton:removeEventListener("tap", menuFromStats)
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	if clearbutton~=nil then 
		images:remove(clearbutton)
		clearbutton=nil
		end
		
	remove()
	createMenu()
end


function buildBoth()
	local font = 18 
	local b = fileName
	wine = 25
	fileName = "normalStats.txt"
	--programersWrite()
	read()
	
	txt[15]=display.newText("Normal Mode", rightX - 375, 20,"Georgia", font)
	txt[16]=display.newText("Challenge Mode", rightX - 190,20,"Georgia", font)
	
	for x = 0, 7, 1 do
		txt[x] = display.newText(statLabel[x],10,60 + 30*x,"Georgia",font)
		if(x==1)then
			txt[9] = display.newText(string.format("%.2f",stat[x]*100).."%", 185,60 + 35*x,"Georgia",font)
		elseif(x==2)then
			convertSToM(stat[x])
			local s = string.format("%02d", fileSec)
			s = fileMin..":"..s
			txt[10]= display.newText(s,185,60 + 30*x,"Georgia",font)
		elseif (x==7) then
			txt[24] = display.newText(stat[9],185,60 + 30*x,"Georgia",font)
		else
			txt[x +8] = display.newText(stat[x],185,60+30*x,"Georgia",font)
		end
	end
	
	fileName = "challengeStats.txt"	   
	--programersWrite()
	read()
	
	for x = 0, 7,1 do
		if(x==1)then
			txt[18] = display.newText(string.format("%.2f",stat[x]*100).."%", rightX - 140,60 + 30*x,"Georgia",font)
		elseif(x==2)then
			convertSToM(stat[x])
			local s = string.format("%02d", fileSec)
			s = fileMin..":"..s
			txt[19]= display.newText(s,rightX - 140,60 + 30*x,"Georgia",font)
		elseif(x==7) then 
			txt[25] = display.newText(stat[9],rightX - 140,60+30*x,"Georgia",font)
		else
			txt[x +17] = display.newText(stat[x],rightX - 140,60+30*x,"Georgia",font)
		end
	end		
	
	for x = 0,wine,1 do
		txt[x]:setTextColor(0,0,0)
		images:insert(txt[x])
		
	end
	
	fileName = b
end

function build()
	local font = 18
	wine = 21
	--statLabel[0] = "High score"
	--statLabel[1] = "All-Time Accuracy"
	--statLabel[2] = "Longest Life"
	--statLabel[3] = "Total Deaths"
	--statLabel[4] = "Deaths By Croc"
	--statLabel[5] = "Deaths By Bird"
	--statLabel[6] = "Deaths By Snake"
	txt[15]=display.newText("All Time", 180, 20,"Georgia", font)
	txt[16]=display.newText("Last Game", 345,20,"Georgia", font)
	txt[19] = display.newText(mode.." Mode",leftX + 25,20,"Georgia", font)

	for x = 0,7,1 do
		txt[x] = display.newText(statLabel[x],10,60 + 30*x,"Georgia",font)
		if(x==1)then
			txt[9] = display.newText(string.format("%.2f",stat[x]*100).."%", 210,60 + 30*x,"Georgia",font)--185
		elseif(x==2)then
			convertSToM(stat[x])
			local s = string.format("%02d", fileSec)
			s = fileMin..":"..s
			txt[10]= display.newText(s,210,60 + 30*x,"Georgia",font)
		elseif(x == 7) then
			txt[21] = display.newText(stat[9],210,60 + 30*x,"Georgia",font)
		
		else
			txt[x +8] = display.newText(stat[x],210,60+30*x,"Georgia",font)
		end
	end
	
	txt[17] = display.newText(score2, 380, 60, "Georgia", font)
	txt[18] = display.newText(string.format("%.2f", accuracy).."%", 380, 60 + 30, "Georgia", font)
	txt[20] = display.newText(lifeTime, 380, 60 + 60, "Georgia", font)
	
	for x = 0,wine,1 do
		txt[x]:setTextColor(0,0,0)
		images:insert(txt[x])
	end
end

function remove()
	for x = 0,wine,1 do
		images:remove(txt[x])
	end

end
