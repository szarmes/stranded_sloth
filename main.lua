-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require "menu"
require "stats"
require "splash"


--allow audio to continue uninterrupted 
    audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)

----flurry stuff---
--analytics = require "analytics"

-- initialize with proper API key corresponding to your application
--analytics.init( "P4RY46P5B3WW6YD256WS" )

-- log events


display.setStatusBar( display.HiddenStatusBar )

--Horizontal Scaling Variable
alter = 0.46--a scale for the game screen
infoScale = 0.37  -- a scale for the choice tutorial
infoScaleY = 0.67
shift = 0
GOShift = 0
GOShiftX = 0
heartScale = 0


--Screen Dimensions
topY = display.screenOriginY
rightX = display.contentWidth - display.screenOriginX
bottomY = display.contentHeight - display.screenOriginY
leftX = display.screenOriginX

physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode( "debug" )
--instance data

score = 0
local ammo=25

mode = "Normal"
fileName="normalStats.txt"

local poocounter=0
local splatcounter = 0
local flashCounter = 0

local background
images = display.newGroup() --use an image group to layer properly

local location = ""

--counters used in snake movement

local snakecount = 0
local xsnake = -50
local ysnake =	250
local snakerotate=15
local topsnakecount=0
local spidercount=0



crocspawncounter = 4

--counters used in bird movement
local birdcountnew=0
local birdcountold=0
local xbird=500
local ybird=120

local bird2countnew=0
local bird2countold=0
local xbird2=500
local ybird2=0

local bird3countnew=0
local bird3countold=0
local xbird3=-100
local ybird3=0

spawnRate = 2500

local crocshape = { -40,-10, 40,-10, 40,0, -40,0 }
local snakeshape = { -7,-30, 7,-30, 7,30, -7,30 }



local clickable = false		--keeps track of whether treebutton is clickable or not

local arm

local heartcount=3
local coconuts

local paused = false
local muted = false

local rotatable = true	--keeps track of whether the arm is rotatable or not (if the user is allowed to shoot)
local growing = false

local pausebutton
local mutebutton
local treebutton
local ammobubble
local ammoText
local timeText
local scorebubble
local scoreText

--stats From Normal Stat File

accuracy = 0
numbShots = 0
hits = 0
lifeTime = 0
timeInSec = 0  --holds time played in seconds
dbCroc = 0
dbBird = 0
dbSnake = 0
dbBoss = 0
seconds = -1
minutes = 0
fileSec = 0
fileMin = 0
score2 = 0

statLabel = {}

statLabel[0] = "High score"
statLabel[1] = "All-Time Accuracy"
statLabel[2] = "Longest Life"
statLabel[3] = "Total Deaths"
statLabel[4] = "Deaths By Jumper"
statLabel[5] = "Deaths By Bird"
statLabel[6] = "Deaths By Crawler"
statLabel[7] = "Death By Boss"

stat = {}
stat[0] = 7 -- High score
stat[1] = 0 -- Total Accuracy
stat[2] = 0 -- Longest Life in seconds to be converted later
stat[3] = 0 -- Total Deaths
stat[4] = 0 -- Death by crocks
stat[5] = 0 -- Death by Birds
stat[6] = 0 -- Death by snakes
stat[7] = 0 -- Total Number of shots
stat[8] = 0 -- Total Number of hits
stat[9] = 0 --Death By Boss

--mode-based settings

local crocspeed
local birdspeed
local snakespeed

local snaketimer1=nil
local snaketimer2=nil
local snaketimer3=nil

local crocrespawnlow
local crocrespawnhigh

local birdrespawnlow
local birdrespawnhigh

local snakerespawnlow
local snakerespawnhigh

--keeps track of what is on the screen
local snakeisoff=true
local topsnakeisoff=true
local birdisoff=true
local bird2isoff=true
local bird3isoff=true
local crocisoff=true
local poosplatisoff=true
local poosplat1isoff=true
local bgisoff=true
local bg2isoff=true
local bg3isoff=true
local bg4isoff=true
local bossisoff=true

local bosshitcount=3
local setbosshitcount=3
local bossbodytype="static"
bossSpawnCounter = 0

attack7counter =0


--local spawntemp=2000

--sounds
local throwsound = audio.loadStream( "throwsound.wav" )
local eatsound = audio.loadStream("eatsound.wav")
local splatsound = audio.loadStream("splat.wav")

local splashsound = audio.loadStream("splash.wav")
local gameoversound = audio.loadStream("gameOverSound.wav")
local hurtsound=audio.loadStream("hurt.wav")
local heartsound=audio.loadStream("ding.wav")
local roarsound=audio.loadStream("roar.wav")
local spawnAgain = 0 --how many animals have currently spawned
local multiSpawn = 1  --keeps track of how many animals spawn at once

--End of function varibales--------------------------------------------------

--background changes

-------------------------------------------------------------------Jungle/Universal code--------------------------
local function background2listener( event )
	background2 = display.newImage("background2.png", -275, -245)
	background2:scale (alter,0.50)
	images:insert(2,background2)
	bg2isoff=false

end
local function background3listener( event )
	background3 = display.newImage("background3.png",-275,-245)
	background3:scale (alter,0.50)
	images:insert(3,background3)
	bg3isoff=false



end
local function background4listener( event )
	background4 = display.newImage("background4.png",-275,-245)
	background4:scale (alter,0.50)
	images:insert(4,background4)
	bg4isoff=false

end

local function clickableTrue()
	clickable=true
	growing=false
end

function pause()


	if paused==false then
		pausepic = display.newImage("paus.png",140,200)
		--pausepic.alpha=0.9
		images:insert(pausepic)
		images:remove(pausebutton)
		pausebutton = display.newImage("playy.png",rightX - 100,bottomY -140)
		pausebutton:scale(0.3,0.3)
		images:insert(pausebutton)
		pausebutton:addEventListener("tap",pause)

		timer.pause(clockTimer)
		paused=true
		physics.pause()
		if background2timer~=nil then timer.pause(background2timer) else end
		if background3timer~=nil then timer.pause(background3timer) else end
		if background4timer~=nil then timer.pause(background4timer) else end
		if clickabletimer~=nil then timer.pause(clickabletimer) else end
		if rotatetimer~=nil then timer.pause(rotatetimer) else end
		if resetarmtimer~=nil then timer.pause(resetarmtimer) else end
		if pooresettimer~=nil then timer.pause(pooresettimer) else end
		if rotatetimer1~=nil then timer.pause(rotatetimer1) else end
		if resetarmtimer1~=nil then timer.pause(resetarmtimer1) else end
		if pooresettimer1~=nil then timer.pause(pooresettimer1) else end
		if rotatetimer2~=nil then timer.pause(rotatetimer2) else end
		if resetarmtimer2~=nil then timer.pause(resetarmtimer2) else end
		if pooresettimer2~=nil then timer.pause(pooresettimer2) else end
		if rotatetimer3~=nil then timer.pause(rotatetimer3) else end
		if resetarmtimer3~=nil then timer.pause(resetarmtimer3) else end
		if pooresettimer3~=nil then timer.pause(pooresettimer3) else end
		if rotatenegativetimer~= nil then timer.pause(rotatenegativetimer) else end
		if resetarmtimer1~=nil then timer.pause(resetarmtimer1) else end
		if rotatepositivetimer~= nil then timer.pause(rotatepositivetimer) else end
		if resetarmtimer2~=nil then timer.pause(resetarmtimer2) else end
		if respawntimer~=nil then timer.pause(respawntimer) else end
		if respawntimer1~=nil then timer.pause(respawntimer1) else end
		if respawntimer2~=nil then timer.pause(respawntimer2) else end
		if respawntimer3~=nil then timer.pause(respawntimer3) else end
		if croctimer1~=nil then timer.pause(croctimer1) else end
		if croctimer2~=nil then timer.pause(croctimer2) else end
		if birdtimer~=nil then timer.pause(birdtimer) else end
		if bird2timer~=nil then timer.pause(bird2timer) else end
		if spawncroctimer~=nil then timer.pause(spawncroctimer) else end
		if snaketimer~=nil then timer.pause(snaketimer) else end
		if snaketimer1~=nil then timer.pause(snaketimer1) else end
		if snaketimer2~=nil then timer.pause(snaketimer2) else end
		if snaketimer3~=nil then timer.pause(snaketimer3) else end
		if snaketimer4~=nil then timer.pause(snaketimer4) else end
		if spawnagaintimer~=nil then timer.pause(spawnagaintimer) else end
		if splashtimer1~=nil then timer.pause(splashtimer1) else end
		if splashtimer2~=nil then timer.pause(splashtimer2) else end
		if splashtimer3~=nil then timer.pause(splashtimer3) else end
		if topsnaketimer~=nil then timer.pause(topsnaketimer) else end
		if GOcroc ~=nil then timer.pause(GOcroc) else end
		if GOsnake ~=nil then timer.pause(GOsnake) else end
		if GOsnake1 ~=nil then timer.pause(GOsnake1) else end
		if GObird ~=nil then timer.pause(GObird) else end
		if GObird2 ~=nil then timer.pause(GObird2) else end
		if birdhittimer~=nil then timer.pause(birdhittimer) else end
		if bird2hittimer~=nil then timer.pause(bird2hittimer) else end
		if snakehittimer~=nil then timer.pause(snakehittimer) else end
		if topsnakehittimer~=nil then timer.pause(topsnakehittimer) else end
		timer.pause(spawntimer)
		audio.pause()
		menubutton=display.newImage("menu.png",rightX - 100,bottomY - 150)
		menubutton:scale(0.5,0.5)
		menubutton:addEventListener("tap", menuFromPause)
		images:insert(menubutton)
		refreshbutton=display.newImage("refresh.png",rightX - 50,bottomY -180)
		refreshbutton:scale(1,1)
		images:insert(refreshbutton)
		refreshbutton:addEventListener("tap",resetFromPause)

	else paused = false
		images:remove(pausepic)
		images:remove(pausebutton)
		pausebutton = display.newImage("pause.png",rightX - 100,bottomY -140)
		pausebutton:scale(0.3,0.3)
		images:insert(pausebutton)
		pausebutton:addEventListener("tap",pause)


		physics.start()
		timer.resume(clockTimer)
		if background2timer~=nil then timer.resume(background2timer) else end
		if background3timer~=nil then timer.resume(background3timer) else end
		if background4timer~=nil then timer.resume(background4timer) else end
		if clickabletimer~=nil then timer.resume(clickabletimer) else end
		if rotatetimer~=nil then timer.resume(rotatetimer) else end
		if resetarmtimer~=nil then timer.resume(resetarmtimer) else end
		if pooresettimer~=nil then timer.resume(pooresettimer) else end
		if rotatetimer1~=nil then timer.resume(rotatetimer1) else end
		if resetarmtimer1~=nil then timer.resume(resetarmtimer1) else end
		if pooresettimer1~=nil then timer.resume(pooresettimer1) else end
		if rotatetimer2~=nil then timer.resume(rotatetimer2) else end
		if resetarmtimer2~=nil then timer.resume(resetarmtimer2) else end
		if pooresettimer2~=nil then timer.resume(pooresettimer2) else end
		if rotatetimer3~=nil then timer.resume(rotatetimer3) else end
		if resetarmtimer3~=nil then timer.resume(resetarmtimer3) else end
		if pooresettimer3~=nil then timer.resume(pooresettimer3) else end
		if rotatenegativetimer~= nil then timer.resume(rotatenegativetimer) else end
		if resetarmtimer1~=nil then timer.resume(resetarmtimer1) else end
		if rotatepositivetimer~= nil then timer.resume(rotatepositivetimer) else end
		if resetarmtimer2~=nil then timer.resume(resetarmtimer2) else end
		if respawntimer~=nil then timer.resume(respawntimer) else end
		if respawntimer1~=nil then timer.resume(respawntimer1) else end
		if respawntimer2~=nil then timer.resume(respawntimer2) else end
		if respawntimer3~=nil then timer.resume(respawntimer3) else end
		if croctimer1~=nil then timer.resume(croctimer1) else end
		if croctimer2~=nil then timer.resume(croctimer2) else end
		if birdtimer~=nil then timer.resume(birdtimer) else end
		if bird2timer~=nil then timer.resume(bird2timer) else end
		if spawncroctimer~=nil then timer.resume(spawncroctimer) else end
		if snaketimer~=nil then timer.resume(snaketimer) else end
		if snaketimer1~=nil then timer.resume(snaketimer1) else end
		if snaketimer2~=nil then timer.resume(snaketimer2) else end
		if snaketimer3~=nil then timer.resume(snaketimer3) else end
		if snaketimer4~=nil then timer.resume(snaketimer4) else end
		if spawnagaintimer~=nil then timer.resume(spawnagaintimer) else end
		if splashtimer1~=nil then timer.resume(splashtimer1) else end
		if splashtimer2~=nil then timer.resume(splashtimer2) else end
		if splashtimer3~=nil then timer.resume(splashtimer3) else end
		if topsnaketimer~=nil then timer.resume(topsnaketimer) else end
		if GOcroc ~=nil then timer.resume(GOcroc) else end
		if GOsnake ~=nil then timer.resume(GOsnake) else end
		if GOsnake1 ~=nil then timer.resume(GOsnake1) else end
		if GObird ~=nil then timer.resume(GObird) else end
		if GObird2 ~=nil then timer.resume(GObird2) else end
		if birdhittimer~=nil then timer.resume(birdhittimer) else end
		if bird2hittimer~=nil then timer.resume(bird2hittimer) else end
		if snakehittimer~=nil then timer.resume(snakehittimer) else end
		if topsnakehittimer~=nil then timer.resume(topsnakehittimer) else end
		timer.resume(spawntimer)
		audio.resume()
		images:remove(menubutton)
		images:remove(refreshbutton)
		refreshbutton:removeEventListener("tap",resetGame)
		menubutton:removeEventListener("tap", menuFromPause)
	end

end
function mute()

	if muted==false then muted = true
		muteon=display.newImage("muteon.png",rightX - 95,bottomY - 100)
		muteon:scale(0.2,0.2)
		images:insert(muteon)
		audio.pause()
	else muted = false
		audio.resume()
		images:remove(muteon)
	end
end
--actions

local function growLeaf()

	clickable=false
	growing = true
	bg2isoff=true
	bg3isoff=true
	bg4isoff=true

	background = display.newImage("background1.png",-275,-245)-------------------------------------------------------hi
	background:scale (alter,0.50)

	images:insert(1,background)
	bgisoff=false

	background2timer=timer.performWithDelay(2000,background2listener)
	background3timer=timer.performWithDelay(4000,background3listener)
	background4timer=timer.performWithDelay(6000,background4listener)
	clickabletimer=timer.performWithDelay(6000, clickableTrue)

end

function playhurtsound()

	if muted==false then
		audio.play( hurtsound )
	end
end

local function playsplashsound()

	if muted==false then
		audio.play( splashsound )
	else end
end

function playthrowsound()

	if muted==false then
		audio.play( throwsound )
	else end
end

local function playeatsound()

	if muted==false then
		audio.play( eatsound )
	else end
end

function playsplatsound()
	if muted==false then
		audio.play(splatsound)
	else end
end

local function playgameoversound()

	if muted==false  then
		audio.play(gameoversound)
	else end
end

local function playmusic()
	if muted==false  then
		audio.play(backgroundmusic,{loops=-1})
	else end
end

function playheartsound()
	if muted==false  then
		audio.play(heartsound)
	else end

