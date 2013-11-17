-------------
-----Menu.lua
-------------

local infocount=0
--local infoScale = 0.60
local shot=false

local menualigner=150

if string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight == 960 then
    menualigner=140
elseif string.sub(system.getInfo("model"),1,4) == "iPad" then
    menualigner=140 end



function createMenu()

	physics.start()
	mb=display.newImage("title.png",-275,-245)
	mb:scale(alter,0.5)
	images:insert(mb)

	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18
	images:insert(arm)

	playbutton = display.newImage("play.png",rightX-menualigner,28)
	playbutton:scale(0.9,0.9)
	images:insert(playbutton)
	playbutton:addEventListener("tap",play)

	info = display.newImage("info.png",rightX-menualigner,90)
	info:scale(0.9,0.9)
	images:insert(info)
	info:addEventListener("tap",shootAtInfo)
	

	statsbtn = display.newImage("stats.png",rightX-menualigner,160)
	statsbtn:scale(0.9,0.9)
	images:insert(statsbtn)
	statsbtn:addEventListener("tap", shootAtStats)
	
	quitbutton= display.newImage("quit.png", leftX-10,bottomY-50)
	quitbutton:scale(0.7,0.7)
	images:insert(quitbutton)
	quitbutton:addEventListener("tap",quitListener)
	
	

	toScale()

end


function play()

	shootAtPlay()
	timer.performWithDelay(1000,clearMenu)
	timer.performWithDelay(1001,chooselocation)
end


function chooselocation()

	mb=display.newImage("location.png",-275,-245)
	mb:scale(0.56,0.5)
	images:insert(mb)
	
	jungle=display.newImage("jungle.png",leftX -70,bottomY - 310)
	jungle:scale(0.4,0.4)
	images:insert(jungle)
	jungle:addEventListener("tap", playJungle)
	
	beach=display.newImage("beachlvl.png",leftX + 90,bottomY - 304)
	beach:scale(0.4,0.4)
	images:insert(beach)
	beach:addEventListener("tap", playBeach)
	
	safari = display.newImage("safarilvl.png", leftX+250,bottomY-304)
	safari:scale(0.38,0.38)
	images:insert(safari)
	safari:addEventListener("tap",playSafari)
	
	----add savannah here
	
	normal = display.newImage("normal.png",leftX+150,bottomY-80)
	normal:scale(0.5,0.5)
	images:insert(normal)
	normal:addEventListener("tap",changeUnderline1)

	challenge=display.newImage("challenge.png",leftX+250,bottomY-79)
	challenge:scale(0.5,0.5)
	images:insert(challenge)
	challenge:addEventListener("tap",changeUnderline2)
	
	arrow1 = display.newImage("arrow.png",rightX-50,bottomY-63)
	arrow1:scale(-1,1)
	arrow1:addEventListener("tap", menuFromLocation)
	images:insert(arrow1)

	if mode=="Normal" then
		underline=display.newImage("underline.png",leftX+130,bottomY-105)
		underline:scale(0.6,0.6)
		images:insert(underline)
	elseif mode=="Challenge" then
		underline=display.newImage("underline.png",leftX+260,bottomY-105)
		underline:scale(0.7,0.6)
		images:insert(underline)
	end

	modepic=display.newImage("mode.png",leftX-160,bottomY-100)
	modepic:scale(0.26,0.26)
	images:insert(modepic)



end

function clearlocation()

	images:remove(beach)
	images:remove(jungle)
	images:remove(safari)
	images:remove(modepic)
	images:remove(underline)
	images:remove(mb)
	images:remove(normal)
	images:remove(challenge)
	images:remove(arrow1)


end
function menuFromLocation()
	clearlocation()
	createMenu()

end
function playJungle()

	clearlocation()
	run()

end

function playBeach()

	clearlocation()
	runbeach()

end

function playSafari()

	clearlocation()
	runsafari()

end

function clearMenu(event)

	images:remove(mb)
	images:remove(arm)
	images:remove(playbutton)
	images:remove(info)
	images:remove(options)
	images:remove(statsbtn)
	images:remove(quitbutton)
end

function changeUnderline1()

	if mode=="Challenge" then
		images:remove(underline)
		underline=display.newImage("underline.png",leftX+130,bottomY-105)
		underline:scale(0.6,0.6)
		images:insert(underline)
		mode="Normal"
		fileName="normalStats.txt"
	else end
end

function changeUnderline2()

	if mode=="Normal" then
		images:remove(underline)
		underline=display.newImage("underline.png",leftX+260,bottomY-105)
		underline:scale(0.7,0.6)
		images:insert(underline)
		mode="Challenge"
		fileName="challengeStats.txt"
	else end
end

function createInfo()

	clearMenu()
	mb=display.newImage("arrow.png")
	images:insert(mb)
	arrow1=display.newImage("arrow.png")
	images:insert(arrow1)
	arrow2=display.newImage("arrow.png")
	images:insert(arrow2)

	menubutton=display.newImage("menu.png", 380,0)
	menubutton:scale(0.5,0.5)
	images:insert(2,menubutton)
	menubutton:addEventListener("tap", menuFromInfo)
	info1()
end

