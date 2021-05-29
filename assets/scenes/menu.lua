Menu = Core.class(Sprite)

function Menu:init()
	-- bg color
	application:setBackgroundColor(0x4182F2)
	-- bg image
	local bg = Bitmap.new(Texture.new("gfx/menu/bg.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(myappwidth/2, myappheight/2)
	bg:setScale(2)
	self:addChild(bg)
	-- sfx
	self.sound = Sound.new("audio/DM-CGS-16.ogg")
	self.channel = self.sound:play(0, nil, true)
	-- app title
	self.mytitle = ButtonTextP9UDDT.new({
		text="MY\n  APP TITLE", ttf=font00, textcolorup=0xD16A2F,
	})
	self.mytitle:setPosition(0.65*myappwidth/2, 4*myappheight/10)
	self.matrix = self.mytitle:getMatrix()
	self.matrix:setRotationX(0)
	self.matrix:setRotationY(0)
	self.matrix:setRotationZ(-12)
	self.mytitle:setMatrix(self.matrix)
	self:addChild(self.mytitle)
	self.timer = 0
	-- logo
	local logo = ButtonTextP9UDDT.new({
		text="my logo (c)", ttf=font10, textcolorup=0x7EF6DD,
	})
	logo:setPosition(0.15*myappwidth/2, 0.97*myappheight)
	self:addChild(logo)
	-- ui buttons
	self.selector = 1
	local pixelcolor = 0xFFD42D -- shared amongst ui buttons
	local textcolor = 0x0009B3 -- shared amongst ui buttons
	local mybtn = ButtonTextP9UDDT.new({
		text="GAME", ttf=font01, textcolorup=textcolor,
		hover=1,
		tooltiptext="let's go!", tooltipoffsetx=96,
	}, 1)
	local mybtn02 = ButtonTextP9UDDT.new({
		text="OPTIONS", ttf=font01, textcolorup=textcolor,
		hover=1,
	}, 2)
	local mybtn03 = ButtonTextP9UDDT.new({
		text="QUIT", ttf=font01, textcolorup=textcolor,
		hover=1,
		tooltiptext="you sure?", tooltipoffsetx=96,
	}, 3)
	-- ui positions
	mybtn:setPosition(1.5*myappwidth/2, 3.5*myappheight/10)
	mybtn02:setPosition(1.5*myappwidth/2, 5*myappheight/10)
	mybtn03:setPosition(1.5*myappwidth/2, 6.5*myappheight/10)
	-- ui order
	self:addChild(mybtn)
	self:addChild(mybtn02)
	self:addChild(mybtn03)
	-- a btns table
	self.btns = {}
	self.btns[#self.btns + 1] = mybtn
	self.btns[#self.btns + 1] = mybtn02
	self.btns[#self.btns + 1] = mybtn03
	-- let's go!
	self:selectionVfx()
	-- ui btns listeners
	for b = 1, #self.btns do
		self.btns[b]:addEventListener("clicked", function() self:goto() end)
	end
	-- scene listeners
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- GAME LOOP
function Menu:onEnterFrame(e)
	-- title fx
	self.timer += 1
	self.matrix:setRotationZ(16*math.cos(self.timer/60))
	self.mytitle:setMatrix(self.matrix)
	-- selection fx
	self:selectionVfx()
end

-- EVENT LISTENERS
function Menu:onTransitionInBegin() self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function Menu:onTransitionInEnd() self:myKeysPressed() end
function Menu:onTransitionOutBegin() self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function Menu:onTransitionOutEnd() end

-- KEYS HANDLER
function Menu:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		-- for mobiles and desktops
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then application:exit() end
		-- keyboard
		if e.keyCode == KeyCode.I then
			self.selector -= 1 if self.selector < 1 then self.selector = #self.btns end
			self:selectionVfx() self:selectionSfxK()
		end
		if e.keyCode == KeyCode.K then
			self.selector += 1 if self.selector > #self.btns then self.selector = 1 end
			self:selectionVfx() self:selectionSfxK()
		end
		if e.keyCode == KeyCode.ENTER then self:goto() end
	end)
end

-- VFX & SFX
function Menu:selectionVfx()
	for k, v in ipairs(self.btns) do
		if k == self.selector then v:setColorTransform(255/255, 255/255, 255/255, 1) v:setScale(1.15)
		else v:setColorTransform(200/255, 200/255, 200/255, 0.7) v:setScale(1)
		end
	end
end

function Menu:selectionSfxM()
	-- sound fx for the mouse
	for k, v in ipairs(self.btns) do
		if k == self.selector then
			if not v.ismoving then if not self.channel:isPlaying() then self.channel = self.sound:play() end end
		end
	end
end

function Menu:selectionSfxK()
	-- sound fx for the keyboard
	for k, v in ipairs(self.btns) do
		if k == self.selector then self.channel = self.sound:play() end
	end
end

function Menu:goto()
	if self.selector == 1 then scenemanager:changeScene("game", 1, transitions[2], easings[2])
	elseif self.selector == 2 then print(2)
	elseif self.selector == 3 then print(3)
	end
end
