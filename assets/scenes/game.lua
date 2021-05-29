Game = Core.class(Sprite)

function Game:init()
	-- BG
	application:setBackgroundColor(0x5737F9)
	-- LISTENERS
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
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then
			scenemanager:changeScene("menu", 1, transitions[2], easings[2])
		end
	end)
end
