local component = require("component")
local term = require("term")
local superlib = require("superlib")
local keyboard = require("keyboard")
local event = require("event")

if component.isAvailable("abstract_bus") == false then
	error("This program requires an abstact bus card.")
end
ab = component.abstract_bus
lastmenu = false

menu = {}
menu[1] = {addr="Dehsetcro Atacpra Silulf", name="Nether"}
menu[2] = {name="SuPeRMiNoR2's Base", addr="Sileston Uspraac Breigon"}

function dial(addr)
	ab.send(0xFFFF, {action="dial", address=addr})
end

function rendermenu(mt)
	term.clear()
	for i=1, #mt do
		print(" "..i.."  ("..mt[i]["name"]..")")
	end
end

function updatemenu(mt, sel)
	if lastmenu ~= false then
		term.setCursor(1, lastmenu)
		term.clearLine()
		term.write(" "..lastmenu.."  ("..mt[lastmenu]["name"]..")")
	end
	term.setCursor(1, sel)
	term.clearLine()
	term.write("["..sel.."] ("..mt[sel]["name"]..")")
end

function menuloop(mt)
	rendermenu(mt)
	sel = 1
	updatemenu(mt, sel)

	while true do
		e, r, t, key = event.pull("key_down")

		if key == keyboard.keys.down then
			lastmenu = sel
			sel = sel + 1
			if sel > #menu then
				sel = 1
			end
		end
		if key == keyboard.keys.up then
			lastmenu = sel
			sel = sel - 1
			if sel < 1 then
				sel = #menu
			end
		end
		if key == keyboard.keys.enter then
			return mt[sel]["addr"]
		end
		if key == keyboard.keys.q then
			return false
		end

		updatemenu(mt, sel)

	end
end

while true do
	addr = menuloop(menu)
	term.clear()
	print("You selected "..addr)
	if addr ~= false then
		dial(addr)
	end
	os.sleep(0.5)

end