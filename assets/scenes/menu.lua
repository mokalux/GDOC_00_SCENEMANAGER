Menu = Core.class(Sprite)

function Menu:init()
	-- audio
	self.sound = Sound.new("audio/DM-CGS-16.ogg")
	self.channel = self.sound:play(0, nil, true)
	-- bg color
	application:setBackgroundColor(0x4182F2)
	-- bg image
	local bg = Bitmap.new(Texture.new("gfx/menu/bg.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(myappwidth/2, myappheight/2)
	bg:setScale(2)
	self:addChild(bg)
	-- app title
	self.mytitle = ButtonTP9UDDT.new({
		text="MY\n  APP TITLE", ttf=font00, textcolorup=0xD16A2F,
		hover=0,
	})
	self.mytitle:setPosition(0.65*myappwidth/2, 3.5*myappheight/10)
	self.matrix = self.mytitle:getMatrix()
	self.matrix:setRotationX(0)
	self.matrix:setRotationY(0)
	self.matrix:setRotationZ(-12)
	self.mytitle:setMatrix(self.matrix)
	self:addChild(self.mytitle)
	self.timer = 0
	-- logo
	local logo = ButtonTP9UDDT.new({
		text="my logo (c)", ttf=font10, textcolorup=0x7EF6DD, textcolordown=0xffffff,
	})
	logo:setPosition(0.15*myappwidth/2, 0.97*myappheight)
	self:addChild(logo)
	-- ui buttons
	self.selector = 1
	local pixelcolor = 0x3d2e33 -- shared amongst ui buttons
	local pixelalphaup = 0.3 -- shared amongst ui buttons
	local pixelalphadown = 0.5 -- shared amongst ui buttons
	local textcolorup = 0x0009B3 -- shared amongst ui buttons
	local textcolordown = 0x45d1ff -- shared amongst ui buttons
	local mybtn = ButtonTP9UDDT.new({
		scalexup=1, scalexdown=1.2,
		pixelcolorup=pixelcolor, pixelalphaup=pixelalphaup, pixelalphadown=pixelalphadown,
		text="    GAME   ", ttf=font01, textcolorup=textcolorup, textcolordown=textcolordown,
		tooltiptext="let's go!", tooltipoffsetx=-2*128,
		channel=self.channel, sound=self.sound,
		fun=self.selectionSfxK,
	}, 1)
	local mybtn02 = ButtonTP9UDDT.new({
		scalexup=1, scalexdown=1.2,
		pixelcolorup=pixelcolor, pixelalphaup=pixelalphaup, pixelalphadown=pixelalphadown,
		text="OPTIONS", ttf=font01, textcolorup=textcolorup, textcolordown=textcolordown,
		channel=self.channel, sound=self.sound,
	}, 2)
	local mybtn03 = ButtonTP9UDDT.new({
		scalexup=1, scalexdown=1.2,
		pixelcolorup=pixelcolor, pixelalphaup=pixelalphaup, pixelalphadown=pixelalphadown,
		text="    QUIT    ", ttf=font01, textcolorup=textcolorup, textcolordown=textcolordown,
		tooltiptext=" you sure? ", tooltipoffsetx=-2*128,
		channel=self.channel, sound=self.sound,
		fun=self.selectionSfxK,
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
	-- ui btns listeners
	for b = 1, #self.btns do
		self.btns[b]:addEventListener("clicked", function() self:goto() end)
	end
	-- let's go
	self:selectionVfx()
	-- scene listeners
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- game loop
function Menu:onEnterFrame(e)
	-- title fx
	self.timer += 1
	self.matrix:setRotationZ(2*math.cos(self.timer/60))
	self.mytitle:setMatrix(self.matrix)
	-- btns ui fx
	self:selectionVfx()
	-- garbage collector
	collectgarbage()
end

-- vfx
function Menu:selectionVfx()
	-- ui buttons vfx from the keyboard
	for k, v in ipairs(self.btns) do
		if k == self.selector then v.isfocused = true
		else v.isfocused = false
		end v:updateVisualState()
	end
end

-- sfx
function Menu:selectionSfxK()
	-- ui button sound fx from the keyboard
	for k, v in ipairs(self.btns) do
		if k == self.selector then self.channel = self.sound:play() end
	end
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
		elseif e.keyCode == KeyCode.K then
			self.selector += 1 if self.selector > #self.btns then self.selector = 1 end
			self:selectionVfx() self:selectionSfxK()
		end
		if e.keyCode == KeyCode.ENTER then self:goto() end
		-- we tell the app that we are navigating using the keyboard
		for _, v in pairs(self.btns) do v.iskeyboard = true end
	end)
end

-- scenes navigation
function Menu:goto()
	if self.selector == 1 then scenemanager:changeScene("game", 1, transitions[2], easings[2])
	elseif self.selector == 2 then print(2)
	elseif self.selector == 3 then print(3)
	end
end
