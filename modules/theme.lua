local theme = {}
theme.max = 3
--theme 1: blue, white, black
theme[1] = {
	bg =  {0,0,1},
	main =  {1,1,1},
	sub = {0,0,0}
}

--theme 2: red, white, black
theme[2] = {
	bg = {1,0,0},
	main = {0,0,0},
	sub = {1,1,1}
}

theme[3] = {
	bg = {237/255, 106/255, 94/255},
	main = {154/255, 52/255, 142/255},
	sub = {13/255, 5/255, 40/255}
}
return theme