function info1()

	images:remove(mb)
	images:remove(arrow1)
	images:remove(arrow2)
	mb=display.newImage("info1.png",-190 + shift, -80)
	mb:scale(infoScale,infoScaleY)
	images:insert(1,mb)

	arrow1 = display.newImage("arrow.png",420,280)
	arrow1:addEventListener("tap", info2)
	images:insert(arrow1)

	arrow2 = display.newImage("arrow.png",420,280)
	images:insert(arrow2)

end

function info2()

	images:remove(mb)
	images:remove(arrow1)
	images:remove(arrow2)
	mb=display.newImage("info2.png",-190 + shift, -80)
	mb:scale(infoScale,  infoScaleY)
	images:insert(1,mb)

	arrow1 = display.newImage("arrow.png",420,280)
	images:insert(arrow1)
	arrow1:addEventListener("tap", info3)

	arrow2 = display.newImage("arrow.png",370,280)
	arrow2:scale(-1,1)
	arrow2:addEventListener("tap", info1)
	images:insert(arrow2)


end

function info3()
	images:remove(mb)
	images:remove(arrow1)
	images:remove(arrow2)

	mb=display.newImage("info3.png",-190 + shift, -80)
	mb:scale(infoScale,infoScaleY)
	images:insert(1,mb)

	arrow1 = display.newImage("arrow.png",370,280)
	arrow1:scale(-1,1)
	images:insert(arrow1)
	arrow1:addEventListener("tap",info2)


	arrow2 = display.newImage("arrow.png",420,280)
	arrow2:addEventListener("tap", info4)
	images:insert(arrow2)
end

function info4()
	images:remove(mb)
	images:remove(arrow1)
	images:remove(arrow2)

	mb=display.newImage("info4.png",-190 + shift, -80)
	mb:scale(infoScale,infoScaleY)
	images:insert(1,mb)

	arrow1 = display.newImage("arrow.png",370,280)
	arrow1:scale(-1,1)
	images:insert(arrow1)
	arrow1:addEventListener("tap",info3)


	arrow2 = display.newImage("arrow.png",420,280)
	arrow2:addEventListener("tap", info5)
	images:insert(arrow2)
end

function info5()
	images:remove(mb)
	images:remove(arrow1)
	images:remove(arrow2)

	mb=display.newImage("credits.png",-190 + shift, -80)
	mb:scale(infoScale,infoScaleY)
	images:insert(1,mb)

	arrow1 = display.newImage("arrow.png",370,280)
	arrow1:scale(-1,1)
	images:insert(arrow1)


	arrow2 = display.newImage("arrow.png",370,280)
	arrow2:scale(-1,1)
	arrow2:addEventListener("tap", info4)
	images:insert(arrow2)

end

function menuFromInfo()

	images:remove(menubutton)
	images:remove(mb)
	images:remove(arrow1)
	images:remove(arrow2)
	createMenu()

end

function shootAtPlay()

	
	rotatearmtimer3=timer.performWithDelay(10, menurotateArm,10)
	timer.performWithDelay(600,menuSplatPlay)
	p = poop()
	physics.addBody(p,{radius=15})
	constantV(0,1,3,0,p)
	p:applyTorque(1)
	playthrowsound()
	statsbtn:removeEventListener("tap", shootAtStats)
	info:removeEventListener("tap",shootAtInfo)
	playbutton:removeEventListener("tap",play)

end


function shootAtInfo()


	rotatearmtimer3=timer.performWithDelay(10, menurotateArm,10)
	timer.performWithDelay(600,menuSplatInfo)
	p = poop()
	physics.addBody(p,{radius=15})
	constantV(0,0.1,1,0,p)
	p:applyTorque(1)
	timer.performWithDelay(1000,createInfo)
	playthrowsound()
	statsbtn:removeEventListener("tap", shootAtStats)
	info:removeEventListener("tap",shootAtInfo)
	playbutton:removeEventListener("tap",play)

end

function shootAtStats()

	rotatearmtimer3=timer.performWithDelay(10, menurotateArm,10)
	timer.performWithDelay(600,menuSplatStats)
	p = poop()
	physics.addBody(p,{radius=15})
	constantV(0.6,0,3,0,p)
	p:applyTorque(1)
	playthrowsound()
	timer.performWithDelay(1000,createStats)
	statsbtn:removeEventListener("tap", shootAtStats)
	info:removeEventListener("tap",shootAtInfo)
	playbutton:removeEventListener("tap",play)
end
function menurotateArm()

	arm:rotate(36)
end

function menuSplatPlay()

	images:remove(poo)
	menupoosplat=display.newImage("poosplat.png",360,40)
	menupoosplat:scale(0.5,0.5)
	images:insert(menupoosplat)
	timer.performWithDelay(300,removeMenuSplat)
	playsplatsound()

end
function menuSplatInfo()

	images:remove(poo)
	menupoosplat=display.newImage("poosplat.png",380,95)
	menupoosplat:scale(0.5,0.5)
	images:insert(menupoosplat)
	timer.performWithDelay(300,removeMenuSplat)
	playsplatsound()

end
function menuSplatStats()
	images:remove(poo)
	menupoosplat=display.newImage("poosplat.png",375,165)
	menupoosplat:scale(0.5,0.5)
	images:insert(menupoosplat)
	timer.performWithDelay(300,removeMenuSplat)
	playsplatsound()

end
function removeMenuSplat()

	menupoosplat:removeSelf()
end

function createStats()
	clearMenu()
	createFromMenu()
end

function quit()

	os.exit()

end

function quitListener()

	timer.performWithDelay(1000,quit)
end