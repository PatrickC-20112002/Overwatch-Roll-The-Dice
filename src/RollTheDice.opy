variables
{
	global:
		0: FavPerkEnabled

	player:
		0: PerkName
		1: PerkDuration
		2: PerkColour
		3: DiceRoll
		4: DiceCooldown
		5: PerkActivated
		21: StolenDiceName
		22: StolenDiceRoll
		23: StolenPlrName
		24: PushAway
		25: PerkDescription
		26: SelectingFavourite
		27: FavouriteRoll
		28: FavouriteTextAndChance
		29: FavPerkName
		30: FavPerkColour
		31: RtdHudText
}

rule("Enable/Disable Favourite Perk")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		If(Workshop Setting Toggle(Custom String("Favourite Perk"), Custom String("Favourite Perk Enabled?"), False, 0) == True);
			Global.FavPerkEnabled = True;
		Else;
			Global.FavPerkEnabled = False;
	}
}

disabled rule("- Select Fav -")
{
	event
	{
		Ongoing - Global;
	}
}

rule("Int Select")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Global.FavPerkEnabled == True;
	}

	actions
	{
		Set Invisible(Event Player, All);
		Event Player.SelectingFavourite = True;
		Event Player.FavouriteRoll = 0;
		Event Player.DiceRoll = 0;
		Event Player.FavouriteTextAndChance = Empty Array;
		Create HUD Text(Event Player, Custom String("Pick your favourite perk"), Null, Null, Top, 0, Color(White), Color(White), Color(
			White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		Create HUD Text(Event Player, Custom String("(Primary Fire: Next)    (Secondary Fire: Previous)    (Interact: Confirm)", Button(
			Primary Fire), Button(Secondary Fire), Button(Jump)), Custom String(""), Null, Top, 1, Color(Orange), Color(White), Color(
			White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		disabled Create HUD Text(Event Player, Custom String("Current Number: ({0}) {1}", Event Player.FavouriteRoll, Event Player.PerkName), Null,
			Null, Top, 2, Color(Yellow), Color(White), Color(White), Visible To and String, Default Visibility);
		Create HUD Text(Event Player, Custom String("({2}) {0}", Event Player.PerkName, Round To Integer(Event Player.PerkDuration, Up),
			Event Player.DiceRoll), Custom String(""), Custom String("", Round To Integer(Event Player.PerkDuration, Up)), Top, 2,
			Event Player.PerkColour, Event Player.PerkColour, Color(White), Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		disabled Create HUD Text(Event Player, Custom String("{0}", Event Player.PerkDescription), Null, Null, Top, 3, Color(White), Null, Null,
			Visible To Sort Order String and Color, Default Visibility);
		disabled Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		Set Status(Event Player, Null, Hacked, 9999);
		Set Status(Event Player, Null, Rooted, 9999);
		Set Status(Event Player, Null, Phased Out, 9999);
		Set Status(Event Player, Null, Knocked Down, 9999);
		Set Primary Fire Enabled(Event Player, False);
		Set Secondary Fire Enabled(Event Player, False);
		Disable Hero HUD(Event Player);
		Disable Game Mode HUD(Event Player);
		Set Jump Enabled(Event Player, False);
	}
}

rule("Increase Fav")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.SelectingFavourite == True;
		Is Button Held(Event Player, Button(Primary Fire)) == True;
		disabled Event Player.FavouriteRoll < 91;
		Event Player.DiceRoll < 110;
		Global.FavPerkEnabled == True;
	}

	actions
	{
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		disabled Event Player.FavouriteRoll += 1;
		Event Player.DiceRoll += 1;
		disabled Event Player.DiceRoll = Event Player.FavouriteRoll;
		Wait(0.050, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("Decrease Fav")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.SelectingFavourite == True;
		Is Button Held(Event Player, Button(Secondary Fire)) == True;
		disabled Event Player.FavouriteRoll > 0;
		Event Player.DiceRoll > 0;
		Global.FavPerkEnabled == True;
	}

	actions
	{
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		disabled Event Player.FavouriteRoll -= 1;
		disabled Event Player.DiceRoll = Event Player.FavouriteRoll;
		Event Player.DiceRoll -= 1;
		Wait(0.050, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("Confirm Fav")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.SelectingFavourite == True;
		Is Button Held(Event Player, Button(Interact)) == True;
		Global.FavPerkEnabled == True;
	}

	actions
	{
		disabled If(Event Player.DiceRoll == 102);
		disabled Small Message(Event Player, Custom String("This perk cannot be picked as favourite!"));
		disabled Abort;
		disabled End;
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		Event Player.FavouriteRoll = Event Player.DiceRoll;
		Event Player.FavPerkName = Event Player.PerkName;
		Event Player.FavPerkColour = Event Player.PerkColour;
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Clear Status(Event Player, Knocked Down);
		Clear Status(Event Player, Hacked);
		Clear Status(Event Player, Rooted);
		Clear Status(Event Player, Phased Out);
		Destroy HUD Text(Event Player.FavouriteTextAndChance[0]);
		Destroy HUD Text(Event Player.FavouriteTextAndChance[1]);
		Destroy HUD Text(Event Player.FavouriteTextAndChance[2]);
		disabled Destroy HUD Text(Event Player.FavouriteTextAndChance[3]);
		Event Player.FavouriteTextAndChance = 0;
		Set Invisible(Event Player, None);
		Enable Hero HUD(Event Player);
		Enable Game Mode HUD(Event Player);
		Set Jump Enabled(Event Player, True);
		Wait(1, Ignore Condition);
		Event Player.SelectingFavourite = False;
	}
}

rule("Repick Favourite Perk")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Interact)) == True;
		(Is Dead(Event Player) || Is In Spawn Room(Event Player)) == True;
		Event Player.DiceRoll == 0;
		Event Player.PerkActivated == False;
		Event Player.DiceCooldown == 0;
		Global.FavPerkEnabled == True;
	}

	actions
	{
		Destroy HUD Text(Event Player.RtdHudText[0]);
		Destroy HUD Text(Event Player.RtdHudText[1]);
		Destroy HUD Text(Event Player.RtdHudText[2]);
		Destroy HUD Text(Event Player.RtdHudText[3]);
		Destroy HUD Text(Event Player.RtdHudText[4]);
		Event Player.RtdHudText = 0;
		Wait(1, Ignore Condition);
		Event Player.SelectingFavourite = True;
		Event Player.FavouriteRoll = 0;
		Event Player.DiceRoll = 0;
		Event Player.FavouriteTextAndChance = Empty Array;
		Set Invisible(Event Player, All);
		Create HUD Text(Event Player, Custom String("Pick your favourite perk"), Null, Null, Top, 0, Color(White), Color(White), Color(
			White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		Create HUD Text(Event Player, Custom String("(Primary Fire: Next)    (Secondary Fire: Previous)    (Interact: Confirm)", Button(
			Primary Fire), Button(Secondary Fire), Button(Jump)), Custom String(""), Null, Top, 1, Color(Orange), Color(White), Color(
			White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		disabled Create HUD Text(Event Player, Custom String("Current Number: ({0}) {1}", Event Player.FavouriteRoll, Event Player.PerkName), Null,
			Null, Top, 2, Color(Yellow), Color(White), Color(White), Visible To and String, Default Visibility);
		Create HUD Text(Event Player, Custom String("({2}) {0}", Event Player.PerkName, Round To Integer(Event Player.PerkDuration, Up),
			Event Player.DiceRoll), Custom String(""), Custom String("", Round To Integer(Event Player.PerkDuration, Up)), Top, 2,
			Event Player.PerkColour, Event Player.PerkColour, Color(White), Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		disabled Create HUD Text(Event Player, Custom String("{0}", Event Player.PerkDescription), Null, Null, Top, 3, Color(White), Null, Null,
			Visible To Sort Order String and Color, Default Visibility);
		disabled Modify Player Variable(Event Player, FavouriteTextAndChance, Append To Array, Last Text ID);
		Set Status(Event Player, Null, Hacked, 9999);
		Set Status(Event Player, Null, Rooted, 9999);
		Set Status(Event Player, Null, Phased Out, 9999);
		Set Status(Event Player, Null, Knocked Down, 9999);
		Set Primary Fire Enabled(Event Player, False);
		Set Secondary Fire Enabled(Event Player, False);
		Disable Hero HUD(Event Player);
		Disable Game Mode HUD(Event Player);
		Set Jump Enabled(Event Player, False);
	}
}

disabled rule("- RTD -")
{
	event
	{
		Ongoing - Global;
	}
}

rule("Init")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		(Event Player.SelectingFavourite == False || Global.FavPerkEnabled == False) == True;
	}

	actions
	{
		Event Player.PerkName = Custom String("Press Interact to Roll the Dice");
		Event Player.PerkDescription = Custom String("The dice is ready!");
		Event Player.PerkDuration = 0;
		Event Player.PerkColour = Color(Yellow);
		Event Player.DiceRoll = 0;
		Event Player.DiceCooldown = 0;
		Event Player.RtdHudText = Empty Array;
		"new perk text"
		Create HUD Text(Event Player, Custom String("{0}", Event Player.PerkName, Round To Integer(Event Player.PerkDuration, Up),
			Event Player.DiceRoll), Custom String("Duration:"), Custom String("{0}", Round To Integer(Event Player.PerkDuration, Up)), Top,
			0, Event Player.PerkColour, Event Player.PerkColour, Color(White), Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, RtdHudText, Append To Array, Last Text ID);
		"new cd text"
		Create HUD Text(Filtered Array(Event Player, Event Player.DiceCooldown > 0), Null, Custom String("Dice Cooldown"), Custom String(
			"{0}", Round To Integer(Event Player.DiceCooldown, Up)), Right, 0, Null, Event Player.PerkColour, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, RtdHudText, Append To Array, Last Text ID);
		"spectator"
		Create In-World Text(Filtered Array(All Players(All Teams), Current Array Element.DiceRoll == 95), Custom String("{0}: {1}",
			Event Player.PerkName, Round To Integer(Event Player.PerkDuration, Up)), Update Every Frame(Eye Position(Event Player)
			+ Vector(0, 1, 0)), 1.500, Clip Against Surfaces, Visible To Position String and Color, Event Player.PerkColour,
			Visible Always);
		Modify Player Variable(Event Player, RtdHudText, Append To Array, Last Text ID);
		"favourite perk perma text"
		Skip If(Global.FavPerkEnabled == False, 2);
		Create HUD Text(Event Player, Custom String("Favourite Perk"), Custom String("{0}", Event Player.FavouriteRoll), Custom String(
			"{0}", Event Player.FavPerkName), Left, 0, Event Player.FavPerkColour, Color(White), Event Player.FavPerkColour,
			Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, RtdHudText, Append To Array, Last Text ID);
		"hero icon"
		Create In-World Text(Filtered Array(All Players(All Teams), Current Array Element.DiceRoll == 94), Custom String("{0}",
			Hero Icon String(Hero Of(Event Player))), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), 1.500, Do Not Clip,
			Visible To Position String and Color, Event Player.PerkColour, Default Visibility);
		Modify Player Variable(Event Player, RtdHudText, Append To Array, Last Text ID);
		"perk description"
		disabled Create HUD Text(Event Player, Custom String("{0}", Event Player.PerkDescription), Null, Null, Left, 4, Color(White), Null, Null,
			Visible To Sort Order String and Color, Default Visibility);
		Wait Until(Has Spawned(Event Player), 99999);
		Wait(1, Ignore Condition);
		Big Message(Event Player, Custom String("Press Interact To Roll The Dice"));
	}
}

rule("AD TEXT")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		Create HUD Text(All Players(All Teams), Custom String("ROLL THE DICE"), Null, Null, Left, 1, Color(Sky Blue), Null, Null,
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("Created by MarkedDerp"), Left, 2, Null, Null, Color(Rose),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("WORKSHOP CODE"), Left, 3, Null, Null, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("N/A"), Left, 4, Null, Null, Color(Red),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("CURRENT VERSION"), Left, 5, Null, Null, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("Celebration Edition"), Left, 6, Null, Null, Color(Aqua),
			Visible To Sort Order String and Color, Default Visibility);
		disabled Create HUD Text(All Players(All Teams), Null, Null, Custom String("CURRENT EXPERIMENT"), Left, 6, Null, Null, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		disabled Create HUD Text(All Players(All Teams), Null, Null, Custom String("Sorcerer's Jackpot Fav Perk"), Left, 7, Null, Null, Color(Gray),
			Visible To Sort Order String and Color, Default Visibility);
	}
}

rule("Dice Cooldown Set")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.PerkActivated == True;
	}

	actions
	{
		Wait Until(Event Player.PerkActivated == False, 99999);
		If(Current Game Mode == Game Mode(Deathmatch));
			Event Player.DiceCooldown = 15;
		Else;
			Event Player.DiceCooldown = 30;
		End;
		Event Player.PerkName = Custom String("No perk");
		Event Player.DiceRoll = 0;
		Event Player.PerkColour = Custom Color(211, 211, 211, 255);
		Event Player.PerkDescription = Custom String("The player is completely normal.");
	}
}

