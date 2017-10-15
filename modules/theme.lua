local theme = {}
-- teal, white, black
--originally theme 1
theme[1] = {
	bg = {0,0.75,0.75},
	main = {1,1,1},
	sub = {0,0,0},
	used = false
}

--theme 2: red, black, white
--originally theme 3
theme[2] = {
	bg = {0.25, 0.75, 0.25},
	main = {1,1,1},
	sub = {0,0,0},
	used = false
}

-- green, black, white
--originally theme 4
theme[3] = {
	bg = {0.75,0.24,0.21},
	main = {1,1,1},
	sub = {0,0,0},
	used = false
}

--theme 1: blue, white, black
--originally theme 2
theme[4] = {
	bg =  {0.5, 0.25, 0.75},
	main =  {1,1,1},
	sub = {0,0,0},
	used = false
}

-- red and off black and white
--originally theme 17
theme[5] = {
	bg = {231/255, 71/255, 46/255},
	main = {229/255, 227/255, 202/255},
	sub = {67/255, 46/255, 51/255},
	used = false
}

--peaches n cream: offwhite, light orange, dark orange
--originally theme 12
theme[6] = {
	bg = {247/255, 239/255, 226/255},
	main = {249/255, 166/255, 3/255},
	sub = {242/255, 92/255, 0/255},
	used = false
}

--summer: mint, toasted marshmallow, light red
--more blue background!
--originally theme 11
theme[7] = {
	bg = {135/255, 217/255, 235/255},
	main = {235/255, 94/255, 48/255},
	sub = {251/255, 203/255, 123/255},
	used = false
}

--leafy: light green, dark green, white
--originally theme 9
theme[8] = {
	bg = {198/255, 209/255, 102/255},
	main = {92/255, 130/255, 26/255},
	sub = {1, 1, 1},
	used = false
}

--apples: red, granny smith green, golden yellow
--sub color more contrast, maybe a cuter blue!
--originally theme 14
theme[9] = {
	bg = {187/255, 196/255, 74/255},
	main = {231/255, 63/255, 3/255},
	sub = {244/255, 236/255, 106/255},
	used = false
}

--ice colors: sky blue, offwhite, blue
--darker bg
--originally theme 6
theme[10] = {
	bg = {165/255, 195/255, 207/255},
	main = {241/255, 241/255, 242/255},
	sub = {25/255, 149/255, 173/255},
	used = false
}

--grey and pink: light grey-purple, darker off purple, pink
--originally theme 7
theme[11] = {
	bg = {154/255, 158/255, 171/255},
	main = {93/255, 83/255, 94/255},
	sub = {236/255, 150/255, 164/255},
	used = false

}

--brownish greys and a dark red text
--originally theme 18
theme[12] = {
	bg = {117/255, 104/255, 103/255},
	main = {213/255, 214/255, 210/255},
	sub = {108/255, 45/255, 44/255},
	used = false
}

--light bluegreen, mustard, dark greenblue
--originally theme 8
theme[13] = {
	bg = {115/255, 96/255, 91/255},
	main = {207/255, 150/255, 131/255},
	sub = {54/255, 50/255, 55/255},
	used = false
}

-- ocean colors, aquamarine, dark blue, icy blue
--originally theme 5
theme[14] = {
	bg = {102/255, 165/255, 173/255},
	main = {0, 59/255,70/255},
	sub = {196/255, 223/255, 230/255},
	used = false
}


--spicy: offred, light beige, cinammon
--originally theme 13
theme[15] = {
	bg = {175/255, 68/255, 37/255},
	main = {235/255, 220/255, 178/255},
	sub = {102/255, 46/255, 18/255},
	used = false
}

--toys: electric blue, yellow, fuschia red
--originally theme 16
theme[16] = {
	bg = {0/255, 141/255, 203/255},
	main = {255/255, 236/255, 92/255},
	sub = {255/255, 49/255, 91/255},
	used = false
}

--blue and coffee: dark blue, ivory, brownred 
--different combo or navy bg
--originally theme 10
theme[17] = {
	bg = {30/255, 101/255, 109/255},
	main = {241/255, 243/255, 206/255},
	sub = {117/255, 42/255, 7/255},
	used = false
}

-- grey tones
--originally theme 20
theme[18] = {
	bg = {187/255, 195/255, 198/255},
	main = {1,1,1},
	sub = {224/255, 88/255, 88/255},
	used = false
}




--nightly: dark blue, misty blue, in between blue
--originally theme 15
theme[19] = {
	bg = {4/255, 32/255, 44/255},
	main = {201/255, 209/255, 216/255},
	sub = {48/255, 64/255, 64/255},
	used = false
}

-- faded pink with dark blue tiles
--originally theme 19
theme[20] = {
	bg = {255/255, 190/255, 189/255},
	main = {26/255, 64/255, 95/255},
	sub = {252/255, 252/255, 250/255},
	used = false
}

--purples and lavendar
theme[21] = {
	bg = {195/255, 195/255, 229/255},
	main = {241/255, 240/255, 255/255},
	sub = {68/255, 50/255, 102/255},
	used = false
}

--terminal theme: grey, black, green
theme[22] = {
	bg = {0.5,0.5,0.5},
	main = {0,0,0},
	sub = {0,1,0},
	used = false
}


return theme

-- theme outline
-- theme[i] = {
-- 	bg = {r/255, g/255, b/255},
-- 	main = {r/255, g/255, b/255},
-- 	sub = {r/255, g/255, b/255}
-- }