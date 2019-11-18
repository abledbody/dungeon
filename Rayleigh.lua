local cols = {
 {20, 21, 24, 255},--Black
 {41, 49, 71, 255},--Dark Blue
 {97, 27, 40, 255},--Maroon
 {48, 89, 8,  255},--Dark Green
 {144,93, 67, 255},--Brown
 {76, 76, 81, 255},--Dark Gray
 {137,136,130,255},--Bright Grey
 {255,251,234,255},--White
 {187,27, 22, 255},--Red
 {255,111,19, 255},--Orange
 {255,236,98, 255},--Yellow
 {127,168,70, 255},--Green
 {141,184,213,255},--Cyan
 {92, 71, 185,255},--Blue
 {241,99, 145,255},--Pink
 {245,191,140,255} --Tan
}

for i = 1, #cols do
 colorPalette(i-1,cols[i][1],cols[i][2],cols[i][3])
end