rule("Trait Activated = False")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.PerkDuration == 0;
	}

	actions
	{
		Event Player.PerkActivated = False;
		Play Effect(Event Player, Debuff Impact Sound, Color(White), Position Of(Event Player), 200);
	}
}

rule("Bring Down Cooldown")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceCooldown > 0;
	}

	actions
	{
		Chase Player Variable At Rate(Event Player, DiceCooldown, 0, 1, Destination and Rate);
		Wait Until(Event Player.DiceCooldown == 0, 99999);
		Stop Chasing Player Variable(Event Player, DiceCooldown);
		Play Effect(Event Player, Ring Explosion Sound, Color(White), Position Of(Event Player), 200);
		Event Player.PerkName = Custom String("Press Interact to Roll the Dice");
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkDescription = Custom String("The dice is ready!");
	}
}

rule("Bring Down Trait Timer")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.PerkDuration > 0;
	}

	actions
	{
		Chase Player Variable At Rate(Event Player, PerkDuration, 0, 1, Destination and Rate);
		Wait Until(Event Player.PerkDuration == 0, 99999);
		Stop Chasing Player Variable(Event Player, PerkDuration);
	}
}

rule("Roll The Dice")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		(Is Button Held(Event Player, Button(Interact)) || (Is Button Held(Event Player, Button(Crouch)) && (Hero Of(Event Player) == Hero(
			Illari) || Hero Of(Event Player) == Hero(Lifeweaver) || Hero Of(Event Player) == Hero(Symmetra) || Hero Of(Event Player)
			== Hero(Torbjörn)))) == True;
		Event Player.DiceCooldown == 0;
		Is Alive(Event Player) == True;
		Is In Spawn Room(Event Player) == False;
		Event Player.SelectingFavourite == False;
		disabled Hero Of(Event Player) != Hero(Illari);
		disabled Hero Of(Event Player) != Hero(Lifeweaver);
		disabled Hero Of(Event Player) != Hero(Symmetra);
		disabled Hero Of(Event Player) != Hero(Torbjörn);
	}

	actions
	{
		Abort If(Event Player.PerkDuration > 0);
		Big Message(Event Player, Custom String("Rolling the dice"));
		Wait(1, Ignore Condition);
		Abort If(Is Dead(Event Player));
		disabled Wait Until(Is Alive(Event Player), 99999);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Position Of(Event Player), 200);
		Event Player.PerkActivated = True;
		Skip If(Event Player.FavouriteRoll == 0, 6);
		"Fav Perk Chance"
		Event Player.FavouriteTextAndChance = Random Integer(1, Workshop Setting Integer(Custom String("Favourite Perk"), Custom String(
			"Favourite Roll Chance (1 in _ chance)"), 10, 1, 10, 0));
		"Fav Perk"
		If(Event Player.FavouriteTextAndChance == 1);
			Event Player.DiceRoll = Event Player.FavouriteRoll;
			Small Message(Event Player, Custom String("You rolled your favourite roll"));
		End;
		"Normal Roll"
		If(Event Player.FavouriteTextAndChance != 1);
			Event Player.DiceRoll = Random Integer(1, 110);
			disabled Event Player.DiceRoll = 56;
		End;
		If(Current Game Mode == Game Mode(Deathmatch));
			Small Message(Event Player, Custom String("{0}{1} rolled {2}", Hero Icon String(Hero Of(Event Player)), Event Player,
				Event Player.PerkName));
			Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
				"{0}{1} rolled the dice.", Hero Icon String(Hero Of(Event Player)), Event Player, Event Player.PerkName));
		Else;
			Small Message(All Players(Team Of(Event Player)), Custom String("{0}{1} rolled {2}", Hero Icon String(Hero Of(Event Player)),
				Event Player, Event Player.PerkName));
			Small Message(All Players(Opposite Team Of(Team Of(Event Player))), Custom String("{0}{1} rolled a perk.", Hero Icon String(
				Hero Of(Event Player)), Event Player, Event Player.PerkName));
		End;
	}
}

disabled rule("- Perk List -")
{
	event
	{
		Ongoing - Global;
	}
}

rule("0: No Favourite Perk (NOT A PERK)")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 0;
		Event Player.SelectingFavourite == True;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("No Favourite Perk");
		Event Player.PerkDescription = Custom String(
			"This option removes all functionality for the favourite perk mechanic. All perk chances will be equal.");
	}
}

rule("1: GodMode")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 1;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("GodMode");
		Event Player.PerkDescription = Custom String("The player's health will not drop below 1");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 20;
		Set Status(Event Player, Null, Invincible, 9999);
		Set Knockback Received(Event Player, 0);
		Create Effect(All Players(All Teams), Good Aura, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Clear Status(Event Player, Invincible);
		Set Knockback Received(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("2: Toxic")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 2;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Toxic");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Cloud, Color(Red), Update Every Frame(Eye Position(Event Player)), 10,
			Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("2: Toxic Damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 2;
		disabled Event Player.PerkActivated == True;
	}

	actions
	{
		Wait(0.200, Ignore Condition);
		Damage(Filtered Array(Players Within Radius(Event Player, 10, All Teams, Surfaces), Current Array Element != Event Player),
			Event Player, 20);
		Loop If Condition Is True;
	}
}

rule("3: Vital")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 3;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Vital");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Add Health Pool To Player(Event Player, Health, 300, True, True);
		Event Player.G = Last Created Health Pool;
		Wait(0.100, Ignore Condition);
		Heal(Event Player, Null, 300);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Remove Health Pool From Player(Event Player.G);
		Event Player.G = 0;
	}
}

rule("4: Speed")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 4;
	}

	actions
	{
		Event Player.PerkColour = Color(Lime Green);
		Event Player.PerkName = Custom String("Speed");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Move Speed(Event Player, 300);
		Create Effect(All Players(All Teams), Sparkles, Color(Lime Green), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Move Speed(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("5: Noclip")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 5;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Noclip");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Disable Movement Collision With Environment(Event Player, False);
		Disable Movement Collision With Players(Event Player);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Enable Movement Collision With Environment(Event Player);
		Enable Movement Collision With Players(Event Player);
	}
}

rule("6: Nanoboost")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 6;
	}

	actions
	{
		Event Player.PerkColour = Color(Blue);
		Event Player.PerkName = Custom String("Nanoboost");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Ana Nano Boosted Effect, Color(Purple), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Create Effect(All Players(All Teams), Sphere, Color(White), Eye Position(Event Player), 25, Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		Heal(Event Player, Null, 250);
		Set Damage Dealt(Event Player, 150);
		Set Damage Received(Event Player, 50);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Destroy Effect(Event Player.H);
		Event Player.H = 0;
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
	}
}

rule("7: Low Gravity")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 7;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Low Gravity");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Gravity(Event Player, 25);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Gravity(Event Player, 100);
	}
}

rule("8: Invisibility")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 8;
	}

	actions
	{
		Event Player.PerkColour = Color(Turquoise);
		Event Player.PerkName = Custom String("Invisibility");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Invisible(Event Player, Enemies);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Invisible(Event Player, None);
	}
}

rule("9: Keyboard Spam")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 9;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Keyboard Spam");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
	}
}

rule("9: Keyboard Spam Spam")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 9;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Press Button(Event Player, Button(Ability 1));
		Wait(0.250, Ignore Condition);
		Press Button(Event Player, Button(Ability 2));
		Wait(0.250, Ignore Condition);
		Press Button(Event Player, Button(Ultimate));
		Wait(0.250, Ignore Condition);
		Press Button(Event Player, Button(Secondary Fire));
		Wait(0.250, Ignore Condition);
		Press Button(Event Player, Button(Primary Fire));
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("10: Scary Bullets")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 10;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Scary Bullets");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Good Aura, Color(Orange), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("10: Scary Bullets Stun")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 10;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Abort If(Has Status(Victim, Stunned));
		Set Status(Victim, Event Player, Stunned, 3);
	}
}

rule("11: Explode")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 11;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Explode");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 5;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Damage(Players Within Radius(Event Player, 15, All Teams, Surfaces), Event Player, 250);
		Play Effect(All Players(All Teams), Bad Explosion, Color(Yellow), Position Of(Event Player), 15);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Position Of(Event Player), 200);
		Filtered Array(Players Within Radius(Event Player, 15, All Teams, Surfaces), Current Array Element != Event Player)
			.PushAway = Event Player;
	}
}

rule("11: Explode Push")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.PushAway != 0;
		Event Player.PushAway.DiceRoll == 11;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Skip If(Is Dead(Event Player.PushAway) == True, 6);
		Apply Impulse(Event Player, Up, 5, To World, Cancel Contrary Motion);
		Wait(0.100, Ignore Condition);
		Apply Impulse(Event Player, Direction Towards(Event Player.PushAway, Event Player), 25, To World, Cancel Contrary Motion);
		Set Environment Credit Player(Event Player, Event Player.PushAway);
		Wait(0.250, Ignore Condition);
		Event Player.PushAway = 0;
	}
}

rule("12: Snail")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 12;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Snail");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Set Move Speed(Event Player, 33);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Move Speed(Event Player, 100);
	}
}

rule("13: Frozen")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 13;
	}

	actions
	{
		Event Player.PerkColour = Color(Aqua);
		Event Player.PerkName = Custom String("Frozen");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Set Status(Event Player, Event Player, Frozen, 9999);
		Set Damage Received(Event Player, 1);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Clear Status(Event Player, Frozen);
		Set Damage Received(Event Player, 100);
	}
}

