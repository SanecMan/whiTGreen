/obj/item/weapon/implantcase
	name = "implant case"
	desc = "A glass case containing an implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 2
	throw_range = 5
	w_class = 1.0
	origin_tech = "materials=1;biotech=2"
	g_amt = 500
	var/obj/item/weapon/implant/imp = null


/obj/item/weapon/implantcase/update_icon()
	if(imp)
		icon_state = "implantcase-[imp.item_color]"
		origin_tech = imp.origin_tech
		flags = imp.flags
		reagents = imp.reagents
	else
		icon_state = "implantcase-0"
		origin_tech = initial(origin_tech)
		flags = initial(flags)
		reagents = null


/obj/item/weapon/implantcase/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(istype(W, /obj/item/weapon/pen))
		var/t = sanitize_russian(stripped_input(user, "What would you like the label to be?", name, null))
		if(user.get_active_hand() != W)
			return
		if(!in_range(src, user) && loc != user)
			return
		if(t)
			name = "implant case - '[t]'"
		else
			name = "implant case"
	else if(istype(W, /obj/item/weapon/implanter))
		var/obj/item/weapon/implanter/I = W
		if(I.imp)
			if(imp || I.imp.implanted)
				return
			I.imp.loc = src
			imp = I.imp
			I.imp = null
			update_icon()
			I.update_icon()
		else
			if(imp)
				if(I.imp)
					return
				imp.loc = I
				I.imp = imp
				imp = null
				update_icon()
			I.update_icon()

	else if(istype(W, /obj/item/ammo_casing/shotgun/implanter))
		var/obj/item/ammo_casing/shotgun/implanter/I = W
		if(I.implanter)
			src.attackby(I.implanter, user, params)


/obj/item/weapon/implantcase/New()
	..()
	update_icon()


/obj/item/weapon/implantcase/tracking
	name = "implant case - 'Tracking'"
	desc = "A glass case containing a tracking implant."

/obj/item/weapon/implantcase/tracking/New()
	imp = new /obj/item/weapon/implant/tracking(src)
	..()


/obj/item/weapon/implantcase/explosive
	name = "implant case - 'Explosive'"
	desc = "A glass case containing an explosive implant."

/obj/item/weapon/implantcase/explosive/New()
	imp = new /obj/item/weapon/implant/explosive(src)
	..()


/obj/item/weapon/implantcase/chemical
	name = "implant case - 'Chemical'"
	desc = "A glass case containing a chemical implant."

/obj/item/weapon/implantcase/chemical/New()
	imp = new /obj/item/weapon/implant/chem(src)
	..()


/obj/item/weapon/implantcase/chemical_sec
	name = "implant case - 'Remote Chemical'"
	desc = "A glass case containing a remote-controlled chemical implant."

/obj/item/weapon/implantcase/chemical_sec/New()
	imp = new /obj/item/weapon/implant/chem/security(src)
	..()


/obj/item/weapon/implantcase/loyalty
	name = "implant case - 'Loyalty'"
	desc = "A glass case containing a loyalty implant."

/obj/item/weapon/implantcase/loyalty/New()
	imp = new /obj/item/weapon/implant/loyalty(src)
	..()


/obj/item/weapon/implantcase/weapons_auth
	name = "implant case - 'Firearms Authentication'"
	desc = "A glass case containing a firearms authentication implant."

/obj/item/weapon/implantcase/weapons_auth/New()
	imp = new /obj/item/weapon/implant/weapons_auth(src)
	..()


/obj/item/weapon/implantcase/freedom
	name = "implant case - 'Freedom'"
	desc = "A glass case containing a freedom implant."

/obj/item/weapon/implantcase/freedom/New()
	imp = new /obj/item/weapon/implant/freedom(src)
	..()


/obj/item/weapon/implantcase/adrenalin
	name = "implant case - 'Adrenalin'"
	desc = "A glass case containing an adrenalin implant."

/obj/item/weapon/implantcase/adrenalin/New()
	imp = new /obj/item/weapon/implant/adrenalin(src)
	..()