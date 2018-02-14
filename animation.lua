function startAnimation(main, anime)
   main = Entity.wrapp(main)

   main.curent_animation = {}
   local cur_anim = main.curent_animation
   cur_anim.animation_frame = 0
   cur_anim.func = anime
   doAnimation(main)
end

function doAnimation(main)
   local cur_anim = main.curent_animation

   if cur_anim then
      cur_anim.func(main:cent(), cur_anim:cent())
      if main.curent_animation then
	 cur_anim.animation_frame = cur_anim.animation_frame + 1
      end
      return true
   end
   return false
end

function endAnimation(main)
   main.curent_animation = nil
end