rule("13: Frozen Ice Break")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 13;
		Has Status(Event Player, Frozen) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 0;
		Clear Status(Event Player, Frozen);
		Set Damage Received(Event Player, 100);
		Wait(0.016, Ignore Condition);
		Start Damage Over Time(Event Player, Attacker, 0.250, 600);
	}
}

rule("14: Timebomb")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 14;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Timebomb");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Create Effect(All Players(All Teams), Orb, Color(Black), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), 1,
			Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Position Of(Event Player), 50);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Create Effect(All Players(All Teams), Cloud, Color(Black), Event Player, 50, Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Kill(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player);
		Wait(0.500, Ignore Condition);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		If(Hero Of(Event Player) == Hero(D.Va));
			Wait Until(Is In Alternate Form(Event Player), 3);
			Kill(Event Player, Event Player);
		End;
	}
}

rule("15: Ignition")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 15;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Ignition");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Set Status(Event Player, Event Player, Burning, 9999);
		disabled If(Is Portrait On Fire(Event Player));
		disabled Start Heal Over Time(Event Player, Event Player, 5, 30);
		disabled Set Damage Dealt(Event Player, 175);
		disabled Big Message(Event Player, Custom String("Already on fire!"));
		disabled End;
		disabled If(!Is Portrait On Fire(Event Player));
		Start Damage Over Time(Event Player, Null, 15, 15);
		disabled End;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Clear Status(Event Player, Burning);
		Set Damage Dealt(Event Player, 100);
	}
}

rule("16: Low Health")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 16;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Low Health");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1.500;
		Start Damage Over Time(Event Player, Null, 1, Health(Event Player) * 0.900);
	}
}

rule("17: Blind")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 17;
	}

	actions
	{
		Event Player.PerkColour = Color(Black);
		Event Player.PerkName = Custom String("Blind");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Start Camera(Event Player, Vector(-10000, -10000, -10000), Vector(-10000, -10000, -10000), 0);
		Set Damage Dealt(Event Player, 250);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Camera(Event Player);
		Set Damage Dealt(Event Player, 100);
	}
}

rule("18: Strip to Melee")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 18;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Strip to Melee");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		disabled Set Damage Dealt(Event Player, 200);
		disabled Set Move Speed(Event Player, 125);
		Skip If(Hero Of(Event Player) == Hero(Brigitte) || Hero Of(Event Player) == Hero(Reinhardt), 1);
		Set Primary Fire Enabled(Event Player, False);
		Set Secondary Fire Enabled(Event Player, False);
		Set Ability 1 Enabled(Event Player, False);
		Set Ability 2 Enabled(Event Player, False);
		Disallow Button(Event Player, Button(Ultimate));
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Set Ability 1 Enabled(Event Player, True);
		Set Ability 2 Enabled(Event Player, True);
		Allow Button(Event Player, Button(Ultimate));
		disabled Set Damage Dealt(Event Player, 100);
		disabled Set Move Speed(Event Player, 100);
	}
}

rule("19: Forced Taunt")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 19;
	}

	actions
	{
		Skip If(Is Communicating Any Emote(Event Player) == True, 18);
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Forced Taunt");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Event Player.G = Random Integer(1, 4);
		disabled Teleport(Event Player, Nearest Walkable Position(Event Player));
		Cancel Primary Action(Event Player);
		If(Event Player.G == 1);
			Communicate(Event Player, Emote Up);
		End;
		If(Event Player.G == 2);
			Communicate(Event Player, Emote Left);
		End;
		If(Event Player.G == 3);
			Communicate(Event Player, Emote Right);
		End;
		If(Event Player.G == 4);
			Communicate(Event Player, Emote Down);
		End;
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("19: Forced Taunt Loop")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 19;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Move Speed(Event Player, 25);
		Set Gravity(Event Player, 500);
		Wait Until(Event Player.PerkActivated == False, 25);
		Set Move Speed(Event Player, 100);
		Set Gravity(Event Player, 100);
		Event Player.PerkDuration = 0;
		Event Player.G = 0;
	}
}

rule("20: Bad Sauce")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 20;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Bad Sauce");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Start Damage Over Time(Event Player, Null, 15, 6.667);
		Set Status(Event Player, Event Player, Burning, 9999);
		Set Status(Event Player, Event Player, Hacked, 9999);
		Set Status(Event Player, Event Player, Stunned, 1);
		disabled Set Status(Event Player, Event Player, Frozen, 9999);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Clear Status(Event Player, Burning);
		Clear Status(Event Player, Hacked);
		disabled Clear Status(Event Player, Frozen);
	}
}

rule("21: Infinite Jump")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 21;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Infinite Jump");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
	}
}

rule("21: Infinite Jump Jump")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 21;
		Is Button Held(Event Player, Button(Jump)) == True;
		Is In Air(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Disallow Button(Event Player, Button(Jump));
		Apply Impulse(Event Player, Up, 8, To World, Cancel Contrary Motion);
		Wait(0.250, Ignore Condition);
		Allow Button(Event Player, Button(Jump));
		Loop If Condition Is True;
	}
}

rule("22: Powerful Hits")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 22;
	}

	actions
	{
		Event Player.PerkColour = Color(Green);
		Event Player.PerkName = Custom String("Powerful Hits");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Damage Dealt(Event Player, 200);
		Create Effect(All Players(All Teams), Mercy Damage Boosted Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Damage Dealt(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("23: Grow")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 23;
	}

	actions
	{
		Event Player.PerkColour = Color(Sky Blue);
		Event Player.PerkName = Custom String("Grow");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Start Scaling Player(Event Player, 2, True);
		Set Damage Received(Event Player, 50);
		Start Modifying Hero Voice Lines(Event Player, 0.500, True);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Scaling Player(Event Player);
		Set Damage Received(Event Player, 100);
		Stop Modifying Hero Voice Lines(Event Player);
	}
}

rule("24: Shrink")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 24;
	}

	actions
	{
		Event Player.PerkColour = Color(Green);
		Event Player.PerkName = Custom String("Shrink");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Start Scaling Player(Event Player, 0.200, True);
		Set Damage Received(Event Player, 150);
		Start Modifying Hero Voice Lines(Event Player, 1.500, True);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Scaling Player(Event Player);
		Set Damage Received(Event Player, 100);
		Stop Modifying Hero Voice Lines(Event Player);
	}
}

rule("25: Firework")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 25;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Firework");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1;
		Apply Impulse(Event Player, Up, 15, To World, Cancel Contrary Motion);
		Set Gravity(Event Player, 40);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Damage(Players Within Radius(Event Player, 15, All Teams, Surfaces), Event Player, 50);
		Play Effect(All Players(All Teams), Bad Explosion, Color(White), Position Of(Event Player), 15);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Position Of(Event Player), 50);
		Set Status(Players Within Radius(Event Player, 15, All Teams, Surfaces), Event Player, Burning, 2);
		Start Damage Over Time(Players Within Radius(Event Player, 15, All Teams, Surfaces), Event Player, 2, 50);
		Set Gravity(Event Player, 100);
		Apply Impulse(Event Player, Down, 1, To World, Cancel Contrary Motion);
	}
}

rule("26: Siphon")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 26;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Siphon");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Baptiste Immortality Field Protected Effect, Color(White), Event Player, 1,
			Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("26: Siphon Effect")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 26;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Heal(Event Player, Event Player, Event Damage * 1.250);
	}
}

rule("27: High Gravity")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 27;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("High Gravity");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Gravity(Event Player, 500);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Gravity(Event Player, 100);
	}
}

rule("28: Frail")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 28;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Frail");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Damage Received(Event Player, 175);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Damage Received(Event Player, 100);
	}
}

rule("29: Knockback Hits")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 29;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Knockback Hits");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
	}
}

rule("29: Knockback Hits KB")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 29;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Apply Impulse(Victim, Up, 3, To World, Cancel Contrary Motion);
		Apply Impulse(Victim, Direction Towards(Event Player, Victim), 20, To World, Cancel Contrary Motion);
		Set Environment Credit Player(Victim, Event Player);
	}
}

rule("30: Zero Gravity")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 30;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Zero Gravity");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Gravity(Event Player, 0);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Gravity(Event Player, 100);
	}
}

rule("31: Fire Timebomb")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 31;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Fire Timebomb");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Create Effect(All Players(All Teams), Orb, Color(Yellow), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), 1,
			Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Create Effect(All Players(All Teams), Cloud, Color(Yellow), Event Player, 50, Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Damage(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player, 100);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Position Of(Event Player), 50);
		Set Status(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player, Burning, 5);
		Start Damage Over Time(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player, 5, 30);
		Wait(0.500, Ignore Condition);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("32: Spring Shoes")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 32;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Spring Shoes");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
	}
}

rule("32: Spring Shoes Bounce")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 32;
		Is On Ground(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Apply Impulse(Event Player, Up, 8, To World, Cancel Contrary Motion);
		Wait(0.200, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("33: Drugged")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 33;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Drugged");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Set Aim Speed(Event Player, 25);
		Set Move Speed(Event Player, 65);
		Set Status(Event Player, Null, Hacked, 3);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Clear Status(Event Player, Hacked);
	}
}

rule("34: Drug Bullets")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 34;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Drug Bullets");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
	}
}

rule("34: Drug Bullets Effect")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Attacker.DiceRoll == 34;
		disabled Event Damage >= 5;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Small Message(Event Player, Custom String("Drugged by {0} {1}", Hero Icon String(Hero Of(Attacker)), Attacker));
		Set Aim Speed(Event Player, 25);
		Set Move Speed(Event Player, 65);
		disabled Set Status(Event Player, Null, Hacked, 9999);
		Wait(0.500, Ignore Condition);
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		disabled Clear Status(Event Player, Hacked);
	}
}

rule("35: Heroes Never Die")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 35;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Heroes Never Die");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Big Message(Event Player, Custom String("Press Interact to Use."));
	}
}

rule("35: Heroes Never Die Resurrect")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 35;
		Is Button Held(Event Player, Button(Interact)) == True;
		Is Dead(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		disabled Event Player.PerkDuration = 0;
		disabled Event Player.PerkActivated = False;
		Big Message(Event Player, Custom String("Reviving"));
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Create Effect(All Players(All Teams), Sphere, Color(Yellow), Eye Position(Event Player), 0.500, None);
		Event Player.H = Last Created Entity;
		Wait(1, Ignore Condition);
		Play Effect(All Players(All Teams), Buff Explosion Sound, Color(White), Position Of(Event Player), 200);
		Play Effect(All Players(All Teams), Good Pickup Effect, Color(Yellow), Position Of(Event Player), 5);
		Wait(0.500, Ignore Condition);
		Resurrect(Event Player);
		Set Status(Event Player, Null, Rooted, 1);
		Set Status(Event Player, Null, Hacked, 1);
		Set Status(Event Player, Null, Phased Out, 1);
		Disallow Button(Event Player, Button(Primary Fire));
		Disallow Button(Event Player, Button(Secondary Fire));
		Wait(1, Ignore Condition);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Destroy Effect(Event Player.H);
		Event Player.H = 0;
	}
}