end

function playroarsound()
	if muted==false  then
		audio.play(roarsound)
	else end

end

local function resetArm()
	images:remove(arm)
	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18
	images:insert(arm)
	rotatable=true
	if growing==false then
		clickable=true
	end
end
local function resetArmShot()
	images:remove(arm)
	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18
	images:insert(arm)
	rotatable=true
	Runtime:addEventListener("touch" , shoot)
	if growing==false then
		clickable=true
	end
end

local function rotateArm(event)

	rotatable=false
	arm:rotate(45)
end

local function rotateArmPositive(event)

	rotatable=false
	arm:rotate(15)
end

local function rotateArmNegative(event)
	arm:rotate(-15)
end
local function rotateReset(event)
	rotatenegativetimer=timer.performWithDelay(1, rotateArmNegative,10)
	resetarmtimer1=timer.performWithDelay(500, resetArmShot)
end
local function rotateResetTut(event)
	rotatenegativetimer=timer.performWithDelay(1, rotateArmNegative,10)
	resetarmtimer1=timer.performWithDelay(500, resetArm)
end

local function eatLeaf()
	rotatable=false				--cant shoot while eating
	addAmmo()
	Runtime:removeEventListener("touch" , shoot)
	rotatepositivetimer=timer.performWithDelay(1, rotateArmPositive,10)
	resetarmtimer2=timer.performWithDelay(500, rotateReset)

end


local function eat()
	if clickable == true and paused==false then
		eatLeaf()
		images:remove(4,background4)
		images:remove(3,background3)
		images:remove(2,background2)
		images:remove(1,background)
		growLeaf()
		playeatsound()
	else end
end

function shoot( event )

	if poocounter==0 and paused==false then
		shootIf(event)
		poocounter=poocounter +1
	elseif poocounter==1 and paused==false then
		shootIf(event)
		poocounter = poocounter + 1
	elseif poocounter==2 and paused==false then
		shootIf(event)
		poocounter=poocounter+1
	elseif poocounter==3 and paused==false then
		shootIf(event)
		poocounter=0
	else end
end
function flash()

	local time = 500

	if(ammo<5) then
		time = 100
	end

	if ammo<10 then
		if (flashCounter == 0) then
			ammobubble:setFillColor(230,0,0)
			flashCounter = flashCounter + 1

		elseif(flashCounter == 1) then
			ammobubble:setFillColor(255,255,255)
			flashCounter = 0
		end
		timer.performWithDelay(time,flash)
		return
	end

end

function addAmmo()
	if mode=="Normal" then
		ammo = ammo+20
	else 
		ammo = ammo+15
	end
	ammoText.text = "Ammo: "..ammo
	if ammo>9 then
		ammoText:setTextColor(0,0,0)
		ammobubble:setFillColor(255,255,255)
	else end
end

function onCollision(event)
	if event.object1.myName == "snake" or event.object2.myName == "snake" then
		if snaketimer~=nil then timer.cancel(snaketimer)end
		if location=="jungle" or location=="safari" then timer.cancel(snaketimer1) end
		timer.cancel(GOsnake)
		if snakehittimer~=nil then timer.cancel(snakehittimer) else end
		if snaketimer2~=nil then timer.cancel(snaketimer2)
			snaketimer2=nil  end
		if snaketimer3~=nil then timer.cancel(snaketimer3)
			snaketimer3=nil  end
		if snaketimer4~=nil then timer.cancel(snaketimer4)
			snaketimer4=nil	 end
		snakeisoff=true
		snakecount=0
		score=score+1
		scoreText.text = "Score: "..score
		images:remove(event.object1)
		images:remove(event.object2)
	elseif event.object1.myName == "topsnake" or event.object2.myName == "topsnake" then
		timer.cancel(topsnaketimer)
		timer.cancel(GOsnake1)
		if topsnakehittimer~=nil then timer.cancel(topsnakehittimer) else end
		topsnakeisoff=true
		xbird3=-100
		ybird3=0
		bird3countnew=0
		bird3countold=0
		spidercount=0
		score=score+1
		scoreText.text = "Score: "..score
		images:remove(event.object1)
		images:remove(event.object2)


	elseif event.object1.myName=="bird" or event.object2.myName == "bird" then
		timer.cancel(birdtimer)
		timer.cancel(GObird)
		if birdhittimer~=nil then timer.cancel(birdhittimer) else end
		birdisoff=true
		xbird=500
		ybird=120
		birdcountnew=0
		birdcountold=0
		score=score+1
		scoreText.text = "Score: "..score
		images:remove(event.object1)
		images:remove(event.object2)



	elseif event.object1.myName=="bird2" or event.object2.myName == "bird2" then
		timer.cancel(bird2timer)
		timer.cancel(GObird2)
		if bird2hittimer~=nil then timer.cancel(bird2hittimer) else end
		bird2isoff=true
		xbird2=500
		ybird2=0
		bird2countnew=0
		bird2countold=0
		score=score+1
		scoreText.text = "Score: "..score
		images:remove(event.object1)
		images:remove(event.object2)


	elseif event.object1.myName=="croc" or event.object2.myName == "croc" then
		timer.cancel(croctimer1)
		timer.cancel(croctimer2)
		timer.cancel(GOcroc)
		crocisoff=true
		score=score+1
		scoreText.text = "Score: "..score
		images:remove(event.object1)
		images:remove(event.object2)

	elseif event.object1.myName=="jungleboss" or event.object2.myName == "jungleboss" then
		if bosshitcount==1 then
			timer.cancel(birdtimer)
			timer.cancel(GObird)
			if birdhittimer~=nil then timer.cancel(birdhittimer) else end
			bossisoff=true
			xbird=500
			ybird=120
			birdcountnew=0
			birdcountold=0
			score=score+10
			scoreText.text = "Score: "..score
			if setbosshitcount<5 then
				setbosshitcount=setbosshitcount+1
			end
			bosshitcount=setbosshitcount
			bossSpawnCounter=0
			images:remove(event.object1)
			images:remove(event.object2)
			addHeart()
		else
			bosshitcount=bosshitcount-1
			if event.object1.myName=="jungleboss" then images:remove(event.object2)
			else images:remove(event.object1) end
		end

	elseif event.object1.myName == "beachboss" or event.object2.myName == "beachboss" then
		if bosshitcount==1 then
			if setbosshitcount<5 then
				setbosshitcount=setbosshitcount+1
			end
			timer.cancel(snaketimer)
			if location=="jungle" then timer.cancel(snaketimer1) end
			timer.cancel(GOsnake)
			if snakehittimer~=nil then timer.cancel(snakehittimer) else end
			if snaketimer2~=nil then timer.cancel(snaketimer2) else end
			if snaketimer3~=nil then timer.cancel(snaketimer3) else end
			if snaketimer4~=nil then timer.cancel(snaketimer4) else end
			bossisoff=true
			snakecount=0
			score=score+10
			scoreText.text = "Score: "..score
			bosshitcount=setbosshitcount
			bossSpawnCounter=0
			bossbodytype = "static"
			images:remove(event.object1)
			images:remove(event.object2)
			addHeart()
		else
			bosshitcount=bosshitcount-1
			if event.object1.myName=="beachboss" then images:remove(event.object2)
			else images:remove(event.object1) end
		end
	elseif event.object1.myName == "safariboss" or event.object2.myName == "safariboss" then
		if bosshitcount==1 then
			timer.cancel(snaketimer)
			if location=="jungle" or location=="safari" then timer.cancel(snaketimer1) end
			timer.cancel(GOsnake)
			if snakehittimer~=nil then timer.cancel(snakehittimer) else end
			if snaketimer2~=nil then timer.cancel(snaketimer2) else end
			if snaketimer3~=nil then timer.cancel(snaketimer3) else end
			if snaketimer4~=nil then timer.cancel(snaketimer4) else end
			bossisoff=true
			snakecount=0
			score=score+10
			scoreText.text = "Score: "..score
			if setbosshitcount<5 then
				setbosshitcount=setbosshitcount+1
			end
			bosshitcount=setbosshitcount
			bossSpawnCounter=0
			bossbodytype = "static"
			images:remove(event.object1)
			images:remove(event.object2)
			addHeart()
		else
			bosshitcount=bosshitcount-1
			if event.object1.myName=="safariboss" then images:remove(event.object2)
			else images:remove(event.object1) end
		end




	end

	playsplatsound()
	xtemp=event.object1.x
	ytemp=event.object1.y
	if splatcounter==0 then
		poosplat=display.newImage("poosplat.png",xtemp-30,ytemp-30)
		poosplat:scale(0.5,0.5)
		images:insert(poosplat)
		splatcounter=1
		poosplatisoff=false
		timer.performWithDelay(400,removepoosplat)
	else
		poosplat1=display.newImage("poosplat.png",xtemp-30,ytemp-30)
		poosplat1:scale(0.5,0.5)
		images:insert(poosplat1)
		splatcounter=0
		poosplat1isoff=false
		timer.performWithDelay(400,removepoosplat1)
	end

	hits = hits + 1
end

function removepoosplat(event)
	if poosplatisoff==false then
		poosplat:removeSelf()
		poosplatisoff=true
	end
end

function removepoosplat1(event)
	if poosplat1isoff==false then
		poosplat1:removeSelf()
		poosplat1isoff=true
	end
end

function constantV(yend,ystart,xend, xstart,poo)

	local y = yend- ystart
	local x = xend - xstart
	local slope = y/x

	if(x>0)then
		deg2 = math.atan(slope)
	else
		deg2 = math.pi-math.atan(-1*slope)
	end

	local finaly = math.sin(deg2)*3
	local finalx = math.cos(deg2)*3

	if x==0 then
		poo:applyForce(0,-finaly, poo.x,poo.y)	--added because shooting straight up and down was reversed for some reason..
	else
		poo:applyForce(finalx,finaly, poo.x,poo.y)
	end
end


