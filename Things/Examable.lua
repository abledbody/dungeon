local Examable = class("Examinable")

Examable.dat = {
	"You have stumbled upon something\nthat was broken by a developer.\n\nGo away."
}

function Examable:trigger()
	local dat = self.dat
	local datLen = #dat
	
	local count = game.examine(self,datLen)
	diBox.show(dat[count])
end

return Examable