rule("36: Wasted Roll")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 36;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Wasted Roll");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1;
		Play Effect(Event Player, Debuff Impact Sound, Color(White), Position Of(Event Player), 200);
		Wait Until(Event Player.DiceCooldown > 0, 5);
		Event Player.DiceCooldown = 5;
	}
}

rule("37: Beat Drop")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 37;
	}

	actions
	{
		Event Player.PerkColour = Color(Lime Green);
		Event Player.PerkName = Custom String("Beat Drop");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Apply Impulse(Event Player, Up, 8, To World, Cancel Contrary Motion);
		Event Player.G = Max Health(Event Player);
		Wait(0.500, Ignore Condition);
		Wait Until(Is On Ground(Event Player) || Is Dead(Event Player) || Has Status(Event Player, Stunned) || Has Status(Event Player,
			Hacked) || Has Status(Event Player, Asleep), 5);
		If((Is Dead(Event Player) || Has Status(Event Player, Hacked) || Has Status(Event Player, Asleep) || Has Status(Event Player,
			Stunned)) == True);
			Event Player.G = 0;
			Event Player.PerkDuration = 0;
			Event Player.PerkActivated = False;
			Abort;
		End;
		Play Effect(Event Player, Doomfist Meteor Strike Impact Sound, Color(White), Position Of(Event Player), 200);
		Add Health Pool To Player(Event Player, Health, 1000, False, True);
		Start Damage Over Time(Event Player, Null, 30, 125);
		disabled Wait(1, Ignore Condition);
		disabled Wait Until(Event Player.PerkActivated == False, 999999);
		disabled Wait Until(Max Health Of Type(Event Player, Health) + Max Health Of Type(Event Player, Armor) + Max Health Of Type(Event Player,
			Shields) <= Health(Event Player), 15);
		Wait Until(Health(Event Player) <= Event Player.G, 30);
		Stop All Damage Over Time(Event Player);
		Remove All Health Pools From Player(Event Player);
		Event Player.G = 0;
		Heal(Event Player, Null, 16);
	}
}

rule("38: Jackpot")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 38;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Jackpot");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) + 50);
		Set Move Speed(Event Player, 225);
		Set Damage Received(Event Player, 50);
		Set Damage Dealt(Event Player, 175);
		Create Effect(All Players(All Teams), Good Aura, Color(Yellow), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Move Speed(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("39: Pocket Mercy Heal")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 39;
		Health(Event Player) < Max Health(Event Player) * 0.750;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Destroy Effect(Event Player.G);
		Destroy Effect(Event Player.H);
		Set Damage Dealt(Event Player, 100);
		Create Effect(All Players(All Teams), Heal Target Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Create Effect(Event Player, Mercy Heal Beam Sound, Color(White), Event Player, 200, Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		Start Heal Over Time(Event Player, Null, 9999, 60);
	}
}

rule("39: Pocket Mercy Damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 39;
		Health(Event Player) >= Max Health(Event Player) * 0.750;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Destroy Effect(Event Player.G);
		Destroy Effect(Event Player.H);
		Stop Heal Over Time(Last Heal Over Time ID);
		Create Effect(All Players(All Teams), Mercy Damage Boosted Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Create Effect(Event Player, Mercy Damage Boosted Sound, Color(White), Event Player, 200, Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		Set Damage Dealt(Event Player, 130);
	}
}

rule("39: Pocket Mercy")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 39;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Pocket Mercy");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Damage Dealt(Event Player, 100);
		Stop Heal Over Time(Last Heal Over Time ID);
		Destroy Effect(Event Player.G);
		Destroy Effect(Event Player.H);
		Event Player.G = 0;
		Event Player.H = 0;
	}
}

rule("40: Temporary Ultimate")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 40;
	}

	actions
	{
		Event Player.PerkColour = Color(Blue);
		Event Player.PerkName = Custom String("Temporary Ult");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 30;
		Event Player.G = Ultimate Charge Percent(Event Player) + 25;
		Set Ultimate Charge(Event Player, 100);
		Wait Until(Ultimate Charge Percent(Event Player) == 0 || Event Player.PerkActivated == False, 999999);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.PerkDuration = 0;
	}
}

rule("41: No Cooldowns Effect")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 41;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Ability Cooldown(Event Player, Button(Ability 1), 0);
		Set Ability Cooldown(Event Player, Button(Ability 2), 0);
		Set Ability Cooldown(Event Player, Button(Secondary Fire), 0);
		Set Ability Cooldown(Event Player, Button(Jump), 0);
		Set Ability Charge(Event Player, Button(Ability 1), 1000);
		Wait(0.016, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("41: No Cooldowns")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 41;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("No Cooldowns");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Ability Charge(Event Player, Button(Ability 1), 0);
	}
}

rule("42: Weakened")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 42;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Weakened");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Damage Dealt(Event Player, 50);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Damage Dealt(Event Player, 100);
	}
}

rule("43: Auto Dodge")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 43;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Auto Dodge");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Cloud, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Color(White), Always);
		Set Damage Received(Event Player, 75);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Set Damage Received(Event Player, 100);
	}
}

rule("43: Auto Dodge Dodge")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 43;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		disabled Start Heal Over Time(Event Player, Event Player, 0.500, Event Damage * 2);
		Set Status(Event Player, Event Player, Phased Out, 1.500);
		Play Effect(All Players(All Teams), Bad Explosion, Color(White), Event Player, 5);
		Play Effect(Array(Event Player, Attacker), Ring Explosion Sound, Color(White), Position Of(Event Player), 200);
		disabled Teleport(Event Player, Position Of(Event Player) + Facing Direction Of(Event Player) * 1.500);
		Teleport(Event Player, Ray Cast Hit Position(Position Of(Attacker), Position Of(Attacker) + Direction From Angles(
			Horizontal Facing Angle Of(Attacker), 0) * -5, All Players(All Teams), Attacker, True));
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Set Facing(Event Player, Direction Towards(Eye Position(Event Player), Eye Position(Attacker)), To World);
	}
}

rule("44: Primal Rage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 44;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Primal Rage");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 11;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Start Forcing Player To Be Hero(Event Player, Hero(Winston));
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, 100);
		Start Holding Button(Event Player, Button(Ultimate));
		Wait Until(Is Using Ultimate(Event Player), 2);
		Stop Holding Button(Event Player, Button(Ultimate));
		Wait Until(Event Player.PerkActivated == False, 20);
		Wait Until(Is Alive(Event Player), 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		disabled Event Player.PerkDuration = 1;
	}
}

rule("45: Eye for an Eye")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 45;
	}

	actions
	{
		Event Player.PerkColour = Color(Black);
		Event Player.PerkName = Custom String("Eye for an Eye");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		disabled Create Effect(All Players(All Teams), Reaper Wraith Form Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		disabled Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 20);
		disabled Destroy Effect(Event Player.G);
		disabled Event Player.G = 0;
	}
}

rule("45: Eye for an Eye Reflect")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 45;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Damage(Event Player, Null, Event Damage * 1);
	}
}

rule("46: Phlog")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 46;
	}

	actions
	{
		Event Player.PerkColour = Color(Blue);
		Event Player.PerkName = Custom String("Phlog");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Echo Cloning Effect, Color(Blue), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Set Damage Dealt(Event Player, 200);
		Start Forcing Throttle(Event Player, 0, 0, 0, 0, 0, 0);
		Set Status(Event Player, Null, Phased Out, 15);
		Set Move Speed(Event Player, 25);
		Set Gravity(Event Player, 500);
		Wait Until(Event Player.H == True, 25);
		Wait Until(!Is Communicating Any Emote(Event Player), 25);
		Stop Forcing Throttle(Event Player);
		Set Move Speed(Event Player, 100);
		Set Gravity(Event Player, 100);
		Clear Status(Event Player, Phased Out);
		Wait Until(Event Player.PerkActivated == False, 25);
		Set Damage Dealt(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
	}
}

rule("46: Phlog Taunt")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 46;
		Event Player.H != True;
		disabled Is Communicating Any Emote(Event Player) == False;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.I = Random Integer(1, 4);
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Cancel Primary Action(Event Player);
		If(Event Player.I == 1);
			Communicate(Event Player, Emote Up);
		Else If(Event Player.I == 2);
			Communicate(Event Player, Emote Left);
		Else If(Event Player.I == 3);
			Communicate(Event Player, Emote Right);
		Else;
			Communicate(Event Player, Emote Down);
		End;
		Wait(0.250, Ignore Condition);
		If(Is Communicating Any Emote(Event Player));
			Event Player.H = True;
		End;
		Loop If Condition Is True;
	}
}

rule("47: Random Hero")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 47;
	}

	actions
	{
		Event Player.PerkColour = Color(Rose);
		Event Player.PerkName = Custom String("Random Hero");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Start Forcing Player To Be Hero(Event Player, Random Value In Array(Filtered Array(All Heroes, Current Array Element != Hero Of(
			Event Player))));
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, 100);
		Wait Until(Event Player.PerkActivated == False, 20);
		Wait Until(Is Alive(Event Player), 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
	}
}

rule("47: Random Hero Dead")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 47;
	}

	actions
	{
		Event Player.PerkDuration = 0;
		Event Player.PerkActivated = False;
	}
}

rule("48: Random Teleport")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 48;
	}

	actions
	{
		Event Player.PerkColour = Color(Aqua);
		Event Player.PerkName = Custom String("Random Teleport");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1.500;
		Event Player.G = Random Value In Array(Filtered Array(All Living Players(Opposite Team Of(Team Of(Event Player))),
			Current Array Element != Event Player));
		Play Effect(Array(Event Player, Event Player.G), Ring Explosion Sound, Color(White), Position Of(Event Player), 200);
		Teleport(Event Player, Ray Cast Hit Position(Position Of(Event Player.G), Position Of(Event Player.G) + Direction From Angles(
			Horizontal Facing Angle Of(Event Player.G), 0) * -5, All Players(All Teams), Event Player.G, True));
		Event Player.G = 0;
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Set Facing(Event Player, Direction Towards(Eye Position(Event Player), Eye Position(Closest Player To(Event Player, All Teams))),
			To World);
	}
}

rule("49: Short Bounty")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 49;
	}

	actions
	{
		Event Player.PerkColour = Custom Color(87, 28, 116, 255);
		Event Player.PerkName = Custom String("Short Bounty");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		disabled Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Custom Color(87, 28, 116, 255), Always);
		Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Color(Purple), Always);
		Create Icon(All Players(All Teams), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), Skull,
			Visible To and Position, Custom Color(87, 28, 116, 255), False);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 99999);
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Destroy Icon(Event Player.G);
		Event Player.G = 0;
	}
}

rule("49: Short Bounty Kill")
{
	event
	{
		Player Dealt Final Blow;
		All;
		All;
	}

	conditions
	{
		Victim.DiceRoll == 49;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Big Message(Event Player, Custom String("Killed Bounty"));
		Heal(Event Player, Event Player, 9999);
		Set Status(Event Player, Null, Phased Out, 3);
		Set Ultimate Charge(Event Player, 100);
	}
}

