/datum/surgery/xenomorph_removal
	name = "foreign body removal"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/xenomorph_removal, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list("chest")



//remove xeno and spacevine from premises
/datum/surgery_step/xenomorph_removal
	name = "remove foreign body"
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/shovel/spade = 65, /obj/item/weapon/cultivator = 50, /obj/item/weapon/crowbar = 35)
	time = 64

/datum/surgery_step/xenomorph_removal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to search in [target]'s chest for a foreign bodyes.", "<span class='notice'>You begin to search in [target]'s chest for a foreign bodyes...</span>")

/datum/surgery_step/xenomorph_removal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(remove_xeno(user, target))
		user.visible_message("[user] successfully extracts the xenomorph embryo from [target]!", "<span class='notice'>You successfully extract the xenomorph embryo from [target].</span>")
	else
		user.visible_message("[user] can't seem to find anything in [target]'s chest!", "<span class='notice'>You can't find anything in [target]'s chest!</span>")
	return 1

/datum/surgery_step/xenomorph_removal/proc/remove_xeno(mob/user, mob/living/carbon/target)
	var/obj/item/body_egg/alien_embryo/A = locate() in target.contents
	var/obj/effect/spacevine/B = locate() in target.contents
	if(A)
		user << "<span class='notice'>You find an unknown alien organism in [target]'s chest!</span>"
		if(A.stage < 4)
			user << "It's small and weak, barely the size of a foetus."
		else
			user << "It's grown quite large, and writhes slightly as you look at it."
			if(prob(10))
				A.AttemptGrow()

		A.loc = get_turf(target)
		return 1
	else if(B)
		user << "<span class='notice'>You find a parasitizing vine in [target]'s chest!</span>"
		B.loc = get_turf(target)
		return 1


/datum/surgery_step/xenomorph_removal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/body_egg/alien_embryo/A = locate() in target.contents
	if(A)
		if(prob(50))
			A.AttemptGrow(0)
		user.visible_message("<span class='warning'>[user] accidentally pokes the xenomorph in [target]!</span>", "<span class='warning'>You accidentally poke the xenomorph in [target]!</span>")
	else
		target.adjustOxyLoss(30)
		user.visible_message("<span class='warning'>[user] accidentally pokes [target] in the lungs!</span>", "<span class='warning'>You accidentally poke [target] in the lungs!</span>")
	return 0