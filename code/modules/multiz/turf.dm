/turf/simulated/open_space
	name = "open space"
	intact = 0
	density = 0
	icon_state = "osblack"
	var/icon/darkoverlays = null
	var/turf/floorbelow
	var/list/overlay_references

	New()
		..()
		getbelow()
		return

	Enter(var/atom/movable/AM)
		if (..())
			spawn(1)
				// only fall down in defined areas (read: areas with artificial gravitiy)
				if(!floorbelow) //make sure that there is actually something below
					if(!getbelow())
						return
				if(AM)
					if (istype(AM, /obj/structure/lattice))
						return

					var/area/areacheck = get_area(src)
					var/blocked = 0

					if(istype(AM, /obj/item/projectile)) //Projectiles shoudn't fall into open space...
						var/obj/item/projectile/P = AM
						if(P.original != src)	//... untill they aimed at one
							return
					else if(!(length(gravity_generators["[src.z]"]) || areacheck.has_gravity))	//also, this shouldnt be affected with grevity
						return	//no gravity, no fall

					if(AM.throwing != 0)
						sleep(1)
						if(AM.throwing != 0 || AM.loc != src)
							return //It should fly over open space, not fall into

					for(var/atom/A in floorbelow.contents)
						if(A.density && !istype(A, /mob))
							blocked = 1
							break
						if(istype(A, /obj/machinery/atmospherics/pipe/zpipe/up) && istype(AM,/obj/item/pipe))
							blocked = 1
							break
						if(istype(A, /obj/structure/disposalpipe/crossZ/up) && istype(AM,/obj/item/pipe))
							blocked = 1
							break

					var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
					if (W)
						blocked = 1

							//dont break here, since we still need to be sure that it isnt blocked

					if (!blocked && !(areacheck.name == "Space"))
						//so we DO fall
						if(AM.density)
							for(var/mob/M in floorbelow)
								M.Weaken(3)	//so, something heawy falls on someone
								M << "<span class='dange'>\the [AM] fell on you!</span>"
						AM.Move(floorbelow)
						if(locate(AM) in floorbelow)
							if ( istype(AM, /mob/living/carbon/human))
								if(AM:back && istype(AM:back, /obj/item/weapon/tank/jetpack))
									return
								else if (istype(floorbelow, /turf/space))
									return //You broke you legs on space no more!
								else if(istype(floorbelow, /turf/simulated/open_space))
									return //You get stannet only when you hawe impact TODO: increase damage on long fals
								else
									var/mob/living/carbon/human/H = AM
									var/damage = 10
//									H.apply_damage(rand(0,damage), BRUTE, "groin") // �� ����� �� ������
									H.apply_damage(rand(0,damage), BRUTE, "l_leg")
									H.apply_damage(rand(0,damage), BRUTE, "r_leg")
									H.apply_damage(rand(2,damage), BRUTE, "l_foot")
									H.apply_damage(rand(2,damage), BRUTE, "r_foot")
									H.Weaken(3)
									H:updatehealth()
		return ..()

/turf/simulated/open_space/proc/getbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			src.ChangeTurf(/turf/space)
			return 0
		else
			floorbelow = locate(src.x, src.y, controller.down_target)
			return 1
	return 1

// override to make sure nothing is hidden
/turf/simulated/open_space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

/turf/simulated/open_space/ex_act(severity)
	// cant destroy empty space with an ordinary bomb
	return

//Singulo shuldn't feed from it, fucken duck.
/turf/simulated/open_space/singularity_act()
	return

/turf/simulated/open_space/singularity_pull()
	return

// Straight copy from space.
/turf/simulated/open_space/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			user << "<span class='warning'>There is already a catwalk here!</span>"
			return
		if(L)
			if(R.use(1))
				user << "<span class='notice'>You begin constructing catwalk...</span>"
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				qdel(L)
				ReplaceWithCatwalk()
			else
				user << "<span class='warning'>You need two rods to build a catwalk!</span>"
			return
		if(R.use(1))
			user << "<span class='notice'>Constructing support lattice...</span>"
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		else
			user << "<span class='warning'>You need one rod to build a lattice.</span>"
		return
	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				user << "<span class='notice'>You build a floor.</span>"
				ChangeTurf(/turf/simulated/floor/plating/airless)
			else
				user << "<span class='warning'>You need one floor tile to build a floor!</span>"
		else
			user << "<span class='warning'>The plating is going to need some support! Place metal rods first.</span>"
	if(istype(C, /obj/item/weapon/wirecutters))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			L.attackby(C, user)

	if(istype(C, /obj/item/weapon/weldingtool))
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			W.attackby(C, user)

	if(istype(C, /obj/item/stack/cable_coil))
		return ..()