rule("50: Conqueror's Will")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 50;
	}

	actions
	{
		Event Player.PerkColour = Color(Black);
		Event Player.PerkName = Custom String("Conqueror's Will");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Create Effect(All Players(All Teams), Sphere, Color(Black), Event Player.G, Event Player.H, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		Event Player.H = 1;
		Event Player.G = Position Of(Event Player);
		Chase Player Variable Over Time(Event Player, H, 25, 1, Destination and Duration);
		Wait(1, Ignore Condition);
		Stop Chasing Player Variable(Event Player, H);
		Wait Until(Event Player.PerkActivated == False, 99999);
		Destroy Effect(Event Player.I);
		Event Player.H = 0;
		Event Player.G = 0;
		Event Player.I = 0;
	}
}

rule("50: Conqueror's Will Loop")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 50;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Status(Filtered Array(Filtered Array(Players Within Radius(Event Player.G, Event Player.H, All Teams, Off),
			Current Array Element != Has Status(Current Array Element, Knocked Down)), Current Array Element != Event Player),
			Event Player, Knocked Down, 10);
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("51: Ice Timebomb")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 51;
	}

	actions
	{
		Event Player.PerkColour = Color(Aqua);
		Event Player.PerkName = Custom String("Ice Timebomb");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Create Effect(All Players(All Teams), Orb, Color(Aqua), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), 1,
			Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Create Effect(All Players(All Teams), Cloud, Color(Aqua), Event Player, 50, Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Damage(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player, 50);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Position Of(Event Player), 50);
		Set Status(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player, Frozen, 5);
		Wait(0.500, Ignore Condition);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("52: Safe Zone")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 52;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Safe Zone");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Ring, Color(Yellow), Event Player.G, 10, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		Event Player.G = Position Of(Event Player);
		Wait(10, Ignore Condition);
		Destroy Effect(Event Player.I);
		Event Player.G = 0;
		Event Player.I = 0;
	}
}

rule("52: Safe Zone Effect")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 52;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Status(Players Within Radius(Event Player.G, 10, All Teams, Off), Event Player, Phased Out, 0.500);
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("53: Overhealth")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 53;
	}

	actions
	{
		Event Player.PerkColour = Color(Lime Green);
		Event Player.PerkName = Custom String("Overhealth");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Heal(Event Player, Null, Max Health(Event Player));
		Add Health Pool To Player(Event Player, Health, Max Health(Event Player), False, True);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Remove Health Pool From Player(Last Created Health Pool);
	}
}

rule("54: Moon Shoes")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 54;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Moon Shoes");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Set Move Speed(Event Player, 75);
		Set Gravity(Event Player, 50);
		Set Jump Vertical Speed(Event Player, 175);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Gravity(Event Player, 100);
		Set Jump Vertical Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
	}
}

rule("55: Gravitational Hits")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 55;
	}

	actions
	{
		Event Player.PerkColour = Color(Violet);
		Event Player.PerkName = Custom String("Gravitational Hits");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
	}
}

rule("55: Gravitational Hits KB")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 55;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Apply Impulse(Victim, Up, 5, To World, Cancel Contrary Motion);
		Apply Impulse(Victim, Direction Towards(Event Player, Victim), -25, To World, Cancel Contrary Motion);
		Set Environment Credit Player(Victim, Event Player);
	}
}

rule("56: Aimbot")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 56;
	}

	actions
	{
		Event Player.PerkColour = Color(Lime Green);
		Event Player.PerkName = Custom String("Aimbot");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		disabled Event Player.G = False;
		Wait Until(Event Player.PerkActivated == False, 999999);
		disabled Event Player.G = 0;
		Stop Facing(Event Player);
	}
}

disabled rule("56: Aimbot Toggle")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 56;
		Is Button Held(Event Player, Button(Interact)) == True;
	}

	actions
	{
		If(Event Player.G == False);
			Event Player.G = True;
			Event Player.PerkColour = Color(Green);
			Small Message(Event Player, Custom String("Aimbot Enabled"));
			Abort;
		End;
		If(Event Player.G == True);
			Event Player.G = False;
			Event Player.PerkColour = Color(Red);
			Small Message(Event Player, Custom String("Aimbot Disabled"));
			Abort;
		End;
	}
}

disabled rule("56: Aimbot Off")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 56;
		Event Player.G == False;
	}

	actions
	{
		Stop Facing(Event Player);
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("56: Aimbot On")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 56;
		disabled Event Player.G == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Stop Facing(Event Player);
		Skip If(Is Dead(Closest Player To(Event Player, Opposite Team Of(Team Of(Event Player)))), 1);
		Start Facing(Event Player, Update Every Frame(Direction Towards(Eye Position(Event Player), Filtered Array(Eye Position(
			Closest Player To(Event Player, Opposite Team Of(Team Of(Event Player)))), Current Array Element != All Dead Players(
			All Teams)))), 10000, To World, Direction and Turn Rate);
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("57: Slow Motion")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 57;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Slow Motion");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 5;
		Set Slow Motion(50);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Slow Motion(100);
	}
}

rule("58: High Sensitivity")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 58;
	}

	actions
	{
		Event Player.PerkColour = Color(Green);
		Event Player.PerkName = Custom String("High Sensitivity");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Aim Speed(Event Player, 150);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Aim Speed(Event Player, 100);
	}
}

rule("59: Low Sensitivity")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 59;
	}

	actions
	{
		Event Player.PerkColour = Color(Rose);
		Event Player.PerkName = Custom String("Low Sensitivity");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Aim Speed(Event Player, 50);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Aim Speed(Event Player, 100);
	}
}

rule("60: Head Attachment")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 60;
	}

	actions
	{
		Event Player.PerkColour = Color(Rose);
		Event Player.PerkName = Custom String("Head Attachment");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Attach Players(Event Player, Random Value In Array(Filtered Array(All Living Players(Opposite Team Of(Team Of(Event Player))),
			Current Array Element != Event Player)), Vector(0, 3, 0));
		Wait(1, Ignore Condition);
		Set Environment Credit Player(Event Player, Closest Player To(Event Player, All Teams));
		Wait Until(Event Player.PerkActivated == False, 999999);
		Detach Players(Event Player);
	}
}

rule("61: Replaced by AI")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 61;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Replaced by AI");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Start Forcing Throttle(Event Player, 1, 0, 0, 0, 0, 0);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Facing(Event Player);
		Stop Forcing Throttle(Event Player);
		Stop Holding Button(Event Player, Button(Primary Fire));
	}
}

rule("61: Replaced by AI facing")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 61;
		disabled Event Player.G == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Facing(Event Player, Update Every Frame(Direction Towards(Eye Position(Event Player), Filtered Array(Eye Position(
			Player Closest To Reticle(Event Player, Opposite Team Of(Team Of(Event Player)))), Current Array Element != All Dead Players(
			All Teams)))), 10000, To World, Direction and Turn Rate);
		Start Holding Button(Event Player, Button(Primary Fire));
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("62: Tripped on rock")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 62;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Tripped on rock");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1;
		Damage(Event Player, Null, 25);
		Apply Impulse(Event Player, Up, 3, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), 15, To World,
			Cancel Contrary Motion);
		Set Status(Event Player, Null, Knocked Down, 0.500);
	}
}

rule("63: Slipped on banana")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 63;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Slipped on banana");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1;
		Damage(Event Player, Null, 50);
		Apply Impulse(Event Player, Up, 3, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), 50, To World,
			Cancel Contrary Motion);
		Set Status(Event Player, Null, Knocked Down, 2);
	}
}

rule("64: One Punch Man")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 64;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("One Punch Man");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Sparkles, Color(Orange), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("64: One Punch Man Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 64;
		disabled Event Ability == Button(Melee);
		((Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Event Ability == Button(Melee))) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Play Effect(All Players(All Teams), Bastion Tank Cannon Explosion Sound, Color(White), Position Of(Event Player), 200);
		Play Effect(All Players(All Teams), Ring Explosion, Color(White), Position Of(Event Player), 10);
		Disable Movement Collision With Environment(Victim, True);
		Disable Movement Collision With Players(Victim);
		Set Environment Credit Player(Victim, Event Player);
		Apply Impulse(Victim, Up, 10, To World, Cancel Contrary Motion);
		Apply Impulse(Victim, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), 50, To World, Cancel Contrary Motion);
		Wait(0.250, Ignore Condition);
		Start Damage Over Time(Victim, Event Player, 0.500, Max Health(Victim) * 3);
		Wait(1, Ignore Condition);
		Enable Movement Collision With Environment(Victim);
		Enable Movement Collision With Players(Victim);
	}
}

rule("64: One Punch Man Endlag")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 64;
		Is Meleeing(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Move Speed(Event Player, 25);
		Wait(1, Ignore Condition);
		Set Move Speed(Event Player, 50);
		Wait(0.500, Ignore Condition);
		Set Move Speed(Event Player, 75);
		Wait(0.750, Ignore Condition);
		Set Move Speed(Event Player, 100);
	}
}

rule("65: Golden Gun")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 65;
	}

	actions
	{
		Event Player.PerkColour = Custom Color(218, 165, 32, 255);
		Event Player.PerkName = Custom String("Golden Gun");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Custom Color(218, 165, 32, 255), Occluded);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
	}
}

rule("65: Golden Gun Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 65;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Kill(Victim, Event Player);
		Event Player.PerkDuration = 0;
		Event Player.PerkActivated = False;
	}
}

rule("66: No Hud")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 66;
	}

	actions
	{
		Event Player.PerkColour = Color(Black);
		Event Player.PerkName = Custom String("No Hud");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Wait(0.500, Ignore Condition);
		Disable Hero HUD(Event Player);
		Disable Game Mode HUD(Event Player);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Enable Hero HUD(Event Player);
		Enable Game Mode HUD(Event Player);
	}
}

rule("67: Flamethrower")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 67;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Flamethrower");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Bad Aura, Color(Orange), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("67: Flamethrower Primary")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 67;
		Event Ability == Button(Primary Fire);
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("67: Flamethrower Secondary")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 67;
		Event Ability == Button(Secondary Fire);
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("67: Flamethrower Ability 1")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 67;
		Event Ability == Button(Ability 1);
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("67: Flamethrower Ability 2")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 67;
		Event Ability == Button(Ability 2);
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("67: Flamethrower Ultimate")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 67;
		Event Ability == Button(Ultimate);
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("67: Flamethrower Melee")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 67;
		Event Ability == Button(Melee);
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("68: Apply damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 68;
		Is On Ground(Event Player) == True;
		Event Player.G < -10;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Damage(Event Player, Null, Absolute Value(Event Player.G) * Max Health(Event Player) / 200 * (Absolute Value(Event Player.G) / 8)
			* 2);
	}
}

rule("68: Find speed")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Altitude Of(Event Player) < 1;
		Is In Air(Event Player) == True;
		Event Player.DiceRoll == 68;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.G = Vertical Speed Of(Event Player) * 1.750;
	}
}

rule("68: Fall Damage (Credits to Lilo for the code: (9SCKQ))")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 68;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Fall Damage");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Small Message(Event Player, Custom String("Thank you to Lilo for the code: (9SCKQ)"));
		Wait Until(Event Player.PerkActivated == False, 999999);
		Event Player.G = 0;
	}
}

rule("69: Spin effect")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 69;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Facing(Event Player, World Vector Of(Vector(1, 0, 0), Event Player, Rotation), 500, To World, Direction and Turn Rate);
		Wait(0.100, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("69: Spin")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 69;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Spin");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 3;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Facing(Event Player);
	}
}

