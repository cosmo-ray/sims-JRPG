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

function dealDmg(fScreen, dmg)
   local enemyLife = fScreen.badGuy.life:to_int()

   enemyLife = enemyLife - dmg
   fScreen.badGuy.life = enemyLife
   CanvasObj.wrapp(fScreen.objs[2]):force_size(Pos.new(enemyLife, 10))
   if enemyLife <= 0 then
      return true
   end
   return false
end

function jimsFSAttackGuy(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = Entity.wrapp(ywCntWidgetFather(mainMenu:cent()))
   local fScreen = Entity.wrapp(main).fightScreen

   if main.guy.attack(main:cent(), main.guy:cent(),
		      fScreen.badGuy:cent()) == Y_TRUE then
      main.guy.money = main.guy.money + 10
      swapToHouse(entity)
      return
   end

   startAnimation(main:cent(), Entity.new_func("workAttackAnim"))
end

function workAttackAnim(main, anim)
   anim = Entity.wrapp(anim)
   main = Entity.wrapp(main)

   print("wooo woo")
   if anim.animation_frame < 1 then
      local fScreen = main.fightScreen

      fScreen.badGuy.attack(main:cent(), fScreen.badGuy:cent())
      print("init time !")
   end

   if anim.animation_frame > 10 then
      endAnimation(main, anim)
      if main.guy.hygien <= 0 then
	 print("dead")
	 swapToHouse(main.menuCnt.entries[0]:cent())
      end
      return
   end
end

function attackOfTheWork(main, badGuy)
   main = Entity.wrapp(main)

   statAdd(main.guy, "hygien", -5)
end

function attackTheWork(main, goodGuy, badGuy)
   goodGuy = Entity.wrapp(goodGuy)
   badGuy = Entity.wrapp(badGuy)
   main = Entity.wrapp(main)

   statAdd(main.guy, "energy", -5)
   if main.guy.energy > 0 and dealDmg(main.fightScreen, 10) then
      return Y_TRUE
   end
   return Y_FALSE
end
