
--require "menu"
--require "main"

local num=1.3

function splashStart()

	toScale()
	system.orientation = ""
	bg = display.newImage("splashbg.png",-275,-245)
	bg:scale (alter,0.50)

	arm = display.newImage("arm.png",86,66)
	arm:scale(0.55,0.55)
	arm.xReference=39
	arm.yReference=-18

	images:insert(bg)
	images:insert(arm)
	splashStart2()
end

function splashStart2()

	splash = display.newImage("splashpoo2.png",86,66)
	splash:scale(0.25,0.25)
	images:insert(splash)

	playthrowsound()
	timer.performWithDelay(10,menurotateArm,10)
	timer.performWithDelay(200,scalesplash, 6)
	timer.performWithDelay(1500,insertwords)

	local f = timer.performWithDelay(4000,firstTime)

end

function insertwords()
	images:remove(splash)
	splash = display.newImage("splashpoo.png",132,66)
	splash:scale(6,6)
	words=display.newImage("strandedslothwords.png",-220,-50)
	words:scale(0.35,0.35)

	playsplatsound()
	images:insert(splash)
	images:insert(words)
end
function scalesplash()

	splash:scale(num,num)
	num=num+0.1
	splash:rotate(60)

end

function firstTime()

	local path = system.pathForFile("first.txt",system.DocumentsDirectory)
	local file = io.open(path, "r")

	images:remove(splash)
	images:remove(bg)
	images:remove(arm)
	images:remove(words)
	if(file==nil)then
		writeFirst()
		linkWipe()
		tutorial()
	else
		createMenu()
	end

	--local n = file:read()
	--p = display.newText(tostring(n),420,5,"Georgia",20)
	--p:setTextColor(0,0,100)
	--io.close(file)
	file = nil

end

function writeFirst()

	local path = system.pathForFile("first.txt",system.DocumentsDirectory)
	local file = io.open(path, "w+")
	file:write("1","\n")
	io.close(file)
	file = nil
end