rule("70: Eliminate Yourself")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 70;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Eliminate Yourself");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 8;
		Event Player.G = False;
		Wait Until(Event Player.PerkActivated == False, 999999);
		If(Event Player.G == False);
			Set Status(Event Player, Null, Hacked, 10);
		End;
		Event Player.G = 0;
	}
}

rule("70: Eliminate Yourself Rez")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 70;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.G = True;
		Event Player.PerkDuration = 0;
		Event Player.PerkActivated = False;
		Big Message(Event Player, Custom String("Reviving"));
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Create Effect(All Players(All Teams), Sphere, Color(Yellow), Eye Position(Event Player), 0.500, None);
		Event Player.H = Last Created Entity;
		Wait(1, Ignore Condition);
		Play Effect(All Players(All Teams), Buff Explosion Sound, Color(White), Position Of(Event Player), 200);
		Play Effect(All Players(All Teams), Good Pickup Effect, Color(Yellow), Position Of(Event Player), 5);
		Wait(0.500, Ignore Condition);
		Resurrect(Event Player);
		Set Status(Event Player, Null, Rooted, 1);
		Set Status(Event Player, Null, Hacked, 1);
		Set Status(Event Player, Null, Phased Out, 1);
		Disallow Button(Event Player, Button(Primary Fire));
		Disallow Button(Event Player, Button(Secondary Fire));
		Wait(1, Ignore Condition);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Destroy Effect(Event Player.H);
		Event Player.H = 0;
		If(Current Game Mode == Game Mode(Deathmatch));
			Set Player Score(Event Player, Score Of(Event Player) + 2);
			Set Player Score(Attacker, Score Of(Attacker) - 1);
		End;
		Set Move Speed(Event Player, 250);
		Wait(5, Ignore Condition);
		Set Move Speed(Event Player, 100);
	}
}

rule("71: Not on my Watch.")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 71;
	}

	actions
	{
		Event Player.PerkColour = Color(Black);
		Event Player.PerkName = Custom String("Not on my watch");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
	}
}

rule("71: Not on my Watch Lock")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 71;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Status(Ray Cast Hit Player(Eye Position(Event Player), Eye Position(Event Player) + Facing Direction Of(Event Player) * 200,
			All Players(Opposite Team Of(Team Of(Event Player))), Event Player, True), Event Player, Hacked, 1);
		Wait(0.100, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("72: Danger Zone")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 72;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Danger Zone");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Ring, Color(Red), Event Player.G, 10, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		Event Player.G = Position Of(Event Player);
		Wait Until(Event Player.PerkActivated == False, 25);
		Destroy Effect(Event Player.I);
		Event Player.G = 0;
		Event Player.I = 0;
	}
}

rule("72: Danger Zone Effect")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 72;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Start Damage Over Time(Players Within Radius(Event Player.G, 10, All Teams, Off), Event Player, 0.500, 15);
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("73: Kaioken x2")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 73;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Kaioken x2");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Start Damage Over Time(Event Player, Null, 10, 10);
		Create Effect(All Players(All Teams), Good Aura, Color(Red), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Set Damage Dealt(Event Player, 200);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Set Damage Dealt(Event Player, 100);
	}
}

rule("74: Revitalised")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 74;
	}

	actions
	{
		Event Player.PerkColour = Color(Lime Green);
		Event Player.PerkName = Custom String("Revitalised");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Big Message(Event Player, Custom String("Press Interact to Use."));
	}
}

rule("74: Revitalised Heal")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 74;
		Is Button Held(Event Player, Button(Interact)) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Player Health(Event Player, Max Health(Event Player));
		Set Ability Cooldown(Event Player, Button(Secondary Fire), 0);
		Set Ability Cooldown(Event Player, Button(Ability 1), 0);
		Set Ability Cooldown(Event Player, Button(Ability 2), 0);
		Set Ability Cooldown(Event Player, Button(Jump), 0);
		Event Player.PerkDuration = 0;
		Event Player.PerkActivated = False;
	}
}

rule("75: Shrink Ray")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 75;
	}

	actions
	{
		Event Player.PerkColour = Color(Turquoise);
		Event Player.PerkName = Custom String("Shrink Ray");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Sparkles, Color(Turquoise), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("75: Shrink Ray Effect")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Attacker.DiceRoll == 75;
	}

	actions
	{
		Abort If(Attacker.SelectingFavourite == True);
		Small Message(Event Player, Custom String("Shrunk by {0} {1}", Hero Icon String(Hero Of(Attacker)), Attacker));
		Start Scaling Player(Event Player, 0.500, True);
		Set Damage Received(Event Player, 200);
		Start Modifying Hero Voice Lines(Event Player, 1.500, True);
		Set Move Speed(Event Player, 75);
		Wait(3, Ignore Condition);
		Stop Scaling Player(Event Player);
		Set Damage Received(Event Player, 100);
		Stop Modifying Hero Voice Lines(Event Player);
		Set Move Speed(Event Player, 100);
	}
}

rule("76: Altitude Damage Loop")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 76;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.G = Altitude Of(Event Player) * 100 + 100;
		Set Damage Dealt(Event Player, Event Player.G);
		Wait(0.100, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("76: Altitude Damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 76;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Altitude Damage");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Progress Bar HUD Text(Event Player, Event Player.G / 10, Custom String("Current Damage Dealt: {0}%", Round To Integer(
			Event Player.G, Up)), Top, 5, Color(Purple), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Wait(0.250, Ignore Condition);
		Destroy Progress Bar HUD Text(Event Player.H);
		Event Player.G = 0;
		Set Damage Dealt(Event Player, 100);
		Event Player.H = 0;
	}
}

disabled rule("77: Invulnerability")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 77;
	}

	actions
	{
		Event Player.PerkColour = Color(Lime Green);
		Event Player.PerkName = Custom String("Invulnerability");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Set Status(Event Player, Null, Invincible, 10);
		Set Move Speed(Event Player, 75);
		Create Effect(All Players(All Teams), Good Aura, Color(Lime Green), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Clear Status(Event Player, Invincible);
		Set Move Speed(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("77: Beacon")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 77;
	}

	actions
	{
		Skip If(Event Player.PerkDuration > 0, 4);
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("Beacon");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
		Play Effect(All Players(All Teams), Ring Explosion, Color(Yellow), Update Every Frame(Position Of(Event Player) + Vector(0, 1, 0)),
			15);
		Wait(1, Ignore Condition);
		Loop If(Event Player.PerkDuration > 0);
	}
}

rule("78: Partial Invisibility")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 78;
	}

	actions
	{
		Event Player.PerkColour = Color(Black);
		Event Player.PerkName = Custom String("Partial Invisibility");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Reaper Wraith Form Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Start Forcing Player Outlines(Event Player, All Players(All Teams), False, Color(White), Default);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("78: Partial Invisibility Dodge")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 78;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.H = Random Integer(1, 2);
		If(Event Player.H != 1);
			Heal(Event Player, Null, Event Damage);
		End;
		Event Player.H = 0;
	}
}

rule("79: Berserk")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 79;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Berserk");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Bad Aura, Color(Red), Update Every Frame(Event Player), 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("79: Berserk Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 79;
		((Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Event Ability == Button(Melee))) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Damage(Victim, Event Player, Random Integer(0, 400));
	}
}

rule("80: Slapped by fish")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 80;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Slapped by Fish");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1;
		Set Move Speed(Event Player, 50);
		Damage(Event Player, Null, 75);
		Apply Impulse(Event Player, Up, 5, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), -70, To World,
			Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), -70, To World,
			Cancel Contrary Motion);
		Set Status(Event Player, Null, Knocked Down, 1);
		Wait(3, Ignore Condition);
		Set Move Speed(Event Player, 100);
	}
}

rule("81: The Horse is here")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 81;
	}

	actions
	{
		Event Player.PerkColour = Color(Yellow);
		Event Player.PerkName = Custom String("The Horse is here");
		Abort If(Event Player.SelectingFavourite == True);
		If(Current Game Mode == Game Mode(Deathmatch));
			Event Player.PerkDuration = 60;
		Else;
			Event Player.PerkDuration = 30;
		End;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Big Message(All Players(All Teams), Custom String("{0} The Horse Is Here {0}", Hero Icon String(Hero(Orisa))));
		Create In-World Text(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}",
			Hero Icon String(Hero(Orisa))), Update Every Frame(Eye Position(Event Player) + Vector(0, 1.750, 0)), 2, Do Not Clip,
			Visible To Position and String, Color(White), Default Visibility);
		Event Player.J = Last Text ID;
		Create Progress Bar In-World Text(Filtered Array(All Players(All Teams), Current Array Element != Event Player),
			Event Player.PerkDuration / 60 * 100, Custom String(""), Update Every Frame(Eye Position(Event Player) + Vector(0, 0, 0)),
			0.500, Do Not Clip, Color(Yellow), Color(White), Visible To Position Values and Color, Default Visibility);
		Event Player.K = Last Text ID;
		Start Forcing Player To Be Hero(Event Player, Hero(Orisa));
		Set Damage Received(Event Player, 150);
		Set Damage Dealt(Event Player, 125);
		Set Move Speed(Event Player, 125);
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, 75);
		Wait Until(Event Player.PerkActivated == False, 70);
		Wait Until(Is Alive(Event Player), 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Set Damage Received(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Big Message(All Players(All Teams), Custom String("{0} The Horse Is Gone {0}", Hero Icon String(Hero(Orisa))));
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Destroy In-World Text(Event Player.J);
		Event Player.J = 0;
		Destroy Progress Bar In-World Text(Event Player.K);
		Event Player.K = 0;
		Wait Until(Event Player.DiceCooldown > 0, 999999);
		Event Player.DiceCooldown = Event Player.DiceCooldown + 10;
	}
}

rule("81: Horse Resurrect")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 81;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Big Message(Event Player, Custom String("Reviving"));
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Create Effect(All Players(All Teams), Sphere, Color(Yellow), Eye Position(Event Player), 0.500, None);
		Event Player.I = Last Created Entity;
		Play Effect(All Players(All Teams), Buff Explosion Sound, Color(White), Position Of(Event Player), 200);
		Play Effect(All Players(All Teams), Good Pickup Effect, Color(Yellow), Position Of(Event Player), 5);
		Wait(0.250, Ignore Condition);
		Resurrect(Event Player);
		Big Message(All Players(All Teams), Custom String("{0} The Horse Is Back {0}", Hero Icon String(Hero(Orisa))));
		Set Status(Event Player, Null, Rooted, 0.250);
		Set Status(Event Player, Null, Hacked, 0.250);
		Set Status(Event Player, Null, Phased Out, 0.250);
		Disallow Button(Event Player, Button(Primary Fire));
		Disallow Button(Event Player, Button(Secondary Fire));
		Event Player.PerkDuration -= 15;
		If(Event Player.PerkDuration < 0);
			Event Player.PerkDuration = 0;
		End;
		Wait(0.250, Ignore Condition);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Destroy Effect(Event Player.I);
		Event Player.I = 0;
		If(Current Game Mode == Game Mode(Deathmatch));
			Set Player Score(Attacker, Score Of(Attacker) - 1);
		End;
	}
}

