Game = Core.class(Sprite)

function Game:init()
	-- bg
	application:setBackgroundColor(0x5737F9)
	-- ui
	self.selector = 1
	local pixelcolor = 0xFFD42D -- shared amongst ui buttons
	local textcolor = 0x0 -- shared amongst ui buttons
	local mybtn = ButtonTP9UDDT.new({
		pixelcolorup=pixelcolor,
		text="MENU", ttf=font01, textcolorup=textcolor, textcolordown=0xffffff,
	}, 1)
	local mybtn02 = ButtonTP9UDDT.new({
		pixelcolorup=pixelcolor, pixelalphaup=0.5,
		text="TEST", ttf=font01, textcolorup=textcolor, textcolordown=0xffffff,
		hovered=0,
	}, 2)
	-- ui positions
	mybtn:setPosition(myappwidth/2, 4*myappheight/10)
	mybtn02:setPosition(myappwidth/2, 6*myappheight/10)
	-- ui order
	self:addChild(mybtn)
	self:addChild(mybtn02)
	-- a btns table
	self.btns = {}
	self.btns[#self.btns + 1] = mybtn
	self.btns[#self.btns + 1] = mybtn02
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
function Game:onEnterFrame(e)
end

-- EVENT LISTENERS
function Game:onTransitionInBegin() self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function Game:onTransitionInEnd() self:myKeysPressed() end
function Game:onTransitionOutBegin() self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function Game:onTransitionOutEnd() end

-- KEYS HANDLER
function Game:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		-- for mobiles and desktops
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then self:goto() end
	end)
end

-- change scene
function Game:goto()
	if self.selector == 1 then scenemanager:changeScene("menu", 1, transitions[2], easings[2])
	elseif self.selector == 2 then print(self.selector)
	end
end
