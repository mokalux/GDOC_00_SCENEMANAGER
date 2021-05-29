-- GLOBAL VARIABLES

-- screen size
myappleft, myapptop, myappright, myappbot = application:getLogicalBounds()
myappwidth, myappheight = myappright - myappleft, myappbot - myapptop
print("app left", myappleft, "app top", myapptop, "app right", myappright, "app bot", myappbot)
print("app width", myappwidth, "app height", myappheight)

-- fonts (see also composite font)
font00 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*11.5)//1)
font01 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*5.2)//1)
font10 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*3)//1)