rule("82: Freeze Ray")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 82;
	}

	actions
	{
		Event Player.PerkColour = Color(Aqua);
		Event Player.PerkName = Custom String("Freeze Ray");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Mei Frozen Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("82: Freeze Ray Effect")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Attacker.DiceRoll == 82;
		Has Status(Event Player, Frozen) == False;
	}

	actions
	{
		Abort If(Attacker.SelectingFavourite == True);
		Small Message(Event Player, Custom String("Frozen by {0} {1}", Hero Icon String(Hero Of(Attacker)), Attacker));
		Set Status(Event Player, Attacker, Frozen, 0.250);
		Set Damage Received(Event Player, 75);
		Wait Until(!Has Status(Event Player, Frozen), 0.500);
		Set Damage Received(Event Player, 100);
	}
}

rule("83: Time Keeper")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 83;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Time Keeper");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 2.500;
		Set Slow Motion(25);
		Set Move Speed(Event Player, 225);
		Set Damage Dealt(Event Player, 150);
		Set Projectile Speed(Event Player, 225);
		Set Ability Cooldown(Event Player, Button(Secondary Fire), 0);
		Set Ability Cooldown(Event Player, Button(Ability 1), 0);
		Set Ability Cooldown(Event Player, Button(Ability 2), 0);
		Set Ability Cooldown(Event Player, Button(Jump), 0);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Slow Motion(100);
		Set Move Speed(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Set Projectile Speed(Event Player, 100);
	}
}

rule("84: Float Push")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 84;
		Vertical Speed Of(Event Player) <= 2;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Apply Impulse(Event Player, Up, 2, To World, Cancel Contrary Motion);
	}
}

rule("84: Float")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 84;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Float");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Gravity(Event Player, 0);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Gravity(Event Player, 100);
	}
}

rule("85: Sent to Heaven")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 85;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Sent to Heaven");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 3;
		Apply Impulse(All Players(All Teams), Up, 70, To World, Cancel Contrary Motion);
		Small Message(All Players(All Teams), Custom String("Sent to heaven by {0}", Event Player));
		Set Environment Credit Player(All Players(All Teams), Event Player);
	}
}

rule("86: Heart Virus")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 86;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Heart Virus");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Set Move Speed(Event Player, 100);
		Wait Until(Event Player.PerkDuration / 10 * 100 < 75, 15);
		Set Move Speed(Event Player, 75);
		Set Aim Speed(Event Player, 75);
		Wait Until(Event Player.PerkDuration / 10 * 100 < 50, 15);
		Set Move Speed(Event Player, 50);
		Set Aim Speed(Event Player, 50);
		Wait Until(Event Player.PerkDuration / 10 * 100 < 25, 15);
		Set Aim Speed(Event Player, 25);
		Set Move Speed(Event Player, 25);
		Wait Until(Event Player.PerkActivated == False, 15);
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Set Status(Event Player, Null, Knocked Down, 4);
		Wait(0.500, Ignore Condition);
		Abort If(Is Dead(Event Player));
		Start Damage Over Time(Event Player, Null, 2, Max Health(Event Player) * 2);
		Wait(2, Ignore Condition);
		Wait Until(Event Player.DiceCooldown > 0, 5);
		Event Player.DiceCooldown = 5;
	}
}

rule("86: Heart Virus Die")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 86;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 0;
		Event Player.PerkActivated = False;
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Stop All Damage Over Time(Event Player);
	}
}

rule("87: Sturdy")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 87;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Sturdy");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Knockback Received(Event Player, 0);
		Set Move Speed(Event Player, 80);
		Add Health Pool To Player(Event Player, Armor, 250, True, True);
		Set Damage Received(Event Player, 75);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Knockback Received(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Remove All Health Pools From Player(Event Player);
	}
}

rule("88: Constant Nullification")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 88;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Constant Nullification");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Event Player.I = 10;
		Create Effect(All Players(All Teams), Ring, Color(White), Event Player, Event Player.I, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Create Effect(All Players(All Teams), Sphere, Color(White), Event Player, Event Player.I, Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Destroy Effect(Event Player.H);
		Event Player.I = 0;
		Event Player.G = 0;
		Event Player.H = 0;
	}
}

rule("88: Nullification")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 88;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Slow Motion(100);
		Cancel Primary Action(Filtered Array(Players Within Radius(Event Player, Event Player.I, All Teams, Off),
			Current Array Element != Event Player));
		Stop All Heal Over Time(Players Within Radius(Event Player, Event Player.I, All Teams, Off));
		Clear Status(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Hacked);
		Clear Status(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Burning);
		Clear Status(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Knocked Down);
		Clear Status(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Asleep);
		Clear Status(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Frozen);
		Clear Status(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Rooted);
		Clear Status(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Stunned);
		Stop All Damage Over Time(Players Within Radius(Event Player, Event Player.I, All Teams, Off));
		Set Aim Speed(Players Within Radius(Event Player, Event Player.I, All Teams, Off), 100);
		Set Move Speed(Players Within Radius(Event Player, Event Player.I, All Teams, Off), 100);
		Set Damage Received(Players Within Radius(Event Player, Event Player.I, All Teams, Off), 100);
		Set Damage Dealt(Players Within Radius(Event Player, Event Player.I, All Teams, Off), 100);
		Set Gravity(Players Within Radius(Event Player, Event Player.I, All Teams, Off), 100);
		Set Knockback Dealt(Players Within Radius(Event Player, Event Player.I, All Teams, Off), 100);
		Set Knockback Received(Players Within Radius(Event Player, Event Player.I, All Teams, Off), 100);
		Stop Modifying Hero Voice Lines(Players Within Radius(Event Player, Event Player.I, All Teams, Off));
		Stop Scaling Player(Players Within Radius(Event Player, Event Player.I, All Teams, Off));
		Filtered Array(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Current Array Element != Event Player)
			.PerkDuration = 0;
		Filtered Array(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Current Array Element != Event Player)
			.PerkActivated = False;
		Set Environment Credit Player(Event Player, Players Within Radius(Event Player, Event Player.I, All Teams, Off));
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("89: A-Train")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 89;
	}

	actions
	{
		Event Player.PerkColour = Color(Aqua);
		Event Player.PerkName = Custom String("A-Train");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Create Effect(All Players(All Teams), Good Aura, Color(Aqua), Event Player, 1, Visible To Position and Radius);
		Start Forcing Throttle(Event Player, 1, 1, 0, 0, 0, 0);
		Event Player.G = Last Created Entity;
		Disable Movement Collision With Players(Event Player);
		disabled Set Status(Event Player, Null, Hacked, 9999);
		disabled Set Primary Fire Enabled(Event Player, False);
		disabled Set Secondary Fire Enabled(Event Player, False);
		Set Move Speed(Event Player, 400);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Move Speed(Event Player, 100);
		disabled Clear Status(Event Player, Hacked);
		disabled Set Primary Fire Enabled(Event Player, True);
		disabled Set Secondary Fire Enabled(Event Player, True);
		Stop Forcing Throttle(Event Player);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Enable Movement Collision With Players(Event Player);
	}
}

rule("89: A-Train Array")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 89;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Filtered Array(Players Within Radius(Event Player, 5, All Teams, Surfaces), Current Array Element != Event Player)
			.PushAway = Event Player;
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("89: A-Train Push")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.PushAway != 0;
		Event Player.PushAway.DiceRoll == 89;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Skip If(Is Dead(Event Player.PushAway) == True, 6);
		Apply Impulse(Event Player, Up, 5, To World, Cancel Contrary Motion);
		Wait(0.100, Ignore Condition);
		Apply Impulse(Event Player, Direction Towards(Event Player.PushAway, Event Player), 70, To World, Cancel Contrary Motion);
		Set Environment Credit Player(Event Player, Event Player.PushAway);
		Damage(Event Player, Event Player.PushAway, 300);
		Wait(0.250, Ignore Condition);
		Event Player.PushAway = 0;
	}
}

rule("89: A-Train kill Notification")
{
	event
	{
		Player Dealt Final Blow;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 89;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Big Message(Array(Event Player, Victim), Custom String("{0} I can't stop...", Hero Icon String(Hero Of(Event Player))));
		disabled Event Player.PerkDuration = 0;
		disabled Event Player.PerkActivated = False;
	}
}

rule("90: Gravitational Push")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 90;
	}

	actions
	{
		Event Player.PerkColour = Color(Violet);
		Event Player.PerkName = Custom String("Gravitational Push");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Sphere, Color(Violet), Event Player, 10, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Disable Movement Collision With Players(Event Player);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Enable Movement Collision With Players(Event Player);
	}
}

rule("90: Grav Push Array")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 90;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Filtered Array(Players Within Radius(Event Player, 10, All Teams, Off), Current Array Element != Event Player)
			.PushAway = Event Player;
		Wait(0.050, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("90: Grav Push Impulse")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.PushAway != 0;
		Event Player.PushAway.DiceRoll == 90;
		Is Alive(Event Player.PushAway) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Skip If(Is Dead(Event Player.PushAway) == True, 4);
		Apply Impulse(Event Player, Up, 1, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction Towards(Event Player.PushAway, Event Player), 10, To World, Cancel Contrary Motion);
		Set Environment Credit Player(Event Player, Event Player.PushAway);
		Wait(0.016, Ignore Condition);
		Event Player.PushAway = 0;
	}
}

rule("91: Gravitational Pull")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 91;
	}

	actions
	{
		Event Player.PerkColour = Color(Purple);
		Event Player.PerkName = Custom String("Gravitational Pull");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Sphere, Color(Purple), Event Player, 10, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Disable Movement Collision With Players(Event Player);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Enable Movement Collision With Players(Event Player);
	}
}

rule("91: Grav Pull Array")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 91;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Filtered Array(Players Within Radius(Event Player, 10, All Teams, Off), Current Array Element != Event Player)
			.PushAway = Event Player;
		Wait(0.050, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("91: Grav Pull Impulse")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.PushAway != 0;
		Event Player.PushAway.DiceRoll == 91;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Skip If(Is Dead(Event Player.PushAway) == True, 4);
		Apply Impulse(Event Player, Up, 1, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction Towards(Event Player.PushAway, Event Player), -15, To World, Cancel Contrary Motion);
		Set Environment Credit Player(Event Player, Event Player.PushAway);
		Wait(0.016, Ignore Condition);
		Event Player.PushAway = 0;
	}
}

rule("92: Lost the Dice")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 92;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Lost the Dice");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 2.500;
		Wait Until(Event Player.DiceCooldown > 0, 999999);
		Event Player.DiceCooldown = Event Player.DiceCooldown + 5;
		Big Message(Event Player, Custom String("You lost the dice?"));
	}
}