local function moveCroc1()
	images:remove(croc)
	croc = display.newImage("crocmid.png",65,80)
	croc:scale (0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
end

local function moveCroc2()
	images:remove(croc)
	croc = display.newImage("crochigh.png",65,45)
	croc:scale (0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
end

function spawnCroc()
	crocisoff=false
	croc=display.newImage("croclow.png",65,162)
	croc:scale(0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
	crocsplash()
	croctimer1=timer.performWithDelay(crocspeed,moveCroc1)
	croctimer2=timer.performWithDelay(2*crocspeed,moveCroc2)
	GOcroc = timer.performWithDelay(3*crocspeed,gameOverCroc)
	playsplashsound()
end

function crocsplash()
	droplet1=display.newImage("droplet.png",130,280)
	droplet1:scale(0.35,0.35)
	droplet1:rotate(180)
	images:insert(droplet1)

	droplet2=display.newImage("droplet.png",250,290)
	droplet2:scale(-0.3,0.3)
	droplet2:rotate(200)
	images:insert(droplet2)

	droplet3=display.newImage("droplet.png",230,260)
	droplet3:scale(-0.27,0.27)
	droplet3:rotate(180)
	images:insert(droplet3)

	splashtimer1=timer.performWithDelay(400,crocsplash1)
	splashtimer2=timer.performWithDelay(800,crocsplash2)
	splashtimer3=timer.performWithDelay(1500,removesplash)
end

function crocsplash1()
	images:remove(droplet1)
	images:remove(droplet2)
	images:remove(droplet3)

	droplet1=display.newImage("droplet.png",120,275)
	droplet1:scale(0.35,0.35)
	droplet1:rotate(170)
	images:insert(droplet1)

	droplet2=display.newImage("droplet.png",260,285)
	droplet2:scale(-0.3,0.3)
	droplet2:rotate(210)
	images:insert(droplet2)

	droplet3=display.newImage("droplet.png",240,255)
	droplet3:scale(-0.27,0.27)
	droplet3:rotate(200)
	images:insert(droplet3)

end
function crocsplash2()
	images:remove(droplet1)
	images:remove(droplet2)
	images:remove(droplet3)

	droplet1=display.newImage("droplet.png",110,270)
	droplet1:scale(0.35,0.35)
	droplet1:rotate(150)
	images:insert(droplet1)

	droplet2=display.newImage("droplet.png",270,280)
	droplet2:scale(-0.3,0.3)
	droplet2:rotate(230)
	images:insert(droplet2)

	droplet3=display.newImage("droplet.png",250,250)
	droplet3:scale(-0.27,0.27)
	droplet3:rotate(220)
	images:insert(droplet3)
end

function removesplash()
	images:remove(droplet1)
	images:remove(droplet2)
	images:remove(droplet3)
end

function moveBird()
	images:remove(bird)
	if birdcountnew == 0 then
		bird = display.newImage("birdmid.png",xbird,ybird-10)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 0 then
		bird = display.newImage("birddown.png",xbird,ybird-20)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 2 then
		bird = display.newImage("birdup.png",xbird,ybird)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1

	else
		bird = display.newImage("birdmid.png",xbird,ybird-10)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1
	end

	physics.addBody(bird,{radius=10})
end

function moveBird2()
	images:remove(bird2)
	if bird2countnew == 0 then
		bird2 = display.newImage("birdmid.png",xbird2,ybird2-10)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew+1

	elseif bird2countnew == 1 and bird2countold == 0 then
		bird2 = display.newImage("birddown.png",xbird2,ybird2-20)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew+1

	elseif bird2countnew == 1 and bird2countold == 2 then
		bird2 = display.newImage("birdup.png",xbird2,ybird2)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew-1

	else
		bird2 = display.newImage("birdmid.png",xbird2,ybird2-10)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew-1
	end

	ybird2=ybird2+7
	bird2:rotate(-25)
	physics.addBody(bird2,{radius=10})
end

function moveBirdBoss()
	images:remove(boss)
	if birdcountnew == 0 then
		boss = display.newImage("birdmid.png",xbird,ybird-10)
		images:insert(boss)
		boss.myName="jungleboss"
		boss.xOrigin = boss.xOrigin-20
		xbird = xbird-10
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 0 then
		boss = display.newImage("birddown.png",xbird,ybird-20)
		images:insert(boss)
		boss.myName="jungleboss"
		boss.xOrigin = boss.xOrigin-20
		xbird = xbird-10
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 2 then
		boss = display.newImage("birdup.png",xbird,ybird)
		images:insert(boss)
		boss.myName="jungleboss"
		boss.xOrigin = boss.xOrigin-20
		xbird = xbird-10
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1

	else
		boss = display.newImage("birdmid.png",xbird,ybird-10)
		images:insert(boss)
		boss.myName="jungleboss"
		boss.xOrigin = boss.xOrigin-20
		xbird = xbird-10
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1
	end
	boss:scale(2.3,2.3)
	physics.addBody(boss,{radius=15})
	boss.bodyType=bossbodytype
end

function spawnBird()
	if bossSpawnCounter>17 then
		spawnBossJungle()
		bossSpawnCounter=0
	else
		birdisoff=false
		bird=display.newImage("birdup.png",xbird,ybird)
		images:insert(bird)
		bird.myName="bird"
		birdtimer = timer.performWithDelay(birdspeed, moveBird, 13)
		GObird=timer.performWithDelay(15*birdspeed,birdhit)
		physics.addBody(bird,{radius=10})
	end
end

function spawnBossJungle()
	bossisoff=false
	boss=display.newImage("birdup.png",xbird,ybird)
	boss:scale(2.3,2.3)
	images:insert(boss)
	boss.myName="jungleboss"
	birdtimer = timer.performWithDelay(birdspeed, moveBirdBoss, 26)
	GObird=timer.performWithDelay(28*birdspeed,gameOverBoss)
	physics.addBody(boss,{radius=15})
	boss.bodyType=bossbodytype

end

function spawnBird2()
	bird2isoff=false
	bird2=display.newImage("birdup.png",xbird2,ybird2)
	images:insert(bird2)
	bird2.myName="bird2"
	bird2timer = timer.performWithDelay(birdspeed, moveBird2, 13)
	GObird2=timer.performWithDelay(15*birdspeed,bird2hit)
	physics.addBody(bird2,{radius=10})
end

function snakehit()
	playhurtsound()
	if heartcount==3 then images:remove(heart3)
		heartcount=2
		snakehittimer=timer.performWithDelay(1000,snakehit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		snakehittimer=timer.performWithDelay(1000,snakehit,1)
	elseif heartcount==1 then gameOverSnake()
	end

end

function topsnakehit()
	playhurtsound()
	if heartcount==3 then images:remove(heart3)
		heartcount=2
		topsnakehittimer=timer.performWithDelay(1000,topsnakehit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		topsnakehittimer=timer.performWithDelay(1000,topsnakehit,1)
	elseif heartcount==1 then gameOverSnake()
	end
end

function birdhit()
	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		birdhittimer=timer.performWithDelay(1000,birdhit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		birdhittimer=timer.performWithDelay(1000,birdhit,1)
	elseif heartcount==1 then gameOverBird()
	end

end

function bird2hit()
	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		bird2hittimer=timer.performWithDelay(1000,bird2hit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		bird2hittimer=timer.performWithDelay(1000,bird2hit,1)
	elseif heartcount==1 then gameOverBird()
	end

end

function spawnSnakeTop()
	if snakeisoff==true then
		topsnakeisoff=false
		topsnake=display.newImage("snake1.png",-70,10)
		topsnake:rotate(90)
		physics.addBody(topsnake, {shape=snakeshape})
		topsnake.myName="topsnake"
		topsnake:scale(-0.5,0.5)
		images:insert(topsnake)
		topsnaketimer=timer.performWithDelay(snakespeed, moveSnakeTop, 17)
		GOsnake1 = timer.performWithDelay(19*snakespeed,topsnakehit)
	else
		if snake.yOrigin>225 then
			topsnakeisoff=false
			topsnake=display.newImage("snake1.png",-70,10)
			topsnake:rotate(90)
			physics.addBody(topsnake, {shape=snakeshape})
			topsnake.myName="topsnake"
			topsnake:scale(-0.5,0.5)
			images:insert(topsnake)
			topsnaketimer=timer.performWithDelay(snakespeed, moveSnakeTop, 17)
			GOsnake1 = timer.performWithDelay(19*snakespeed,topsnakehit)
		end
	end
end

function moveSnakeTop()
	if topsnakeisoff==false then
		topsnake.xOrigin=topsnake.xOrigin+10
		if topsnakecount==1 then
			topsnake:scale(-1,1)

		elseif topsnakecount==3 then
			topsnake:scale(-1,1)
			topsnakecount=-1
		else end

		topsnakecount=topsnakecount+1
	end
end

local function rotateSnakeBottom(event)
	snake:rotate(snakerotate)
	snake.yOrigin = snake.yOrigin-7

	if snakecount == 1 then
		snake:scale(-1,1)
	elseif snakecount == 3 then
		snake:scale(-1,1)
		snakecount=-1
	else end

	snakecount=snakecount+1
end

local function rotateSnakeBottomListener()
	snaketimer2=timer.performWithDelay(snakespeed, rotateSnakeBottom,6)
	snaketimer3=timer.performWithDelay(6*snakespeed,moveSnakeRightListener)
end

function moveSnakeRightListener()
	snaketimer4=timer.performWithDelay(snakespeed,moveSnakeRight,10)
end
function moveSnakeRight()

	snake.xOrigin=snake.xOrigin+10
	if snakecount==1 then
		snake:scale(-1,1)
	elseif snakecount==3 then
		snake:scale(-1,1)
		snakecount=-1
	else end
	snakecount=snakecount+1
end
local function moveSnakeBottom( event)
	if snakeisoff==false then
		snake.yOrigin = snake.yOrigin-7 end

	if snakecount == 1 then
		snake:scale(-1,1)
	elseif snakecount==3 then
		snake:scale(-1,1)
		snakecount=-1
	else end
	snakecount=snakecount+1
end

function spawnSnakeBottom()
	snakeisoff=false
	snake=display.newImage("snake1.png",leftX + 10,250)
	physics.addBody(snake, {shape=snakeshape})
	snake.myName="snake"
	snake:scale(-0.5,0.5)
	images:insert(snake)
	snaketimer=timer.performWithDelay(snakespeed, moveSnakeBottom, 29)
	snaketimer1 =timer.performWithDelay(31*snakespeed, rotateSnakeBottomListener)
	GOsnake = timer.performWithDelay(48*snakespeed,snakehit)
end

local function pooListener(event)
	poo:applyLinearImpulse( event.x - event.xStart,  event.y - event.yStart, poo.x, poo.y )
end

function resetPoo(n)

	if pause==false then
		if n==0 then
			images:remove(poo)

		elseif n==1 then
			images:remove(poo1)

		elseif n==2 then
			images:remove(poo2)

		elseif n==3 then
			images:remove(poo3)

		else end
	else end
end

function poop()
	if poocounter==0 then
		poo = display.newImage("poo.png",120,120)
		poo:scale(0.4,0.4)
		images:insert(poo)
		poo.myName="poo"
		return poo
	elseif poocounter==1 then
		poo1 = display.newImage("poo.png",120,120)
		poo1:scale(0.4,0.4)
		images:insert(poo1)
		poo1.myName="poo"
		return poo1
	elseif poocounter==2 then
		poo2 = display.newImage("poo.png",120,120)
		poo2:scale(0.4,0.4)
		images:insert(poo2)
		poo2.myName="poo"
		return poo2
	elseif poocounter==3 then
		poo3 = display.newImage("poo.png",120,120)
		poo3:scale(0.4,0.4)
		images:insert(poo3)
		poo3.myName="poo"
		return poo3
	else end
end

function shootIf(event)

	if event.phase=="ended" and (math.abs(event.xStart-event.x)>5 or math.abs(event.yStart-event.y)>5)  and ammo>0 then
		Runtime:removeEventListener("touch" , shoot)
		numbShots = numbShots + 1
		images:remove(arm)
		arm = display.newImage("arm.png",86,66)
		arm:scale(0.55,0.55)
		arm.xReference=39
		arm.yReference=-18
		images:insert(arm)
		rotatearmtimer3=timer.performWithDelay(20, rotateArm,8)
		resetarmtimer3=timer.performWithDelay(500, resetArmShot)
		ammo = ammo-1
		ammoText.text = "Ammo: "..ammo
		p = poop()
		physics.addBody(p,{radius=15})
		constantV(event.y,event.yStart,event.x, event.xStart,p)
		p:applyTorque(1)
		playthrowsound()
		clickable=false
		if ammo==9 then
			flash()
		end
	else end
end

function adjustMode(str)

	if str=="Normal" then
		crocspeed=700
		birdspeed=320
		snakespeed=260
		
		spawnRate=2500
		
	elseif str=="Challenge" then
		crocspeed=500
		birdspeed=265
		snakespeed=170
		
		spawnRate=2000
		
	end

end

function gameOverCroc(event)
	dbCroc = 1
	gameOver("croc")

end
function gameOverBird(event)
	dbBird = 1
	gameOver("bird")

end
function gameOverSnake(event)
	dbSnake = 1
	gameOver("snake")

end
function gameOverBoss(event)
	dbBoss=1
	gameOver("boss")

end

function tmeSet()

	timeInSec = 0
	seconds = -1
	minutes = 0

end

function gameOver(name)
	local oldscore=stat[0]
	current_game_stats()
	compare_stats()
	playgameoversound()
	timer.cancel(clockTimer)
	removeEventListeners()
	cancelTimers()
	physics.pause()
	if name=="croc" then
		gameOverPic = display.newImage("gameovercroc.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)

	elseif name =="bird" then
		gameOverPic = display.newImage("gameoverbird.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	elseif name=="snake" then
		gameOverPic = display.newImage("gameoversnake.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	elseif name=="boss" then
		gameOverPic = display.newImage("gameoverboss1.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	else end
	if score>oldscore then
		newhigh=display.newImage("newhighscore.png", rightX-210, 220)
		images:insert(newhigh)
	end
	menubutton=display.newImage("menu.png",rightX - 100,210)
	menubutton:scale(0.5,0.5)
	images:insert(menubutton)
	menubutton:addEventListener("tap", menuFromGO)
	refreshbutton=display.newImage("refresh.png",rightX - 70,180)
	refreshbutton:scale(1,1)
	images:insert(refreshbutton)
	refreshbutton:addEventListener("tap",resetGame)
	statbutton=display.newImage("stat.png",rightX - 110,260)
	statbutton:scale(0.5,0.5)
	images:insert(statbutton)
	statbutton:addEventListener("tap", displayStats)

	scoreBubble = display.newImage("bubble.png",rightX - 155,-18)
	scoreBubble:scale(0.8,0.4)
	images:insert(scoreBubble)

	Dscore = display.newText("Score: "..score,rightX - 120,5,"Georgia",20)
	Dscore:setTextColor(0,0,0)
	images:insert(Dscore)

	timeBubbleGO = display.newImage("bubble.png",rightX - 155,15)
	timeBubbleGO:scale(0.8,0.4)
	images:insert(timeBubbleGO)

	Dtime = display.newText("Time: "..timeText.text, rightX - 120,40,"Georgia", 20)
	Dtime:setTextColor(0,0,0)
	images:insert(Dtime)

end

function removeEventListeners()
	treebutton:removeEventListener( "tap" , eat)	--when treebutton is tapped, call eat
	Runtime:removeEventListener("touch" , shoot)	--when swiping anywhere on screen, call shoot
	Runtime:removeEventListener("collision", onCollision)
	pausebutton:removeEventListener("tap", pause)
	mutebutton:removeEventListener("tap", mute)
	pausebutton:removeEventListener("tap",pauseBeach)
	pausebutton:removeEventListener("tap",pauseSafari)

end

function displayStats()

	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	menubutton:removeEventListener("tap", menuFromGO)
	images:remove(menubutton)
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	images:remove(statbutton)
	statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)

	createStatsGO()



end

function menuFromPause()

	seconds = -1
	removeEventListeners()
	cancelTimers()
	removeImages()
	resetInstanceData()
	images:remove(pausepic)
	images:remove(menubutton)
	if splashtimer1~=nil then timer.resume(splashtimer1) else end
	if splashtimer2~=nil then timer.resume(splashtimer2) else end
	if splashtimer3~=nil then timer.resume(splashtimer3) else end
	refreshbutton:removeEventListener("tap",resetGame)
	menubutton:removeEventListener("tap", menuFromPause)
	images:remove(refreshbutton)
	createMenu()
	physics.start()


end

function menuFromGO()
	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	menubutton:removeEventListener("tap", menuFromGO)
	images:remove(menubutton)
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	images:remove(statbutton)
	statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)
	createMenu()
	physics.start()

end

function cancelTimers()
	if background2timer~=nil then timer.cancel(background2timer) else end
	if background3timer~=nil then timer.cancel(background3timer) else end
	if background4timer~=nil then timer.cancel(background4timer) else end
	if coconuttimer~=nil then timer.cancel(coconuttimer) else end
	if coconuttimer1~=nil then timer.cancel(coconuttimer1) else end
	if coconuttimer2~=nil then timer.cancel(coconuttimer2) else end
	if clickabletimer~=nil then timer.cancel(clickabletimer) else end
	if rotatetimer~=nil then timer.cancel(rotatetimer) else end
	if resetarmtimer~=nil then timer.cancel(resetarmtimer) else end
	if pooresettimer~=nil then timer.cancel(pooresettimer) else end
	if rotatetimer1~=nil then timer.cancel(rotatetimer1) else end
	if resetarmtimer1~=nil then timer.cancel(resetarmtimer1) else end
	if pooresettimer1~=nil then timer.cancel(pooresettimer1) else end
	if rotatetimer2~=nil then timer.cancel(rotatetimer2) else end
	if resetarmtimer2~=nil then timer.cancel(resetarmtimer2) else end
	if pooresettimer2~=nil then timer.cancel(pooresettimer2) else end
	if rotatetimer3~=nil then timer.cancel(rotatetimer3) else end
	if resetarmtimer3~=nil then timer.cancel(resetarmtimer3) else end
	if pooresettimer3~=nil then timer.cancel(pooresettimer3) else end
	if rotatenegativetimer~= nil then timer.cancel(rotatenegativetimer) else end
	if resetarmtimer1~=nil then timer.cancel(resetarmtimer1) else end
	if rotatepositivetimer~= nil then timer.cancel(rotatepositivetimer) else end
	if resetarmtimer2~=nil then timer.cancel(resetarmtimer2) else end
	if respawntimer~=nil then timer.cancel(respawntimer) else end
	if respawntimer1~=nil then timer.cancel(respawntimer1) else end
	if respawntimer2~=nil then timer.cancel(respawntimer2) else end
	if respawntimer3~=nil then timer.cancel(respawntimer3) else end
	if croctimer1~=nil then timer.cancel(croctimer1) else end
	if croctimer2~=nil then timer.cancel(croctimer2) else end
	if birdtimer~=nil then timer.cancel(birdtimer) else end
	if bird2timer~=nil then timer.cancel(bird2timer) else end
	if spawncroctimer~=nil then timer.cancel(spawncroctimer) else end
	if snaketimer~=nil then timer.cancel(snaketimer) else end
	if snaketimer1~=nil then timer.cancel(snaketimer1) else end
	if snaketimer2~=nil then timer.cancel(snaketimer2) else end
	if snaketimer3~=nil then timer.cancel(snaketimer3) else end
	if snaketimer4~=nil then timer.cancel(snaketimer4) else end
	if spawnagaintimer~=nil then timer.cancel(spawnagaintimer) else end
	if splashtimer1~=nil then timer.cancel(splashtimer1) else end
	if splashtimer2~=nil then timer.cancel(splashtimer2) else end
	--if splashtimer3~=nil then timer.cancel(splashtimer3) else end
	if topsnaketimer~=nil then timer.cancel(topsnaketimer) else end
	if GOcroc ~=nil then timer.cancel(GOcroc) else end
	if GOsnake ~=nil then timer.cancel(GOsnake) else end
	if GOsnake1 ~=nil then timer.cancel(GOsnake1) else end
	if GObird ~=nil then timer.cancel(GObird) else end
	if GObird2 ~=nil then timer.cancel(GObird2) else end
	if birdhittimer~=nil then timer.cancel(birdhittimer) else end
	if bird2hittimer~=nil then timer.cancel(bird2hittimer) else end
	if bird3hittimer~=nil then timer.cancel(bird3hittimer) else end
	if snakehittimer~=nil then timer.cancel(snakehittimer) else end
	if topsnakehittimer~=nil then timer.cancel(topsnakehittimer) else end
	timer.cancel(spawntimer)
	if spawnratetimer~=nil then timer.cancel(spawnratetimer) end

end
function addBasic()
	pausebutton = display.newImage("pause.png",rightX - 100,bottomY -140)
	pausebutton:scale(0.3,0.3)
	images:insert(pausebutton)
	--add mute button
	mutebutton = display.newImage("muteoff.png",rightX - 95,bottomY - 100)
	mutebutton:scale(0.3,0.3)
	images:insert(mutebutton)

	--add timer clock button
	timerbubble = display.newImage("bubble.png",rightX - 265, topY-15)
	timerbubble:scale(0.6,0.4)
	images:insert(timerbubble)

	--add the tree button to screen, to make leaves clickable
	treebutton = display.newImage("treebutton.png",10,-140)
	treebutton:scale(0.2,0.2)
	images:insert(treebutton)

	--add arm to screen
	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18
	images:insert(arm)

	--add ammo count to screen
	ammobubble = display.newImage("bubble.png",rightX - 155,topY-15)---------------------------------------------------------bob
	ammobubble:scale(0.8,0.4)
	images:insert(ammobubble)

	ammoText = display.newText("Ammo: "..ammo,rightX - 115,topY + 10,"Georgia",20)
	ammoText:setTextColor( 0, 0, 0)
	images:insert(ammoText)

	timeText = display.newText("0:00",rightX - 205,topY + 10,"Georgia",20)
	timeText:setTextColor(0,0,0)
	images:insert(timeText)

	--add score to screen
	scorebubble = display.newImage("bubble.png",leftX -20 ,topY-15)
	scorebubble:scale(0.8,0.4)
	images:insert(scorebubble)

	scoreText = display.newText("Score: "..score,leftX + 15,topY + 10,"Georgia",20)
	scoreText:setTextColor( 0, 0, 0)
	images:insert(scoreText)

	heart1=display.newImage("heart.png",leftX + 130,0 + heartScale)
	heart1:scale(0.7,0.7)
	images:insert(heart1)
	heart2=display.newImage("heart.png",leftX + 155,0 + heartScale)
	heart2:scale(0.7,0.7)
	images:insert(heart2)
	heart3=display.newImage("heart.png",leftX + 180,0 + heartScale)
	heart3:scale(0.7,0.7)
	images:insert(heart3)


end
function removeImages()
	if birdisoff==false then bird:removeSelf() else end
	if bird2isoff==false then bird2:removeSelf() else end
	if bird3isoff==false then bird3:removeSelf() else end
	if crocisoff==false then croc:removeSelf() else end
	if snakeisoff==false then snake:removeSelf() else end
	if topsnakeisoff==false then topsnake:removeSelf() else end
	if bossisoff==false then boss:removeSelf() else end
	if bgisoff==false then images:remove(background) else end
	if location=="jungle" and bg2isoff==false then images:remove(background2) else end
	if location=="jungle" and bg3isoff==false then images:remove(background3) else end
	if location=="jungle" and bg4isoff==false then images:remove(background4) else end
	if coconuts~=nil then images:remove(coconuts) end
	coconuts=nil
	if safarileaves~=nil then images:remove(safarileaves) end
	safarileaves=nil
	if newhigh~=nil then images:remove(newhigh) end
	removepoosplat()
	removepoosplat1()
	
	if heartcount==3 then images:remove(heart1)
		images:remove(heart2)
		images:remove(heart3)
	elseif heartcount==2 then images:remove(heart1)
		images:remove(heart2)
	else images:remove(heart1) end
	images:remove(arm)
	images:remove(pausebutton)
	images:remove(mutebutton)
	images:remove(treebutton)
	images:remove(ammobubble)
	images:remove(ammoText)
	images:remove(scorebubble)
	images:remove(timeText)
	images:remove(treebutton)
	images:remove(scoreText)
	images:remove(timerbubble)
end

function resetGame()
	seconds = -1
	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	images:remove(menubutton)
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	images:remove(statbutton)
	statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)
	run()


end
function resetFromPause()

	seconds = -1
	removeEventListeners()
	cancelTimers()
	removeImages()
	resetInstanceData()
	images:remove(pausepic)
	images:remove(menubutton)
	if splashtimer1~=nil then timer.resume(splashtimer1) else end
	if splashtimer2~=nil then timer.resume(splashtimer2) else end
	if splashtimer3~=nil then timer.resume(splashtimer3) else end
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	run()
end

function resetInstanceData()

	--reset instance data
	score = 0
	ammo=25

	poocounter=0
	splatcounter=0
	flashCounter = 0
	isFlash = false
	snakecount = 0
	xsnake = -50
	ysnake =	250
	snakerotate=15
	topsnakecount=0
	spidercount=0

	birdcountnew=0
	birdcountold=0
	xbird=500
	ybird=120

	bird2countnew=0
	bird2countold=0
	xbird2=500
	ybird2=0

	bird3countnew=0
	bird3countold=0
	xbird3=-100
	ybird3=0

	clickable = false
	paused = false
	rotatable = true
	growing = false
	heartcount=3
	coconuts=nil

	snakeisoff=true
	topsnakeisoff=true
	birdisoff=true
	bird2isoff=true
	crocisoff=true
	bg2isoff=true
	bg3isoff=true
	bg4isoff=true
	bossisoff=true

	bosshitcount=3
	setbosshitcount=3
	bossbodytype="static"
	bossSpawnCounter = 0
	-- spawntemp=2000
	spawnRate=2500
	
	multiSpawn=1
	spawnAgain=0
 attack7counter =0

end

function read()

	--local path = system.pathForFile("challengeStats.txt",system.DocumentsDirectory)
	local path = system.pathForFile(fileName,system.DocumentsDirectory)
	local file = io.open(path, "r")
	for x = 0,9,1 do
		stat[x] = file:read("*n")
		--display.newText(file:read("*n"), 200,100 + 20*x,"Georgia", 20)
		--display.newText(tostring(stat[x]), 200,100 + 20*x,"Georgia", 20)
	end
	io.close(file)
	--display.newText(tostring(stats[4]), 200,100,"Georgia", 20)
	file = nil

end

function write()

	local path = system.pathForFile(fileName,system.DocumentsDirectory)
	local file = io.open(path, "w+")
	for x = 0,9,1 do
		file:write(stat[x],"\n")
	end
	io.close(file)
	file = nil
end

--sets up all the stats for the main stats
function compare_stats()
	timeInSec = timeInSec -1

	if(score > stat[0]) then		--compares the high scores and lifeTime might want to display a message
		stat[0] = score
	end

	if(timeInSec > stat[2])then
		stat[2] = timeInSec
	end

	stat[7] = stat[7] + numbShots		--takes the number of shots shot in the last game as adds it to the total
	stat[8] = stat[8] + hits			--takes the number of hits made in the last game and adds them to the total

	stat[3] = stat[3] + 1		-- increments total deaths counter buy one
	stat[4] = stat[4] + dbCroc  -- increments total deaths by crock
	stat[5] = stat[5] + dbBird	--increments total deaths by bird
	stat[6] = stat[6] + dbSnake	--increments total deaths by snake
	stat[9] = stat[9] + dbBoss --increments total deaths by boss

	if(stat[7]>0)then
		stat[1] = stat[8]/stat[7]	--creates total accuracy
	else
		stat[1]=0
	end

	write()
end

local function timerClock()

	seconds = seconds + 1
	timeInSec = timeInSec + 1

	if(seconds == 60)then
		seconds = 0
		minutes = minutes + 1
	end
	local s = string.format("%02d", seconds)
	
	
	
	

	timeText.text = minutes..":"..s
	clockTimer = timer.performWithDelay(1000,timerClock)
end

function reset_stats()
	dbCroc = 0
	dbBird = 0
	dbSnake = 0
	dbBoss = 0
	accuracy = 0
	lifeTime = 0
	hits = 0
	numbShots = 0
end


function run()
	location = "jungle"
	score=0
	ammo=20
	tmeSet()
	--writeFirst()
	--programersWrite()-------------------------------------------
	adjustMode(mode)
	physics.start()
	audio.resume()
	growLeaf()
	--spawnagaintimer=timer.performWithDelay(birdspawntime,spawnBird2)
	--spawnBird2()
	--spawnSnakeBottom()
	--spawnSnakeTop()
	--spawnBird()
	--spawncroctimer=timer.performWithDelay(crocspawntime,spawnCroc)
	--=timer.performWithDelay(crocspawntime,spawnCroc)
	spawn()
	addBasic()
	timerClock()
	--listeners upSpawntime

	treebutton:addEventListener( "tap" , eat)	--when treebutton is tapped, call eat
	Runtime:addEventListener("touch" , shoot)	--when swiping anywhere on screen, call shoot
	Runtime:addEventListener("collision", onCollision)
	pausebutton:addEventListener("tap", pause)
	mutebutton:addEventListener("tap", mute)
	read()
	reset_stats()
end



function current_game_stats()

	if(numbShots>0) then
		accuracy = hits*100/numbShots
	else
		accuracy = 0
	end

	lifeTime = timeText.text
	score2 = score
end

function programersWrite()--used to wipe the stats file and reset all values

	local path = system.pathForFile(fileName,system.DocumentsDirectory)
	local file = io.open(path, "w+")
	file:write(0,"\n")
	file:write(0,"\n")
	for x = 2,10,1 do
		file:write(0,"\n")
	end
	io.close(file)
	file = nil

end

function convertSToM(s)

	if(s>=60)then
		fileSec = s%60
		fileMin = s - fileSec
		fileMin = fileMin/60
	else
		fileSec = s
		fileMin = 0
	end
end


function tutorial()

	bg = display.newImage("tutorial1.png",-275,-245)
	bg:scale (alter,0.50)
	images:insert(1,bg)

	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18
	images:insert(2,arm)

	arrow1 = display.newImage("arrow.png",420,280)
	arrow1:addEventListener("tap", tutorial1)
	images:insert(arrow1)

end
function spawnBirdTut()
	--birdisoff=false
	xbird=500
	ybird=120
	if bird~=nil then images:remove(bird) end
	physics.start()
	bird=display.newImage("birdup.png",xbird,ybird)
	images:insert(bird)
	bird.myName="bird"
	birdtimer=timer.performWithDelay(250, moveBird, 13)
	rsptn=timer.performWithDelay(3500,spawnBirdTut)
	--GObird=timer.performWithDelay(15*birdspeed,birdhit)
	physics.addBody(bird,{radius=10})
end

function tutorial1()

	images:remove(bg)
	images:remove(arrow1)
	bg = display.newImage("tutorial2.png",-275,-245)
	bg:scale (alter,0.50)
	images:insert(1,bg)

	spawnBirdTut()
	Runtime:addEventListener("touch",tutorialShoot)
	Runtime:addEventListener("collision",tutorialCollide)

end
function tutorialCollide(event)

	timer.cancel(birdtimer)
	timer.cancel(rsptn)
	images:remove(event.object1)
	images:remove(event.object2)
	Runtime:removeEventListener("touch",tutorialShoot)
	Runtime:removeEventListener("collision",tutorialCollide)
	arrow1 = display.newImage("arrow.png",420,280)
	arrow1:addEventListener("tap", tutorial2)
	images:insert(arrow1)
	xbird=500
	ybird=120

end

function tutorialShoot(event)

	if event.phase=="ended" and event.xStart~=event.x then
		images:remove(arm)
		arm = display.newImage("arm.png",86,66)
		arm:scale(0.55,0.55)
		arm.xReference=39
		arm.yReference=-18
		images:insert(arm)
		rotatearmtimer3=timer.performWithDelay(20, rotateArm,8)
		resetarmtimer3=timer.performWithDelay(500, resetArm)
		p = poop()
		physics.addBody(p,{radius=15})
		constantV(event.y,event.yStart,event.x, event.xStart,p)
		p:applyTorque(1)
		playthrowsound()
	end

end

function tutorial2()

	images:remove(bg)
	images:remove(arrow1)
	bg = display.newImage("tutorial3.png",-275,-245)
	bg:scale (alter,0.50)
	images:insert(1,bg)

	ammobubble = display.newImage("bubble.png",rightX - 150,topY-15)
	ammobubble:scale(0.7,0.4)
	images:insert(ammobubble)

	treebutton = display.newImage("treebutton.png",10,-140)
	treebutton:scale(0.14,0.14)
	images:insert(treebutton)

	ammoText = display.newText("Ammo: "..ammo,rightX - 110,topY + 10,"Georgia",20)
	ammoText:setTextColor( 0, 0, 0)
	images:insert(ammoText)

	treebutton:addEventListener("tap",tutorialEat)

end
function tutorialEat()
	rotatepositivetimer=timer.performWithDelay(1, rotateArmPositive,10)
	resetarmtimer2=timer.performWithDelay(500, rotateResetTut)
	playeatsound()
	images:remove(bg)
	growLeafTut()
	treebutton:removeEventListener("tap",tutorialEat)
	timer.performWithDelay(2000,tutorial3)
end
function growLeafTut()


	addAmmo()
	background = display.newImage("background1.png",-275,-245)
	background:scale (alter,0.50)

	images:insert(1,background)
	bgisoff=false

	background2timer=timer.performWithDelay(500,background2listener)
	background3timer=timer.performWithDelay(1000,background3listener)
	background4timer=timer.performWithDelay(1500,background4listener)

end
function tutorial3()

	ready=display.newImage("ready.png",320,240)
	ready:scale(0.7,0.7)
	images:insert(ready)

	ready:addEventListener("tap", finishTutorial)
end
function finishTutorial()

	images:remove(arm)
	images:remove(ready)
	images:remove(4,background4)
	images:remove(3,background3)
	images:remove(2,background2)
	images:remove(1,background)
	images:remove(ammobubble)
	images:remove(ammoText)

	createMenu()

end

function toScale()
	local t = 0.48

	if string.sub(system.getInfo("model"),1,4) == "iPad" then
		alter = t
		infoScale = 0.60
		infoScaleY = 0.73
		shift = 20
		GOShift = -15
		heartScale = -20
	elseif string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight > 960 then
		alter = 0.56
		infoScale = 0.67
		infoScaleY = 0.67
		GOShift = 0
	elseif string.sub(system.getInfo("model"),1,2) == "iP" then
		infoScale = 0.60
		alter = t
		shift = 20
		infoScaleY = 0.67
		GOShift = 0
	elseif display.pixelHeight / display.pixelWidth > 1.72 then
		infoScale = 0.73
		alter = 0.56
		shift = 30
		infoScaleY = 0.67
		GOShift = 0
	else
		alter = 0.56
		infoScale = 0.68
		shift = 20
		infoScaleY = 0.68
		GOShift = 0
		GOShiftX = 0
	end
end

function linkWipe()
	fileName = "normalStats.txt"
	programersWrite()
	fileName = "challengeStats.txt"
	programersWrite()
	fileName = "normalStats.txt"
end

timer.performWithDelay(700,splashStart)   --first call

--------------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-------------------------------------------------Beach Level Code-----------------------------------------
function  runbeach()
	location = "beach"
	score=0
	ammo=20
	tmeSet()
	--writeFirst()
	--programersWrite()-------------------------------------------
	adjustMode(mode)
	physics.start()
	audio.resume()
	growCoconuts()
	--spawnagaintimer=timer.performWithDelay(birdspawntime,spawnBird2)
	--spawnBird2()
	--spawnSnakeBottom()
	--spawnSnakeTop()
	--spawnBird()
	--spawncroctimer=timer.performWithDelay(crocspawntime,spawnCroc)
	--=timer.performWithDelay(crocspawntime,spawnCroc)
	spawnb()
	addBasicBeach()
	timerClock()
	--listeners

	treebutton:addEventListener( "tap" , eatBeach)	--when treebutton is tapped, call eat
	Runtime:addEventListener("touch" , shoot)	--when swiping anywhere on screen, call shoot
	Runtime:addEventListener("collision", onCollision)
	pausebutton:addEventListener("tap", pauseBeach)
	mutebutton:addEventListener("tap", mute)
	read()
	reset_stats()
end

function addBasicBeach()

	pausebutton = display.newImage("pause.png",rightX - 100,bottomY -140)
	pausebutton:scale(0.3,0.3)
	images:insert(pausebutton)
	--add mute button
	mutebutton = display.newImage("muteoff.png",rightX - 95,bottomY - 100)
	mutebutton:scale(0.3,0.3)
	images:insert(mutebutton)

	--add timer clock button
	timerbubble = display.newImage("bubble.png",rightX - 265, topY-15)
	timerbubble:scale(0.6,0.4)
	images:insert(timerbubble)

	--add the tree button to screen, to make leaves clickable
	treebutton = display.newImage("treebutton.png",10,-140)
	treebutton:scale(0.2,0.2)
	images:insert(treebutton)

	--add arm to screen
	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18
	images:insert(arm)

	--add ammo count to screen
	ammobubble = display.newImage("bubble.png",rightX - 155,topY-15)---------------------------------------------------------bob
	ammobubble:scale(0.8,0.4)
	images:insert(ammobubble)

	ammoText = display.newText("Ammo: "..ammo,rightX - 115,topY + 10,"Georgia",20)
	ammoText:setTextColor( 0, 0, 0)
	images:insert(ammoText)

	timeText = display.newText("0:00",rightX - 205,topY + 10,"Georgia",20)
	timeText:setTextColor(0,0,0)
	images:insert(timeText)

	--add score to screen
	scorebubble = display.newImage("bubble.png",leftX -20 ,topY-15)
	scorebubble:scale(0.8,0.4)
	images:insert(scorebubble)

	scoreText = display.newText("Score: "..score,leftX + 15,topY + 10,"Georgia",20)
	scoreText:setTextColor( 0, 0, 0)
	images:insert(scoreText)

	heart1=display.newImage("heart.png",leftX + 130,0 + heartScale)
	heart1:scale(0.7,0.7)
	images:insert(heart1)
	heart2=display.newImage("heart.png",leftX + 155,0 + heartScale)
	heart2:scale(0.7,0.7)
	images:insert(heart2)
	heart3=display.newImage("heart.png",leftX + 180,0 + heartScale)
	heart3:scale(0.7,0.7)
	images:insert(heart3)
	background = display.newImage("beach.png", -275, -245)
	background:scale(alter, 0.50)
	images:insert(1,background)
	bgisoff=false

end





function scaleCoconuts()
	coconuts:scale(1.5,1.5)

end

function growCoconuts()

	clickable=false
	growing = true

	if coconuts~=nil then images:remove(coconuts) end
	coconuts=nil
	coconuttimer=timer.performWithDelay(2000,spawnCoconuts)
	coconuttimer1=timer.performWithDelay(4000,scaleCoconuts)
	coconuttimer2=timer.performWithDelay(6000,scaleCoconuts)
	clickabletimer=timer.performWithDelay(6000, clickableTrue)

end

function spawnCoconuts()

	coconuts=display.newImage("coconuts.png",220,0)
	coconuts:scale(0.2,0.2)
	images:insert(coconuts)

end

function eatBeach()
	if clickable == true and paused==false then
		eatLeaf()
		growCoconuts()
		playeatsound()
	else end
end

local function moveShark1()
	images:remove(croc)
	croc = display.newImage("shark2.png",50,80)
	croc:scale (0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
end

local function moveShark2()
	images:remove(croc)
	croc = display.newImage("shark3.png",45,0)
	croc:scale (0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
end

function spawnShark()
	crocisoff=false
	croc=display.newImage("shark1.png",65,162)
	croc:scale(0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
	crocsplash()
	croctimer1=timer.performWithDelay(crocspeed,moveShark1)
	croctimer2=timer.performWithDelay(2*crocspeed,moveShark2)
	GOcroc = timer.performWithDelay(3*crocspeed,gameOverShark)
	playsplashsound()
end

function spawnSeagull()
	birdisoff=false
	bird=display.newImage("seagullup.png",xbird,ybird)
	images:insert(bird)
	bird.myName="bird"
	birdtimer = timer.performWithDelay(birdspeed, moveSeagull, 13)
	GObird=timer.performWithDelay(15*birdspeed,seagullhit)
	physics.addBody(bird,{radius=10})
end



function spawnSeagull2()
	bird2isoff=false
	bird2=display.newImage("seagullup.png",xbird2,ybird2)
	images:insert(bird2)
	bird2.myName="bird2"
	bird2timer = timer.performWithDelay(birdspeed, moveSeagull2, 13)
	GObird2=timer.performWithDelay(15*birdspeed,seagull2hit)
	physics.addBody(bird2,{radius=10})
end

function moveSeagull()
	images:remove(bird)
	if birdcountnew == 0 then
		bird = display.newImage("seagullmid.png",xbird,ybird-10)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 0 then
		bird = display.newImage("seagulldown.png",xbird,ybird-20)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 2 then
		bird = display.newImage("seagullup.png",xbird,ybird)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1

	else
		bird = display.newImage("seagullmid.png",xbird,ybird-10)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1
	end

	physics.addBody(bird,{radius=10})
end

function moveSeagull2()
	images:remove(bird2)
	if bird2countnew == 0 then
		bird2 = display.newImage("seagullmid.png",xbird2,ybird2-10)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew+1

	elseif bird2countnew == 1 and bird2countold == 0 then
		bird2 = display.newImage("seagulldown.png",xbird2,ybird2-20)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew+1

	elseif bird2countnew == 1 and bird2countold == 2 then
		bird2 = display.newImage("seagullup.png",xbird2,ybird2)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew-1

	else
		bird2 = display.newImage("seagullmid.png",xbird2,ybird2-10)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew-1
	end

	ybird2=ybird2+7
	bird2:rotate(-25)
	physics.addBody(bird2,{radius=10})
end

function spawnSeagull3()
	topsnakeisoff=false
	topsnake=display.newImage("seagullup.png",xbird3,ybird3)
	images:insert(topsnake)
	topsnake:scale(-1,1)
	topsnake.myName="topsnake"
	physics.addBody(topsnake,{radius=10})
	topsnaketimer=timer.performWithDelay(birdspeed, moveSeagull3, 13)
	GOsnake1 = timer.performWithDelay(15*birdspeed,seagull3hit)

end

function moveSeagull3()
	images:remove(topsnake)
	if bird3countnew == 0 then
		topsnake = display.newImage("seagullmid.png",xbird3,ybird3-10)
		images:insert(topsnake)
		topsnake.myName="topsnake"
		topsnake.xOrigin = topsnake.xOrigin+20
		xbird3 = xbird3+20
		bird3countold = bird3countnew
		bird3countnew = bird3countnew+1

	elseif bird3countnew == 1 and bird3countold == 0 then
		topsnake = display.newImage("seagulldown.png",xbird3,ybird3-20)
		images:insert(topsnake)
		topsnake.myName="topsnake"
		topsnake.xOrigin = topsnake.xOrigin+20
		xbird3 = xbird3+20
		bird3countold = bird3countnew
		bird3countnew = bird3countnew+1

	elseif bird3countnew == 1 and bird3countold == 2 then
		topsnake = display.newImage("seagullup.png",xbird3,ybird3)
		images:insert(topsnake)
		topsnake.myName="topsnake"
		topsnake.xOrigin = topsnake.xOrigin+20
		xbird3 = xbird3+20
		bird3countold = bird3countnew
		bird3countnew = bird3countnew-1

	else
		topsnake = display.newImage("seagullmid.png",xbird3,ybird3-10)
		images:insert(topsnake)
		topsnake.myName="topsnake"
		topsnake.xOrigin = topsnake.xOrigin+20
		xbird3 = xbird3+20
		bird3countold = bird3countnew
		bird3countnew = bird3countnew-1
	end

	ybird3=ybird3+7
	topsnake:scale(-1,1)
	topsnake:rotate(25)
	physics.addBody(topsnake,{radius=10})
end

function seagullhit()
	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		birdhittimer=timer.performWithDelay(1000,seagullhit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		birdhittimer=timer.performWithDelay(1000,seagullhit,1)
	elseif heartcount==1 then gameOverSeagull()
	end

end

function seagull2hit()
	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		bird2hittimer=timer.performWithDelay(1000,seagull2hit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		bird2hittimer=timer.performWithDelay(1000,seagull2hit,1)
	elseif heartcount==1 then gameOverSeagull()
	end

end

function seagull3hit()

	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		topsnakehittimer=timer.performWithDelay(1000,seagull3hit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		topsnakehittimer=timer.performWithDelay(1000,seagull3hit,1)
	elseif heartcount==1 then gameOverSeagull()
	end
end

function spawnCrab()
	if bossSpawnCounter>20 then spawnBossBeach()
	bossSpawnCounter=0
	else
		snakeisoff=false
		snake=display.newImage("crab.png",leftX-40 ,190)
		physics.addBody(snake, {shape=snakeshape})
		snake.myName="snake"
		snake:scale(-0.4,0.4)
		images:insert(snake)
		snaketimer=timer.performWithDelay(snakespeed, moveCrab, 37)
		--snaketimer1 =timer.performWithDelay(31*snakespeed, rotateSnakeBottomListener)
		GOsnake = timer.performWithDelay(39*snakespeed,crabhit)
	end


end


function moveCrab()

	snake.x=snake.x+4
	snake.y=snake.y-3.5

	if snakecount==2 then
		snake:scale(-1,1)
	elseif snakecount==4 then
		snake:scale(-1,1)
		snakecount=0
	end
	snakecount=snakecount+1
	snake.bodyType=bossbodytype
end

function moveCrabBoss()

	boss.x=boss.x+4
	boss.y=boss.y-3.5

	if snakecount==2 then
		boss:scale(-1,1)
	elseif snakecount==4 then
		boss:scale(-1,1)
		snakecount=0
	end
	snakecount=snakecount+1
	boss.bodyType=bossbodytype
end

function spawnBossBeach()

	bossisoff=false
	boss=display.newImage("crab.png",leftX-40 ,200)
	physics.addBody(boss, {shape=snakeshape})
	boss.myName="beachboss"
	boss:scale(-1.4,1.4)
	images:insert(boss)
	snaketimer=timer.performWithDelay(snakespeed, moveCrabBoss, 37)
	--snaketimer1 =timer.performWithDelay(31*snakespeed, rotateSnakeBottomListener)
	GOsnake = timer.performWithDelay(39*snakespeed,gameOverBossB)
	boss.bodyType=bossbodytype

end
function gameOverBossB(event)
	dbBoss=1
	gameOverBeach("boss")

end

function crabhit()
	playhurtsound()
	if heartcount==3 then images:remove(heart3)
		heartcount=2
		snakehittimer=timer.performWithDelay(1000,crabhit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		snakehittimer=timer.performWithDelay(1000,crabhit,1)
	elseif heartcount==1 then gameOverCrab()
	end


end
function gameOverShark()
	dbCroc = 1
	gameOverBeach("shark")

end
function gameOverSeagull(event)
	dbBird = 1
	gameOverBeach("bird")

end
function gameOverCrab()

	dbSnake = 1
	gameOverBeach("snake")


end
function gameOverBeach(name)
	local oldscore=stat[0]
	current_game_stats()
	compare_stats()
	playgameoversound()
	timer.cancel(clockTimer)
	removeEventListeners()
	cancelTimers()
	physics.pause()
	if name=="shark" then
		gameOverPic = display.newImage("gameovershark.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)

	elseif name =="bird" then
		gameOverPic = display.newImage("gameoverseagull.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	elseif name=="snake" then
		gameOverPic = display.newImage("gameovercrab.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	elseif name=="boss" then
		gameOverPic = display.newImage("gameoverboss2.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	else	 end
	if score>oldscore then
		newhigh=display.newImage("newhighscore.png", rightX-210, 220)
		images:insert(newhigh)
	end
	menubutton=display.newImage("menu.png",rightX - 100,210)
	menubutton:scale(0.5,0.5)
	images:insert(menubutton)
	menubutton:addEventListener("tap", menuFromGOBeach)
	refreshbutton=display.newImage("refresh.png",rightX - 70,180)
	refreshbutton:scale(1,1)
	images:insert(refreshbutton)
	refreshbutton:addEventListener("tap",resetGameBeach)
	statbutton=display.newImage("stat.png",rightX - 110,260)
	statbutton:scale(0.56,0.56)
	images:insert(statbutton)
	statbutton:addEventListener("tap", displayStatsBeach)

	scoreBubble = display.newImage("bubble.png",rightX - 155,-18)
	scoreBubble:scale(0.8,0.4)
	images:insert(scoreBubble)

	Dscore = display.newText("Score: "..score,rightX - 120,5,"Georgia",20)
	Dscore:setTextColor(0,0,0)
	images:insert(Dscore)

	timeBubbleGO = display.newImage("bubble.png",rightX - 155,15)
	timeBubbleGO:scale(0.8,0.4)
	images:insert(timeBubbleGO)

	Dtime = display.newText("Time: "..timeText.text, rightX - 120,40,"Georgia", 20)
	Dtime:setTextColor(0,0,0)
	images:insert(Dtime)


end

function resetGameBeach()
	seconds = -1
	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	images:remove(menubutton)
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	images:remove(statbutton)
	statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)
	runbeach()


end

function pauseBeach()


	if paused==false then
		pausepic = display.newImage("paus.png",140,200)
		--pausepic.alpha=0.9
		images:insert(pausepic)
		images:remove(pausebutton)
		pausebutton = display.newImage("playy.png",rightX - 100,bottomY -140)
		pausebutton:scale(0.3,0.3)
		images:insert(pausebutton)
		pausebutton:addEventListener("tap",pauseBeach)

		timer.pause(clockTimer)
		paused=true
		physics.pause()
		if spawnratetimer~=nil then timer.pause(spawnratetimer) end
		if background2timer~=nil then timer.pause(background2timer) else end
		if background3timer~=nil then timer.pause(background3timer) else end
		if background4timer~=nil then timer.pause(background4timer) else end
		if coconuttimer~=nil then timer.pause(coconuttimer) else end
		if coconuttimer1~=nil then timer.pause(coconuttimer1) else end
		if coconuttimer2~=nil then timer.pause(coconuttimer2) else end
		if clickabletimer~=nil then timer.pause(clickabletimer) else end
		if rotatetimer~=nil then timer.pause(rotatetimer) else end
		if resetarmtimer~=nil then timer.pause(resetarmtimer) else end
		if pooresettimer~=nil then timer.pause(pooresettimer) else end
		if rotatetimer1~=nil then timer.pause(rotatetimer1) else end
		if resetarmtimer1~=nil then timer.pause(resetarmtimer1) else end
		if pooresettimer1~=nil then timer.pause(pooresettimer1) else end
		if rotatetimer2~=nil then timer.pause(rotatetimer2) else end
		if resetarmtimer2~=nil then timer.pause(resetarmtimer2) else end
		if pooresettimer2~=nil then timer.pause(pooresettimer2) else end
		if rotatetimer3~=nil then timer.pause(rotatetimer3) else end
		if resetarmtimer3~=nil then timer.pause(resetarmtimer3) else end
		if pooresettimer3~=nil then timer.pause(pooresettimer3) else end
		if rotatenegativetimer~= nil then timer.pause(rotatenegativetimer) else end
		if resetarmtimer1~=nil then timer.pause(resetarmtimer1) else end
		if rotatepositivetimer~= nil then timer.pause(rotatepositivetimer) else end
		if resetarmtimer2~=nil then timer.pause(resetarmtimer2) else end
		if respawntimer~=nil then timer.pause(respawntimer) else end
		if respawntimer1~=nil then timer.pause(respawntimer1) else end
		if respawntimer2~=nil then timer.pause(respawntimer2) else end
		if respawntimer3~=nil then timer.pause(respawntimer3) else end
		if croctimer1~=nil then timer.pause(croctimer1) else end
		if croctimer2~=nil then timer.pause(croctimer2) else end
		if birdtimer~=nil then timer.pause(birdtimer) else end
		if bird2timer~=nil then timer.pause(bird2timer) else end
		if spawncroctimer~=nil then timer.pause(spawncroctimer) else end
		if snaketimer~=nil then timer.pause(snaketimer) else end
		if snaketimer1~=nil then timer.pause(snaketimer1) else end
		if snaketimer2~=nil then timer.pause(snaketimer2) else end
		if snaketimer3~=nil then timer.pause(snaketimer3) else end
		if snaketimer4~=nil then timer.pause(snaketimer4) else end
		if spawnagaintimer~=nil then timer.pause(spawnagaintimer) else end
		if splashtimer1~=nil then timer.pause(splashtimer1) else end
		if splashtimer2~=nil then timer.pause(splashtimer2) else end
		if splashtimer3~=nil then timer.pause(splashtimer3) else end
		if topsnaketimer~=nil then timer.pause(topsnaketimer) else end
		if GOcroc ~=nil then timer.pause(GOcroc) else end
		if GOsnake ~=nil then timer.pause(GOsnake) else end
		if GOsnake1 ~=nil then timer.pause(GOsnake1) else end
		if GObird ~=nil then timer.pause(GObird) else end
		if GObird2 ~=nil then timer.pause(GObird2) else end
		if birdhittimer~=nil then timer.pause(birdhittimer) else end
		if bird2hittimer~=nil then timer.pause(bird2hittimer) else end
		if bird3hittimer~=nil then timer.pause(bird3hittimer) else end
		if snakehittimer~=nil then timer.pause(snakehittimer) else end
		if topsnakehittimer~=nil then timer.pause(topsnakehittimer) else end
		timer.pause(spawntimer)
		audio.pause()
		menubutton=display.newImage("menu.png",rightX - 100,bottomY - 150)
		menubutton:scale(0.5,0.5)
		menubutton:addEventListener("tap", menuFromPause)
		images:insert(menubutton)
		refreshbutton=display.newImage("refresh.png",rightX - 50,bottomY -180)
		refreshbutton:scale(1,1)
		images:insert(refreshbutton)
		refreshbutton:addEventListener("tap",resetFromPauseBeach)

	else paused = false
		images:remove(pausepic)
		images:remove(pausebutton)
		pausebutton = display.newImage("pause.png",rightX - 100,bottomY -140)
		pausebutton:scale(0.3,0.3)
		images:insert(pausebutton)
		pausebutton:addEventListener("tap",pauseBeach)

		physics.start()
		timer.resume(clockTimer)
		if spawnratetimer~=nil then timer.resume(spawnratetimer) end
		if background2timer~=nil then timer.resume(background2timer) else end
		if background3timer~=nil then timer.resume(background3timer) else end
		if background4timer~=nil then timer.resume(background4timer) else end
		if coconuttimer~=nil then timer.resume(coconuttimer) else end
		if coconuttimer1~=nil then timer.resume(coconuttimer1) else end
		if coconuttimer2~=nil then timer.resume(coconuttimer2) else end
		if clickabletimer~=nil then timer.resume(clickabletimer) else end
		if rotatetimer~=nil then timer.resume(rotatetimer) else end
		if resetarmtimer~=nil then timer.resume(resetarmtimer) else end
		if pooresettimer~=nil then timer.resume(pooresettimer) else end
		if rotatetimer1~=nil then timer.resume(rotatetimer1) else end
		if resetarmtimer1~=nil then timer.resume(resetarmtimer1) else end
		if pooresettimer1~=nil then timer.resume(pooresettimer1) else end
		if rotatetimer2~=nil then timer.resume(rotatetimer2) else end
		if resetarmtimer2~=nil then timer.resume(resetarmtimer2) else end
		if pooresettimer2~=nil then timer.resume(pooresettimer2) else end
		if rotatetimer3~=nil then timer.resume(rotatetimer3) else end
		if resetarmtimer3~=nil then timer.resume(resetarmtimer3) else end
		if pooresettimer3~=nil then timer.resume(pooresettimer3) else end
		if rotatenegativetimer~= nil then timer.resume(rotatenegativetimer) else end
		if resetarmtimer1~=nil then timer.resume(resetarmtimer1) else end
		if rotatepositivetimer~= nil then timer.resume(rotatepositivetimer) else end
		if resetarmtimer2~=nil then timer.resume(resetarmtimer2) else end
		if respawntimer~=nil then timer.resume(respawntimer) else end
		if respawntimer1~=nil then timer.resume(respawntimer1) else end
		if respawntimer2~=nil then timer.resume(respawntimer2) else end
		if respawntimer3~=nil then timer.resume(respawntimer3) else end
		if croctimer1~=nil then timer.resume(croctimer1) else end
		if croctimer2~=nil then timer.resume(croctimer2) else end
		if birdtimer~=nil then timer.resume(birdtimer) else end
		if bird2timer~=nil then timer.resume(bird2timer) else end
		if spawncroctimer~=nil then timer.resume(spawncroctimer) else end
		if snaketimer~=nil then timer.resume(snaketimer) else end
		if snaketimer1~=nil then timer.resume(snaketimer1) else end
		if snaketimer2~=nil then timer.resume(snaketimer2) else end
		if snaketimer3~=nil then timer.resume(snaketimer3) else end
		if snaketimer4~=nil then timer.resume(snaketimer4) else end
		if spawnagaintimer~=nil then timer.resume(spawnagaintimer) else end
		if splashtimer1~=nil then timer.resume(splashtimer1) else end
		if splashtimer2~=nil then timer.resume(splashtimer2) else end
		if splashtimer3~=nil then timer.resume(splashtimer3) else end
		if topsnaketimer~=nil then timer.resume(topsnaketimer) else end
		if GOcroc ~=nil then timer.resume(GOcroc) else end
		if GOsnake ~=nil then timer.resume(GOsnake) else end
		if GOsnake1 ~=nil then timer.resume(GOsnake1) else end
		if GObird ~=nil then timer.resume(GObird) else end
		if GObird2 ~=nil then timer.resume(GObird2) else end
		if birdhittimer~=nil then timer.resume(birdhittimer) else end
		if bird2hittimer~=nil then timer.resume(bird2hittimer) else end
		if bird3hittimer~=nil then timer.resume(bird3hittimer) else end
		if snakehittimer~=nil then timer.resume(snakehittimer) else end
		if topsnakehittimer~=nil then timer.resume(topsnakehittimer) else end
		timer.resume(spawntimer)
		audio.resume()
		images:remove(menubutton)
		images:remove(refreshbutton)
		refreshbutton:removeEventListener("tap",resetFromPauseBeach)
		menubutton:removeEventListener("tap", menuFromPause)
	end

end


function resetFromPauseBeach()
	seconds = -1
	removeEventListeners()
	cancelTimers()
	removeImages()
	resetInstanceData()
	images:remove(pausepic)
	images:remove(menubutton)
	if splashtimer1~=nil then timer.resume(splashtimer1) else end
	if splashtimer2~=nil then timer.resume(splashtimer2) else end
	if splashtimer3~=nil then timer.resume(splashtimer3) else end
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	runbeach()


end

function menuFromGOBeach()
	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	--menubutton:removeEventListener("tap", menuFromGO)
	images:remove(menubutton)
	--refreshbutton:removeEventListener("tap",resetGameBeach)
	images:remove(refreshbutton)
	images:remove(statbutton)
	statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)
	createMenu()
	physics.start()

end

function displayStatsBeach()

	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	--menubutton:removeEventListener("tap", menuFromGO)
	images:remove(menubutton)
	--refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	images:remove(statbutton)
	--statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)

	createStatsGOBeach()



end

function addHeart()

	if heartcount==2 then
		heartcount=3
		heart3=display.newImage("heart.png",leftX + 180,0 + heartScale)
		heart3:scale(0.7,0.7)
		images:insert(heart3)
		playheartsound()
	elseif heartcount==1 then
		heartcount=2
		heart2=display.newImage("heart.png",leftX + 155,0 + heartScale)
		heart2:scale(0.7,0.7)
		images:insert(heart2)
		playheartsound()
	end


end
----^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--------------------------------------------------------Safari level code--------------------

function addBasicSafari()

	pausebutton = display.newImage("pause.png",rightX - 100,bottomY -140)
	pausebutton:scale(0.3,0.3)
	images:insert(pausebutton)
	--add mute button
	mutebutton = display.newImage("muteoff.png",rightX - 95,bottomY - 100)
	mutebutton:scale(0.3,0.3)
	images:insert(mutebutton)

	--add timer clock button
	timerbubble = display.newImage("bubble.png",rightX - 265, topY-15)
	timerbubble:scale(0.6,0.4)
	images:insert(timerbubble)

	--add the tree button to screen, to make leaves clickable
	treebutton = display.newImage("treebutton.png",10,-100)
	treebutton:scale(0.2,0.2)
	images:insert(treebutton)

	--add arm to screen
	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18
	images:insert(arm)

	--add ammo count to screen
	ammobubble = display.newImage("bubble.png",rightX - 155,topY-15)---------------------------------------------------------bob
	ammobubble:scale(0.8,0.4)
	images:insert(ammobubble)

	ammoText = display.newText("Ammo: "..ammo,rightX - 115,topY + 10,"Georgia",20)
	ammoText:setTextColor( 0, 0, 0)
	images:insert(ammoText)

	timeText = display.newText("0:00",rightX - 205,topY + 10,"Georgia",20)
	timeText:setTextColor(0,0,0)
	images:insert(timeText)

	--add score to screen
	scorebubble = display.newImage("bubble.png",leftX -20 ,topY-15)
	scorebubble:scale(0.8,0.4)
	images:insert(scorebubble)

	scoreText = display.newText("Score: "..score,leftX + 15,topY + 10,"Georgia",20)
	scoreText:setTextColor( 0, 0, 0)
	images:insert(scoreText)

	heart1=display.newImage("heart.png",leftX + 130,0 + heartScale)
	heart1:scale(0.7,0.7)
	images:insert(heart1)
	heart2=display.newImage("heart.png",leftX + 155,0 + heartScale)
	heart2:scale(0.7,0.7)
	images:insert(heart2)
	heart3=display.newImage("heart.png",leftX + 180,0 + heartScale)
	heart3:scale(0.7,0.7)
	images:insert(heart3)
	background = display.newImage("safari.png", -275, -245)
	background:scale(alter, 0.50)
	images:insert(1,background)
	bgisoff=false

end


function  runsafari()
	location = "safari"
	score=0
	ammo=20
	tmeSet()
	--writeFirst()
	--programersWrite()-------------------------------------------
	adjustMode(mode)
	physics.start()
	audio.resume()
	growSafari()
	safarileaves=nil
	--spawnagaintimer=timer.performWithDelay(birdspawntime,spawnBird2)
	--spawnBird2()
	--spawnSnakeBottom()
	--spawnSnakeTop()
	--spawnBird()
	--spawncroctimer=timer.performWithDelay(crocspawntime,spawnCroc)
	--=timer.performWithDelay(crocspawntime,spawnCroc)
	spawns()
	addBasicSafari()
	timerClock()
--listeners

	treebutton:addEventListener( "tap" , eatSafari)	--when treebutton is tapped, call eat
	Runtime:addEventListener("touch" , shoot)	--when swiping anywhere on screen, call shoot
	Runtime:addEventListener("collision", onCollision)
	pausebutton:addEventListener("tap", pauseSafari)
	mutebutton:addEventListener("tap", mute)
	read()
	reset_stats()
end

function pauseSafari()


	if paused==false then
		pausepic = display.newImage("paus.png",140,200)
		--pausepic.alpha=0.9
		images:insert(pausepic)
		images:remove(pausebutton)
		pausebutton = display.newImage("playy.png",rightX - 100,bottomY -140)
		pausebutton:scale(0.3,0.3)
		images:insert(pausebutton)
		pausebutton:addEventListener("tap",pauseSafari)

		timer.pause(clockTimer)
		paused=true
		physics.pause()
		if spawnratetimer~=nil then timer.pause(spawnratetimer) end
		if background2timer~=nil then timer.pause(background2timer) else end
		if background3timer~=nil then timer.pause(background3timer) else end
		if background4timer~=nil then timer.pause(background4timer) else end
		if coconuttimer~=nil then timer.pause(coconuttimer) else end
		if coconuttimer1~=nil then timer.pause(coconuttimer1) else end
		if coconuttimer2~=nil then timer.pause(coconuttimer2) else end
		if clickabletimer~=nil then timer.pause(clickabletimer) else end
		if rotatetimer~=nil then timer.pause(rotatetimer) else end
		if resetarmtimer~=nil then timer.pause(resetarmtimer) else end
		if pooresettimer~=nil then timer.pause(pooresettimer) else end
		if rotatetimer1~=nil then timer.pause(rotatetimer1) else end
		if resetarmtimer1~=nil then timer.pause(resetarmtimer1) else end
		if pooresettimer1~=nil then timer.pause(pooresettimer1) else end
		if rotatetimer2~=nil then timer.pause(rotatetimer2) else end
		if resetarmtimer2~=nil then timer.pause(resetarmtimer2) else end
		if pooresettimer2~=nil then timer.pause(pooresettimer2) else end
		if rotatetimer3~=nil then timer.pause(rotatetimer3) else end
		if resetarmtimer3~=nil then timer.pause(resetarmtimer3) else end
		if pooresettimer3~=nil then timer.pause(pooresettimer3) else end
		if rotatenegativetimer~= nil then timer.pause(rotatenegativetimer) else end
		if resetarmtimer1~=nil then timer.pause(resetarmtimer1) else end
		if rotatepositivetimer~= nil then timer.pause(rotatepositivetimer) else end
		if resetarmtimer2~=nil then timer.pause(resetarmtimer2) else end
		if respawntimer~=nil then timer.pause(respawntimer) else end
		if respawntimer1~=nil then timer.pause(respawntimer1) else end
		if respawntimer2~=nil then timer.pause(respawntimer2) else end
		if respawntimer3~=nil then timer.pause(respawntimer3) else end
		if croctimer1~=nil then timer.pause(croctimer1) else end
		if croctimer2~=nil then timer.pause(croctimer2) else end
		if birdtimer~=nil then timer.pause(birdtimer) else end
		if bird2timer~=nil then timer.pause(bird2timer) else end
		if spawncroctimer~=nil then timer.pause(spawncroctimer) else end
		if snaketimer~=nil then timer.pause(snaketimer) else end
		if snaketimer1~=nil then timer.pause(snaketimer1) else end
		if snaketimer2~=nil then timer.pause(snaketimer2) else end
		if snaketimer3~=nil then timer.pause(snaketimer3) else end
		if snaketimer4~=nil then timer.pause(snaketimer4) else end
		if spawnagaintimer~=nil then timer.pause(spawnagaintimer) else end
		if splashtimer1~=nil then timer.pause(splashtimer1) else end
		if splashtimer2~=nil then timer.pause(splashtimer2) else end
		if splashtimer3~=nil then timer.pause(splashtimer3) else end
		if topsnaketimer~=nil then timer.pause(topsnaketimer) else end
		if GOcroc ~=nil then timer.pause(GOcroc) else end
		if GOsnake ~=nil then timer.pause(GOsnake) else end
		if GOsnake1 ~=nil then timer.pause(GOsnake1) else end
		if GObird ~=nil then timer.pause(GObird) else end
		if GObird2 ~=nil then timer.pause(GObird2) else end
		if birdhittimer~=nil then timer.pause(birdhittimer) else end
		if bird2hittimer~=nil then timer.pause(bird2hittimer) else end
		if bird3hittimer~=nil then timer.pause(bird3hittimer) else end
		if snakehittimer~=nil then timer.pause(snakehittimer) else end
		if topsnakehittimer~=nil then timer.pause(topsnakehittimer) else end
		timer.pause(spawntimer)
		audio.pause()
		menubutton=display.newImage("menu.png",rightX - 100,bottomY - 150)
		menubutton:scale(0.5,0.5)
		menubutton:addEventListener("tap", menuFromPause)
		images:insert(menubutton)
		refreshbutton=display.newImage("refresh.png",rightX - 50,bottomY -180)
		refreshbutton:scale(1,1)
		images:insert(refreshbutton)
		refreshbutton:addEventListener("tap",resetFromPauseSafari)

	else paused = false
		images:remove(pausepic)
		images:remove(pausebutton)
		pausebutton = display.newImage("pause.png",rightX - 100,bottomY -140)
		pausebutton:scale(0.3,0.3)
		images:insert(pausebutton)
		pausebutton:addEventListener("tap",pauseSafari)

		physics.start()
		timer.resume(clockTimer)
		if spawnratetimer~=nil then timer.resume(spawnratetimer) end
		if background2timer~=nil then timer.resume(background2timer) else end
		if background3timer~=nil then timer.resume(background3timer) else end
		if background4timer~=nil then timer.resume(background4timer) else end
		if coconuttimer~=nil then timer.resume(coconuttimer) else end
		if coconuttimer1~=nil then timer.resume(coconuttimer1) else end
		if coconuttimer2~=nil then timer.resume(coconuttimer2) else end
		if clickabletimer~=nil then timer.resume(clickabletimer) else end
		if rotatetimer~=nil then timer.resume(rotatetimer) else end
		if resetarmtimer~=nil then timer.resume(resetarmtimer) else end
		if pooresettimer~=nil then timer.resume(pooresettimer) else end
		if rotatetimer1~=nil then timer.resume(rotatetimer1) else end
		if resetarmtimer1~=nil then timer.resume(resetarmtimer1) else end
		if pooresettimer1~=nil then timer.resume(pooresettimer1) else end
		if rotatetimer2~=nil then timer.resume(rotatetimer2) else end
		if resetarmtimer2~=nil then timer.resume(resetarmtimer2) else end
		if pooresettimer2~=nil then timer.resume(pooresettimer2) else end
		if rotatetimer3~=nil then timer.resume(rotatetimer3) else end
		if resetarmtimer3~=nil then timer.resume(resetarmtimer3) else end
		if pooresettimer3~=nil then timer.resume(pooresettimer3) else end
		if rotatenegativetimer~= nil then timer.resume(rotatenegativetimer) else end
		if resetarmtimer1~=nil then timer.resume(resetarmtimer1) else end
		if rotatepositivetimer~= nil then timer.resume(rotatepositivetimer) else end
		if resetarmtimer2~=nil then timer.resume(resetarmtimer2) else end
		if respawntimer~=nil then timer.resume(respawntimer) else end
		if respawntimer1~=nil then timer.resume(respawntimer1) else end
		if respawntimer2~=nil then timer.resume(respawntimer2) else end
		if respawntimer3~=nil then timer.resume(respawntimer3) else end
		if croctimer1~=nil then timer.resume(croctimer1) else end
		if croctimer2~=nil then timer.resume(croctimer2) else end
		if birdtimer~=nil then timer.resume(birdtimer) else end
		if bird2timer~=nil then timer.resume(bird2timer) else end
		if spawncroctimer~=nil then timer.resume(spawncroctimer) else end
		if snaketimer~=nil then timer.resume(snaketimer) else end
		if snaketimer1~=nil then timer.resume(snaketimer1) else end
		if snaketimer2~=nil then timer.resume(snaketimer2) else end
		if snaketimer3~=nil then timer.resume(snaketimer3) else end
		if snaketimer4~=nil then timer.resume(snaketimer4) else end
		if spawnagaintimer~=nil then timer.resume(spawnagaintimer) else end
		if splashtimer1~=nil then timer.resume(splashtimer1) else end
		if splashtimer2~=nil then timer.resume(splashtimer2) else end
		if splashtimer3~=nil then timer.resume(splashtimer3) else end
		if topsnaketimer~=nil then timer.resume(topsnaketimer) else end
		if GOcroc ~=nil then timer.resume(GOcroc) else end
		if GOsnake ~=nil then timer.resume(GOsnake) else end
		if GOsnake1 ~=nil then timer.resume(GOsnake1) else end
		if GObird ~=nil then timer.resume(GObird) else end
		if GObird2 ~=nil then timer.resume(GObird2) else end
		if birdhittimer~=nil then timer.resume(birdhittimer) else end
		if bird2hittimer~=nil then timer.resume(bird2hittimer) else end
		if bird3hittimer~=nil then timer.resume(bird3hittimer) else end
		if snakehittimer~=nil then timer.resume(snakehittimer) else end
		if topsnakehittimer~=nil then timer.resume(topsnakehittimer) else end
		timer.resume(spawntimer)
		audio.resume()
		images:remove(menubutton)
		images:remove(refreshbutton)
		refreshbutton:removeEventListener("tap",resetFromPauseSafari)
		menubutton:removeEventListener("tap", menuFromPause)
	end

end




function scaleSafari()
	safarileaves:scale(1.5,1.5)

end

function growSafari()

	clickable=false
	growing = true

	if safarileaves~=nil then images:remove(safarileaves) end
	safarileaves=nil
	coconuttimer=timer.performWithDelay(2000,spawnSafariLeaves)
	coconuttimer1=timer.performWithDelay(4000,scaleSafari)
	coconuttimer2=timer.performWithDelay(6000,scaleSafari)
	clickabletimer=timer.performWithDelay(6000, clickableTrue)

end

function spawnSafariLeaves()

	safarileaves=display.newImage("safarileaves.png",230,30)
	safarileaves:scale(0.2,0.2)
	images:insert(safarileaves)

end

function eatSafari()
	if clickable == true and paused==false then
		eatLeaf()
		growSafari()
		playeatsound()
	else end
end

function resetFromPauseSafari()
	seconds = -1
	removeEventListeners()
	cancelTimers()
	removeImages()
	resetInstanceData()
	images:remove(pausepic)
	images:remove(menubutton)
	if splashtimer1~=nil then timer.resume(splashtimer1) else end
	if splashtimer2~=nil then timer.resume(splashtimer2) else end
	if splashtimer3~=nil then timer.resume(splashtimer3) else end
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	runsafari()


end

function resetGameSafari()
	seconds = -1
	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	images:remove(menubutton)
	refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	images:remove(statbutton)
	statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)
	runsafari()


end

function gameOverSafari(name)
	local oldscore=stat[0]
	current_game_stats()
	compare_stats()
	playgameoversound()
	timer.cancel(clockTimer)
	removeEventListeners()
	cancelTimers()
	physics.pause()
	if name=="shark" then
		gameOverPic = display.newImage("gameovercat.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)

	elseif name =="bird" then
		gameOverPic = display.newImage("gameovereagle.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	elseif name=="snake" then
		gameOverPic = display.newImage("gameoverspider.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	elseif name=="boss" then
		gameOverPic = display.newImage("gameoverboss3.png",-275 + GOShiftX, -205 + GOShift)
		gameOverPic:scale (alter,0.50)
		images:insert(gameOverPic)
	else end
	if score>oldscore then
		newhigh=display.newImage("newhighscore.png", rightX-210, 220)
		images:insert(newhigh)
	end
	menubutton=display.newImage("menu.png",rightX - 100,210)
	menubutton:scale(0.5,0.5)
	images:insert(menubutton)
	menubutton:addEventListener("tap", menuFromGOBeach)
	refreshbutton=display.newImage("refresh.png",rightX - 70,180)
	refreshbutton:scale(1,1)
	images:insert(refreshbutton)
	refreshbutton:addEventListener("tap",resetGameSafari)
	statbutton=display.newImage("stat.png",rightX - 110,260)
	statbutton:scale(0.56,0.56)
	images:insert(statbutton)
	statbutton:addEventListener("tap", displayStatsSafari)
scoreBubble = display.newImage("bubble.png",rightX - 155,-18)
	scoreBubble:scale(0.8,0.4)
	images:insert(scoreBubble)

	Dscore = display.newText("Score: "..score,rightX - 120,5,"Georgia",20)
	Dscore:setTextColor(0,0,0)
	images:insert(Dscore)

	timeBubbleGO = display.newImage("bubble.png",rightX - 155,15)
	timeBubbleGO:scale(0.8,0.4)
	images:insert(timeBubbleGO)

	Dtime = display.newText("Time: "..timeText.text, rightX - 120,40,"Georgia", 20)
	Dtime:setTextColor(0,0,0)
	images:insert(Dtime)

end

function spawnEagle()
	birdisoff=false
	bird=display.newImage("eagleup.png",xbird,ybird)
	images:insert(bird)
	bird.myName="bird"
	birdtimer = timer.performWithDelay(birdspeed, moveEagle, 13)
	GObird=timer.performWithDelay(15*birdspeed,eaglehit)
	physics.addBody(bird,{radius=10})
end

function moveEagle()
	images:remove(bird)
	if birdcountnew == 0 then
		bird = display.newImage("eaglemid.png",xbird,ybird-10)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 0 then
		bird = display.newImage("eagledown.png",xbird,ybird-20)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew+1

	elseif birdcountnew == 1 and birdcountold == 2 then
		bird = display.newImage("eagleup.png",xbird,ybird)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1

	else
		bird = display.newImage("eaglemid.png",xbird,ybird-10)
		images:insert(bird)
		bird.myName="bird"
		bird.xOrigin = bird.xOrigin-20
		xbird = xbird-20
		birdcountold = birdcountnew
		birdcountnew = birdcountnew-1
	end

	physics.addBody(bird,{radius=10})
end



function gameOverEagle(event)
	dbBird = 1
	gameOverSafari("bird")

end
function gameOverCat()
	dbCroc = 1
	gameOverSafari("shark")

end
function gameOverSpider()

	dbSnake = 1
	gameOverSafari("snake")
end

function eaglehit()
	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		birdhittimer=timer.performWithDelay(1000,eaglehit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		birdhittimer=timer.performWithDelay(1000,eaglehit,1)
	elseif heartcount==1 then gameOverEagle()
	end

end

function eagle2hit()
	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		bird2hittimer=timer.performWithDelay(1000,eagle2hit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		bird2hittimer=timer.performWithDelay(1000,eagle2hit,1)
	elseif heartcount==1 then gameOverEagle()
	end

end

function spiderhit()
	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		snakehittimer=timer.performWithDelay(1000,spiderhit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		snakehittimer=timer.performWithDelay(1000,spiderhit,1)
	elseif heartcount==1 then gameOverSpider()
	end

end

function spider2hit()

	playhurtsound()

	if heartcount==3 then images:remove(heart3)
		heartcount=2
		topsnakehittimer=timer.performWithDelay(1000,spider2hit,1)
	elseif heartcount==2 then images:remove(heart2)
		heartcount=1
		topsnakehittimer=timer.performWithDelay(1000,spider2hit,1)
	elseif heartcount==1 then gameOverSpider()
	end

end

function displayStatsSafari()

	removeEventListeners()
	cancelTimers()
	images:remove(gameOverPic)
	removeImages()
	resetInstanceData()
	--menubutton:removeEventListener("tap", menuFromGO)
	images:remove(menubutton)
	--refreshbutton:removeEventListener("tap",resetGame)
	images:remove(refreshbutton)
	images:remove(statbutton)
	--statbutton:removeEventListener("tap", displayStats)
	images:remove(timeBubbleGO)
	images:remove(Dtime)
	images:remove(Dscore)
	images:remove(scoreBubble)

	createStatsGOSafari()



end


function spawnEagle2()
	bird2isoff=false
	bird2=display.newImage("eagleup.png",xbird2,ybird2)
	images:insert(bird2)
	bird2.myName="bird2"
	bird2timer = timer.performWithDelay(birdspeed, moveEagle2, 13)
	GObird2=timer.performWithDelay(15*birdspeed,eagle2hit)
	physics.addBody(bird2,{radius=10})
end

function moveEagle2()
	images:remove(bird2)
	if bird2countnew == 0 then
		bird2 = display.newImage("eaglemid.png",xbird2,ybird2-10)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew+1

	elseif bird2countnew == 1 and bird2countold == 0 then
		bird2 = display.newImage("eagledown.png",xbird2,ybird2-20)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew+1

	elseif bird2countnew == 1 and bird2countold == 2 then
		bird2 = display.newImage("eagleup.png",xbird2,ybird2)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew-1

	else
		bird2 = display.newImage("eaglemid.png",xbird2,ybird2-10)
		images:insert(bird2)
		bird2.myName="bird2"
		bird2.xOrigin = bird2.xOrigin-20
		xbird2 = xbird2-20
		bird2countold = bird2countnew
		bird2countnew = bird2countnew-1
	end

	ybird2=ybird2+7
	bird2:rotate(-25)
	physics.addBody(bird2,{radius=10})
end

local function moveCat1()
	images:remove(croc)
	croc = display.newImage("cat2.png",65,80)
	croc:scale (0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
end

local function moveCat2()
	images:remove(croc)
	croc = display.newImage("cat3.png",45,20)
	croc:scale (0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
end

function spawnCat()
	crocisoff=false
	croc=display.newImage("cat1.png",65,162)
	croc:scale(0.5,0.5)
	croc.myName="croc"
	images:insert(croc)
	physics.addBody(croc,{shape=crocshape})
	--crocsplash()
	croctimer1=timer.performWithDelay(crocspeed,moveCat1)
	croctimer2=timer.performWithDelay(2*crocspeed,moveCat2)
	GOcroc = timer.performWithDelay(3*crocspeed,gameOverCat)
	playroarsound()
end

function spawnSpider()
	if bossSpawnCounter>20 then
		spawnSpiderBoss()
		bossSpawnCounter=0
	else
		snakeisoff=false
		snake=display.newImage("spider.png",leftX + 10,250)
		physics.addBody(snake, {radius=10})
		snake.myName="snake"
		snake:scale(-0.7,-0.7)
		images:insert(snake)
		snaketimer=timer.performWithDelay(snakespeed, moveSpider, 29)
		snaketimer1 =timer.performWithDelay(31*snakespeed, moveSpiderRightListener)
		GOsnake = timer.performWithDelay(43*snakespeed,spiderhit)
	end

end

function moveSpider (event)
	if snakeisoff==false then
		snake.yOrigin = snake.yOrigin-7 end

	if snakecount == 1 then
		snake:scale(-1,1)
	elseif snakecount==3 then
		snake:scale(-1,1)
		snakecount=-1
	else end
	snakecount=snakecount+1
end

function moveSpiderRightListener()
	snaketimer3=timer.performWithDelay(snakespeed,moveSpiderRight,11)
	snake:rotate(90)
end
function moveSpiderRight()

	snake.xOrigin=snake.xOrigin+10
	if snakecount==1 then
		snake:scale(-1,1)
	elseif snakecount==3 then
		snake:scale(-1,1)
		snakecount=-1
	else end
	snakecount=snakecount+1
end



function spawnSpiderTop()
	if snakeisoff==true and bossisoff==true then
		topsnakeisoff=false
		topsnake=display.newImage("spider.png",leftX,topY+25)
		topsnake:rotate(-90)
		physics.addBody(topsnake, {radius=10})
		topsnake.myName="topsnake"
		topsnake:scale(-0.7,0.7)
		images:insert(topsnake)
		topsnaketimer=timer.performWithDelay(snakespeed, moveSpiderTop, 14)
		GOsnake1 = timer.performWithDelay(16*snakespeed,spider2hit)
	elseif 	snakeisoff==false and snake.yOrigin>225 then
			topsnakeisoff=false
			topsnake=display.newImage("spider.png",leftX,topY+25)
			topsnake:rotate(-90)
			physics.addBody(topsnake, {radius=10})
			topsnake.myName="topsnake"
			topsnake:scale(-0.7,0.7)
			images:insert(topsnake)
			topsnaketimer=timer.performWithDelay(snakespeed, moveSpiderTop, 14)
			GOsnake1 = timer.performWithDelay(16*snakespeed,spider2hit)
	elseif bossisoff==false and boss.yOrigin>225 then
			topsnakeisoff=false
			topsnake=display.newImage("spider.png",leftX,topY+25)
			topsnake:rotate(-90)
			physics.addBody(topsnake, {radius=10})
			topsnake.myName="topsnake"
			topsnake:scale(-0.7,0.7)
			images:insert(topsnake)
			topsnaketimer=timer.performWithDelay(snakespeed, moveSpiderTop, 14)
			GOsnake1 = timer.performWithDelay(16*snakespeed,spider2hit)
	else
	end
end

function moveSpiderTop()

	if topsnakeisoff==false then
		if spidercount<6 then
			topsnake.xOrigin=topsnake.xOrigin+10
			topsnake.yOrigin=topsnake.yOrigin+5
		else
			topsnake.xOrigin=topsnake.xOrigin+10 end
		if topsnakecount==1 then
			topsnake:scale(-1,1)

		elseif topsnakecount==3 then
			topsnake:scale(-1,1)
			topsnakecount=-1
		else end

		topsnakecount=topsnakecount+1
		spidercount=spidercount+1
	end
end

function spawnSpiderBoss()

	bossisoff=false
	boss=display.newImage("spider.png",leftX + 10,250)
	physics.addBody(boss, {radius=20})
	boss.myName="safariboss"
	boss:scale(2,-2)
	images:insert(boss)
	snaketimer=timer.performWithDelay(snakespeed, moveSpiderBoss, 29)
	snaketimer1 =timer.performWithDelay(31*snakespeed, moveSpiderRightListenerBoss)
	GOsnake = timer.performWithDelay(43*snakespeed,gameOverBossS)
	boss.bodyType=bossbodytype


end
function gameOverBossS(event)
	dbBoss=1
	gameOverSafari("boss")

end
function moveSpiderBoss (event)
	if bossisoff==false then
		boss.yOrigin = boss.yOrigin-7 end

	if snakecount == 1 then
		boss:scale(-1,1)
	elseif snakecount==3 then
		boss:scale(-1,1)
		snakecount=-1
	else end
	snakecount=snakecount+1
end
function moveSpiderRightListenerBoss()
	snaketimer3=timer.performWithDelay(snakespeed,moveSpiderRightBoss,11)
	boss:rotate(90)
end

function moveSpiderRightBoss()

	boss.xOrigin=boss.xOrigin+10
	if snakecount==1 then
		boss:scale(-1,1)
	elseif snakecount==3 then
		boss:scale(-1,1)
		snakecount=-1
	else end
	snakecount=snakecount+1
end
---^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


------Spawn Algorithm Code-----------------------------------
function upSpawnRate()

	if (mode == "Normal") then
		spawnRate = spawnRate+150
	else spawnRate = spawnRate+100 
	end
	--spawntemp=spawnRate

end

function numbSpawn()

	local numb = 45
	local temp = multiSpawn
	
	if mode=="Challenge" then
		numb = 30
	end
	
	if(timeInSec <= numb) then
		multiSpawn = 1
	elseif (timeInSec <= numb*3)then
		multiSpawn = 2
		
	elseif (timeInSec <= numb*6)then
		multiSpawn = 3
	elseif (timeInSec <= numb*12) then
		multiSpawn = 4
	else
		multiSpawn = 5
	end
	
	if temp~=multiSpawn then
		upSpawnRate()
	end
		
end

function spawn()
	numbSpawn()
	local nextSpawn=spawnRate
	local attack = 7
	if attack7counter<15 then
		attack = math.random(0,6)
	end

	if(attack==0)then
		if birdisoff==true and bossisoff==true then spawnBird()
		elseif crocisoff==true and crocspawncounter>6 then spawnCroc()
			crocspawncounter=0
		elseif topsnakeisoff==true then spawnSnakeTop() 
		elseif birdisoff==true and bossisoff==true then spawnBird() 
		elseif bird2isoff==true then spawnBird2() 
		elseif snakeisoff==true then spawnSnakeBottom() 
		else
		end
	elseif(attack == 1) then
		if bird2isoff==true then spawnBird2()
		elseif crocisoff==true and crocspawncounter>6 then spawnCroc()
			crocspawncounter=0
		elseif snakeisoff==true then spawnSnakeBottom() 
		elseif birdisoff==true and bossisoff==true then spawnBird() 
		elseif bird2isoff==true then spawnBird2() 
		elseif topsnakeisoff==true then spawnSnakeTop() 
		else
		end
	elseif(attack == 2) then
		if snakeisoff==true then spawnSnakeBottom()
		elseif crocisoff==true and crocspawncounter>6 then spawnCroc()
			crocspawncounter=0
		elseif birdisoff==true and bossisoff==true then spawnBird() 
		elseif topsnakeisoff==true then spawnSnakeTop() 
		elseif birdisoff==true and bossisoff==true then spawnBird() 
		elseif bird2isoff==true then spawnBird2() 
		elseif snakeisoff==true then spawnSnakeBottom() 
		else
		end
	elseif(attack ==3)then
		if topsnakeisoff==true then spawnSnakeTop()
		elseif crocisoff==true and crocspawncounter>6 then spawnCroc()
			crocspawncounter=0
		elseif bird2isoff==true then spawnBird2() 
		elseif topsnakeisoff==true then spawnSnakeTop() 
		elseif birdisoff==true and bossisoff==true then spawnBird() 
		elseif bird2isoff==true then spawnBird2() 
		elseif snakeisoff==true then spawnSnakeBottom() 
		else
		end
	elseif(attack ==4)then
	
		if crocisoff==true and crocspawncounter>6 then spawnCroc()
			crocspawncounter=0
		elseif topsnakeisoff==true then spawnSnakeTop() 
		elseif birdisoff==true and bossisoff==true then spawnBird() 
		elseif bird2isoff==true then spawnBird2() 
		elseif snakeisoff==true then spawnSnakeBottom() 
		else
		end
	elseif(attack == 5)then
		if topsnakeisoff==true then spawnSnakeTop()
		elseif crocisoff==true and crocspawncounter>6 then spawnCroc()
			crocspawncounter=0
		elseif topsnakeisoff==true then spawnSnakeTop() 
		elseif birdisoff==true and bossisoff==true then spawnBird() 
		elseif bird2isoff==true then spawnBird2() 
		elseif snakeisoff==true then spawnSnakeBottom() 
		else
		end

	elseif(attack==6) then
		if crocisoff==true and crocspawncounter>6 then spawnCroc()
			crocspawncounter=0
		elseif bird2isoff==true then spawnBird2() 
		elseif topsnakeisoff==true then spawnSnakeTop() 
		elseif birdisoff==true and bossisoff==true then spawnBird()
		elseif snakeisoff==true then spawnSnakeBottom() 
		else
		end

	elseif(attack==7) then
		if birdisoff==true and bossisoff==true then spawnBird() end
		if bird2isoff==true then  spawnBird2() end
		if snakeisoff==true then  spawnSnakeBottom() end
		if topsnakeisoff==true then spawnSnakeTop() end
		if crocisoff==true then spawnCroc()
			crocspawncounter=0 end
		nextSpawn=6000
		attack7counter=0
	end
	spawnAgain = spawnAgain + 1
	attack7counter=attack7counter+1
	if spawnAgain == multiSpawn then 

		bossSpawnCounter=bossSpawnCounter+1
		crocspawncounter= crocspawncounter+1
		spawntimer = timer.performWithDelay(nextSpawn, spawn)
		spawnAgain = 0
	else
		spawnagaintimer = timer.performWithDelay(150,spawn)
	end

end

function spawnb()

	numbSpawn()
	local nextSpawn=spawnRate
	local attack = 7
	if attack7counter<15 then
		attack = math.random(0,6)
	end
	--spawnRate=spawntemp

	if(attack==0)then
		if birdisoff==true then spawnSeagull() 
		elseif birdisoff==true then spawnSeagull() 
		elseif bird2isoff==true then spawnSeagull2() 
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		else
		end
	elseif(attack == 1) then
		if bird2isoff==true then spawnSeagull2()
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		elseif topsnakeisoff==true then spawnSeagull3() 
		elseif birdisoff==true then spawnSeagull() 
		elseif bird2isoff==true then spawnSeagull2() 
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		else
		end
	elseif(attack == 2) then
		if snakeisoff==true and bossisoff==true then spawnCrab()
		elseif topsnakeisoff==true then spawnSeagull3() 
		elseif birdisoff==true then spawnSeagull() 
		elseif bird2isoff==true then spawnSeagull2() 
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		else
		end
	elseif(attack ==3)then
		if topsnakeisoff==true then spawnSeagull3()
		elseif topsnakeisoff==true then spawnSeagull3() 
		elseif birdisoff==true then spawnSeagull() 
		elseif bird2isoff==true then spawnSeagull2() 
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		else
		end
	elseif(attack ==4)then
		if crocisoff==true and crocspawncounter>6 then spawnShark()
			crocspawncounter=0
		elseif birdisoff==true then spawnSeagull() 
		elseif bird2isoff==true then spawnSeagull2() 
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		else
		end
	elseif(attack == 5)then
		if topsnakeisoff==true then spawnSeagull3()
		elseif topsnakeisoff==true then spawnSeagull3() 
		elseif birdisoff==true  then spawnSeagull() 
		elseif bird2isoff==true then spawnSeagull2() 
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		else
		end

	elseif(attack==6) then
		if crocisoff==true and crocspawncounter>6 then spawnShark()
			crocspawncounter=0
		elseif topsnakeisoff==true then spawnSeagull3() 
		elseif birdisoff==true  then spawnSeagull() 
		elseif bird2isoff==true then spawnSeagull2() 
		elseif snakeisoff==true and bossisoff==true then spawnCrab()
		else
		end

	elseif(attack==7) then
		if birdisoff==true then spawnSeagull() end
		if bird2isoff==true then  spawnSeagull2() end
		if snakeisoff==true and bossisoff==true then spawnCrab()end
		if topsnakeisoff==true then spawnSeagull3() end
		if crocisoff==true then spawnShark()
			crocspawncounter=0 end
		--spawntemp=spawnRate
		--spawnRate=4000
		attack7counter=0
		nextSpawn=6000
	end
spawnAgain = spawnAgain + 1
attack7counter=attack7counter+1
	if spawnAgain == multiSpawn then 
	bossSpawnCounter=bossSpawnCounter+1
	crocspawncounter= crocspawncounter+1
		spawntimer = timer.performWithDelay(spawnRate, spawnb)
		spawnAgain = 0
	else
		spawnagaintimer = timer.performWithDelay(150,spawnb)
	end
end


function spawns()

	numbSpawn()
	local nextSpawn=spawnRate
	local attack = 7
	if attack7counter<15 then
		attack = math.random(0,6)
	end
	--spawnRate=spawntemp

	if(attack==0)then
		if birdisoff==true then spawnEagle()
		elseif bird2isoff==true then spawnEagle2() 
		elseif snakeisoff==true and bossisoff==true then spawnSpider()
		else
		end
	elseif(attack == 1) then
		if bird2isoff==true then spawnEagle2()
		elseif snakeisoff==true and bossisoff==true then spawnSpider()
		elseif topsnakeisoff==true then spawnSpiderTop() 
		elseif birdisoff==true then spawnEagle() 
		elseif bird2isoff==true then spawnEagle2() 
		elseif snakeisoff==true and bossisoff==true then spawnSpider()
		else
		end
	elseif(attack == 2) then
		if snakeisoff==true and bossisoff==true then spawnSpider()
		elseif topsnakeisoff==true then spawnSpiderTop() 
		elseif birdisoff==true then spawnEagle() 
		elseif bird2isoff==true then spawnEagle2() 
		else
		end
	elseif(attack ==3)then
		if topsnakeisoff==true then spawnSpiderTop()
		elseif birdisoff==true then spawnEagle() 
		elseif bird2isoff==true then spawnEagle2() 
		elseif snakeisoff==true and bossisoff==true then spawnSpider()
		else
		end
	elseif(attack ==4)then
		if crocisoff==true and crocspawncounter>6 then spawnCat()
			crocspawncounter=0
		elseif birdisoff==true then spawnEagle() 
		elseif topsnakeisoff==true then spawnSpiderTop()  
		elseif bird2isoff==true then spawnEagle2() 
		elseif snakeisoff==true and bossisoff==true then spawnSpider()
		else
		end
	elseif(attack == 5)then
		if topsnakeisoff==true then spawnSpiderTop()
		elseif bird2isoff==true then spawnEagle2() 
		elseif snakeisoff==true and bossisoff==true then spawnSpider()
		elseif topsnakeisoff==true then spawnSpiderTop() 
		elseif birdisoff==true then spawnEagle() 
		else
		end

	elseif(attack==6) then
		if crocisoff==true and crocspawncounter>6 then spawnCat()
			crocspawncounter=0
		elseif birdisoff==true then spawnEagle() 
		elseif bird2isoff==true then spawnEagle2() 
		elseif snakeisoff==true and bossisoff==true then spawnSpider()
		else
		end

	elseif(attack==7) then
		if birdisoff==true then spawnEagle() end
		if bird2isoff==true then  spawnEagle2() end
		if snakeisoff==true and bossisoff==true then spawnSpider()end
		if topsnakeisoff==true then spawnSpiderTop() end
		if crocisoff==true then spawnCat()
			crocspawncounter=0 end
		nextSpawn=6000
		attack7counter=0
	end
	spawnAgain = spawnAgain + 1
	attack7counter=attack7counter+1
	if spawnAgain == multiSpawn then 

		bossSpawnCounter=bossSpawnCounter+1
		crocspawncounter= crocspawncounter+1
		spawntimer = timer.performWithDelay(spawnRate, spawns)
		spawnAgain = 0
	else
		spawnagaintimer = timer.performWithDelay(150,spawns)
	end
end
-----^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^











