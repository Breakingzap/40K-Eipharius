/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	var/key_data

/obj/item/soap/New()
	..()
	create_reagents(30)
	wet()

/obj/item/soap/proc/wet()
	reagents.add_reagent(/datum/reagent/space_cleaner, 15)

/obj/item/soap/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M =	AM
		M.slip("the [src.name]",3)

/obj/item/soap/afterattack(atom/target, mob/living/carbon/human/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='notice'>You need to take that [target.name] off before cleaning it.</span>")
	else if(istype(target,/obj/effect/decal/cleanable/blood))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		target.clean_blood() //Blood is a cleanable decal, therefore needs to be accounted for before all cleanable decals.
		if(user.vice == "Neat Freak" && user.faction != "Nurgle")
			user.happiness += 1
			if(prob(10))
				to_chat(user, "<span class='goodmood'>+ That's much better... +</span>\n")
	else if(istype(target,/obj/effect/decal/cleanable))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		qdel(target)
		if(user.vice == "Neat Freak" && user.faction != "Nurgle")
			user.happiness += 1
			if(prob(10))
				to_chat(user, "<span class='goodmood'>+ That's much better... +</span>\n")
	else if(istype(target,/obj/effect/cleanable))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		qdel(target)
		if(user.vice == "Neat Freak" && user.faction != "nurgle")
			user.happiness += 1
			if(prob(10))
				to_chat(user, "<span class='goodmood'>+ That's much better... +</span>\n")
	else if(istype(target,/turf))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] clean.</span>")
		var/turf/T = target
		T.clean(src, user)
	else if(istype(target,/obj/structure/sink))
		to_chat(user, "<span class='notice'>You wet \the [src] in the sink.</span>")
		wet()
	else
		to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
		target.clean_blood() //Clean bloodied atoms. Blood decals themselves need to be handled above.
		if(user.vice == "Neat Freak" && user.faction != "Nurgle")
			user.happiness += 0.2
			if(prob(10))
				to_chat(user, "<span class='goodmood'>+ That's much better... +</span>\n")
	return

//attack_as_weapon
/obj/item/soap/attack(mob/living/target, mob/living/user, var/target_zone)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == BP_MOUTH)
		user.visible_message("<span class='danger'>\The [user] washes \the [target]'s mouth out with soap!</span>")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return
	..()

/obj/item/soap/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/key))
		if(!key_data)
			to_chat(user, "<span class='notice'>You imprint \the [I] into \the [src].</span>")
			var/obj/item/key/K = I
			key_data = K.key_data
			update_icon()
		return
	..()

/obj/item/soap/update_icon()
	overlays.Cut()
	if(key_data)
		overlays += image('icons/obj/items.dmi', icon_state = "soap_key_overlay")

/obj/item/soap/nanotrasen
	desc = "A NanoTrasen-brand bar of soap. Smells of phoron."
	icon_state = "soapnt"

/obj/item/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/soap/deluxe/New()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."
	..()

/obj/item/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/soap/gold
	desc = "One true soap to rule them all."
	icon_state = "soapgold"