rule("93: Stole the Dice")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 93;
	}

	actions
	{
		Event Player.PerkColour = Color(Rose);
		Event Player.PerkName = Custom String("Stole the Dice");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 3;
		Big Message(Event Player, Custom String("You stole the dice from..."));
		Wait(0.100, Ignore Condition);
		Event Player.StolenPlrName = Random Value In Array(Filtered Array(Filtered Array(All Players(All Teams),
			Current Array Element.PerkActivated == True), Current Array Element != Event Player));
		If(Event Player.StolenPlrName == (Empty Array || 0));
			Big Message(Event Player, Custom String("Couldn't find a player!"));
			Event Player.StolenPlrName = 0;
			Abort;
		End;
		Event Player.StolenDiceRoll = Event Player.StolenPlrName.DiceRoll;
		Event Player.StolenDiceName = Event Player.StolenPlrName.PerkName;
		Big Message(Event Player.StolenPlrName, Custom String("Perk stolen by {0}", Event Player));
		Big Message(Event Player, Custom String("{0} from {1} {2}!", Event Player.StolenDiceName, Hero Icon String(Hero Of(
			Event Player.StolenPlrName)), Event Player.StolenPlrName));
		disabled Event Player.PerkDuration = 0;
		disabled Event Player.PerkActivated = False;
		Event Player.PerkActivated = True;
		Event Player.DiceRoll = Event Player.StolenDiceRoll;
		Wait(0.250, Ignore Condition);
		Event Player.StolenPlrName.PerkDuration = 0;
		Event Player.StolenPlrName.PerkActivated = False;
		Event Player.StolenPlrName = 0;
		Event Player.StolenDiceRoll = 0;
		Event Player.StolenDiceName = 0;
	}
}

rule("94: Esp")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 94;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("ESP");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Start Forcing Player Outlines(All Players(All Teams), Event Player, True, Color(Rose), Always);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Forcing Player Outlines(All Players(All Teams), Event Player);
	}
}

rule("95: Honoured Eyes")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 95;
	}

	actions
	{
		Event Player.PerkColour = Color(Sky Blue);
		Event Player.PerkName = Custom String("Honoured Eyes");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
	}
}

rule("96: Smoke Bomb")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 96;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Smoke Bomb");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Create Effect(All Players(All Teams), Bad Aura, Color(Gray), Eye Position(Event Player), 15, None);
		Event Player.G = Last Created Entity;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), False, Color(White), Default);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("97: Yippee")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 97;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Yippee!");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 1;
		Kill(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player);
		Big Message(All Players(All Teams), Custom String("Yippee!!!!"));
		Wait(2, Ignore Condition);
		Kill(Filtered Array(Filtered Array(Players On Hero(Hero(D.Va), All Teams), Is In Alternate Form(Current Array Element) == True),
			Current Array Element != Event Player), Event Player);
		Wait Until(Event Player.DiceCooldown > 0, 999999);
		Event Player.DiceCooldown = 1;
	}
}

rule("98: Stalker")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 98;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Stalker");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 30;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), False, Color(White), Default);
		Create Progress Bar HUD Text(Event Player, Event Player.G / 10, Custom String("Current Damage Dealt: {0}%", Round To Integer(
			Event Player.G, Up)), Top, 5, Color(Red), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		Event Player.G = 100;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Wait(0.250, Ignore Condition);
		Destroy Progress Bar HUD Text(Event Player.H);
		Event Player.G = 0;
		Set Damage Dealt(Event Player, 100);
		Event Player.H = 0;
		Event Player.I = 0;
	}
}

rule("98: Stalk Damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 98;
		Array Contains(Players in View Angle(Event Player.I, All Teams, 45), Event Player) == False;
		Is Alive(Event Player.I) == True;
		Is In Line of Sight(Event Player, Event Player.I, Barriers Do Not Block LOS) == True;
		Is Alive(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.G = Event Player.G + 10;
		Set Damage Dealt(Event Player, Event Player.G);
		Wait(0.100, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("98: Is Stalking")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 98;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		disabled Event Player.I = Ray Cast Hit Player(Eye Position(Event Player), Eye Position(Event Player) + Facing Direction Of(Event Player)
			* 200, All Players(Opposite Team Of(Team Of(Event Player))), Event Player, False);
		Event Player.I = Player Closest To Reticle(Event Player, All Teams);
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
		End;
	}
}

rule("99: See the world burn")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 99;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("See the world burn");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Set Status(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player, Burning, 10);
		Start Damage Over Time(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player, 10, 20);
		Big Message(All Players(All Teams), Custom String("{0}{1} wants to see the world burn.", Hero Icon String(Hero Of(Event Player)),
			Event Player));
		Wait Until(Event Player.PerkActivated == False, 999999);
		Clear Status(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Burning);
	}
}

rule("100: Blood is Fuel")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 100;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Blood is Fuel");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Start Damage Over Time(Event Player, Null, 10, Max Health(Event Player) * 0.750 / Event Player.PerkDuration);
		Set Move Speed(Event Player, 125);
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Move Speed(Event Player, 115);
	}
}

rule("100: Blood is Fuel Heal")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 100;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Heal(Event Player, Null, Event Damage);
	}
}

rule("101: Party Time")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 101;
	}

	actions
	{
		Event Player.PerkColour = Color(Blue);
		Event Player.PerkName = Custom String("Party Time");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 3;
		Big Message(All Players(All Teams), Custom String("PARTY TIME!!!!"));
		Disable Movement Collision With Players(All Players(All Teams));
		Teleport(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player);
		Heal(All Players(All Teams), Event Player, 999);
		Set Environment Credit Player(All Players(All Teams), Event Player);
		Set Ability Cooldown(All Players(All Teams), Button(Secondary Fire), 0);
		Set Ability Cooldown(All Players(All Teams), Button(Ability 1), 0);
		Set Ability Cooldown(All Players(All Teams), Button(Ability 2), 0);
		Set Ability Cooldown(All Players(All Teams), Button(Jump), 0);
		Set Ultimate Charge(All Players(All Teams), 100);
		All Players(All Teams).PerkDuration = 0;
		All Players(All Teams).PerkActivated = False;
		Wait(0.500, Ignore Condition);
		All Players(All Teams).DiceCooldown = 0;
		Wait(0.500, Ignore Condition);
		Enable Movement Collision With Players(All Players(All Teams));
		Press Button(Event Player, Button(Interact));
	}
}

rule("102: Sorcerer's Jackpot")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 102;
	}

	actions
	{
		Event Player.PerkColour = Color(Turquoise);
		Event Player.PerkName = Custom String("Sorcerer's Jackpot");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 251;
		Set Move Speed(Event Player, 275);
		Set Damage Dealt(Event Player, 125);
		Start Heal Over Time(Event Player, Event Player, 9999, 250);
		Set Knockback Dealt(Event Player, 200);
		Set Knockback Received(Event Player, 0);
		Create Progress Bar HUD Text(Event Player, Event Player.PerkDuration / 251 * 100, Custom String("Energy Remaining:"), Top, 10,
			Color(Turquoise), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.I = Last Text ID;
		Create Progress Bar In-World Text(Filtered Array(All Players(All Teams), Current Array Element != Event Player),
			Event Player.PerkDuration / 251 * 100, Custom String(""), Update Every Frame(Eye Position(Event Player) + Vector(0, 0, 0)),
			0.500, Do Not Clip, Color(Turquoise), Color(White), Visible To Position Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		Create Effect(All Players(All Teams), Bad Aura, Color(Turquoise), Event Player, 3, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Stop All Heal Over Time(Event Player);
		Set Move Speed(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Set Knockback Dealt(Event Player, 100);
		Set Knockback Received(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Destroy Progress Bar In-World Text(Event Player.H);
		Event Player.H = 0;
		Destroy Progress Bar HUD Text(Event Player.I);
		Event Player.I = 0;
		disabled Wait Until(Event Player.DiceCooldown > 0, 999999);
		disabled Event Player.DiceCooldown = Event Player.DiceCooldown + 30;
	}
}

rule("102: Sorcerer's Jackpot Damage")
{
	event
	{
		Player Dealt Healing;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 102;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration -= Event Healing / 5;
		If(Event Player.PerkDuration < 0);
			Event Player.PerkDuration = 0;
		End;
	}
}

rule("102: Sorcerer Die")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 102;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = Event Player.PerkDuration / 2;
		disabled Event Player.PerkActivated = False;
	}
}

rule("103: Lightspeed")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 103;
	}

	actions
	{
		Event Player.PerkColour = Color(White);
		Event Player.PerkName = Custom String("Lightspeed");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Set Move Speed(Event Player, 1000);
		Create Effect(All Players(All Teams), Sparkles, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Move Speed(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("104: The Floor Is Lava")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 104;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("The Floor Is Lava");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
	}
}

rule("104: The Floor Is Lava Damage Loop")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 104;
		Is On Ground(Event Player) == True;
		Is Alive(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Set Status(Event Player, Null, Burning, 0.250);
		Damage(Event Player, Null, 6.250);
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("105: Legendary")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 105;
	}

	actions
	{
		Event Player.PerkColour = Color(Orange);
		Event Player.PerkName = Custom String("Legendary");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Max Health(Event Player, 404);
		Set Player Health(Event Player, Health(Event Player) * 4.040);
		Set Damage Dealt(Event Player, 300);
		Create Effect(All Players(All Teams), Bad Aura, Color(Orange), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Player Health(Event Player, Health(Event Player) * 0.248);
		Set Max Health(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("106: Tragic")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 106;
	}

	actions
	{
		Event Player.PerkColour = Color(Gray);
		Event Player.PerkName = Custom String("Tragic");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Max Health(Event Player, 40);
		Set Damage Dealt(Event Player, 25);
		Create Effect(All Players(All Teams), Bad Aura, Color(Gray), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Max Health(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("107: Headache")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 107;
	}

	actions
	{
		Event Player.PerkColour = Color(Red);
		Event Player.PerkName = Custom String("Headache");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 15;
	}
}

rule("107: Headache Damage")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 107;
		Event Was Critical Hit == True;
	}

	actions
	{
		Damage(Event Player, Attacker, Event Damage / 2);
	}
}

rule("108: Accelerated Ultimate")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 108;
	}

	actions
	{
		Skip If(Event Player.PerkDuration > 0, 4);
		Event Player.PerkColour = Color(Aqua);
		Event Player.PerkName = Custom String("Accelerated Ultimate");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) + 1);
		Wait(0.063, Ignore Condition);
		Loop If(Event Player.PerkDuration > 0);
	}
}

rule("109: Damage Reflection")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 109;
	}

	actions
	{
		Event Player.PerkColour = Color(Black);
		Event Player.PerkName = Custom String("Damage Reflection");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 25;
		Create Effect(All Players(All Teams), Reaper Wraith Form Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 25);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("109: Damage Reflection Reflect")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 109;
	}

	actions
	{
		Abort If(Event Player.SelectingFavourite == True);
		Damage(Attacker, Event Player, Event Damage * 1);
	}
}

rule("110: Personal Orbital Ray")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.DiceRoll == 110;
	}

	actions
	{
		Event Player.PerkColour = Color(Violet);
		Event Player.PerkName = Custom String("Personal Orbital Ray");
		Abort If(Event Player.SelectingFavourite == True);
		Event Player.PerkDuration = 10;
		Set Damage Dealt(Event Player, 135);
		Start Heal Over Time(Event Player, Event Player, 9999, 85);
		Create Effect(All Players(All Teams), Heal Target Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Create Effect(All Players(All Teams), Mercy Damage Boosted Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		Create Effect(All Players(All Teams), Light Shaft, Color(Violet), Update Every Frame(Position Of(Event Player) + Vector(0, -1, 0)),
			1, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		Wait Until(Event Player.PerkActivated == False, 999999);
		Set Damage Dealt(Event Player, 100);
		Stop Heal Over Time(Last Heal Over Time ID);
		Destroy Effect(Event Player.G);
		Destroy Effect(Event Player.H);
		Destroy Effect(Event Player.I);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
	}
}