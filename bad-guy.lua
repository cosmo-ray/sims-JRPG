function jimsFSAttackGuy(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = ywCntWidgetFather(mainMenu:cent())
   local fScreen = Entity.wrapp(main).fightScreen
   local enemyLife = fScreen.badGuy.life:to_int()

   enemyLife = enemyLife - 10
   fScreen.badGuy.life = enemyLife
   CanvasObj.wrapp(fScreen.objs[2]):force_size(Pos.new(enemyLife, 10))
   if enemyLife <= 0 then
      swapToHouse(entity)
      return
   end
   fScreen.badGuy.attack(fScreen.badGuy:cent())
end

function jimsFSAddGuy(main, fScreen, widSize, badGuy)
   local rect = Entity.new_array()

   fScreen:pop_back() -- life bar
   fScreen:pop_back() -- life text
   fScreen:pop_back() -- image
   rect[0] = Pos.new(50, 50).ent;
   rect[1] = "rgba: 255 255 255 255";
   local badGuyImg = fScreen:new_rect(widSize.w:to_int() / 2 - 50 / 2,
				      widSize.h:to_int() / 2 - 50 / 2, rect)
   fScreen.ent.badGuy = badGuy
   local txt = fScreen:new_text(1, 1, Entity.new_string("life"))
   local rect = Entity.new_array()
   rect[0] = Pos.new(badGuy.life:to_int(), 10).ent;
   rect[1] = "rgba: 0 255 0 255";
   local bar = fScreen:new_rect(0, 0, rect)

   local pos = Pos.new(badGuyImg:pos():x() + badGuyImg:size():x() / 2 -
			  (txt:size():x() + bar:size():x()) / 2, 1)
   txt:move(pos)
   pos = Pos.new(txt:pos():x() + txt:size():x(), 1)
   bar:move(pos)
end

function attackOfTheWork(badGuy)
   print("it's time to rise !")
end
