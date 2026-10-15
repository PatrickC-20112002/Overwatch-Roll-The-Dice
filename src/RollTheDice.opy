variables
{
	global:
		0: favPerkEnabled
		1: bannedFav
		2: perkTotal
		3: kingsDemand
		4: hamonOrbPosition
		5: hamonOrbKiller
		6: hamonOrbActive
		7: hamonOrbEffect

	player:
		0: perkName
		1: perkDuration
		2: perkColour
		3: diceRoll
		4: diceCooldown
		5: perkActivated
		14: integrityChain
		15: integrityIn
		16: integrityOut
		17: integrity
		18: timeFreeze
		19: virusCloud
		20: virusSpread
		21: stolenDiceName
		22: stolenDiceRoll
		23: stolenPlr
		25: perkDescription
		26: isSelectingFavourite
		27: favouritePerkRoll
		28: favouriteHudText
		29: favouritePerkName
		30: favouritePerkColour
		31: rtdHudText
		32: durationModifier
		33: showHeroIconEsp
		34: showPerkEsp
		35: diceReroll
		36: rtdWorldText
		37: hudLoopIndex
		38: favouriteChanceRoll
		39: O
		40: virusTargets
}

rule("Enable/Disable Favourite Perk")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		If(Workshop Setting Toggle(Custom String("Favourite Perk"), Custom String("Favourite Perk Enabled?"), True, 0) == True);
			Global.favPerkEnabled = True;
		Else;
			Global.favPerkEnabled = False;
	}
}

disabled rule("- Select Fav -")
{
	event
	{
		Ongoing - Global;
	}
}

rule("Banned Favourite Perks + Total Number of Perks")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		Global.bannedFav = Array(64, 65, 86, 97, 102, 105, 46, 118, 134, 145);
		Global.perkTotal = 146;
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
		Global.favPerkEnabled == True;
		Is Dummy Bot(Event Player) == False;
	}

	actions
	{
		"hide player and enter favourite selection"
		Set Invisible(Event Player, All);
		Event Player.isSelectingFavourite = True;
		Event Player.favouritePerkRoll = 0;
		Event Player.diceRoll = 0;
		"reset favourite selection HUD array"
		Event Player.favouriteHudText = Empty Array;
		"favourite selection title"
		Create HUD Text(Event Player, Custom String("Pick your favourite perk"), Null, Null, Top, 0, Color(White), Color(White), Color(
			White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"favourite selection controls"
		Create HUD Text(Event Player, Custom String("(Primary: Next)  (Secondary: Previous)  (Ability 1/2: Jump 5)  (Interact: Confirm)",
			Button(Primary Fire), Button(Secondary Fire), Button(Jump)), Custom String(""), Null, Top, 1, Color(Orange), Color(White),
			Color(White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"favourite selection current perk"
		Create HUD Text(Event Player, Custom String("({2}/{1}) {0}", Event Player.perkName, Global.perkTotal, Event Player.diceRoll),
			Custom String(""), Custom String("", Round To Integer(Event Player.perkDuration, Up)), Top, 2, Event Player.perkColour,
			Event Player.perkColour, Color(White), Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"favourite selection perk description, disabled for now"
		disabled Create HUD Text(Event Player, Custom String("{0}", Event Player.perkDescription), Null, Null, Top, 3, Color(White), Null, Null,
			Visible To Sort Order String and Color, Default Visibility);
		disabled Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"lock player during favourite selection"
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
		Event Player.isSelectingFavourite == True;
		Is Button Held(Event Player, Button(Primary Fire)) == True;
		Global.favPerkEnabled == True;
		Event Player.favouriteHudText != Empty Array;
	}

	actions
	{
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		If(Event Player.diceRoll == Global.perkTotal);
			Event Player.diceRoll = 0;
		Else;
			Event Player.diceRoll += 1;
		End;
		Wait(0.050, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("Increase Fav by 5")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.isSelectingFavourite == True;
		Is Button Held(Event Player, Button(Ability 2)) == True;
		Global.favPerkEnabled == True;
		Event Player.favouriteHudText != Empty Array;
	}

	actions
	{
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		Event Player.diceRoll += 5;
		If(Event Player.diceRoll > Global.perkTotal);
			Event Player.diceRoll = 0;
		End;
		Wait(0.100, Ignore Condition);
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
		Event Player.isSelectingFavourite == True;
		Is Button Held(Event Player, Button(Secondary Fire)) == True;
		Global.favPerkEnabled == True;
		Event Player.favouriteHudText != Empty Array;
	}

	actions
	{
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		If(Event Player.diceRoll == 0);
			Event Player.diceRoll = Global.perkTotal;
		Else;
			Event Player.diceRoll -= 1;
		End;
		Wait(0.050, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("Decrease Fav by 5")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.isSelectingFavourite == True;
		Is Button Held(Event Player, Button(Ability 1)) == True;
		Global.favPerkEnabled == True;
		Event Player.favouriteHudText != Empty Array;
	}

	actions
	{
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		Event Player.diceRoll -= 5;
		If(Event Player.diceRoll < 0);
			Event Player.diceRoll = Global.perkTotal;
		End;
		Wait(0.100, Ignore Condition);
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
		Event Player.isSelectingFavourite == True;
		Is Button Held(Event Player, Button(Interact)) == True;
		Global.favPerkEnabled == True;
		Is Alive(Event Player) == True;
	}

	actions
	{
		"stop banned favourite perks from being selected"
		If(Array Contains(Global.bannedFav, Event Player.diceRoll) == True);
			Small Message(Event Player, Custom String("This perk cannot be picked as favourite!"));
			Abort;
		End;
		"save selected favourite perk"
		Play Effect(Event Player, Buff Impact Sound, Color(White), Position Of(Event Player), 200);
		Event Player.favouritePerkRoll = Event Player.diceRoll;
		Event Player.favouritePerkName = Event Player.perkName;
		Event Player.favouritePerkColour = Event Player.perkColour;
		"restore player controls"
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Clear Status(Event Player, Knocked Down);
		Clear Status(Event Player, Hacked);
		Clear Status(Event Player, Rooted);
		Clear Status(Event Player, Phased Out);
		"destroy favourite selection HUD texts"
		For Player Variable(Event Player, hudLoopIndex, 0, Count Of(Event Player.favouriteHudText), 1);
			Destroy HUD Text(Event Player.favouriteHudText[Event Player.hudLoopIndex]);
		End;
		Event Player.favouriteHudText = Empty Array;
		"return player to normal visibility and HUD"
		Set Invisible(Event Player, None);
		Enable Hero HUD(Event Player);
		Enable Game Mode HUD(Event Player);
		Set Jump Enabled(Event Player, True);
		"finish favourite selection"
		Wait(1, Ignore Condition);
		Event Player.isSelectingFavourite = False;
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
		Event Player.diceRoll == 0;
		Event Player.perkActivated == False;
		Event Player.diceCooldown == 0;
		Global.favPerkEnabled == True;
		Event Player.favouriteHudText == Empty Array;
	}

	actions
	{
		"destroy stored RTD HUD texts"
		For Player Variable(Event Player, hudLoopIndex, 0, Count Of(Event Player.rtdHudText), 1);
			Destroy HUD Text(Event Player.rtdHudText[Event Player.hudLoopIndex]);
		End;
		Event Player.rtdHudText = Empty Array;
		"destroy stored RTD in-world texts"
		For Player Variable(Event Player, hudLoopIndex, 0, Count Of(Event Player.rtdWorldText), 1);
			Destroy In-World Text(Event Player.rtdWorldText[Event Player.hudLoopIndex]);
		End;
		Event Player.rtdWorldText = Empty Array;
		"wait before opening favourite menu"
		Wait(1, Ignore Condition);
		"enter favourite selection"
		Event Player.isSelectingFavourite = True;
		Event Player.favouritePerkRoll = 0;
		Event Player.diceRoll = 0;
		Set Invisible(Event Player, All);
		"reset favourite selection HUD array"
		Event Player.favouriteHudText = Empty Array;
		"favourite selection title"
		Create HUD Text(Event Player, Custom String("Pick your favourite perk"), Null, Null, Top, 0, Color(White), Color(White), Color(
			White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"favourite selection controls"
		Create HUD Text(Event Player, Custom String("(Primary: Next)  (Secondary: Previous)  (Ability 1/2: Jump 5)  (Interact: Confirm)",
			Button(Primary Fire), Button(Secondary Fire), Button(Jump)), Custom String(""), Null, Top, 1, Color(Orange), Color(White),
			Color(White), Visible To and String, Default Visibility);
		Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"favourite selection current perk"
		Create HUD Text(Event Player, Custom String("({2}/{1}) {0}", Event Player.perkName, Global.perkTotal, Event Player.diceRoll),
			Custom String(""), Custom String("", Round To Integer(Event Player.perkDuration, Up)), Top, 2, Event Player.perkColour,
			Event Player.perkColour, Color(White), Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"favourite selection perk description, disabled for now"
		disabled Create HUD Text(Event Player, Custom String("{0}", Event Player.perkDescription), Null, Null, Top, 3, Color(White), Null, Null,
			Visible To Sort Order String and Color, Default Visibility);
		disabled Modify Player Variable(Event Player, favouriteHudText, Append To Array, Last Text ID);
		"lock player during favourite selection"
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
		(Event Player.isSelectingFavourite == False || Global.favPerkEnabled == False) == True;
	}

	actions
	{
		"reset basic RTD player values"
		Event Player.perkName = Custom String("Press Interact to Roll the Dice");
		Event Player.perkDescription = Custom String("The dice is ready!");
		Event Player.perkDuration = 0;
		Event Player.perkColour = Color(Yellow);
		Event Player.diceRoll = 0;
		Event Player.diceCooldown = 0;
		Event Player.showHeroIconEsp = 0;
		Event Player.showPerkEsp = 0;
		If(Event Player.durationModifier == 0);
			Event Player.durationModifier = 1;
		End;
		"reset stored text arrays"
		Event Player.rtdHudText = Empty Array;
		Event Player.rtdWorldText = Empty Array;
		"main perk text"
		Create HUD Text(Event Player, Custom String("{0}", Event Player.perkName, Round To Integer(Event Player.perkDuration, Up),
			Event Player.diceRoll), Custom String("Duration:"), Custom String("{0}", Round To Integer(Event Player.perkDuration, Up)), Top,
			0, Event Player.perkColour, Event Player.perkColour, Color(White), Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, rtdHudText, Append To Array, Last Text ID);
		"dice cooldown text"
		Create HUD Text(Filtered Array(Event Player, Event Player.diceCooldown > 0), Null, Custom String("Dice Cooldown"), Custom String(
			"{0}", Round To Integer(Event Player.diceCooldown, Up)), Right, 0, Null, Event Player.perkColour, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, rtdHudText, Append To Array, Last Text ID);
		"spectator perk text"
		Create In-World Text(Filtered Array(All Players(All Teams), Current Array Element.showPerkEsp == True), Custom String("{0}: {1}",
			Event Player.perkName, Round To Integer(Event Player.perkDuration, Up)), Update Every Frame(Eye Position(Event Player)
			+ Vector(0, 1, 0)), 1.500, Clip Against Surfaces, Visible To Position String and Color, Event Player.perkColour,
			Visible Always);
		Modify Player Variable(Event Player, rtdWorldText, Append To Array, Last Text ID);
		"favourite perk permanent text"
		Skip If(Global.favPerkEnabled == False, 2);
		Create HUD Text(Event Player, Custom String("Favourite Perk"), Custom String("{0}", Event Player.favouritePerkRoll), Custom String(
			"{0}", Event Player.favouritePerkName), Left, 0, Event Player.favouritePerkColour, Color(White),
			Event Player.favouritePerkColour, Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, rtdHudText, Append To Array, Last Text ID);
		"hero icon spectator text"
		Create In-World Text(Filtered Array(All Players(All Teams), Current Array Element.showHeroIconEsp == True), Custom String("{0}",
			Hero Icon String(Hero Of(Event Player))), Update Every Frame(Eye Position(Event Player) + Vector(0, 1.500, 0)), 1.500,
			Do Not Clip, Visible To Position String and Color, Event Player.perkColour, Default Visibility);
		Modify Player Variable(Event Player, rtdWorldText, Append To Array, Last Text ID);
		"perk description text, disabled for now"
		disabled Create HUD Text(Event Player, Custom String("{0}", Event Player.perkDescription), Null, Null, Left, 4, Color(White), Null, Null,
			Visible To Sort Order String and Color, Default Visibility);
		"duration modifier label"
		Create HUD Text(Event Player, Null, Null, Custom String("Duration Modifier"), Left, 9, Null, Null, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, rtdHudText, Append To Array, Last Text ID);
		"duration modifier value"
		Create HUD Text(Event Player, Null, Null, Custom String("x{0}", Event Player.durationModifier), Left, 10, Null, Null, Color(
			Orange), Visible To Sort Order String and Color, Default Visibility);
		Modify Player Variable(Event Player, rtdHudText, Append To Array, Last Text ID);
		"show starting reminder"
		Wait(1, Ignore Condition);
		Big Message(Event Player, Custom String("Press Interact To Roll The Dice"));
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
		Event Player.perkActivated == True;
	}

	actions
	{
		Wait Until(Event Player.perkActivated == False, 99999);
		Event Player.diceCooldown = 15;
		Event Player.perkName = Custom String("No perk");
		Event Player.diceRoll = 0;
		Event Player.perkColour = Custom Color(211, 211, 211, 255);
		Event Player.perkDescription = Custom String("The player is completely normal.");
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
		Event Player.perkDuration == 0;
	}

	actions
	{
		Event Player.perkActivated = False;
		Play Effect(Event Player, Debuff Impact Sound, Color(White), Position Of(Event Player), 200);
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
		Create HUD Text(All Players(All Teams), Custom String("ROLL THE DICE {0} {1} {2}", Server Load, Server Load Average,
			Server Load Peak), Null, Null, Left, 1, Color(Sky Blue), Null, Null, Visible To Sort Order String and Color,
			Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("Created by MarkedDerp"), Left, 2, Null, Null, Color(Rose),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("WORKSHOP CODE"), Left, 3, Null, Null, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("4C92C"), Left, 4, Null, Null, Color(Orange),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("CURRENT VERSION"), Left, 5, Null, Null, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("V2.5"), Left, 6, Null, Null, Color(Aqua),
			Visible To Sort Order String and Color, Default Visibility);
		disabled Create HUD Text(All Players(All Teams), Null, Null, Custom String("CURRENT EXPERIMENT"), Left, 7, Null, Null, Color(White),
			Visible To Sort Order String and Color, Default Visibility);
		disabled Create HUD Text(All Players(All Teams), Null, Null, Custom String("Higher Fav Perk chance"), Left, 8, Null, Null, Color(Gray),
			Visible To Sort Order String and Color, Default Visibility);
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
		Event Player.diceCooldown > 0;
	}

	actions
	{
		Chase Player Variable At Rate(Event Player, diceCooldown, 0, 1, Destination and Rate);
		Wait Until(Event Player.diceCooldown == 0, 99999);
		Stop Chasing Player Variable(Event Player, diceCooldown);
		Play Effect(Event Player, Ring Explosion Sound, Color(White), Position Of(Event Player), 200);
		Event Player.perkName = Custom String("Press Interact to Roll the Dice");
		Event Player.perkColour = Color(Orange);
		Event Player.perkDescription = Custom String("The dice is ready!");
	}
}

rule("Final Blows lower Dice Cooldown")
{
	event
	{
		Player Dealt Final Blow;
		All;
		All;
	}

	conditions
	{
		Event Player.diceCooldown > 0;
	}

	actions
	{
		Event Player.diceCooldown = Max(0, Event Player.diceCooldown - 15);
		If(Event Player.diceCooldown < 0);
			Event Player.diceCooldown = 0;
		End;
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
		Event Player.perkDuration > 0;
	}

	actions
	{
		Chase Player Variable At Rate(Event Player, perkDuration, 0, 1, Destination and Rate);
		Wait Until(Event Player.perkDuration == 0, 99999);
		Stop Chasing Player Variable(Event Player, perkDuration);
	}
}

rule("Apply Pending Duration Modifier")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.durationModifier != 1;
		Event Player.perkActivated == True;
		Event Player.perkDuration > 0;
		"duration perks"
		Event Player.diceRoll != 126;
		Event Player.diceRoll != 127;
		"ban hammer"
		Event Player.diceRoll != 46;
		"spirit bomb"
		Event Player.diceRoll != 145;
	}

	actions
	{
		Wait(0.050, Ignore Condition);
		Event Player.perkDuration *= Event Player.durationModifier;
		If(Event Player.durationModifier > 1);
			Small Message(Event Player, Custom String("Perk Duration x{0}", Event Player.durationModifier));
		Else;
			Small Message(Event Player, Custom String("Perk Duration /{0}", 1 / Event Player.durationModifier));
		End;
		Event Player.durationModifier = 1;
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
		Event Player.diceCooldown == 0;
		Is Alive(Event Player) == True;
		Is In Spawn Room(Event Player) == False;
		Event Player.isSelectingFavourite == False;
		disabled Hero Of(Event Player) != Hero(Illari);
		disabled Hero Of(Event Player) != Hero(Lifeweaver);
		disabled Hero Of(Event Player) != Hero(Symmetra);
		disabled Hero Of(Event Player) != Hero(Torbjörn);
	}

	actions
	{
		Abort If(Event Player.perkDuration > 0);
		Big Message(Event Player, Custom String("Rolling the dice"));
		Wait(1, Ignore Condition);
		Abort If(Is Dead(Event Player));
		disabled Wait Until(Is Alive(Event Player), 99999);
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Position Of(Event Player), 200);
		Event Player.perkActivated = True;
		If(Event Player.diceReroll != 0);
			"Dice Reroll"
			If(Random Integer(0, 1) == 0);
				Event Player.diceRoll = Event Player.diceReroll;
				Small Message(Event Player, Custom String("You rerolled your perk."));
				If(Current Game Mode == Game Mode(Deathmatch));
					Small Message(Event Player, Custom String("{0}{1} rolled {2}", Hero Icon String(Hero Of(Event Player)), Event Player,
						Event Player.perkName));
					Small Message(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String(
						"{0}{1} rolled the dice.", Hero Icon String(Hero Of(Event Player)), Event Player, Event Player.perkName));
				Else;
					Small Message(All Players(Team Of(Event Player)), Custom String("{0}{1} rolled {2}", Hero Icon String(Hero Of(Event Player)),
						Event Player, Event Player.perkName));
					Small Message(All Players(Opposite Team Of(Team Of(Event Player))), Custom String("{0}{1} rolled a perk.", Hero Icon String(
						Hero Of(Event Player)), Event Player, Event Player.perkName));
				End;
				Event Player.diceReroll = 0;
				Abort;
			End;
			Event Player.diceReroll = 0;
		End;
		"If the player has a favourite perk selected, roll the favourite chance"
		If(Event Player.favouritePerkRoll != 0);
			Event Player.favouriteChanceRoll = Random Integer(1, Workshop Setting Integer(Custom String("Favourite Perk"), Custom String(
				"Favourite Roll Chance (1 in _ chance)"), 5, 1, 10, 0));
			"If the favourite chance succeeds, force the favourite perk"
			If(Event Player.favouriteChanceRoll == 1);
				Event Player.diceRoll = Event Player.favouritePerkRoll;
				Small Message(Event Player, Custom String("You rolled your favourite roll"));
			End;
			"If the favourite chance fails, roll a normal random perk"
			If(Event Player.favouriteChanceRoll != 1);
				Event Player.diceRoll = Random Integer(1, Global.perkTotal);
				disabled Event Player.diceRoll = 114;
			End;
		Else;
			"If the player has no favourite perk selected, roll a normal random perk"
			Event Player.diceRoll = Random Integer(1, Global.perkTotal);
			disabled Event Player.diceRoll = 46;
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
		Event Player.diceRoll == 0;
		Event Player.isSelectingFavourite == True;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("No Favourite Perk");
		Event Player.perkDescription = Custom String(
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
		Event Player.diceRoll == 1;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("GodMode");
		Event Player.perkDescription = Custom String("Can't take damage or knockback.");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Status(Event Player, Null, Invincible, 9999);
		Set Knockback Received(Event Player, 0);
		Create Effect(All Players(All Teams), Good Aura, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 2;
	}

	actions
	{
		Event Player.perkColour = Color(Green);
		Event Player.perkName = Custom String("Toxic");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Cloud, Color(Green), Event Player, 8, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 2;
		disabled Event Player.perkActivated == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Wait(0.250, Ignore Condition);
		Damage(Filtered Array(Players Within Radius(Event Player, 10, All Teams, Surfaces), Current Array Element != Event Player),
			Event Player, 16);
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
		Event Player.diceRoll == 3;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Vital");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Add Health Pool To Player(Event Player, Health, 300, True, True);
		Event Player.G = Last Created Health Pool;
		Wait(0.100, Ignore Condition);
		Heal(Event Player, Null, 300);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 4;
	}

	actions
	{
		Event Player.perkColour = Color(Lime Green);
		Event Player.perkName = Custom String("Speed");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Move Speed(Event Player, 250);
		Create Effect(All Players(All Teams), Sparkles, Color(Lime Green), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 5;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Noclip");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Disable Movement Collision With Environment(Event Player, False);
		Disable Movement Collision With Players(Event Player);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 6;
	}

	actions
	{
		Event Player.perkColour = Color(Blue);
		Event Player.perkName = Custom String("Nanoboost");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Ana Nano Boosted Effect, Color(Purple), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Create Effect(All Players(All Teams), Ana Nano Boosted Sound, Color(White), Eye Position(Event Player), 25,
			Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		Heal(Event Player, Null, 250);
		Set Damage Dealt(Event Player, 150);
		Set Damage Received(Event Player, 50);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 7;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Low Gravity");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Gravity(Event Player, 25);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 8;
	}

	actions
	{
		Event Player.perkColour = Color(Turquoise);
		Event Player.perkName = Custom String("Invisibility");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Invisible(Event Player, All);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 9;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Keyboard Spam");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
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
			Press Button(Event Player, Button(Melee));
			Wait(0.250, Ignore Condition);
			Press Button(Event Player, Button(Jump));
			Wait(0.250, Ignore Condition);
			Press Button(Event Player, Button(Crouch));
			Wait(0.250, Ignore Condition);
		End;
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
		Event Player.diceRoll == 10;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Scary Bullets");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Good Aura, Color(Orange), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 10;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Abort If(Has Status(Victim, Stunned));
		Set Status(Victim, Event Player, Stunned, 0.500);
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
		Event Player.diceRoll == 11;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Explode");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Wait Until(Event Player.perkActivated == False, 999999);
		Event Player.G = Position Of(Event Player);
		Event Player.H = Filtered Array(Players Within Radius(Event Player.G, 15, All Teams, Surfaces),
			Current Array Element != Event Player);
		Damage(Players Within Radius(Event Player.G, 15, All Teams, Surfaces), Event Player, 200);
		Play Effect(All Players(All Teams), Bad Explosion, Color(Yellow), Event Player.G, 15);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Event Player.G, 200);
		Event Player.K = 0;
		While(Event Player.K < Count Of(Event Player.H));
			Event Player.I = Event Player.H[Event Player.K];
			If(Is Alive(Event Player.I) == True);
				Set Environment Credit Player(Event Player.I, Event Player);
				Apply Impulse(Event Player.I, Up, 5, To World, Cancel Contrary Motion);
				Wait(0.100, Ignore Condition);
				Apply Impulse(Event Player.I, Direction Towards(Event Player.G, Event Player.I), 25, To World, Cancel Contrary Motion);
			End;
			Event Player.K = Event Player.K + 1;
		End;
		Wait(0.250, Ignore Condition);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.K = 0;
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
		Event Player.diceRoll == 12;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Snail");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Move Speed(Event Player, 33);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 13;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Frozen");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Status(Event Player, Event Player, Frozen, 9999);
		Set Damage Received(Event Player, 1);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 13;
		Has Status(Event Player, Frozen) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 0;
		Clear Status(Event Player, Frozen);
		Set Damage Received(Event Player, 100);
		Start Damage Over Time(Event Player, Attacker, 1, 100);
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
		Event Player.diceRoll == 14;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Timebomb");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Create Effect(All Players(All Teams), Orb, Color(Black), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), 1,
			Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Position Of(Event Player), 50);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Create Effect(All Players(All Teams), Cloud, Color(Black), Event Player, 50, Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		disabled Kill(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player);
		Damage(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player, 100000);
		Wait(0.500, Ignore Condition);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		If(Hero Of(Event Player) == Hero(D.Va));
			Wait Until(Is In Alternate Form(Event Player), 3);
			disabled Kill(Event Player, Event Player);
			Damage(Event Player, Null, 100000);
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
		Event Player.diceRoll == 15;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Ignition");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Status(Event Player, Event Player, Burning, 9999);
		If(Is Portrait On Fire(Event Player));
			Start Heal Over Time(Event Player, Event Player, 10, 15);
			Set Damage Dealt(Event Player, 175);
			Big Message(Event Player, Custom String("Already on fire!"));
		End;
		If(!Is Portrait On Fire(Event Player));
			Start Damage Over Time(Event Player, Null, 10, 15);
		End;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 16;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Low Health");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1.500;
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
		Event Player.diceRoll == 17;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("Blind");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Start Camera(Event Player, Vector(-10000, -10000, -10000), Vector(-10000, -10000, -10000), 0);
		Set Damage Dealt(Event Player, 250);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 18;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Strip to Melee");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Primary Fire Enabled(Event Player, False);
		Set Secondary Fire Enabled(Event Player, False);
		Set Ability 1 Enabled(Event Player, False);
		Set Ability 2 Enabled(Event Player, False);
		Disallow Button(Event Player, Button(Ultimate));
		"Primary Fire Allow"
		If(Hero Of(Event Player) == Hero(Brigitte));
			Set Primary Fire Enabled(Event Player, True);
		Else If(Hero Of(Event Player) == Hero(Reinhardt));
			Set Primary Fire Enabled(Event Player, True);
		Else If(Hero Of(Event Player) == Hero(Vendetta));
			Set Primary Fire Enabled(Event Player, True);
		End;
		"Secondary Fire Allow"
		If(Hero Of(Event Player) == Hero(Doomfist));
			Set Secondary Fire Enabled(Event Player, True);
		Else If(Hero Of(Event Player) == Hero(Venture));
			Set Secondary Fire Enabled(Event Player, True);
		End;
		"Ability 1 Allow"
		If(Hero Of(Event Player) == Hero(Hazard));
			Set Ability 1 Enabled(Event Player, True);
		Else If(Hero Of(Event Player) == Hero(Ramattra));
			Set Ability 1 Enabled(Event Player, True);
		End;
		If(Hero Of(Event Player) == Hero(Ramattra));
			Allow Button(Event Player, Button(Ultimate));
		End;
		"Keep abilities allowed"
		While(Event Player.perkActivated == True);
			"Ramattra Ability1/3, allow primary fire"
			If(Hero Of(Event Player) == Hero(Ramattra) && Is Using Ability 1(Event Player) == True);
				Set Primary Fire Enabled(Event Player, True);
			Else If(Hero Of(Event Player) == Hero(Ramattra));
				Set Primary Fire Enabled(Event Player, False);
			End;
			"Torb Hammer, allow primary fire"
			If(Hero Of(Event Player) == Hero(Torbjörn) && Is In Alternate Form(Event Player) == True);
				Set Primary Fire Enabled(Event Player, True);
			Else If(Hero Of(Event Player) == Hero(Torbjörn));
				Set Primary Fire Enabled(Event Player, False);
			End;
			Wait(0.100, Ignore Condition);
		End;
		"allow all"
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Set Ability 1 Enabled(Event Player, True);
		Set Ability 2 Enabled(Event Player, True);
		Allow Button(Event Player, Button(Ultimate));
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
		Event Player.diceRoll == 19;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Forced Taunt");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 3;
		Set Move Speed(Event Player, 25);
		Set Gravity(Event Player, 500);
		While(Event Player.perkActivated == True);
			If(Is Communicating Any Emote(Event Player) == False);
				Event Player.G = Random Integer(1, 4);
				Teleport(Event Player, Nearest Walkable Position(Event Player));
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
			End;
			Wait(0.250, Ignore Condition);
		End;
		Set Move Speed(Event Player, 100);
		Set Gravity(Event Player, 100);
		Event Player.perkDuration = 0;
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
		Event Player.diceRoll == 20;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Bad Sauce");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Start Damage Over Time(Event Player, Null, 10, 10);
		Set Status(Event Player, Event Player, Burning, 9999);
		Set Status(Event Player, Event Player, Hacked, 9999);
		disabled Set Status(Event Player, Event Player, Asleep, 1);
		Set Status(Event Player, Event Player, Frozen, 9999);
		Wait Until(Event Player.perkActivated == False, 999999);
		Clear Status(Event Player, Burning);
		Clear Status(Event Player, Hacked);
		Clear Status(Event Player, Frozen);
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
		Event Player.diceRoll == 21;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Infinite Jump");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			If(Is Button Held(Event Player, Button(Jump)) == True && Is In Air(Event Player) == True);
				Disallow Button(Event Player, Button(Jump));
				Apply Impulse(Event Player, Up, 8, To World, Cancel Contrary Motion);
				Wait(0.250, Ignore Condition);
				Allow Button(Event Player, Button(Jump));
			End;
			Wait(0.100, Ignore Condition);
		End;
		Allow Button(Event Player, Button(Jump));
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
		Event Player.diceRoll == 22;
	}

	actions
	{
		Event Player.perkColour = Color(Green);
		Event Player.perkName = Custom String("Powerful Hits");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Damage Dealt(Event Player, 200);
		Create Effect(All Players(All Teams), Mercy Damage Boosted Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 23;
	}

	actions
	{
		Event Player.perkColour = Color(Sky Blue);
		Event Player.perkName = Custom String("Grow");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Start Scaling Player(Event Player, 2, True);
		Set Damage Received(Event Player, 50);
		Start Modifying Hero Voice Lines(Event Player, 0.500, True);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 24;
	}

	actions
	{
		Event Player.perkColour = Color(Green);
		Event Player.perkName = Custom String("Shrink");
		Abort If(Event Player.isSelectingFavourite == True);
		If(Custom String("{0}", Event Player) == Custom String("Cheelai"));
			Event Player.perkDuration = 30;
		Else;
			Event Player.perkDuration = 10;
		End;
		disabled Event Player.perkDuration = 10;
		Start Scaling Player(Event Player, 0.500, True);
		Set Damage Received(Event Player, 125);
		Start Modifying Hero Voice Lines(Event Player, 1.500, True);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 25;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Firework");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Apply Impulse(Event Player, Up, 15, To World, Cancel Contrary Motion);
		Set Gravity(Event Player, 40);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 26;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Siphon");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		disabled Create Effect(All Players(All Teams), Heal Target Active Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		disabled Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
		disabled Destroy Effect(Event Player.G);
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
		Event Player.diceRoll == 26;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Heal(Event Player, Event Player, Event Damage);
		Play Effect(All Players(All Teams), Heal Target Active Effect, Color(White), Event Player, 1);
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
		Event Player.diceRoll == 27;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("High Gravity");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Gravity(Event Player, 500);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 28;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Frail");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Damage Received(Event Player, 175);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 29;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Knockback Hits");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
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
		Event Player.diceRoll == 29;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
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
		Event Player.diceRoll == 30;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Zero Gravity");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Gravity(Event Player, 0);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 31;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Fire Timebomb");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Create Effect(All Players(All Teams), Orb, Color(Yellow), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), 1,
			Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 32;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Spring Shoes");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			If(Is On Ground(Event Player) == True);
				Apply Impulse(Event Player, Up, 8, To World, Cancel Contrary Motion);
				Wait(0.200, Ignore Condition);
			End;
			Wait(0.100, Ignore Condition);
		End;
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
		Event Player.diceRoll == 33;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Drugged");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Aim Speed(Event Player, 25);
		Set Move Speed(Event Player, 65);
		Set Status(Event Player, Null, Hacked, 9999);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 34;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Drug Bullets");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
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
		Attacker.diceRoll == 34;
		disabled Event Damage >= 5;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Small Message(Event Player, Custom String("Drugged by {0} {1}", Hero Icon String(Hero Of(Attacker)), Attacker));
		Set Aim Speed(Event Player, 25);
		Set Move Speed(Event Player, 50);
		Set Status(Event Player, Null, Hacked, 9999);
		Wait(3, Ignore Condition);
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Clear Status(Event Player, Hacked);
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
		Event Player.diceRoll == 35;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Heroes Never Die");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 25;
		Wait Until(Is Dead(Event Player) == True || Event Player.perkActivated == False, 999999);
		Abort If(Event Player.perkActivated == False);
		Abort If(Is Dead(Event Player) == False);
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
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
		Event Player.diceRoll == 36;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Wasted Roll");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Play Effect(Event Player, Debuff Impact Sound, Color(White), Position Of(Event Player), 200);
		disabled Wait Until(Event Player.diceCooldown > 0, 5);
		disabled Event Player.diceCooldown = 1;
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
		Event Player.diceRoll == 37;
	}

	actions
	{
		Event Player.perkColour = Color(Lime Green);
		Event Player.perkName = Custom String("Beat Drop");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Apply Impulse(Event Player, Up, 8, To World, Cancel Contrary Motion);
		Event Player.G = Max Health(Event Player);
		Wait(0.500, Ignore Condition);
		Wait Until(Is On Ground(Event Player) || Is Dead(Event Player) || Has Status(Event Player, Stunned) || Has Status(Event Player,
			Hacked) || Has Status(Event Player, Asleep), 5);
		If((Is Dead(Event Player) || Has Status(Event Player, Hacked) || Has Status(Event Player, Asleep) || Has Status(Event Player,
			Stunned)) == True);
			Set Ultimate Charge(Event Player, 0);
			Event Player.G = 0;
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
			Wait Until(Event Player.diceCooldown >= 1, 99999);
			Event Player.diceCooldown += 10;
			Abort;
		End;
		Add Health Pool To Player(Event Player, Health, 750, False, True);
		Start Damage Over Time(Event Player, Null, 30, 125);
		disabled Wait(1, Ignore Condition);
		disabled Wait Until(Event Player.perkActivated == False, 999999);
		disabled Wait Until(Max Health Of Type(Event Player, Health) + Max Health Of Type(Event Player, Armor) + Max Health Of Type(Event Player,
			Shields) <= Health(Event Player), 15);
		Wait Until(Health(Event Player) <= Event Player.G, 30);
		Stop All Damage Over Time(Event Player);
		Remove All Health Pools From Player(Event Player);
		Event Player.G = 0;
		Heal(Event Player, Null, 16);
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
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
		Event Player.diceRoll == 38;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Jackpot");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) + 50);
		Set Move Speed(Event Player, 175);
		Set Damage Received(Event Player, 25);
		Set Damage Dealt(Event Player, 175);
		Create Effect(All Players(All Teams), Good Aura, Color(Yellow), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
		Set Move Speed(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
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
		Event Player.diceRoll == 39;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Pocket Mercy");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.I = 0;
		While(Event Player.perkActivated == True);
			If(Health(Event Player) < Max Health(Event Player) * 0.750 && Event Player.I != 1);
				Event Player.I = 1;
				Destroy Effect(Event Player.G);
				Destroy Effect(Event Player.H);
				Stop Heal Over Time(Event Player.J);
				Set Damage Dealt(Event Player, 100);
				Create Effect(All Players(All Teams), Heal Target Effect, Color(White), Event Player, 1, Visible To Position and Radius);
				Event Player.G = Last Created Entity;
				Create Effect(Event Player, Mercy Heal Beam Sound, Color(White), Event Player, 200, Visible To Position and Radius);
				Event Player.H = Last Created Entity;
				Start Heal Over Time(Event Player, Null, 9999, 60);
				Event Player.J = Last Heal Over Time ID;
			End;
			If(Health(Event Player) >= Max Health(Event Player) * 0.750 && Event Player.I != 2);
				Event Player.I = 2;
				Destroy Effect(Event Player.G);
				Destroy Effect(Event Player.H);
				Stop Heal Over Time(Event Player.J);
				Create Effect(All Players(All Teams), Mercy Damage Boosted Effect, Color(White), Event Player, 1, Visible To Position and Radius);
				Event Player.G = Last Created Entity;
				Create Effect(Event Player, Mercy Damage Boosted Sound, Color(White), Event Player, 200, Visible To Position and Radius);
				Event Player.H = Last Created Entity;
				Set Damage Dealt(Event Player, 130);
			End;
			Wait(0.250, Ignore Condition);
		End;
		Set Damage Dealt(Event Player, 100);
		Stop Heal Over Time(Event Player.J);
		Destroy Effect(Event Player.G);
		Destroy Effect(Event Player.H);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.J = 0;
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
		Event Player.diceRoll == 40;
	}

	actions
	{
		Event Player.perkColour = Color(Blue);
		Event Player.perkName = Custom String("Temporary Ult");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 25;
		Event Player.G = Ultimate Charge Percent(Event Player) + 25;
		Set Ultimate Charge(Event Player, 100);
		Wait Until(Ultimate Charge Percent(Event Player) == 0 || Event Player.perkActivated == False, 999999);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.perkDuration = 0;
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
		Event Player.diceRoll == 41;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("No Cooldowns");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			Set Ability Charge(Event Player, Button(Ability 1), 0);
			Set Ability Cooldown(Event Player, Button(Ability 1), 0);
			Set Ability Cooldown(Event Player, Button(Ability 2), 0);
			Set Ability Cooldown(Event Player, Button(Secondary Fire), 0);
			Set Ability Cooldown(Event Player, Button(Jump), 0);
			Set Ability Charge(Event Player, Button(Ability 1), 1000);
			Wait(0.050, Ignore Condition);
		End;
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
		Event Player.diceRoll == 42;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Weakened");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Damage Dealt(Event Player, 25);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 43;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Auto Dodge");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 60;
		Create Effect(All Players(All Teams), Cloud, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Color(White), Always);
		Set Damage Dealt(Event Player, 100);
		Set Move Speed(Event Player, 130);
		Set Damage Received(Event Player, 100);
		Play Effect(All Players(All Teams), Ring Explosion, Color(White), Eye Position(Event Player), 5);
		Play Effect(All Players(All Teams), Bad Explosion, Color(White), Eye Position(Event Player), 5);
		Create Effect(All Players(All Teams), Light Shaft, Color(White), Position Of(Event Player), 3, None);
		Wait(1, Ignore Condition);
		Destroy Effect(Last Created Entity);
		Wait Until(Event Player.perkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Set Damage Received(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Wait(0.016, Ignore Condition);
		Set Status(Event Player, Null, Knocked Down, 3.500);
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
		Event Player.diceRoll == 43;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration -= 3;
		If(Event Player.perkDuration < 0);
			Event Player.perkDuration = 0;
		End;
		Heal(Event Player, Null, Event Damage);
		disabled Start Heal Over Time(Event Player, Event Player, 1, Event Damage * 1);
		Clear Status(Event Player, Hacked);
		Clear Status(Event Player, Burning);
		Clear Status(Event Player, Knocked Down);
		Clear Status(Event Player, Asleep);
		Clear Status(Event Player, Frozen);
		Clear Status(Event Player, Rooted);
		Clear Status(Event Player, Stunned);
		Stop All Damage Over Time(Event Player);
		Set Status(Event Player, Event Player, Phased Out, 0.250);
		Play Effect(All Players(All Teams), Bad Explosion, Color(White), Event Player, 5);
		Play Effect(Array(Event Player, Attacker), Ring Explosion Sound, Color(White), Position Of(Event Player), 200);
		"Dodge Move"
		disabled Event Player.H = 0;
		disabled Event Player.H = Ray Cast Hit Position(Position Of(Player Closest To Reticle(Event Player, All Teams)), Position Of(
			Player Closest To Reticle(Event Player, All Teams)) + Direction From Angles(Horizontal Facing Angle Of(
			Player Closest To Reticle(Event Player, All Teams)), 0) * -3, All Players(All Teams), Player Closest To Reticle(Event Player,
			All Teams), True);
		disabled Event Player.I = Position Of(Event Player);
		disabled Start Forcing Player Position(Event Player, Event Player.I, True);
		disabled Start Facing(Event Player, Direction Towards(Eye Position(Event Player), Eye Position(Player Closest To Reticle(Event Player,
			All Teams))), 10000, To World, Direction and Turn Rate);
		disabled Chase Player Variable Over Time(Event Player, I, Event Player.H, 0.500, Destination and Duration);
		disabled Wait(0.500, Ignore Condition);
		disabled Stop Chasing Player Variable(Event Player, I);
		disabled Stop Forcing Player Position(Event Player);
		disabled Teleport(Event Player, Nearest Walkable Position(Event Player));
		disabled Stop Facing(Event Player);
		disabled Damage(Attacker, Event Player, Event Damage / 2);
		"Old Teleport Functions"
		disabled Teleport(Event Player, World Vector Of(Vector(Random Integer(0, 1) == 1 ? -1 : 1, 0, 0), Event Player, Rotation And Translation));
		Teleport(Event Player, Ray Cast Hit Position(Position Of(Attacker), Position Of(Attacker) + Direction From Angles(
			Horizontal Facing Angle Of(Attacker), 0) * -5, All Players(All Teams), Attacker, True));
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Set Facing(Event Player, Direction Towards(Eye Position(Event Player), Eye Position(Attacker)), To World);
	}
}

rule("43: Auto Dodge Force Dodge")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 43;
		Is Button Held(Event Player, Button(Interact)) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Abort If(Count Of(Filtered Array(All Living Players(All Teams), Current Array Element != Event Player)) == 0);
		Event Player.perkDuration -= 3;
		If(Event Player.perkDuration < 0);
			Event Player.perkDuration = 0;
		End;
		Clear Status(Event Player, Hacked);
		Clear Status(Event Player, Burning);
		Clear Status(Event Player, Knocked Down);
		Clear Status(Event Player, Asleep);
		Clear Status(Event Player, Frozen);
		Clear Status(Event Player, Rooted);
		Clear Status(Event Player, Stunned);
		"Dodge Move"
		Event Player.H = 0;
		Event Player.H = Ray Cast Hit Position(Position Of(Player Closest To Reticle(Event Player, All Teams)), Position Of(
			Player Closest To Reticle(Event Player, All Teams)) + Direction From Angles(Horizontal Facing Angle Of(
			Player Closest To Reticle(Event Player, All Teams)), 0) * -3, All Players(All Teams), Player Closest To Reticle(Event Player,
			All Teams), True);
		Event Player.I = Position Of(Event Player);
		Stop All Damage Over Time(Event Player);
		Set Status(Event Player, Event Player, Phased Out, 0.250);
		Play Effect(All Players(All Teams), Bad Explosion, Color(White), Event Player, 5);
		Play Effect(Array(Event Player, Player Closest To Reticle(Event Player, All Teams)), Ring Explosion Sound, Color(White),
			Position Of(Event Player), 200);
		Start Forcing Player Position(Event Player, Event Player.I, True);
		Start Facing(Event Player, Direction Towards(Eye Position(Event Player), Eye Position(Player Closest To Reticle(Event Player,
			All Teams))), 10000, To World, Direction and Turn Rate);
		Chase Player Variable Over Time(Event Player, I, Event Player.H, 0.500, Destination and Duration);
		Wait(0.500, Ignore Condition);
		Stop Chasing Player Variable(Event Player, I);
		Stop Forcing Player Position(Event Player);
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Stop Facing(Event Player);
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
		Event Player.diceRoll == 44;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Primal Rage");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 11;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Start Forcing Player To Be Hero(Event Player, Hero(Winston));
		Wait(1, Ignore Condition);
		Set Damage Dealt(Event Player, 200);
		Set Ultimate Charge(Event Player, 100);
		Start Holding Button(Event Player, Button(Ultimate));
		Wait Until(Is Using Ultimate(Event Player), 2);
		Stop Holding Button(Event Player, Button(Ultimate));
		Wait Until(Event Player.perkActivated == False, 999999);
		Wait Until(Is Alive(Event Player), 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Set Damage Dealt(Event Player, 100);
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		disabled Event Player.perkDuration = 1;
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
		Event Player.diceRoll == 45;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("Eye for an Eye");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		disabled Create Effect(All Players(All Teams), Reaper Wraith Form Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		disabled Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 45;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Damage(Event Player, Null, Event Damage * 1);
	}
}

rule("46: Ban Hammer")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 46;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Ban Hammer");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 600;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Event Player.I = False;
		Start Forcing Player To Be Hero(Event Player, Hero(Reinhardt));
		Wait(1, Ignore Condition);
		Set Damage Received(Event Player, 0);
		Set Move Speed(Event Player, 75);
		Set Ultimate Charge(Event Player, 100);
		Disallow Button(Event Player, Button(Primary Fire));
		Disallow Button(Event Player, Button(Secondary Fire));
		Disallow Button(Event Player, Button(Ability 1));
		Disallow Button(Event Player, Button(Ability 2));
		Disallow Button(Event Player, Button(Melee));
		While(Event Player.perkActivated == True);
			If(Ultimate Charge Percent(Event Player) < 25 && Event Player.perkDuration <= 598 && Event Player.I != True);
				Event Player.I = True;
				Event Player.perkDuration = 2.500;
			End;
			Wait(0.100, Ignore Condition);
		End;
		Wait Until(Is Alive(Event Player), 99999);
		"Change Back"
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Set Damage Received(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Allow Button(Event Player, Button(Melee));
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Allow Button(Event Player, Button(Ability 1));
		Allow Button(Event Player, Button(Ability 2));
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
	}
}

rule("46: Ban Hammer Damage")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Attacker != Null;
		Attacker.diceRoll == 46;
		Event Ability == Button(Ultimate);
	}

	actions
	{
		Abort If(Attacker.isSelectingFavourite == True);
		Set Slow Motion(100);
		Cancel Primary Action(Event Player);
		Stop All Heal Over Time(Event Player);
		Clear Status(Event Player, Hacked);
		Clear Status(Event Player, Burning);
		Clear Status(Event Player, Asleep);
		Clear Status(Event Player, Frozen);
		Clear Status(Event Player, Unkillable);
		Clear Status(Event Player, Invincible);
		Clear Status(Event Player, Phased Out);
		Clear Status(Event Player, Rooted);
		Clear Status(Event Player, Stunned);
		Stop All Damage Over Time(Event Player);
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Set Gravity(Event Player, 100);
		Set Knockback Dealt(Event Player, 100);
		Set Knockback Received(Event Player, 100);
		Stop Modifying Hero Voice Lines(Event Player);
		Stop Scaling Player(Event Player);
		Set Environment Credit Player(Event Player, Attacker);
		Set Status(Event Player, Attacker, Knocked Down, 15);
		If(Event Was Critical Hit);
			Remove Player(Event Player);
			Big Message(All Players(All Teams), Custom String("{0} The Ban Hammer has spoken.", Hero Icon String(Hero(Reinhardt))));
		End;
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
		Wait Until(Event Player.diceCooldown > 0, 5);
		Event Player.diceCooldown = 30;
		Kill(Event Player, Attacker);
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
		Event Player.diceRoll == 47;
	}

	actions
	{
		Event Player.perkColour = Color(Rose);
		Event Player.perkName = Custom String("Random Hero");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Start Forcing Player To Be Hero(Event Player, Random Value In Array(Filtered Array(All Heroes, Current Array Element != Hero Of(
			Event Player))));
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, 80);
		Wait Until(Event Player.perkActivated == False, 999999);
		Wait Until(Is Alive(Event Player), 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Wait(0.500, Ignore Condition);
		Skip If(Event Player.J != True, 1);
		Set Player Health(Event Player, Max Health(Event Player) * 0.150);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.J = 0;
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
		Event Player.diceRoll == 47;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.J = True;
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
		Big Message(Event Player, Custom String("Reviving"));
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Create Effect(All Players(All Teams), Sphere, Color(Yellow), Eye Position(Event Player), 0.500, None);
		Event Player.I = Last Created Entity;
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
		Destroy Effect(Event Player.I);
		Event Player.I = 0;
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
		Event Player.diceRoll == 48;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Random Teleport");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1.500;
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
		Event Player.diceRoll == 49;
	}

	actions
	{
		Event Player.perkColour = Custom Color(87, 28, 116, 255);
		Event Player.perkName = Custom String("Short Bounty");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		disabled Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Custom Color(87, 28, 116, 255), Always);
		Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Color(Purple), Always);
		Create Icon(All Players(All Teams), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), Skull,
			Visible To and Position, Custom Color(87, 28, 116, 255), False);
		Event Player.G = Last Created Entity;
		If(Custom String("{0}", Event Player) == Custom String("LordFrieza"));
			Event Player.showHeroIconEsp = True;
			Event Player.showPerkEsp = True;
		End;
		Wait Until(Event Player.perkActivated == False, 999999);
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		If(Custom String("{0}", Event Player) == Custom String("LordFrieza"));
			Event Player.showHeroIconEsp = 0;
			Event Player.showPerkEsp = 0;
		End;
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
		Victim.diceRoll == 49;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Big Message(All Players(All Teams), Custom String("{0} {1} claimed the bounty.", Hero Icon String(Hero Of(Event Player)),
			Event Player));
		Heal(Event Player, Event Player, 9999);
		disabled Set Status(Event Player, Null, Phased Out, 3);
		Set Ultimate Charge(Event Player, 100);
		Victim.perkDuration = 0;
		Victim.perkActivated = False;
		Wait Until(Event Player.diceCooldown >= 1, 99999);
		Event Player.diceCooldown = 0.500;
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
		Event Player.diceRoll == 50;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("Conqueror's Will");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Event Player.G = Position Of(Event Player);
		Event Player.H = 1;
		Create Effect(All Players(All Teams), Sphere, Color(Black), Event Player.G, Event Player.H, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		Play Effect(All Players(All Teams), Bad Explosion, Color(Black), Event Player, 25);
		Chase Player Variable Over Time(Event Player, H, 25, 0.250, Destination and Duration);
		Wait(0.250, Ignore Condition);
		Destroy Effect(Event Player.I);
		Stop Chasing Player Variable(Event Player, H);
		Event Player.J = Filtered Array(Players Within Radius(Event Player.G, Event Player.H, All Teams, Off),
			Current Array Element != Event Player);
		Event Player.K = 0;
		While(Event Player.K < Count Of(Event Player.J));
			Event Player.L = Event Player.J[Event Player.K];
			If(Is Alive(Event Player.L) == True);
				Set Environment Credit Player(Event Player.L, Event Player);
				Set Status(Event Player.L, Event Player, Asleep, 2);
				Set Move Speed(Event Player.L, 75);
				Set Damage Received(Event Player.L, 125);
				Wait(8, Ignore Condition);
				Set Move Speed(Event Player.L, 100);
				Set Damage Received(Event Player.L, 100);
			End;
			Event Player.K = Event Player.K + 1;
		End;
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
		Event Player.L = 0;
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
		Event Player.diceRoll == 51;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Ice Timebomb");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Create Effect(All Players(All Teams), Orb, Color(Aqua), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), 1,
			Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Create Effect(All Players(All Teams), Cloud, Color(Aqua), Event Player, 50, Visible To Position Radius and Color);
		Event Player.G = Last Created Entity;
		Damage(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers), Event Player, 50);
		Play Effect(All Players(All Teams), Explosion Sound, Color(White), Position Of(Event Player), 50);
		Set Status(Filtered Array(Players Within Radius(Event Player, 50, All Teams, Surfaces And All Barriers),
			Current Array Element != Event Player), Event Player, Frozen, 5);
		Set Status(Event Player, Event Player, Frozen, 3);
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
		Event Player.diceRoll == 52;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Safe Zone");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = Position Of(Event Player);
		Create Effect(All Players(All Teams), Ring, Color(Yellow), Event Player.G, 10, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		While(Event Player.perkActivated == True);
			Set Status(Players Within Radius(Event Player.G, 10, All Teams, Off), Event Player, Phased Out, 0.500);
			Wait(0.250, Ignore Condition);
		End;
		Destroy Effect(Event Player.I);
		Event Player.G = 0;
		Event Player.I = 0;
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
		Event Player.diceRoll == 53;
	}

	actions
	{
		Event Player.perkColour = Color(Lime Green);
		Event Player.perkName = Custom String("Overhealth");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Heal(Event Player, Null, Max Health(Event Player));
		Add Health Pool To Player(Event Player, Health, Max Health(Event Player), False, True);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 54;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Moon Shoes");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Move Speed(Event Player, 75);
		Set Gravity(Event Player, 50);
		Set Jump Vertical Speed(Event Player, 175);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 55;
	}

	actions
	{
		Event Player.perkColour = Color(Violet);
		Event Player.perkName = Custom String("Gravitational Hits");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
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
		Event Player.diceRoll == 55;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
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
		Event Player.diceRoll == 56;
	}

	actions
	{
		Event Player.perkColour = Color(Lime Green);
		Event Player.perkName = Custom String("Aimbot");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			Start Facing(Event Player, Update Every Frame(Direction Towards(Eye Position(Event Player), Eye Position(Player Closest To Reticle(
				Event Player, All Teams)))), 10000, To World, Direction and Turn Rate);
			Wait(0.250, Ignore Condition);
		End;
		Stop Facing(Event Player);
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
		Event Player.diceRoll == 57;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Slow Motion");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Set Slow Motion(50);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 58;
	}

	actions
	{
		Event Player.perkColour = Color(Green);
		Event Player.perkName = Custom String("High Sensitivity");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Aim Speed(Event Player, 200);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 59;
	}

	actions
	{
		Event Player.perkColour = Color(Rose);
		Event Player.perkName = Custom String("Low Sensitivity");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Aim Speed(Event Player, 10);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 60;
	}

	actions
	{
		Event Player.perkColour = Color(Rose);
		Event Player.perkName = Custom String("Head Attachment");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Attach Players(Event Player, Random Value In Array(Filtered Array(All Living Players(Opposite Team Of(Team Of(Event Player))),
			Current Array Element != Event Player)), Vector(0, 3, 0));
		Wait(1, Ignore Condition);
		Set Environment Credit Player(Event Player, Closest Player To(Event Player, All Teams));
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 61;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Replaced by AI");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Start Forcing Throttle(Event Player, 1, 0, 0, 0, 0, 0);
		Start Holding Button(Event Player, Button(Primary Fire));
		While(Event Player.perkActivated == True);
			Event Player.G = Player Closest To Reticle(Event Player, All Teams);
			If(Event Player.G != Null && Event Player.G != Event Player);
				Start Facing(Event Player, Update Every Frame(Direction Towards(Eye Position(Event Player), Eye Position(Event Player.G))), 10000,
					To World, Direction and Turn Rate);
			End;
			Wait(0.250, Ignore Condition);
		End;
		Stop Facing(Event Player);
		Stop Forcing Throttle(Event Player);
		Stop Holding Button(Event Player, Button(Primary Fire));
		Event Player.G = 0;
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
		Event Player.diceRoll == 62;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Tripped on rock");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 0.500;
		Damage(Event Player, Null, 25);
		Apply Impulse(Event Player, Up, 3, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), 15, To World,
			Cancel Contrary Motion);
		Set Status(Event Player, Null, Knocked Down, 9999);
		Wait Until(Event Player.perkActivated == False, 999999);
		Clear Status(Event Player, Knocked Down);
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
		Event Player.diceRoll == 63;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Slipped on banana");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 2;
		Damage(Event Player, Null, 50);
		Apply Impulse(Event Player, Up, 3, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), 50, To World,
			Cancel Contrary Motion);
		Set Status(Event Player, Null, Knocked Down, 9999);
		Wait Until(Event Player.perkActivated == False, 999999);
		Clear Status(Event Player, Knocked Down);
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
		Event Player.diceRoll == 64;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("One Punch Man");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Create Effect(All Players(All Teams), Sparkles, Color(Orange), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 64;
		disabled Event Ability == Button(Melee);
		disabled ((Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Event Ability == Button(Melee))) == True;
		((Hero Of(Event Player) == Hero(Brigitte) && Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Reinhardt)
			&& Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Vendetta) && Event Ability == Button(Primary Fire))
			|| (Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Hero Of(Event Player) == Hero(
			Hazard) && Event Ability == Button(Ability 1)) || (Hero Of(Event Player) == Hero(Ramattra) && (Event Ability == Button(
			Ability 1) || Event Ability == Button(Ultimate)) && Event Damage >= 50) || (Hero Of(Event Player) == Hero(Torbjörn)
			&& Event Ability == Button(Primary Fire) && Is In Alternate Form(Event Player) == True) || (Hero Of(Event Player) == Hero(
			Venture) && Event Ability == Button(Secondary Fire)) || Event Ability == Button(Melee)) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
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
		Event Player.diceRoll == 65;
	}

	actions
	{
		Event Player.perkColour = Custom Color(218, 165, 32, 255);
		Event Player.perkName = Custom String("Golden Gun");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Custom Color(218, 165, 32, 255), Occluded);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 65;
		Event Player.perkActivated == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		disabled Kill(Victim, Event Player);
		Damage(Victim, Event Player, 100000);
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
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
		Event Player.diceRoll == 66;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("No Hud");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Wait(0.500, Ignore Condition);
		Disable Hero HUD(Event Player);
		Disable Game Mode HUD(Event Player);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 67;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Flamethrower");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		disabled Create Effect(All Players(All Teams), Bad Aura, Color(Orange), Event Player, 1, Visible To Position and Radius);
		disabled Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
		disabled Destroy Effect(Event Player.G);
		disabled Event Player.G = 0;
	}
}

rule("67: Flamethrower Apply Burn")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 67;
		Array Contains(Array(Button(Primary Fire), Button(Secondary Fire), Button(Ability 1), Button(Ability 2), Button(Ultimate), Button(
			Melee)), Event Ability) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Start Damage Over Time(Victim, Event Player, 3, 10);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("68: Fall Damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 68;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Fall Damage");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Small Message(Event Player, Custom String("Thank you to Lilo for the code: (9SCKQ)"));
		While(Event Player.perkActivated == True);
			If(Altitude Of(Event Player) < 1 && Is In Air(Event Player) == True);
				Event Player.G = Vertical Speed Of(Event Player) * 1.750;
			End;
			If(Is On Ground(Event Player) == True && Event Player.G < -10);
				Damage(Event Player, Null, Absolute Value(Event Player.G) * Max Health(Event Player) / 200 * (Absolute Value(Event Player.G) / 8)
					* 2);
				Event Player.G = 0;
			End;
			Wait(0.050, Ignore Condition);
		End;
		Event Player.G = 0;
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
		Event Player.diceRoll == 69;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Spin");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 3;
		While(Event Player.perkActivated == True);
			Start Facing(Event Player, World Vector Of(Vector(1, 0, 0), Event Player, Rotation), 500, To World, Direction and Turn Rate);
			Wait(0.100, Ignore Condition);
		End;
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
		Event Player.diceRoll == 70;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Eliminate Yourself");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 8;
		Wait Until(Is Dead(Event Player) == True || Event Player.perkActivated == False, 999999);
		If(Is Dead(Event Player) == False);
			Start Damage Over Time(Event Player, Null, 1, Health(Event Player) * 0.750);
			Abort;
		End;
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
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

rule("71: Not on my Watch")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 71;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("Not on my watch");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			Set Status(Ray Cast Hit Player(Eye Position(Event Player), Eye Position(Event Player) + Facing Direction Of(Event Player) * 200,
				Filtered Array(All Living Players(All Teams), Current Array Element != Event Player), Event Player, True), Event Player,
				Hacked, 1);
			Wait(0.100, Ignore Condition);
		End;
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
		Event Player.diceRoll == 72;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Danger Zone");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = Position Of(Event Player);
		Create Effect(All Players(All Teams), Ring, Color(Red), Event Player.G, 10, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		While(Event Player.perkActivated == True);
			Damage(Players Within Radius(Event Player.G, 10, All Teams, Off), Event Player, 18.750);
			Wait(0.250, Ignore Condition);
		End;
		Destroy Effect(Event Player.I);
		Event Player.G = 0;
		Event Player.I = 0;
	}
}

rule("73: Kaioken x3")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 73;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Kaioken x3");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Start Damage Over Time(Event Player, Null, 5, 35);
		Create Effect(All Players(All Teams), Good Aura, Color(Red), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Set Damage Dealt(Event Player, 300);
		Set Jump Vertical Speed(Event Player, 125);
		Set Move Speed(Event Player, 125);
		Wait Until(Event Player.perkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Set Damage Dealt(Event Player, 100);
		Set Jump Vertical Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
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
		Event Player.diceRoll == 74;
	}

	actions
	{
		Event Player.perkColour = Color(Lime Green);
		Event Player.perkName = Custom String("Revitalised");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 25;
		Big Message(Event Player, Custom String("Press Interact to Use."));
		Wait Until(Is Button Held(Event Player, Button(Interact)) == True || Event Player.perkActivated == False, 999999);
		Abort If(Event Player.perkActivated == False);
		Set Player Health(Event Player, Max Health(Event Player));
		Set Ability Cooldown(Event Player, Button(Secondary Fire), 0);
		Set Ability Cooldown(Event Player, Button(Ability 1), 0);
		Set Ability Cooldown(Event Player, Button(Ability 2), 0);
		Set Ability Cooldown(Event Player, Button(Jump), 0);
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
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
		Event Player.diceRoll == 75;
	}

	actions
	{
		Event Player.perkColour = Color(Turquoise);
		Event Player.perkName = Custom String("Shrink Ray");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Sparkles, Color(Turquoise), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Attacker.diceRoll == 75;
	}

	actions
	{
		Abort If(Attacker.isSelectingFavourite == True);
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
		Event Player.diceRoll == 76;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Altitude Damage");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Progress Bar HUD Text(Event Player, Event Player.G / 10, Custom String("Current Damage Dealt: {0}%", Round To Integer(
			Event Player.G, Up)), Top, 5, Color(Purple), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		While(Event Player.perkActivated == True);
			Event Player.G = Altitude Of(Event Player) * 100 + 100;
			Set Damage Dealt(Event Player, Event Player.G);
			Wait(0.100, Ignore Condition);
		End;
		Wait(0.250, Ignore Condition);
		Destroy Progress Bar HUD Text(Event Player.H);
		Event Player.G = 0;
		Set Damage Dealt(Event Player, 100);
		Event Player.H = 0;
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
		Event Player.diceRoll == 77;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Beacon");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = Position Of(Event Player);
		Create Effect(All Players(All Teams), Ring, Color(White), Event Player.G, 15, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		Create Effect(All Players(All Teams), Light Shaft, Color(White), Event Player.G, 1.500, Visible To Position and Radius);
		Event Player.J = Last Created Entity;
		Create Effect(All Players(All Teams), Baptiste Immortality Field Protected Effect, Color(White), Event Player.G, 1,
			Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		While(Event Player.perkActivated == True);
			If(Array Contains(Players Within Radius(Event Player.G, 15, All Teams, Off), Event Player) == True);
				Set Damage Received(Event Player, 75);
				Set Damage Dealt(Event Player, 125);
				Heal(Event Player, Null, 12.500);
			Else;
				Set Damage Received(Event Player, 100);
				Set Damage Dealt(Event Player, 100);
			End;
			Wait(0.250, Ignore Condition);
		End;
		Set Damage Received(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Destroy Effect(Event Player.I);
		Destroy Effect(Event Player.J);
		Destroy Effect(Event Player.H);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
	}
}

rule("78: Crab")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 78;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Crab");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Start Forcing Throttle(Event Player, 0, 0, 0, 0, 0, 1);
		Wait Until(Event Player.perkActivated == False, 999999);
		Stop Forcing Throttle(Event Player);
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
		Event Player.diceRoll == 79;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Berserk");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Bad Aura, Color(Red), Update Every Frame(Event Player), 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 79;
		((Hero Of(Event Player) == Hero(Brigitte) && Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Reinhardt)
			&& Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Vendetta) && Event Ability == Button(Primary Fire))
			|| (Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Hero Of(Event Player) == Hero(
			Hazard) && Event Ability == Button(Ability 1)) || (Hero Of(Event Player) == Hero(Ramattra) && (Event Ability == Button(
			Ability 1) || Event Ability == Button(Ultimate)) && Event Damage >= 50) || (Hero Of(Event Player) == Hero(Torbjörn)
			&& Event Ability == Button(Primary Fire) && Is In Alternate Form(Event Player) == True) || (Hero Of(Event Player) == Hero(
			Venture) && Event Ability == Button(Secondary Fire)) || Event Ability == Button(Melee)) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
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
		Event Player.diceRoll == 80;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Slapped by Fish");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Set Move Speed(Event Player, 50);
		Damage(Event Player, Null, 75);
		Apply Impulse(Event Player, Up, 5, To World, Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), -70, To World,
			Cancel Contrary Motion);
		Apply Impulse(Event Player, Direction From Angles(Horizontal Facing Angle Of(Event Player), 0), -70, To World,
			Cancel Contrary Motion);
		Set Status(Event Player, Null, Knocked Down, 9999);
		Wait Until(Event Player.perkActivated == False, 999999);
		Clear Status(Event Player, Knocked Down);
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
		Event Player.diceRoll == 81;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("The Horse is here");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 60;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Big Message(All Players(All Teams), Custom String("{0} The Horse Is Here {0}", Hero Icon String(Hero(Orisa))));
		Create In-World Text(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Custom String("{0}",
			Hero Icon String(Hero(Orisa))), Update Every Frame(Eye Position(Event Player) + Vector(0, 1.750, 0)), 2, Do Not Clip,
			Visible To Position and String, Color(White), Default Visibility);
		Event Player.J = Last Text ID;
		Create Progress Bar In-World Text(Filtered Array(All Players(All Teams), Current Array Element != Event Player),
			Event Player.perkDuration / 60 * 100, Custom String(""), Update Every Frame(Eye Position(Event Player) + Vector(0, 0, 0)),
			0.500, Do Not Clip, Color(Yellow), Color(White), Visible To Position Values and Color, Default Visibility);
		Event Player.K = Last Text ID;
		Start Forcing Player To Be Hero(Event Player, Hero(Orisa));
		Set Damage Received(Event Player, 100);
		Set Damage Dealt(Event Player, 125);
		Set Move Speed(Event Player, 125);
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, 75);
		Wait Until(Event Player.perkActivated == False, 70);
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
		disabled Wait Until(Event Player.diceCooldown > 0, 999999);
		disabled Event Player.diceCooldown = Event Player.diceCooldown + 10;
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
		Event Player.diceRoll == 81;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
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
		Event Player.perkDuration -= 5;
		If(Event Player.perkDuration < 0);
			Event Player.perkDuration = 0;
		End;
		Wait(0.250, Ignore Condition);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Destroy Effect(Event Player.I);
		Event Player.I = 0;
		Set Player Score(Attacker, Score Of(Attacker) - 1);
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
		Event Player.diceRoll == 82;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Freeze Ray");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Mei Frozen Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Attacker.diceRoll == 82;
		Has Status(Event Player, Frozen) == False;
	}

	actions
	{
		Abort If(Attacker.isSelectingFavourite == True);
		Small Message(Event Player, Custom String("Frozen by {0} {1}", Hero Icon String(Hero Of(Attacker)), Attacker));
		Set Status(Event Player, Attacker, Frozen, 1);
		disabled Set Damage Received(Event Player, 75);
		disabled Wait Until(!Has Status(Event Player, Frozen), 1.500);
		disabled Set Damage Received(Event Player, 100);
	}
}

rule("83: Time Keeper End")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.timeFreeze[0] == True;
	}

	actions
	{
		Start Forcing Player Position(Event Player, World Vector Of(Vector(0, 0.250, 0), Event Player, Rotation And Translation), False);
		Wait Until(Event Player.timeFreeze[0] == False, 15);
		Stop Forcing Player Position(Event Player);
		Start Damage Over Time(Event Player, Event Player.timeFreeze[1], 1, Event Player.timeFreeze[2]);
		disabled Damage(Event Player, Event Player.timeFreeze[1], Event Player.timeFreeze[2]);
		Wait(1, Ignore Condition);
		Event Player.timeFreeze[1] = 0;
		Event Player.timeFreeze[2] = 0;
	}
}

rule("83: Time Keeper Damage")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.timeFreeze[0] == True;
	}

	actions
	{
		Event Player.timeFreeze[2] += Event Damage * 9;
	}
}

rule("83: Time Keeper Death")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.timeFreeze[0] == True;
	}

	actions
	{
		Clear Status(Event Player, Unkillable);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Allow Button(Event Player, Button(Ability 1));
		Allow Button(Event Player, Button(Ability 2));
		Allow Button(Event Player, Button(Ultimate));
		Allow Button(Event Player, Button(Interact));
		Allow Button(Event Player, Button(Jump));
		Allow Button(Event Player, Button(Crouch));
		Allow Button(Event Player, Button(Melee));
		Allow Button(Event Player, Button(Reload));
		Stop Forcing Throttle(Event Player);
		Stop Forcing Player Position(Event Player);
		Set Aim Speed(Event Player, 100);
		Clear Status(Event Player, Frozen);
		Event Player.timeFreeze[0] = False;
		Event Player.timeFreeze[1] = 0;
		Event Player.timeFreeze[2] = 0;
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
		Event Player.diceRoll == 83;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Time Keeper");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 4;
		Event Player.I = 25;
		"Start TS"
		Set Slow Motion(75);
		Play Effect(All Players(All Teams), Ring Explosion, Custom Color(128, 128, 128, 128), Position Of(Event Player), Event Player.I);
		Play Effect(All Players(All Teams), Debuff Impact Sound, Color(White), Position Of(Event Player), Event Player.I);
		Wait(0.250, Ignore Condition);
		Set Slow Motion(50);
		Play Effect(All Players(All Teams), Ring Explosion, Custom Color(128, 128, 128, 128), Position Of(Event Player), Event Player.I);
		Play Effect(All Players(All Teams), Debuff Impact Sound, Color(White), Position Of(Event Player), Event Player.I);
		Wait(0.150, Ignore Condition);
		Set Slow Motion(25);
		Play Effect(All Players(All Teams), Ring Explosion, Custom Color(128, 128, 128, 128), Position Of(Event Player), Event Player.I);
		Play Effect(All Players(All Teams), Debuff Impact Sound, Color(White), Position Of(Event Player), Event Player.I);
		Wait(0.100, Ignore Condition);
		"TIME FROZEN"
		Set Slow Motion(100);
		Play Effect(All Players(All Teams), Ring Explosion, Custom Color(128, 128, 128, 128), Position Of(Event Player), Event Player.I);
		Play Effect(All Players(All Teams), Debuff Impact Sound, Color(White), Position Of(Event Player), Event Player.I);
		Create Effect(All Players(All Teams), Sphere, Custom Color(128, 128, 128, 128), Position Of(Event Player), Event Player.I, None);
		Event Player.G = Last Created Entity;
		Event Player.H = Filtered Array(Players Within Radius(Event Player, Event Player.I, All Teams, Off),
			Current Array Element != Event Player);
		Set Projectile Speed(Event Player, 25);
		Set Projectile Gravity(Event Player, 0);
		Set Damage Dealt(Event Player, 10);
		Start Forcing Throttle(Event Player.H, 0, 0, 0, 0, 0, 0);
		Disallow Button(Event Player.H, Button(Primary Fire));
		Disallow Button(Event Player.H, Button(Secondary Fire));
		Disallow Button(Event Player.H, Button(Ability 1));
		Disallow Button(Event Player.H, Button(Ability 2));
		Disallow Button(Event Player.H, Button(Ultimate));
		Disallow Button(Event Player.H, Button(Interact));
		Disallow Button(Event Player.H, Button(Jump));
		Disallow Button(Event Player.H, Button(Crouch));
		Disallow Button(Event Player.H, Button(Melee));
		Disallow Button(Event Player.H, Button(Reload));
		Set Aim Speed(Event Player.H, 10);
		Set Status(Event Player.H, Event Player, Frozen, 9999);
		Set Status(Event Player.H, Event Player, Unkillable, 9999);
		Event Player.H.timeFreeze[0] = True;
		Event Player.H.timeFreeze[1] = Event Player;
		Event Player.H.timeFreeze[2] = 0;
		Wait Until(Event Player.perkActivated == False, 999999);
		Clear Status(Event Player.H, Unkillable);
		Stop Forcing Player Position(Event Player.H);
		Allow Button(Event Player.H, Button(Primary Fire));
		Allow Button(Event Player.H, Button(Secondary Fire));
		Allow Button(Event Player.H, Button(Ability 1));
		Allow Button(Event Player.H, Button(Ability 2));
		Allow Button(Event Player.H, Button(Ultimate));
		Allow Button(Event Player.H, Button(Interact));
		Allow Button(Event Player.H, Button(Jump));
		Allow Button(Event Player.H, Button(Crouch));
		Allow Button(Event Player.H, Button(Melee));
		Allow Button(Event Player.H, Button(Reload));
		Stop Forcing Throttle(Event Player.H);
		Set Aim Speed(Event Player.H, 100);
		Clear Status(Event Player.H, Frozen);
		Set Projectile Speed(Event Player, 100);
		Set Projectile Gravity(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Event Player.H.timeFreeze[0] = False;
		disabled Event Player.H.timeFreeze[1] = 0;
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
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
		Event Player.diceRoll == 84;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Float");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Gravity(Event Player, 0);
		While(Event Player.perkActivated == True);
			If(Vertical Speed Of(Event Player) <= 2);
				Apply Impulse(Event Player, Up, 2, To World, Cancel Contrary Motion);
			End;
			Wait(0.050, Ignore Condition);
		End;
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
		Event Player.diceRoll == 85;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Sent to Heaven");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 3;
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
		Event Player.diceRoll == 86;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Heart Virus");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.virusSpread = 0;
		Create Effect(All Players(All Teams), Cloud, Color(Red), Event Player, Event Player.virusSpread, Visible To Position and Radius);
		Event Player.virusCloud = Last Created Entity;
		Set Move Speed(Event Player, 100);
		Set Aim Speed(Event Player, 100);
		While(Event Player.perkActivated == True && Event Player.perkDuration > 0);
			If(Event Player.perkDuration / 10 * 100 < 75 && Event Player.perkDuration / 10 * 100 >= 50);
				Event Player.virusSpread = 5;
				Set Move Speed(Event Player, 80);
				Set Aim Speed(Event Player, 75);
			End;
			If(Event Player.perkDuration / 10 * 100 < 50 && Event Player.perkDuration / 10 * 100 >= 25);
				Event Player.virusSpread = 10;
				Set Move Speed(Event Player, 65);
				Set Aim Speed(Event Player, 50);
			End;
			If(Event Player.perkDuration / 10 * 100 < 25);
				Event Player.virusSpread = 15;
				Set Move Speed(Event Player, 35);
				Set Aim Speed(Event Player, 25);
			End;
			"find new targets once per tick"
			Event Player.virusTargets = Filtered Array(Players Within Radius(Event Player, Event Player.virusSpread, All Teams,
				Surfaces And Enemy Barriers), Current Array Element != Event Player && Current Array Element.diceRoll != 86);
			"end any active perk first so its normal cleanup runs"
			Filtered Array(Event Player.virusTargets, Current Array Element.perkActivated == True).perkDuration = 0;
			Filtered Array(Event Player.virusTargets, Current Array Element.perkActivated == True).perkActivated = False;
			Wait(0.100, Ignore Condition);
			"infect living targets"
			Event Player.virusTargets = Filtered Array(Event Player.virusTargets, Is Alive(Current Array Element) == True);
			Event Player.virusTargets.perkActivated = True;
			Event Player.virusTargets.diceRoll = 86;
			Wait(0.150, Ignore Condition);
		End;
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		If(Event Player.perkDuration <= 0 && Is Alive(Event Player) == True);
			Set Status(Event Player, Null, Knocked Down, 9999);
			Wait(0.500, Ignore Condition);
			If(Is Alive(Event Player) == True);
				Start Damage Over Time(Event Player, Null, 5, Max Health(Event Player) * 0.750);
			End;
			Wait(2, Ignore Condition);
		End;
		Destroy Effect(Event Player.virusCloud);
		Event Player.virusCloud = 0;
		Event Player.virusSpread = 0;
		Event Player.virusTargets = 0;
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
		Event Player.diceRoll == 86;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
		Set Aim Speed(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Stop All Damage Over Time(Event Player);
		Destroy Effect(Event Player.virusCloud);
		Event Player.virusCloud = 0;
		Event Player.virusSpread = 0;
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
		Event Player.diceRoll == 87;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Sturdy");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Knockback Received(Event Player, 0);
		Set Move Speed(Event Player, 80);
		Add Health Pool To Player(Event Player, Armor, 250, True, True);
		Set Damage Received(Event Player, 75);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 88;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Constant Nullification");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.I = 15;
		Create Effect(All Players(All Teams), Ring, Color(White), Event Player, Event Player.I, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Create Effect(All Players(All Teams), Sphere, Color(White), Event Player, Event Player.I, Visible To Position and Radius);
		Event Player.H = Last Created Entity;
		While(Event Player.perkActivated == True);
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
				.perkDuration = 0;
			Filtered Array(Players Within Radius(Event Player, Event Player.I, All Teams, Off), Current Array Element != Event Player)
				.perkActivated = False;
			Set Environment Credit Player(Event Player, Players Within Radius(Event Player, Event Player.I, All Teams, Off));
			Wait(0.250, Ignore Condition);
		End;
		Wait Until(Event Player.perkActivated == False, 999999);
		Destroy Effect(Event Player.G);
		Destroy Effect(Event Player.H);
		Event Player.I = 0;
		Event Player.G = 0;
		Event Player.H = 0;
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
		Event Player.diceRoll == 89;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("A-Train");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 5;
		Create Effect(All Players(All Teams), Good Aura, Color(Aqua), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Start Forcing Throttle(Event Player, 1, 1, 0, 0, 0, 0);
		Disable Movement Collision With Players(Event Player);
		Set Move Speed(Event Player, 400);
		While(Event Player.perkActivated == True);
			Event Player.H = Filtered Array(Players Within Radius(Event Player, 5, All Teams, Surfaces),
				Current Array Element != Event Player);
			Event Player.K = 0;
			While(Event Player.K < Count Of(Event Player.H));
				Event Player.I = Event Player.H[Event Player.K];
				If(Is Alive(Event Player.I) == True);
					Apply Impulse(Event Player.I, Up, 5, To World, Cancel Contrary Motion);
					Apply Impulse(Event Player.I, Direction Towards(Event Player, Event Player.I), 70, To World, Cancel Contrary Motion);
					Set Environment Credit Player(Event Player.I, Event Player);
					Damage(Event Player.I, Event Player, 300);
				End;
				Event Player.K = Event Player.K + 1;
			End;
			Wait(0.500, Ignore Condition);
		End;
		Set Move Speed(Event Player, 100);
		Stop Forcing Throttle(Event Player);
		Enable Movement Collision With Players(Event Player);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.K = 0;
	}
}

rule("89: A-Train Kill")
{
	event
	{
		Player Dealt Final Blow;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 89;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration += 5;
		Big Message(Array(Event Player, Victim), Custom String("{0} I can't stop...", Hero Icon String(Hero Of(Event Player))));
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
		Event Player.diceRoll == 90;
	}

	actions
	{
		Event Player.perkColour = Color(Violet);
		Event Player.perkName = Custom String("Gravitational Push");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Sphere, Color(Violet), Event Player, 10, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Disable Movement Collision With Players(Event Player);
		While(Event Player.perkActivated == True);
			Event Player.H = Filtered Array(Players Within Radius(Event Player, 10, All Teams, Off), Current Array Element != Event Player);
			Event Player.K = 0;
			While(Event Player.K < Count Of(Event Player.H));
				Event Player.I = Event Player.H[Event Player.K];
				If(Is Alive(Event Player.I) == True);
					Apply Impulse(Event Player.I, Up, 1, To World, Cancel Contrary Motion);
					Apply Impulse(Event Player.I, Direction Towards(Event Player, Event Player.I), 10, To World, Cancel Contrary Motion);
					Set Environment Credit Player(Event Player.I, Event Player);
				End;
				Event Player.K = Event Player.K + 1;
			End;
			Wait(0.050, Ignore Condition);
		End;
		Enable Movement Collision With Players(Event Player);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.K = 0;
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
		Event Player.diceRoll == 91;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Gravitational Pull");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Sphere, Color(Purple), Event Player, 10, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Disable Movement Collision With Players(Event Player);
		While(Event Player.perkActivated == True);
			Event Player.H = Filtered Array(Players Within Radius(Event Player, 10, All Teams, Off), Current Array Element != Event Player);
			Event Player.K = 0;
			While(Event Player.K < Count Of(Event Player.H));
				Event Player.I = Event Player.H[Event Player.K];
				If(Is Alive(Event Player.I) == True);
					Apply Impulse(Event Player.I, Up, 1, To World, Cancel Contrary Motion);
					Apply Impulse(Event Player.I, Direction Towards(Event Player, Event Player.I), -10, To World, Cancel Contrary Motion);
					Set Environment Credit Player(Event Player.I, Event Player);
				End;
				Event Player.K = Event Player.K + 1;
			End;
			Wait(0.050, Ignore Condition);
		End;
		Enable Movement Collision With Players(Event Player);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.K = 0;
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
		Event Player.diceRoll == 92;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Lost the Dice");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Wait Until(Event Player.diceCooldown > 0, 999999);
		Event Player.diceCooldown = Event Player.diceCooldown + 10;
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
		Event Player.diceRoll == 93;
	}

	actions
	{
		Event Player.perkColour = Color(Rose);
		Event Player.perkName = Custom String("Stole the Dice");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 20;
		Event Player.stolenPlr = Null;
		disabled Event Player.G = True;
		"search"
		While(Event Player.diceRoll == 93 && Event Player.stolenPlr == Null);
			Event Player.stolenPlr = Random Value In Array(Filtered Array(Filtered Array(All Players(All Teams),
				Current Array Element.perkActivated == True), Current Array Element != Event Player));
			Wait(0.250, Ignore Condition);
		End;
		Big Message(Event Player, Custom String("You stole the dice from..."));
		Wait(0.100, Ignore Condition);
		"find player"
		disabled Event Player.stolenPlr = Random Value In Array(Filtered Array(Filtered Array(All Players(All Teams),
			Current Array Element.perkActivated == True), Current Array Element != Event Player));
		"no player"
		If(Event Player.stolenPlr == Null);
			Big Message(Event Player, Custom String("Couldn't find a player!"));
			Event Player.stolenPlr = 0;
			Abort;
		End;
		Event Player.stolenDiceRoll = Event Player.stolenPlr.diceRoll;
		Event Player.stolenDiceName = Event Player.stolenPlr.perkName;
		Big Message(Event Player.stolenPlr, Custom String("Perk stolen by {0}", Event Player));
		Big Message(Event Player, Custom String("{0} from {1} {2}!", Event Player.stolenDiceName, Hero Icon String(Hero Of(
			Event Player.stolenPlr)), Event Player.stolenPlr));
		disabled Event Player.perkDuration = 0;
		disabled Event Player.perkActivated = False;
		disabled Event Player.perkActivated = True;
		Event Player.diceRoll = Event Player.stolenDiceRoll;
		Wait(0.016, Ignore Condition);
		Event Player.stolenPlr.perkDuration = 0;
		Event Player.stolenPlr.perkActivated = False;
		Event Player.stolenPlr = 0;
		Event Player.stolenDiceRoll = 0;
		Event Player.stolenDiceName = 0;
	}
}

rule("94: ESP")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 94;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("ESP");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Start Forcing Player Outlines(All Players(All Teams), Event Player, True, Color(Rose), Always);
		Event Player.showHeroIconEsp = True;
		Event Player.showPerkEsp = True;
		Wait Until(Event Player.perkActivated == False, 999999);
		Stop Forcing Player Outlines(All Players(All Teams), Event Player);
		Event Player.showPerkEsp = 0;
		Event Player.showHeroIconEsp = 0;
	}
}

rule("95: Super Jump")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 95;
	}

	actions
	{
		Event Player.perkColour = Color(Sky Blue);
		Event Player.perkName = Custom String("Super Jump");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Jump Vertical Speed(Event Player, 300);
		Wait Until(Event Player.perkActivated == False, 999999);
		Set Jump Vertical Speed(Event Player, 100);
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
		Event Player.diceRoll == 96;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Smoke Bomb");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Bad Aura, Color(Gray), Eye Position(Event Player), 15, None);
		Event Player.G = Last Created Entity;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), False, Color(White), Default);
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 97;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Yippee!");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		disabled Kill(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player);
		Damage(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player, 100000);
		Big Message(All Players(All Teams), Custom String("Yippee!!!!"));
		Wait(2, Ignore Condition);
		disabled Kill(Filtered Array(Filtered Array(Players On Hero(Hero(D.Va), All Teams), Is In Alternate Form(Current Array Element) == True),
			Current Array Element != Event Player), Event Player);
		Damage(Filtered Array(Filtered Array(Players On Hero(Hero(D.Va), All Teams), Is In Alternate Form(Current Array Element) == True),
			Current Array Element != Event Player), Event Player, 100000);
		Wait Until(Event Player.diceCooldown > 0, 999999);
		Event Player.diceCooldown = 1;
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
		Event Player.diceRoll == 98;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Stalker");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 30;
		Start Forcing Player Outlines(Event Player, All Players(All Teams), False, Color(White), Default);
		Event Player.G = 100;
		Create Progress Bar HUD Text(Event Player, Event Player.G / 10, Custom String("Current Damage Dealt: {0}%", Round To Integer(
			Event Player.G, Up)), Top, 5, Color(Red), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		While(Event Player.perkActivated == True);
			Event Player.I = Player Closest To Reticle(Event Player, All Teams);
			If(Event Player.I != Null && Event Player.I != Event Player && Is Alive(Event Player) == True && Is Alive(Event Player.I)
				== True && Is In Line of Sight(Event Player, Event Player.I, Barriers Do Not Block LOS) == True && Array Contains(
				Players in View Angle(Event Player.I, All Teams, 45), Event Player) == False);
				Event Player.G = Event Player.G + 5;
				Set Damage Dealt(Event Player, Event Player.G);
			End;
			Wait(0.100, Ignore Condition);
		End;
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Wait(0.250, Ignore Condition);
		Destroy Progress Bar HUD Text(Event Player.H);
		Set Damage Dealt(Event Player, 100);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
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
		Event Player.diceRoll == 99;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("See the world burn");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Status(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player, Burning, 10);
		Start Damage Over Time(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Event Player, 10, 20);
		Big Message(All Players(All Teams), Custom String("{0}{1} wants to see the world burn.", Hero Icon String(Hero Of(Event Player)),
			Event Player));
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 100;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Blood is Fuel");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Start Damage Over Time(Event Player, Null, 10, Max Health(Event Player) * 0.850 / Event Player.perkDuration);
		Set Move Speed(Event Player, 115);
		Wait Until(Event Player.perkActivated == False, 999999);
		Set Move Speed(Event Player, 100);
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
		Event Player.diceRoll == 100;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
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
		Event Player.diceRoll == 101;
	}

	actions
	{
		Event Player.perkColour = Color(Blue);
		Event Player.perkName = Custom String("Party Time");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
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
		Wait(0.100, Ignore Condition);
		All Players(All Teams).perkDuration = 0;
		All Players(All Teams).perkActivated = False;
		Wait(0.100, Ignore Condition);
		All Players(All Teams).diceCooldown = 0;
		Wait(0.100, Ignore Condition);
		Enable Movement Collision With Players(All Players(All Teams));
		Press Button(All Players(All Teams), Button(Interact));
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
		Event Player.diceRoll == 102;
	}

	actions
	{
		Event Player.perkColour = Color(Turquoise);
		Event Player.perkName = Custom String("Sorcerer's Jackpot");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 254;
		"Fever Begin"
		disabled Event Player.diceReroll = 102;
		Set Move Speed(Event Player, 275);
		Set Damage Received(Event Player, 70);
		Set Damage Dealt(Event Player, 140);
		Start Heal Over Time(Event Player, Event Player, 9999, 250);
		Set Knockback Dealt(Event Player, 200);
		Set Knockback Received(Event Player, 50);
		Create Progress Bar HUD Text(Event Player, Event Player.perkDuration / 251 * 100, Custom String("Energy Remaining:"), Top, 10,
			Color(Turquoise), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.I = Last Text ID;
		Create Progress Bar In-World Text(Filtered Array(All Players(All Teams), Current Array Element != Event Player),
			Event Player.perkDuration / 251 * 100, Custom String(""), Update Every Frame(Eye Position(Event Player) + Vector(0, 0, 0)),
			0.500, Do Not Clip, Color(Turquoise), Color(White), Visible To Position Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		Create Effect(All Players(All Teams), Bad Aura, Color(Turquoise), Event Player, 3, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		disabled Wait Until(Event Player.diceCooldown > 0, 999999);
		disabled Event Player.diceCooldown = Event Player.diceCooldown + 30;
	}
}

rule("102: Sorcerer's Jackpot Energy Drain")
{
	event
	{
		Player Dealt Healing;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 102;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		If(Custom String("{0}", Event Player) == Custom String("Zamasu"));
			Event Player.perkDuration -= Event Healing / 15;
		Else;
			Event Player.perkDuration -= Event Healing / 5;
			disabled End;
			If(Event Player.perkDuration < 0);
				Event Player.perkDuration = 0;
			End;
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
		Event Player.diceRoll == 102;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		"half"
		disabled Event Player.perkDuration = Event Player.perkDuration / 2;
		"turn off"
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
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
		Event Player.diceRoll == 103;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Lightspeed");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Move Speed(Event Player, 1000);
		Create Effect(All Players(All Teams), Sparkles, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 104;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("The Floor Is Lava");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			If(Is On Ground(Event Player) == True && Is Alive(Event Player) == True);
				Set Status(Event Player, Null, Burning, 0.250);
				Damage(Event Player, Null, 6.250);
			End;
			Wait(0.250, Ignore Condition);
		End;
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
		Event Player.diceRoll == 105;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Legendary");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Max Health(Event Player, 404);
		Wait(0.016, Ignore Condition);
		Set Player Health(Event Player, Max Health(Event Player));
		Set Damage Dealt(Event Player, 300);
		Create Effect(All Players(All Teams), Bad Aura, Color(Orange), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 106;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Tragic");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Max Health(Event Player, 40);
		Set Damage Dealt(Event Player, 25);
		Create Effect(All Players(All Teams), Bad Aura, Color(Gray), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 107;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Headache");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
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
		Event Player.diceRoll == 107;
		Event Was Critical Hit == True;
	}

	actions
	{
		Damage(Event Player, Attacker, Event Damage / 2);
		Set Status(Event Player, Attacker, Stunned, 0.250);
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
		Event Player.diceRoll == 108;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Accelerated Ultimate");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) + 2);
			Wait(0.050, Ignore Condition);
		End;
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
		Event Player.diceRoll == 109;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("Damage Reflection");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Create Effect(All Players(All Teams), Reaper Wraith Form Effect, Color(White), Event Player, 1, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
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
		Event Player.diceRoll == 109;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Damage(Attacker, Event Player, Event Damage * 1);
	}
}

rule("110: Ground Pound")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 110;
	}

	actions
	{
		Event Player.perkColour = Custom Color(165, 42, 42, 255);
		Event Player.perkName = Custom String("Ground Pound");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		While(Event Player.perkActivated == True);
			If(Is Button Held(Event Player, Button(Crouch)) == True && Is In Air(Event Player) == True);
				Apply Impulse(Event Player, Vector(0, 1, 0), 20, To World, Cancel Contrary Motion);
				Set Move Speed(Event Player, 50);
				Wait(0.250, Ignore Condition);
				Set Gravity(Event Player, 10);
				Apply Impulse(Event Player, Vector(0, -1, 0), 0.050, To World, Cancel Contrary Motion);
				Wait(0.700, Ignore Condition);
				Set Gravity(Event Player, 100);
				Set Move Speed(Event Player, 100);
				Event Player.J = Altitude Of(Event Player);
				Apply Impulse(Event Player, Down, 70, To World, Cancel Contrary Motion);
				Wait Until(Is On Ground(Event Player) == True || Event Player.perkActivated == False, 99999);
				If(Event Player.perkActivated == True);
					Event Player.H = Filtered Array(Players Within Radius(Event Player, 8, All Teams, Surfaces And Enemy Barriers),
						Current Array Element != Event Player);
					Damage(Event Player.H, Event Player, Event Player.J * 30);
					Set Status(Event Player.H, Null, Rooted, Event Player.J * 0.100);
					Apply Impulse(Event Player.H, Up, Event Player.J, To World, Cancel Contrary Motion);
				End;
				Wait(0.500, Ignore Condition);
			End;
			Wait(0.050, Ignore Condition);
		End;
		Set Gravity(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Event Player.I = 0;
		Event Player.H = 0;
		Event Player.J = 0;
	}
}

rule("111: Ultimate Charge Leak")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 111;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Ultimate Charge Leak");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) - 1);
			Wait(0.222, Ignore Condition);
		End;
	}
}

rule("112: Filled with: Determination")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 112;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Filled with: Determination");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Set Status(Event Player, Null, Unkillable, 9999);
		Wait Until(Health(Event Player) <= 1 || Event Player.perkActivated == False, 999999);
		If(Health(Event Player) <= Max Health(Event Player) * 0.250);
			Start Camera(Event Player, World Vector Of(Vector(0, 3, -2.500), Event Player, Rotation And Translation), Event Player, 15);
			Set Damage Received(Event Player, 0);
			Set Status(Event Player, Null, Knocked Down, 2);
			Wait(1, Ignore Condition);
			Big Message(Event Player, Custom String("You are filled with Determination."));
			Create Effect(Event Player, Baptiste Immortality Field Protected Effect, Color(Red), Event Player, 1,
				Visible To Position and Radius);
			Event Player.G = Last Created Entity;
			Play Effect(All Players(All Teams), Good Explosion, Color(Red), Event Player, 5);
			Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
			Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
			Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
			Play Effect(All Players(All Teams), Heal Target Active Effect, Color(White), Event Player, 1);
			Heal(Event Player, Null, Max Health(Event Player) * 0.700);
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
			Wait(0.500, Ignore Condition);
			Clear Status(Event Player, Unkillable);
			Stop Camera(Event Player);
			Set Damage Received(Event Player, 65);
			Set Damage Dealt(Event Player, 125);
			Wait(5, Ignore Condition);
			Destroy Effect(Event Player.G);
			Event Player.G = 0;
			Set Damage Received(Event Player, 100);
			Set Damage Dealt(Event Player, 100);
		Else;
			Clear Status(Event Player, Unkillable);
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
		End;
	}
}

rule("113: Filled with: Patience")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 113;
	}

	actions
	{
		Event Player.perkColour = Color(Sky Blue);
		Event Player.perkName = Custom String("Filled with: Patience");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Big Message(Event Player, Custom String("Wait for the right moment..."));
		Set Damage Received(Event Player, 50);
		Wait Until(Event Player.perkDuration <= 5, 99999);
		If(Event Player.G != True);
			Play Effect(All Players(All Teams), Good Pickup Effect, Color(Sky Blue), Event Player, 1);
			Big Message(Event Player, Custom String("NOW!!!"));
			Set Damage Dealt(Event Player, 350);
		End;
		Wait Until(Event Player.perkActivated == False, 99999);
		Set Damage Received(Event Player, 100);
		Set Damage Dealt(Event Player, 100);
		Event Player.G = 0;
	}
}

rule("113: Filled with: Patience Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 113;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		If(Event Player.perkDuration > 5);
			Event Player.G = True;
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
			Big Message(Event Player, Custom String("Too soon."));
		End;
	}
}

rule("114: Filled with: Bravery")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 114;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Filled with: Bravery");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = 0;
		Big Message(Event Player, Custom String("Refuse to fall."));
		disabled Set Status(Event Player, Null, Unkillable, 9999);
		Create Effect(All Players(All Teams), Baptiste Immortality Field Protected Effect, Color(Orange), Event Player, 1,
			Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		While(Event Player.perkActivated == True);
			If(Health(Event Player) > Max Health(Event Player) * 0.750);
				Set Damage Dealt(Event Player, 100);
				Set Move Speed(Event Player, 100);
				Set Knockback Received(Event Player, 100);
				Set Damage Received(Event Player, 100);
				Set Healing Received(Event Player, 100);
			End;
			If(Health(Event Player) <= Max Health(Event Player) * 0.750 && Health(Event Player) > Max Health(Event Player) * 0.500);
				Set Damage Dealt(Event Player, 125);
				Set Move Speed(Event Player, 125);
				Set Knockback Received(Event Player, 75);
				Set Damage Received(Event Player, 175);
				Set Healing Received(Event Player, 100);
			End;
			If(Health(Event Player) <= Max Health(Event Player) * 0.500 && Health(Event Player) > Max Health(Event Player) * 0.250);
				Set Damage Dealt(Event Player, 175);
				Set Move Speed(Event Player, 175);
				Set Knockback Received(Event Player, 50);
				Set Damage Received(Event Player, 50);
				Set Healing Received(Event Player, 100);
			End;
			If(Health(Event Player) <= Max Health(Event Player) * 0.250);
				Set Damage Dealt(Event Player, 250);
				Set Move Speed(Event Player, 250);
				Set Knockback Received(Event Player, 0);
				Set Damage Received(Event Player, 25);
				Set Healing Received(Event Player, 500);
			End;
			Wait(0.250, Ignore Condition);
		End;
		disabled Clear Status(Event Player, Unkillable);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Set Damage Dealt(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Set Knockback Received(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Set Healing Received(Event Player, 100);
	}
}

rule("115: Filled with: Integrity")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 115;
	}

	actions
	{
		Event Player.perkColour = Color(Blue);
		Event Player.perkName = Custom String("Filled with: Integrity");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 30;
		Wait Until(Event Player.perkActivated == False, 99999);
		Abort If(Event Player.integrity == 0);
		If(Event Player.integrityChain != 0);
			Big Message(Event Player, Custom String("The chains decay."));
			Destroy Effect(Event Player.integrityChain);
		End;
		If(Event Player.integrity != 0 && Event Player.integrity.integrityChain != 0);
			Big Message(Event Player.integrity, Custom String("The chains decay."));
			Destroy Effect(Event Player.integrity.integrityChain);
		End;
		Stop Damage Modification(Event Player.integrity.integrityIn);
		Stop Damage Modification(Event Player.integrity.integrityOut);
		Stop Damage Modification(Event Player.integrityIn);
		Stop Damage Modification(Event Player.integrityOut);
		Event Player.integrityChain = 0;
		Event Player.integrity.integrityChain = 0;
		Event Player.integrity.integrityIn = 0;
		Event Player.integrity.integrityOut = 0;
		Event Player.integrity.integrity = 0;
		Event Player.integrity = 0;
		Event Player.integrityIn = 0;
		Event Player.integrityOut = 0;
	}
}

rule("115: Filled with: Integrity Get Target")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 115;
		Event Player.integrity == 0;
		Is Alive(Victim) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.integrity = Victim;
		Victim.integrity = Event Player;
		Heal(Event Player, Null, Max Health(Event Player));
		Heal(Victim, Null, Max Health(Victim));
		Big Message(Event Player, Custom String("{0} An honest duel.", Hero Icon String(Hero Of(Victim))));
		Big Message(Victim, Custom String("{0} Face me.", Hero Icon String(Hero Of(Event Player))));
		Create Beam Effect(All Players(All Teams), Grapple Beam, Event Player, Victim, Color(White), Visible To Position and Radius);
		Event Player.integrityChain = Last Created Entity;
		Victim.integrityChain = Event Player.integrityChain;
	}
}

rule("115: Filled with: Integrity No Outside Damage")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.integrity != 0;
		Event Player.integrityIn == 0;
		Event Player.integrityOut == 0;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		"in"
		Start Damage Modification(Event Player, Filtered Array(All Players(All Teams), Current Array Element != Event Player.integrity), 0,
			Receivers and Damagers);
		Event Player.integrityIn = Last Damage Modification ID;
		"out"
		Start Damage Modification(Filtered Array(All Players(All Teams), Current Array Element != Event Player.integrity), Event Player, 0,
			Receivers and Damagers);
		Event Player.integrityOut = Last Damage Modification ID;
	}
}

rule("115: Filled with: Integrity Death")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.integrity != 0;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
		If(Event Player.integrityChain != 0);
			Big Message(Event Player.integrity, Custom String("Your opponent has fallen."));
			Destroy Effect(Event Player.integrityChain);
		End;
		If(Event Player.integrity != 0 && Event Player.integrity.integrityChain != 0);
			Big Message(Event Player, Custom String("You fought with integrity."));
			Destroy Effect(Event Player.integrity.integrityChain);
		End;
		Stop Damage Modification(Event Player.integrity.integrityIn);
		Stop Damage Modification(Event Player.integrity.integrityOut);
		Stop Damage Modification(Event Player.integrityIn);
		Stop Damage Modification(Event Player.integrityOut);
		Event Player.integrityChain = 0;
		Event Player.integrity.integrityChain = 0;
		Event Player.integrity.integrityIn = 0;
		Event Player.integrity.integrityOut = 0;
		Event Player.integrity.integrity = 0;
		Event Player.integrity = 0;
		Event Player.integrityIn = 0;
		Event Player.integrityOut = 0;
	}
}

rule("116: Filled with: Perseverance")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 116;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Filled with: Perseverance");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Event Player.G = 0;
		Event Player.J = 0;
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Big Message(Event Player, Custom String("Endure."));
		Create Progress Bar HUD Text(Event Player, Event Player.G, Custom String("Perseverance"), Top, 5, Color(Purple), Color(White),
			Visible To Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		"Buff Duration"
		While(Event Player.perkActivated == True);
			If(Event Player.J > 0);
				Event Player.J = Max(0, Event Player.J - 0.050);
				If(Event Player.J == 0);
					Destroy Effect(Event Player.I);
					Event Player.I = 0;
					Set Damage Received(Event Player, 100);
				End;
			End;
			Wait(0.050, Ignore Condition);
		End;
		Destroy Progress Bar HUD Text(Event Player.H);
		Event Player.G = 0;
		Event Player.J = 0;
		Event Player.H = 0;
		Destroy Effect(Event Player.I);
		Event Player.I = 0;
		Set Damage Received(Event Player, 100);
	}
}

rule("116: Filled with: Perseverance Charge")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 116;
		Event Player.perkActivated == True;
		Event Player.G < 100;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		"Charge Perseverance"
		Event Player.G = Min(100, Event Player.G + 20);
		If(Event Player.G >= 100);
			"Activate Perseverance"
			Event Player.G = 0;
			"Refresh Three Second Buff"
			Event Player.J = 3;
			"Heal 30%"
			Heal(Event Player, Null, Max Health(Event Player) * 0.300);
			"Refresh Effects"
			Destroy Effect(Event Player.I);
			Event Player.I = 0;
			Play Effect(All Players(All Teams), Heal Target Active Effect, Color(White), Event Player, 1);
			Play Effect(All Players(All Teams), Good Explosion, Color(Purple), Eye Position(Event Player), 1);
			Play Effect(Event Player, Buff Impact Sound, Color(White), Eye Position(Event Player), 200);
			Create Effect(All Players(All Teams), Baptiste Immortality Field Protected Effect, Color(White), Event Player, 1,
				Visible To Position and Radius);
			Event Player.I = Last Created Entity;
			"50% Damage Reduction"
			Set Damage Received(Event Player, 50);
		End;
	}
}

rule("117: Filled with: Kindness")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 117;
	}

	actions
	{
		Event Player.perkColour = Color(Green);
		Event Player.perkName = Custom String("Filled with: Kindness");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Big Message(Event Player, Custom String("Spare them."));
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Create Effect(All Players(All Teams), Ring, Color(Green), Event Player, 10, Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Start Heal Over Time(Event Player, Event Player, 99999, 100);
		Event Player.H = Last Heal Over Time ID;
		While(Event Player.perkActivated == True);
			Play Effect(All Players(All Teams), Heal Target Active Effect, Color(White), Eye Position(Event Player), 10);
			Heal(Players Within Radius(Event Player, 10, All Teams, Off), Event Player, 25);
			Wait(0.250, Ignore Condition);
		End;
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Stop Heal Over Time(Event Player.H);
		Event Player.H = 0;
	}
}

rule("118: Filled with: Justice")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 118;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Filled with: Justice");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Play Effect(Event Player, Explosion Sound, Color(White), Eye Position(Event Player), 200);
		Big Message(Event Player, Custom String("Punish those that are guilty. (Melee)"));
	}
}

rule("118: Filled with: Justice Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 118;
		((Hero Of(Event Player) == Hero(Brigitte) && Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Reinhardt)
			&& Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Vendetta) && Event Ability == Button(Primary Fire))
			|| (Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Hero Of(Event Player) == Hero(
			Hazard) && Event Ability == Button(Ability 1)) || (Hero Of(Event Player) == Hero(Ramattra) && (Event Ability == Button(
			Ability 1) || Event Ability == Button(Ultimate)) && Event Damage >= 50) || (Hero Of(Event Player) == Hero(Torbjörn)
			&& Event Ability == Button(Primary Fire) && Is In Alternate Form(Event Player) == True) || (Hero Of(Event Player) == Hero(
			Venture) && Event Ability == Button(Secondary Fire)) || Event Ability == Button(Melee)) == True;
		Health(Victim) <= Max Health(Victim) * 0.500;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Big Message(Event Player, Custom String("Justice has been served."));
		Big Message(Victim, Custom String("Guilty."));
		Disable Movement Collision With Environment(Victim, True);
		Apply Impulse(Victim, Down, 70, To World, Cancel Contrary Motion);
		Set Environment Credit Player(Victim, Event Player);
		Victim.perkDuration = 0;
		Victim.perkActivated = False;
		Set Status(Victim, Event Player, Hacked, 15);
		Wait(0.750, Ignore Condition);
		Enable Movement Collision With Environment(Victim);
		Kill(Victim, Event Player);
	}
}

rule("119: Duck Hunt")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 119;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Duck Hunt");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Start Accelerating(Filtered Array(All Players(All Teams), Current Array Element != Event Player), Up, 100, 2, To World,
			Direction Rate and Max Speed);
		Start Forcing Throttle(Filtered Array(All Players(All Teams), Current Array Element != Event Player), 1, 1, 0, 0, 0, 0);
		Big Message(All Players(All Teams), Custom String("{0} Duck Hunt", Hero Icon String(Hero(Cassidy))));
		Start Forcing Player To Be Hero(Event Player, Hero(Cassidy));
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, 80);
		Wait Until(Event Player.perkActivated == False || Is Dead(Event Player) == True, 20);
		If(Is Dead(Event Player) == True);
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
		End;
		Wait Until(Is Alive(Event Player), 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Wait(1, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.G);
		Event Player.G = 0;
		Event Player.H = 0;
		Stop Accelerating(All Players(All Teams));
		Stop Forcing Throttle(All Players(All Teams));
	}
}

rule("120: 0.2 Second Domain Expansion: Infinite Void")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 120;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("0.2 Second Void");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 4;
		Event Player.J = Color(Black);
		Event Player.H = 1;
		Event Player.G = Position Of(Event Player);
		Start Forcing Throttle(Event Player, 0, 0, 0, 0, 0, 0);
		Disallow Button(Event Player, Button(Primary Fire));
		Disallow Button(Event Player, Button(Secondary Fire));
		Disallow Button(Event Player, Button(Ability 1));
		Disallow Button(Event Player, Button(Ability 2));
		Disallow Button(Event Player, Button(Ultimate));
		Disallow Button(Event Player, Button(Interact));
		Disallow Button(Event Player, Button(Jump));
		Disallow Button(Event Player, Button(Crouch));
		Disallow Button(Event Player, Button(Melee));
		Disallow Button(Event Player, Button(Reload));
		Create Effect(All Players(All Teams), Sparkles, Color(Purple), Event Player.G, Event Player.H,
			Visible To Position Radius and Color);
		Event Player.K = Last Created Entity;
		Create Effect(All Players(All Teams), Sphere, Event Player.J, Event Player.G, Event Player.H,
			Visible To Position Radius and Color);
		Event Player.I = Last Created Entity;
		Chase Player Variable Over Time(Event Player, H, 25, 0.200, Destination and Duration);
		Event Player.L = 0;
		While(Event Player.L < 4);
			Set Status(Filtered Array(Players Within Radius(Event Player.G, Event Player.H, All Teams, Off),
				Current Array Element != Event Player && Has Status(Current Array Element, Stunned) == False), Event Player, Stunned,
				Event Player.perkDuration);
			Event Player.L += 1;
			Wait(0.050, Ignore Condition);
		End;
		Stop Chasing Player Variable(Event Player, H);
		Event Player.J = Color(White);
		Wait(0.500, Ignore Condition);
		Destroy Effect(Event Player.I);
		Event Player.I = 0;
		Event Player.J = 0;
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Allow Button(Event Player, Button(Ability 1));
		Allow Button(Event Player, Button(Ability 2));
		Allow Button(Event Player, Button(Ultimate));
		Allow Button(Event Player, Button(Interact));
		Allow Button(Event Player, Button(Jump));
		Allow Button(Event Player, Button(Crouch));
		Allow Button(Event Player, Button(Melee));
		Allow Button(Event Player, Button(Reload));
		Stop Forcing Throttle(Event Player);
		Set Move Speed(Event Player, 200);
		Wait Until(Event Player.perkActivated == False, 99999);
		Set Move Speed(Event Player, 100);
		Event Player.H = 0;
		Event Player.G = 0;
		Event Player.L = 0;
		Destroy Effect(Event Player.K);
		Event Player.K = 0;
	}
}

rule("120: 0.2 Second Domain Expansion Melee Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 120;
		((Hero Of(Event Player) == Hero(Brigitte) && Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Reinhardt)
			&& Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Vendetta) && Event Ability == Button(Primary Fire))
			|| (Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Hero Of(Event Player) == Hero(
			Hazard) && Event Ability == Button(Ability 1)) || (Hero Of(Event Player) == Hero(Ramattra) && (Event Ability == Button(
			Ability 1) || Event Ability == Button(Ultimate)) && Event Damage >= 50) || (Hero Of(Event Player) == Hero(Torbjörn)
			&& Event Ability == Button(Primary Fire) && Is In Alternate Form(Event Player) == True) || (Hero Of(Event Player) == Hero(
			Venture) && Event Ability == Button(Secondary Fire)) || Event Ability == Button(Melee)) == True;
		Has Status(Victim, Stunned) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Damage(Victim, Event Player, 160);
	}
}

rule("121: Contained Void")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 121;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("Contained Void");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 8;
		Event Player.H = 1;
		Event Player.G = Position Of(Event Player);
		Create Effect(All Players(All Teams), Sphere, Color(Black), Event Player.G, Event Player.H, Visible To Position and Radius);
		Event Player.I = Last Created Entity;
		Chase Player Variable Over Time(Event Player, H, 25, 1, Destination and Duration);
		Wait(1, Ignore Condition);
		Stop Chasing Player Variable(Event Player, H);
		While(Event Player.perkActivated == True);
			Set Status(Filtered Array(Players Within Radius(Event Player.G, Event Player.H, All Teams, Off),
				Current Array Element != Event Player && Has Status(Current Array Element, Stunned) == False), Event Player, Stunned,
				Event Player.perkDuration);
			Wait(0.250, Ignore Condition);
		End;
		Destroy Effect(Event Player.I);
		Event Player.H = 0;
		Event Player.G = 0;
		Event Player.I = 0;
	}
}

rule("122: Single Use Abilities")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 122;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Single Use Abilities");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
		Event Player.L = 0;
		While(Event Player.perkActivated == True);
			If(Is Firing Primary(Event Player) == True && Event Player.G == 0);
				Event Player.G = 1;
			End;
			If(Is Firing Primary(Event Player) == False && Event Player.G == 1);
				Event Player.G = 2;
				Set Primary Fire Enabled(Event Player, False);
				Small Message(Event Player, Custom String("Can no longer use: Primary Fire"));
			End;
			If(Is Firing Secondary(Event Player) == True && Event Player.H == 0);
				Event Player.H = 1;
			End;
			If(Is Firing Secondary(Event Player) == False && Event Player.H == 1);
				Event Player.H = 2;
				Set Secondary Fire Enabled(Event Player, False);
				Small Message(Event Player, Custom String("Can no longer use: Secondary Fire"));
			End;
			If(Is Using Ability 1(Event Player) == True && Event Player.I == 0);
				Event Player.I = 1;
			End;
			If(Is Using Ability 1(Event Player) == False && Event Player.I == 1);
				Event Player.I = 2;
				Set Ability 1 Enabled(Event Player, False);
				Small Message(Event Player, Custom String("Can no longer use: Ability 1"));
			End;
			If(Is Using Ability 2(Event Player) == True && Event Player.J == 0);
				Event Player.J = 1;
			End;
			If(Is Using Ability 2(Event Player) == False && Event Player.J == 1);
				Event Player.J = 2;
				Set Ability 2 Enabled(Event Player, False);
				Small Message(Event Player, Custom String("Can no longer use: Ability 2"));
			End;
			If(Is Using Ultimate(Event Player) == True && Event Player.K == 0);
				Event Player.K = 1;
			End;
			If(Is Using Ultimate(Event Player) == False && Event Player.K == 1);
				Event Player.K = 2;
				Set Ultimate Ability Enabled(Event Player, False);
				Small Message(Event Player, Custom String("Can no longer use: Ultimate"));
			End;
			If(Is Meleeing(Event Player) == True && Event Player.L == 0);
				Event Player.L = 1;
			End;
			If(Is Meleeing(Event Player) == False && Event Player.L == 1);
				Event Player.L = 2;
				Set Melee Enabled(Event Player, False);
				Small Message(Event Player, Custom String("Can no longer use: Melee"));
			End;
			Wait(0.050, Ignore Condition);
		End;
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Set Ability 1 Enabled(Event Player, True);
		Set Ability 2 Enabled(Event Player, True);
		Set Ultimate Ability Enabled(Event Player, True);
		Set Melee Enabled(Event Player, True);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
		Event Player.L = 0;
	}
}

rule("123: Black Flash")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 123;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Black Flash");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		disabled Event Player.H = 0;
		Wait Until(Event Player.perkActivated == False, 9999);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		disabled Event Player.H = 0;
		Set Move Speed(Event Player, 100);
		Set Damage Received(Event Player, 100);
	}
}

rule("123: Black Flash Melee")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 123;
		((Hero Of(Event Player) == Hero(Brigitte) && Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Reinhardt)
			&& Event Ability == Button(Primary Fire)) || (Hero Of(Event Player) == Hero(Vendetta) && Event Ability == Button(Primary Fire))
			|| (Hero Of(Event Player) == Hero(Doomfist) && Event Ability == Button(Secondary Fire)) || (Hero Of(Event Player) == Hero(
			Hazard) && Event Ability == Button(Ability 1)) || (Hero Of(Event Player) == Hero(Ramattra) && (Event Ability == Button(
			Ability 1) || Event Ability == Button(Ultimate)) && Event Damage >= 50) || (Hero Of(Event Player) == Hero(Torbjörn)
			&& Event Ability == Button(Primary Fire) && Is In Alternate Form(Event Player) == True) || (Hero Of(Event Player) == Hero(
			Venture) && Event Ability == Button(Secondary Fire)) || Event Ability == Button(Melee)) == True;
		disabled Random Integer(1, 3) == 1;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		If(Random Integer(1, Event Player.diceReroll == 123 ? 2 : 3) == 1);
			Event Player.diceReroll = 123;
			disabled Event Player.H = True;
			Destroy Effect(Event Player.G);
			Play Effect(All Players(All Teams), Bad Explosion, Color(Red), Position Of(Victim), 15);
			Play Effect(All Players(All Teams), Bad Explosion, Color(Black), Position Of(Victim), 15);
			Play Effect(All Players(All Teams), Good Explosion, Color(Red), Position Of(Victim), 15);
			Play Effect(All Players(All Teams), Good Explosion, Color(Black), Position Of(Victim), 15);
			Play Effect(All Players(All Teams), Ring Explosion, Color(Red), Position Of(Victim), 15);
			Play Effect(All Players(All Teams), Ring Explosion, Color(Black), Position Of(Victim), 15);
			Play Effect(All Players(All Teams), Ana Biotic Grenade Increased Healing Sound, Color(White), Event Player, 200);
			Play Effect(All Players(All Teams), Ana Biotic Grenade No Healing Sound, Color(White), Event Player, 200);
			Damage(Victim, Event Player, 80);
			Start Damage Over Time(Victim, Event Player, 2, 10);
			Apply Impulse(Victim, Direction From Angles(Horizontal Facing Angle Of(Event Player), -5), 25, To World, Cancel Contrary Motion);
			Create Effect(All Players(All Teams), Baptiste Immortality Field Protected Effect, Color(White), Event Player, 1,
				Visible To Position and Radius);
			Event Player.G = Last Created Entity;
			Event Player.perkDuration += 3;
			Set Move Speed(Event Player, 125);
			Set Damage Received(Event Player, 75);
		End;
		Wait(2, Restart When True);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Set Move Speed(Event Player, 100);
		Set Damage Received(Event Player, 100);
	}
}

rule("124: Cursed Swap")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 124;
	}

	actions
	{
		disabled Wait Until(Event Player.perkActivated == False, 9999);
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Cursed Swap");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 30;
		Big Message(Event Player, Custom String("Press Interact to Swap"));
	}
}

rule("124: Cursed Swap Interact")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 124;
		Is Button Held(Event Player, Button(Interact)) == True;
		Event Player.perkDuration > 0;
		Is Alive(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.G = Player Closest To Reticle(Event Player, All Teams);
		If(Is In Line of Sight(Event Player, Event Player.G, Barriers Do Not Block LOS));
			Event Player.H[0] = Position Of(Event Player);
			Event Player.H[1] = Facing Direction Of(Event Player);
			Event Player.H[2] = Position Of(Event Player.G);
			Event Player.H[3] = Facing Direction Of(Event Player.G);
			Play Effect(All Players(All Teams), Bastion Tank Cannon Explosion Sound, Color(White), Position Of(Event Player), 200);
			Play Effect(All Players(All Teams), Bastion Tank Cannon Explosion Sound, Color(White), Position Of(Event Player.G), 200);
			Play Effect(All Players(All Teams), Bad Pickup Effect, Color(Aqua), Position Of(Event Player), 3);
			Play Effect(All Players(All Teams), Bad Pickup Effect, Color(Aqua), Position Of(Event Player.G), 3);
			Teleport(Event Player, Event Player.H[2]);
			Set Facing(Event Player, Event Player.H[3], To World);
			Teleport(Event Player.G, Event Player.H[0]);
			Set Facing(Event Player.G, Event Player.H[1], To World);
			Set Environment Credit Player(Event Player, Event Player.G);
			Set Environment Credit Player(Event Player.G, Event Player);
			Event Player.perkDuration -= 3;
			If(Event Player.perkDuration < 0);
				Event Player.perkDuration = 0;
			End;
			Event Player.G = 0;
		Else;
			Event Player.G = 0;
		End;
		Event Player.G = 0;
		Event Player.H = 0;
	}
}

rule("125: Cursed Speech")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 125;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Cursed Speech");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 30;
		Event Player.G = 0;
		Event Player.H = False;
		Event Player.I = 0;
		Big Message(Event Player, Custom String("Aim at a player and press Interact."));
		Wait Until(Event Player.perkActivated == False, 9999);
		"Allow Current Command To Finish"
		Wait Until(Event Player.H == False, 99999);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
	}
}

rule("125: Cursed Speech - Command")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 125;
		Event Player.perkActivated == True;
		Is Button Held(Event Player, Button(Interact)) == True;
		Event Player.H != True;
		Is Alive(Event Player) == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		"Find Target"
		Event Player.G = Player Closest To Reticle(Event Player, All Teams);
		Abort If(Event Player.G == Null);
		Abort If(Event Player.G == Event Player);
		Abort If(Is Alive(Event Player.G) == False);
		Abort If(Is In Line of Sight(Event Player, Event Player.G, Barriers Do Not Block LOS) == False);
		"Roll Command"
		Event Player.I = Random Integer(1, 7);
		Event Player.H = True;
		"Default Costs"
		Event Player.J = 40;
		Event Player.K = 8;
		"Freeze!"
		If(Event Player.I == 1);
			Big Message(Array(Event Player, Event Player.G), Custom String("FREEZE!"));
			Play Effect(All Players(All Teams), Ring Explosion, Color(Sky Blue), Event Player.G, 3);
			Play Effect(All Players(All Teams), Ring Explosion Sound, Color(White), Event Player.G, 200);
			Set Status(Event Player.G, Event Player, Frozen, 2);
		"Catch Fire!"
		Else If(Event Player.I == 2);
			Event Player.J = 30;
			Event Player.K = 6;
			Big Message(Array(Event Player, Event Player.G), Custom String("CATCH FIRE!"));
			Play Effect(All Players(All Teams), Bad Explosion, Color(Orange), Event Player.G, 3);
			Set Status(Event Player.G, Event Player, Burning, 3);
			Start Damage Over Time(Event Player.G, Event Player, 3, 12);
		"Fly!"
		Else If(Event Player.I == 3);
			Event Player.J = 25;
			Event Player.K = 5;
			Big Message(Array(Event Player, Event Player.G), Custom String("FLY!"));
			Play Effect(All Players(All Teams), Good Explosion, Color(White), Event Player.G, 4);
			Play Effect(All Players(All Teams), Buff Explosion Sound, Color(White), Event Player.G, 200);
			Apply Impulse(Event Player.G, Up, 28, To World, Cancel Contrary Motion);
		"Hover!"
		Else If(Event Player.I == 4);
			Event Player.J = 15;
			Event Player.K = 3;
			Big Message(Array(Event Player, Event Player.G), Custom String("HOVER!"));
			Play Effect(All Players(All Teams), Good Explosion, Color(Aqua), Event Player.G, 3);
			Set Gravity(Event Player.G, 0);
			Apply Impulse(Event Player.G, Up, 1, To World, Cancel Contrary Motion);
		"Shrink!"
		Else If(Event Player.I == 5);
			Event Player.J = 20;
			Event Player.K = 4;
			Big Message(Array(Event Player, Event Player.G), Custom String("SHRINK!"));
			Play Effect(All Players(All Teams), Bad Explosion, Color(Purple), Event Player.G, 3);
			Start Scaling Player(Event Player.G, 0.500, True);
			Set Damage Received(Event Player.G, 125);
			Start Modifying Hero Voice Lines(Event Player.G, 1.500, True);
		"Grow!"
		Else If(Event Player.I == 6);
			Event Player.J = 25;
			Event Player.K = 5;
			Big Message(Array(Event Player, Event Player.G), Custom String("GROW!"));
			Play Effect(All Players(All Teams), Good Explosion, Color(Purple), Event Player.G, 4);
			Start Scaling Player(Event Player.G, 2, True);
			Set Damage Received(Event Player.G, 50);
			Start Modifying Hero Voice Lines(Event Player.G, 0.500, True);
		"Sleep!"
		Else;
			Event Player.J = 35;
			Event Player.K = 7;
			Big Message(Array(Event Player, Event Player.G), Custom String("SLEEP!"));
			Play Effect(All Players(All Teams), Ring Explosion, Color(Purple), Event Player.G, 3);
			Play Effect(All Players(All Teams), Ring Explosion Sound, Color(White), Event Player.G, 200);
			Set Status(Event Player.G, Event Player, Asleep, 3);
		End;
		"Health Cost"
		Set Player Health(Event Player, Max(1, Health(Event Player) - Event Player.J));
		"Duration Cost"
		Event Player.perkDuration = Max(0, Event Player.perkDuration - Event Player.K);
		"Command Cooldown"
		Wait(4, Ignore Condition);
		"Restore Temporary Effects"
		If(Event Player.I == 4);
			Set Gravity(Event Player.G, 100);
		Else If(Event Player.I == 5 || Event Player.I == 6);
			Stop Scaling Player(Event Player.G);
			Set Damage Received(Event Player.G, 100);
			Stop Modifying Hero Voice Lines(Event Player.G);
		End;
		Event Player.H = False;
		Event Player.G = 0;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
	}
}

rule("126: Double Duration")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 126;
	}

	actions
	{
		Event Player.perkColour = Color(Green);
		Event Player.perkName = Custom String("Double Duration");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Event Player.diceReroll = 126;
		All Players(All Teams).durationModifier *= 2;
		Big Message(All Players(All Teams), Custom String("{0} {1} doubled all perk durations!", Hero Icon String(Hero Of(Event Player)),
			Event Player));
		Wait Until(Event Player.perkActivated == False, 9999);
		Wait Until(Event Player.diceCooldown > 0, 99999);
		Event Player.diceCooldown = 0;
	}
}

rule("127: Halved Duration")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 127;
	}

	actions
	{
		Event Player.perkColour = Color(Lime Green);
		Event Player.perkName = Custom String("Halved Duration");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Event Player.diceReroll = 127;
		All Players(All Teams).durationModifier /= 2;
		Big Message(All Players(All Teams), Custom String("{0} {1} halved all perk durations!", Hero Icon String(Hero Of(Event Player)),
			Event Player));
		Wait Until(Event Player.perkActivated == False, 9999);
		Wait Until(Event Player.diceCooldown > 0, 99999);
		Event Player.diceCooldown = 0;
	}
}

rule("128: Limited Ammo")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 128;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Limited Ammo");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Reload Enabled(Event Player, False);
		Wait Until(Event Player.perkActivated == False, 9999);
		Set Reload Enabled(Event Player, True);
	}
}

rule("129: Gun Jammed")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 129;
	}

	actions
	{
		Event Player.perkColour = Color(Black);
		Event Player.perkName = Custom String("Gun Jammed");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Primary Fire Enabled(Event Player, False);
		Wait Until(Event Player.perkActivated == False, 9999);
		Set Primary Fire Enabled(Event Player, True);
	}
}

rule("130: Anti-Heal")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 130;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("Anti-Heal");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Healing Received(Event Player, 0);
		Create Effect(All Players(All Teams), Ana Biotic Grenade No Healing Effect, Color(White), Event Player, 1,
			Visible To Position and Radius);
		Event Player.G = Last Created Entity;
		Wait Until(Event Player.perkActivated == False, 999999);
		Set Healing Received(Event Player, 100);
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
	}
}

rule("131: Grounded")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 131;
	}

	actions
	{
		Event Player.perkColour = Custom Color(165, 42, 42, 255);
		Event Player.perkName = Custom String("Grounded");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Set Jump Enabled(Event Player, False);
		Wait Until(Event Player.perkActivated == False, 9999);
		Set Jump Enabled(Event Player, True);
	}
}

rule("132: No-Reg")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 132;
	}

	actions
	{
		Event Player.perkColour = Color(Purple);
		Event Player.perkName = Custom String("No-Reg");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		disabled Wait Until(Event Player.perkActivated == False, 999999);
	}
}

rule("132: No-Reg - Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 132;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		If(Random Integer(0, 1) == 0);
			Heal(Victim, Null, Event Damage);
		End;
	}
}

rule("133: Skill Check")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 133;
	}

	actions
	{
		Event Player.perkColour = Color(White);
		Event Player.perkName = Custom String("Skill Check");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = Random Real(0.750, 3);
		Event Player.H = Color(White);
		Event Player.I = 0;
		Event Player.J = 0;
		Create Progress Bar HUD Text(Event Player, Update Every Frame(Event Player.I), Custom String("^Interact^"), Top, 5,
			Update Every Frame(Event Player.H), Update Every Frame(Event Player.H), Visible To Values and Color, Default Visibility);
		Event Player.G = Last Text ID;
		Chase Player Variable Over Time(Event Player, I, 100, Event Player.perkDuration, Destination and Duration);
		While(Event Player.I < 100 && Event Player.J == 0);
			If(Event Player.I >= 40 && Event Player.I <= 60);
				Event Player.H = Color(Red);
			Else;
				Event Player.H = Color(White);
			End;
			If(Is Button Held(Event Player, Button(Interact)) == True);
				If(Event Player.I >= 40 && Event Player.I <= 60);
					Event Player.J = 1;
					Event Player.I = 100;
					Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) + 15);
					Play Effect(Event Player, Buff Impact Sound, Color(Green), Eye Position(Event Player), 200);
					Set Ability Cooldown(Event Player, Button(Secondary Fire), 0);
					Set Ability Cooldown(Event Player, Button(Ability 1), 0);
					Set Ability Cooldown(Event Player, Button(Ability 2), 0);
					Start Heal Over Time(Event Player, Event Player, 1, 75);
					Event Player.diceReroll = 133;
				Else;
					Event Player.J = 2;
					Event Player.I = 100;
					Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) - 15);
					Play Effect(Event Player, Debuff Impact Sound, Color(Green), Eye Position(Event Player), 200);
					Set Status(Event Player, Null, Stunned, 0.600);
					Set Ability Cooldown(Event Player, Button(Secondary Fire), Ability Cooldown(Event Player, Button(Secondary Fire)) + 5);
					Set Ability Cooldown(Event Player, Button(Ability 1), Ability Cooldown(Event Player, Button(Ability 1)) + 5);
					Set Ability Cooldown(Event Player, Button(Ability 2), Ability Cooldown(Event Player, Button(Ability 2)) + 5);
					Damage(Event Player, Null, 75);
				End;
			End;
			Wait(0.050, Ignore Condition);
		End;
		Destroy Progress Bar HUD Text(Event Player.G);
		Stop Chasing Player Variable(Event Player, I);
		If(Event Player.J == 0);
			Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) - 15);
			Play Effect(Event Player, Debuff Impact Sound, Color(Green), Eye Position(Event Player), 200);
			Set Status(Event Player, Null, Stunned, 0.600);
			Set Ability Cooldown(Event Player, Button(Secondary Fire), Ability Cooldown(Event Player, Button(Secondary Fire)) + 5);
			Set Ability Cooldown(Event Player, Button(Ability 1), Ability Cooldown(Event Player, Button(Ability 1)) + 5);
			Set Ability Cooldown(Event Player, Button(Ability 2), Ability Cooldown(Event Player, Button(Ability 2)) + 5);
			Damage(Event Player, Null, 75);
		End;
		"End Skill Check"
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		"Successful Skill Check Cooldown"
		If(Event Player.J == 1);
			Wait Until(Event Player.diceCooldown > 0, 5);
			Event Player.diceCooldown = 1;
		End;
		Event Player.J = 0;
	}
}

rule("134: Kings Demand")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 134;
	}

	actions
	{
		Event Player.perkColour = Color(Red);
		Event Player.perkName = Custom String("Kings Demand");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 18;
		Event Player.G = Filtered Array(All Players(All Teams), Current Array Element != Event Player);
		Start Forcing Throttle(All Players(All Teams), 0, 0, 0, 0, 0, 0);
		Disallow Button(All Players(All Teams), Button(Primary Fire));
		Disallow Button(All Players(All Teams), Button(Secondary Fire));
		Disallow Button(All Players(All Teams), Button(Ability 1));
		Disallow Button(All Players(All Teams), Button(Ability 2));
		Disallow Button(All Players(All Teams), Button(Ultimate));
		Disallow Button(All Players(All Teams), Button(Interact));
		Disallow Button(All Players(All Teams), Button(Jump));
		Disallow Button(All Players(All Teams), Button(Crouch));
		Disallow Button(All Players(All Teams), Button(Melee));
		Disallow Button(All Players(All Teams), Button(Reload));
		Big Message(All Players(All Teams), Custom String("{0} No you dont.", Hero Icon String(Hero Of(Event Player))));
		Wait(2, Ignore Condition);
		Start Camera(All Players(All Teams), World Vector Of(Vector(0, 2, 5), Event Player, Rotation And Translation), Eye Position(
			Event Player), 0);
		Global.kingsDemand = Event Player;
		Big Message(All Players(All Teams), Custom String("{0} I hereby forbid every person in this match", Hero Icon String(Hero Of(
			Event Player))));
		Wait(2, Ignore Condition);
		Start Camera(All Players(All Teams), World Vector Of(Vector(0, 2, 2), Event Player, Rotation And Translation), Eye Position(
			Event Player), 5);
		Big Message(All Players(All Teams), Custom String("{0} from moving until I say the word \"now\".", Hero Icon String(Hero Of(
			Event Player))));
		Wait(2, Ignore Condition);
		Big Message(All Players(All Teams), Custom String("{0} and of course, I'll kill anyone who violates that rule.", Hero Icon String(
			Hero Of(Event Player))));
		Wait(1, Ignore Condition);
		Stop Camera(All Players(All Teams));
		Allow Button(Event Player.G, Button(Primary Fire));
		Allow Button(Event Player.G, Button(Secondary Fire));
		Allow Button(Event Player.G, Button(Ability 1));
		Allow Button(Event Player.G, Button(Ability 2));
		Allow Button(Event Player.G, Button(Ultimate));
		Allow Button(Event Player.G, Button(Interact));
		Allow Button(Event Player.G, Button(Jump));
		Allow Button(Event Player.G, Button(Crouch));
		Allow Button(Event Player.G, Button(Melee));
		Allow Button(Event Player.G, Button(Reload));
		Stop Forcing Throttle(Event Player.G);
		Wait(3, Ignore Condition);
		Big Message(All Players(All Teams), Custom String("{0} Not yet.", Hero Icon String(Hero Of(Event Player))));
		Wait(3, Ignore Condition);
		Big Message(All Players(All Teams), Custom String("{0} Still not yet.", Hero Icon String(Hero Of(Event Player))));
		Wait Until(Event Player.perkActivated == False, 99999);
		Big Message(All Players(All Teams), Custom String("{0} Now.", Hero Icon String(Hero Of(Event Player))));
		Global.kingsDemand = 0;
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Allow Button(Event Player, Button(Ability 1));
		Allow Button(Event Player, Button(Ability 2));
		Allow Button(Event Player, Button(Ultimate));
		Allow Button(Event Player, Button(Interact));
		Allow Button(Event Player, Button(Jump));
		Allow Button(Event Player, Button(Crouch));
		Allow Button(Event Player, Button(Melee));
		Allow Button(Event Player, Button(Reload));
		Stop Forcing Throttle(Event Player);
		Set Ultimate Charge(All Players(All Teams), 100);
		Event Player.G = 0;
	}
}

rule("134: Kings Demand Kill")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Global.kingsDemand != 0;
		Event Player != Global.kingsDemand;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		If(Is Moving(Event Player) || Is Firing Primary(Event Player) || Is Firing Secondary(Event Player) || Is Using Ability 1(
			Event Player) || Is Using Ability 2(Event Player) || Is Meleeing(Event Player) || Is Using Ultimate(Event Player));
			disabled Kill(Event Player, Global.kingsDemand);
			Damage(Event Player, Global.kingsDemand, 100000);
			Teleport(Global.kingsDemand, Position Of(Event Player));
		End;
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("135: Phlog")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 135;
	}

	actions
	{
		Event Player.perkColour = Color(Blue);
		Event Player.perkName = Custom String("Phlog");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 30;
		Event Player.G = 0;
		Event Player.K = 0;
		Event Player.L = 0;
		Create Progress Bar HUD Text(Event Player, Event Player.G / 2.500, Custom String("Mmmph", Round To Integer(Event Player.G, Up)),
			Top, 5, Color(Blue), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		While(Event Player.perkActivated == True);
			If(Event Player.G >= 250 && Event Player.L == 0);
				Event Player.L = 1;
				Play Effect(All Players(All Teams), Good Pickup Effect, Color(Red), Event Player, 1);
				Big Message(Event Player, Custom String("Press Interact to use."));
			End;
			If(Is Button Held(Event Player, Button(Interact)) == True && Event Player.G >= 250 && Is In Air(Event Player) == False && Is Alive(
				Event Player) == True && Event Player.K != True);
				Event Player.K = True;
				Event Player.perkDuration += 15;
				Create Effect(All Players(All Teams), Echo Cloning Effect, Color(Blue), Event Player, 1, Visible To Position and Radius);
				Event Player.I = Last Created Entity;
				Set Damage Dealt(Event Player, 200);
				Set Status(Event Player, Null, Phased Out, 3);
				Cancel Primary Action(Event Player);
				Communicate(Event Player, Emote Up);
			End;
			Wait(0.050, Ignore Condition);
		End;
		Destroy Progress Bar HUD Text(Event Player.H);
		Destroy Effect(Event Player.I);
		Set Damage Dealt(Event Player, 100);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.K = 0;
		Event Player.L = 0;
	}
}

rule("135: Phlog Damage")
{
	event
	{
		Player Dealt Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 135;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.G += Event Damage;
	}
}

rule("135: Phlog Kill")
{
	event
	{
		Player Dealt Final Blow;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 135;
		Event Player.G >= 1200;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Set Status(Victim, Event Player, Burning, 3);
	}
}

rule("136: Solar Flare")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 136;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Solar Flare");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 30;
		Big Message(Event Player, Custom String("Press Interact to Use"));
		Wait Until((Is Alive(Event Player) == True && Is Button Held(Event Player, Button(Interact)) == True) || (
			Event Player.perkActivated == False), 9999);
		Abort If(Event Player.perkActivated == False);
		Event Player.I = True;
		Event Player.perkDuration = 5.275;
		"Text"
		Event Player.J = 0;
		Create In-World Text(All Players(All Teams), Custom String("{0}", Event Player.J[0]), Event Player, 2, Clip Against Surfaces,
			Visible To Position String and Color, Event Player.J[1], Default Visibility);
		Event Player.J[2] = Last Text ID;
		Create In-World Text(Event Player, Custom String("{0}", Event Player.J[0]), Update Every Frame(Eye Position(Event Player)
			+ Facing Direction Of(Event Player) * 3 + Vector(0, 0.750, 0)), 2, Do Not Clip, Visible To Position String and Color,
			Event Player.J[1], Default Visibility);
		Event Player.J[3] = Last Text ID;
		Event Player.J[1] = Color(White);
		Event Player.J[0] = Custom String("S");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("So");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Sol");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Sola");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar ");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar F");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar Fl");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar Fla");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar Flar");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar Flare");
		Wait(0.025, Ignore Condition);
		Event Player.J[0] = Custom String("Solar Flare!");
		Create Effect(All Players(All Teams), Sphere, Color(White), Position Of(Event Player), 25, None);
		Event Player.G = Last Created Entity;
		Event Player.H = Filtered Array(Players Within Radius(Event Player, 25, All Teams, Surfaces And All Barriers),
			Current Array Element != Event Player && Is Alive(Current Array Element) && Array Contains(Players in View Angle(
			Current Array Element, All Teams, 45), Event Player) == True);
		Set Status(Event Player.H, Event Player, Stunned, 9999);
		Set Environment Credit Player(Event Player.H, Event Player);
		Set Move Speed(Event Player.H, 50);
		Start Camera(Event Player.H, Vector(-10000, -10000, -10000), Vector(-10000, -10000, -10000), 0);
		Wait(1, Ignore Condition);
		Clear Status(Event Player.H, Stunned);
		Destroy In-World Text(Event Player.J[2]);
		Destroy In-World Text(Event Player.J[3]);
		Event Player.J = 0;
		Destroy Effect(Event Player.G);
		Event Player.G = 0;
		Wait(2, Ignore Condition);
		Stop Camera(Event Player.H);
		Wait(2, Ignore Condition);
		Set Move Speed(Event Player.H, 100);
		Event Player.H = 0;
		Event Player.I = 0;
	}
}

rule("137: Equalizer")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 137;
	}

	actions
	{
		Event Player.perkColour = Color(Rose);
		Event Player.perkName = Custom String("Equalizer");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 1;
		Event Player.G = Filtered Array(Players Within Radius(Event Player, 15, All Teams, Off),
			Current Array Element != Event Player && Is Alive(Current Array Element) == True);
		Event Player.H = Health(Event Player) / Max Health(Event Player);
		Play Effect(All Players(All Teams), Ring Explosion, Color(Rose), Position Of(Event Player), 15);
		Event Player.I = 0;
		While(Event Player.I < Count Of(Event Player.G));
			Set Player Health(Event Player.G[Event Player.I], Max Health(Event Player.G[Event Player.I]) * Event Player.H);
			Set Ultimate Charge(Event Player.G[Event Player.I], Ultimate Charge Percent(Event Player));
			Event Player.I += 1;
		End;
		Wait Until(Event Player.perkActivated == False, 999999);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
	}
}

rule("138: Soul Link")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 138;
	}

	actions
	{
		Event Player.perkColour = Color(Aqua);
		Event Player.perkName = Custom String("Soul Link");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = Random Value In Array(Filtered Array(All Living Players(All Teams), Current Array Element != Event Player));
		Big Message(Event Player, Custom String("Soul Linked to: {0} {1}", Hero Icon String(Hero Of(Event Player.G)), Event Player.G));
		Wait Until((Event Player.perkActivated == False || Is Dead(Event Player.G)) == True, 999999);
		If(Is Dead(Event Player.G));
			Kill(Event Player, Event Player.G);
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
		End;
		Event Player.G = 0;
	}
}

rule("139: Motion Sickness")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 139;
	}

	actions
	{
		Event Player.perkColour = Custom Color(212, 215, 217, 255);
		Event Player.perkName = Custom String("Motion Sickness");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		While(Event Player.perkActivated == True);
			If(Absolute Value(Vertical Speed Of(Event Player)) >= 15 || Absolute Value(Horizontal Speed Of(Event Player)) >= 15);
				Set Status(Event Player, Null, Stunned, 9999);
				Set Move Speed(Event Player, 25);
				Wait Until(Absolute Value(Vertical Speed Of(Event Player)) < 15 && Absolute Value(Horizontal Speed Of(Event Player)) < 15, 15);
				Wait(1, Ignore Condition);
				Clear Status(Event Player, Stunned);
				Wait(2, Ignore Condition);
				Set Move Speed(Event Player, 100);
			End;
			Wait(0.050, Ignore Condition);
		End;
		Clear Status(Event Player, Stunned);
		Set Move Speed(Event Player, 100);
	}
}

rule("140: Hamon")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 140;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Hamon");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 30;
		Event Player.G = 50;
		Create Progress Bar HUD Text(Event Player, Event Player.G, Custom String("Hamon Energy", Round To Integer(Event Player.G, Up)),
			Top, 5, Color(Yellow), Color(White), Visible To Values and Color, Default Visibility);
		Event Player.H = Last Text ID;
		Wait Until(Event Player.perkActivated == False, 99999);
		Destroy Progress Bar HUD Text(Event Player.H);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Set Move Speed(Event Player, 100);
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Clear Status(Event Player, Hacked);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.K = 0;
	}
}

rule("140: Hamon - Energy and Buffs")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 140;
		Event Player.perkActivated == True;
		Is Alive(Event Player) == True;
	}

	actions
	{
		If(Is Button Held(Event Player, Button(Interact)) == True);
			Set Status(Event Player, Null, Hacked, 0.350);
			Set Primary Fire Enabled(Event Player, False);
			Set Secondary Fire Enabled(Event Player, False);
			Event Player.G += 6;
		Else;
			Set Primary Fire Enabled(Event Player, True);
			Set Secondary Fire Enabled(Event Player, True);
		End;
		Event Player.G -= 1.750;
		If(Event Player.G > 100);
			Event Player.G = 100;
		End;
		If(Event Player.G < 0);
			Event Player.G = 0;
		End;
		If(Event Player.G == 0);
			Set Damage Dealt(Event Player, 100);
			Set Damage Received(Event Player, 100);
			Set Move Speed(Event Player, 100);
		Else If(Event Player.G < 25);
			Set Damage Dealt(Event Player, 110);
			Set Damage Received(Event Player, 95);
			Set Move Speed(Event Player, 100);
			Heal(Event Player, Null, 2.500);
		Else If(Event Player.G < 50);
			Set Damage Dealt(Event Player, 125);
			Set Damage Received(Event Player, 90);
			Set Move Speed(Event Player, 105);
			Heal(Event Player, Null, 5);
		Else If(Event Player.G < 75);
			Set Damage Dealt(Event Player, 140);
			Set Damage Received(Event Player, 80);
			Set Move Speed(Event Player, 110);
			Heal(Event Player, Null, 7.500);
		Else If(Event Player.G < 90);
			Set Damage Dealt(Event Player, 160);
			Set Damage Received(Event Player, 70);
			Set Move Speed(Event Player, 115);
			Heal(Event Player, Null, 10);
		Else;
			Set Damage Dealt(Event Player, 180);
			Set Damage Received(Event Player, 60);
			Set Move Speed(Event Player, 125);
			Heal(Event Player, Null, 15);
		End;
		If(Is Button Held(Event Player, Button(Interact)) == True);
			Set Move Speed(Event Player, 35);
		End;
		Wait(0.250, Ignore Condition);
		Loop If Condition Is True;
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Set Damage Dealt(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Set Move Speed(Event Player, 100);
	}
}

rule("140: Hamon - Death Bubble")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 140;
		Event Player.perkActivated == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Destroy Effect(Global.hamonOrbEffect);
		Global.hamonOrbPosition = Eye Position(Event Player);
		Global.hamonOrbKiller = Attacker;
		Global.hamonOrbActive = True;
		Create Effect(All Players(All Teams), Sphere, Color(Red), Global.hamonOrbPosition, 0.500, Visible To Position and Radius);
		Global.hamonOrbEffect = Last Created Entity;
		Play Effect(All Players(All Teams), Bad Explosion, Color(Red), Global.hamonOrbPosition, 3);
		Big Message(All Players(All Teams), Custom String("This is the last of my Hamon."));
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
	}
}

rule("140: Hamon - Bubble Pickup")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Global.hamonOrbActive == True;
		Is Alive(Event Player) == True;
		Event Player != Global.hamonOrbKiller;
		Distance Between(Event Player, Global.hamonOrbPosition) <= 2;
	}

	actions
	{
		Global.hamonOrbActive = False;
		Destroy Effect(Global.hamonOrbEffect);
		Heal(Event Player, Null, Max Health(Event Player));
		Add Health Pool To Player(Event Player, Health, 150, False, False);
		Event Player.diceCooldown = 0;
		Set Ability Cooldown(Event Player, Button(Secondary Fire), 0);
		Set Ability Cooldown(Event Player, Button(Ability 1), 0);
		Set Ability Cooldown(Event Player, Button(Ability 2), 0);
		Set Ability Cooldown(Event Player, Button(Jump), 0);
		Set Ultimate Charge(Event Player, 100);
		Play Effect(All Players(All Teams), Good Pickup Effect, Color(Yellow), Event Player, 5);
		Big Message(Event Player, Custom String("The last of their Hamon flows through you."));
		Global.hamonOrbPosition = 0;
		Global.hamonOrbKiller = 0;
		Global.hamonOrbEffect = 0;
	}
}

rule("141: Endurance")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 141;
	}

	actions
	{
		Event Player.perkColour = Color(Yellow);
		Event Player.perkName = Custom String("Endurance");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Set Status(Event Player, Null, Unkillable, 9999);
		Wait Until(Health(Event Player) <= 1 || Event Player.perkActivated == False, 999999);
		If(Health(Event Player) <= 1);
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
			Heal(Event Player, Null, Max Health(Event Player) * 0.500);
			Play Effect(Event Player, Buff Impact Sound, Color(White), Eye Position(Event Player), 200);
			Set Status(Event Player, Null, Phased Out, 1);
		End;
		Clear Status(Event Player, Unkillable);
	}
}

rule("142: Camera Lock")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 142;
	}

	actions
	{
		Event Player.perkColour = Color(Gray);
		Event Player.perkName = Custom String("Camera Lock");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = 0;
		Event Player.G[0] = Eye Position(Event Player);
		Event Player.G[1] = Facing Direction Of(Event Player);
		Start Camera(Event Player, Event Player.G[0], Event Player.G[1], 0);
		Wait Until(Event Player.perkActivated == False, 99999);
		Stop Camera(Event Player);
		Event Player.G = 0;
	}
}

rule("143: Auto Counter")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 143;
	}

	actions
	{
		Event Player.perkColour = Color(Lime Green);
		Event Player.perkName = Custom String("Auto Counter");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 15;
		Event Player.G = Random Integer(1, 3);
		disabled Wait(0.100, Ignore Condition);
		If(Event Player.G == 1);
			Event Player.perkName = Custom String("Auto Counter: Offense Type");
			disabled End;
		Else If(Event Player.G == 2);
			Event Player.perkName = Custom String("Auto Counter: Defense Type");
		Else;
			Event Player.perkName = Custom String("Auto Counter: Disruption Type");
		End;
		Wait Until(Event Player.perkActivated == False, 99999);
		Event Player.G = 0;
	}
}

rule("143: Auto Counter - Counter")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 143;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		"Offense Type"
		If(Event Player.G == 1);
			Teleport(Event Player, Ray Cast Hit Position(Position Of(Attacker), Position Of(Attacker) + Direction From Angles(
				Horizontal Facing Angle Of(Attacker), 0) * 3, All Players(All Teams), Attacker, True));
			Teleport(Event Player, Nearest Walkable Position(Event Player));
			Set Facing(Event Player, Direction Towards(Eye Position(Event Player), Eye Position(Attacker)), To World);
			Damage(Attacker, Event Player, 125);
			Apply Impulse(Attacker, Direction From Angles(Horizontal Facing Angle Of(Event Player), -15), 25, To World,
				Cancel Contrary Motion);
			Set Environment Credit Player(Attacker, Event Player);
		End;
		"Defense Type"
		If(Event Player.G == 2);
			Teleport(Event Player, Nearest Walkable Position(Position Of(Event Player) + Direction Towards(Position Of(Attacker), Position Of(
				Event Player)) * 5));
			Clear Status(Event Player, Hacked);
			Clear Status(Event Player, Burning);
			Clear Status(Event Player, Knocked Down);
			Clear Status(Event Player, Asleep);
			Clear Status(Event Player, Frozen);
			Clear Status(Event Player, Rooted);
			Clear Status(Event Player, Stunned);
			Stop All Damage Over Time(Event Player);
			Heal(Event Player, Event Player, Max Health(Event Player) * 1);
			Set Status(Event Player, Null, Phased Out, 1.500);
		End;
		"Disruption Type"
		If(Event Player.G == 3);
			Teleport(Event Player, Ray Cast Hit Position(Position Of(Attacker), Position Of(Attacker) + Direction From Angles(
				Horizontal Facing Angle Of(Attacker), 0) * -5, All Players(All Teams), Attacker, True));
			Teleport(Event Player, Nearest Walkable Position(Event Player));
			Set Facing(Event Player, Direction Towards(Eye Position(Event Player), Eye Position(Attacker)), To World);
			Set Status(Attacker, Event Player, Hacked, 3);
			Set Ultimate Charge(Attacker, Ultimate Charge Percent(Attacker) - 5);
			Set Ability Cooldown(Attacker, Button(Ability 1), Ability Cooldown(Attacker, Button(Ability 1)) + 5);
			Set Ability Cooldown(Attacker, Button(Ability 2), Ability Cooldown(Attacker, Button(Ability 2)) + 5);
			Set Ability Cooldown(Attacker, Button(Secondary Fire), Ability Cooldown(Attacker, Button(Secondary Fire)) + 5);
		End;
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
	}
}

rule("144: Brain Worm")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 144;
	}

	actions
	{
		Event Player.perkColour = Custom Color(242, 174, 177, 255);
		Event Player.perkName = Custom String("Brain Worm");
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.perkDuration = 10;
		Event Player.G = Null;
		Event Player.H = 0;
		"search"
		While(Event Player.diceRoll == 144 && Event Player.perkActivated == True && Event Player.G == Null);
			Event Player.G = Random Value In Array(Filtered Array(All Living Players(All Teams), Current Array Element != Event Player));
			Wait(0.250, Ignore Condition);
		End;
		"no host"
		If(Event Player.G == Null);
			Big Message(Event Player, Custom String("Couldn't find a host!"));
			Event Player.G = 0;
			Event Player.H = 0;
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
			Abort;
		End;
		Big Message(Event Player, Custom String("Brain Worm attached to {0} {1}!", Hero Icon String(Hero Of(Event Player.G)),
			Event Player.G));
		Big Message(Event Player.G, Custom String("Brain Worm attached!"));
		Event Player.H = Ultimate Charge Percent(Event Player);
		Set Environment Credit Player(Event Player, Event Player.G);
		Set Invisible(Event Player, Enemies);
		Set Primary Fire Enabled(Event Player, False);
		Set Secondary Fire Enabled(Event Player, False);
		Set Crouch Enabled(Event Player, False);
		Set Jump Enabled(Event Player, False);
		Set Ability 1 Enabled(Event Player, False);
		Set Ability 2 Enabled(Event Player, False);
		Set Ultimate Ability Enabled(Event Player, False);
		Set Melee Enabled(Event Player, False);
		Set Status(Event Player, Null, Phased Out, 9999);
		While(Event Player.perkActivated == True);
			If(Event Player.G == Null);
				Event Player.perkDuration = 0;
				Event Player.perkActivated = False;
			End;
			If(Is Alive(Event Player.G) == False);
				Event Player.perkDuration = 0;
				Event Player.perkActivated = False;
			End;
			If(Is Button Held(Event Player, Button(Primary Fire)) == True);
				Press Button(Event Player.G, Button(Primary Fire));
			End;
			If(Is Button Held(Event Player, Button(Secondary Fire)) == True);
				Press Button(Event Player.G, Button(Secondary Fire));
			End;
			If(Is Button Held(Event Player, Button(Ability 1)) == True);
				Press Button(Event Player.G, Button(Ability 1));
			End;
			If(Is Button Held(Event Player, Button(Ability 2)) == True);
				Press Button(Event Player.G, Button(Ability 2));
			End;
			If(Is Button Held(Event Player, Button(Crouch)) == True);
				Press Button(Event Player.G, Button(Crouch));
			End;
			If(Is Button Held(Event Player, Button(Melee)) == True);
				Press Button(Event Player.G, Button(Melee));
			End;
			If(Is Button Held(Event Player, Button(Ultimate)) == True);
				Press Button(Event Player.G, Button(Ultimate));
			End;
			If(Is Button Held(Event Player, Button(Interact)) == True);
				Press Button(Event Player.G, Button(Interact));
			End;
			If(Is Button Held(Event Player, Button(Jump)) == True);
				Press Button(Event Player.G, Button(Jump));
			End;
			Attach Players(Event Player, Event Player.G, Vector(0, 1.500, 0));
			Wait(0.016, Ignore Condition);
		End;
		Detach Players(Event Player);
		Set Invisible(Event Player, None);
		Set Primary Fire Enabled(Event Player, True);
		Set Secondary Fire Enabled(Event Player, True);
		Set Crouch Enabled(Event Player, True);
		Set Jump Enabled(Event Player, True);
		Set Ability 1 Enabled(Event Player, True);
		Set Ability 2 Enabled(Event Player, True);
		Set Ultimate Ability Enabled(Event Player, True);
		Set Melee Enabled(Event Player, True);
		Clear Status(Event Player, Phased Out);
		Set Ultimate Charge(Event Player, Event Player.H);
		Event Player.G = 0;
		Event Player.H = 0;
	}
}

rule("145: Spirit Bomb")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 145;
	}

	actions
	{
		Event Player.perkColour = Color(Sky Blue);
		Event Player.perkName = Custom String("Spirit Bomb");
		Abort If(Event Player.isSelectingFavourite == True);
		"Setup"
		Event Player.perkDuration = 75;
		Event Player.G = 0;
		Event Player.H = Empty Array;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
		Event Player.L = 0;
		Event Player.M = 0;
		Event Player.N = Facing Direction Of(Event Player);
		Event Player.O = 0;
		"Opening Cutscene Protection"
		Set Status(Event Player, Null, Invincible, 9999);
		Set Knockback Received(Event Player, 0);
		Set Move Speed(Event Player, 0);
		Disallow Button(Event Player, Button(Primary Fire));
		Disallow Button(Event Player, Button(Secondary Fire));
		Disallow Button(Event Player, Button(Ability 1));
		Disallow Button(Event Player, Button(Ability 2));
		Disallow Button(Event Player, Button(Ultimate));
		Disallow Button(Event Player, Button(Melee));
		Disallow Button(Event Player, Button(Jump));
		Disallow Button(Event Player, Button(Crouch));
		"Create Spirit Bomb Dummy"
		Create Dummy Bot(Hero(Sigma), All Teams, -1, World Vector Of(Vector(1.500, 0, -2), Event Player, Rotation And Translation),
			Facing Direction Of(Event Player));
		Event Player.H[4] = Last Created Entity;
		"Protect Dummy"
		Set Status(Event Player.H[4], Null, Invincible, 9999);
		Set Gravity(Event Player.H[4], 0);
		Set Damage Received(Event Player.H[4], 0);
		Set Knockback Received(Event Player.H[4], 0);
		Set Move Speed(Event Player.H[4], 0);
		"Opening Camera"
		Start Camera(Event Player, Eye Position(Event Player) + Event Player.N * 2.250 + Vector(0, 0.500, 0), Eye Position(Event Player)
			+ Vector(0, 0.250, 0), 0);
		"User Dialogue"
		Create In-World Text(All Players(All Teams), Custom String("Get the Spirit Bomb ready."), Update Every Frame(Eye Position(
			Event Player) + Vector(0, 1, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
		Event Player.H[6] = Last Text ID;
		Wait(1.750, Ignore Condition);
		Destroy In-World Text(Event Player.H[6]);
		Event Player.H[6] = 0;
		"Smooth Pan To Dummy"
		Start Camera(Event Player, Update Every Frame(Eye Position(Event Player.H[4]) + Event Player.N * 2.500 + Vector(0, -1.250, 0)),
			Update Every Frame(Eye Position(Event Player.H[4]) + Vector(0, 1.250, 0)), 5);
		"Dummy Dialogue"
		Create In-World Text(All Players(All Teams), Custom String("Got it!"), Update Every Frame(Eye Position(Event Player.H[4]) + Vector(
			0, 1.500, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
		Event Player.H[6] = Last Text ID;
		Wait(0.850, Ignore Condition);
		Destroy In-World Text(Event Player.H[6]);
		Event Player.H[6] = 0;
		"Dummy Begins Flying"
		Create In-World Text(All Players(All Teams), Custom String("Give me your energy!"), Update Every Frame(Eye Position(
			Event Player.H[4]) + Vector(0, 1.500, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White),
			Default Visibility);
		Event Player.H[6] = Last Text ID;
		Start Accelerating(Event Player.H[4], Up, 40, 6, To World, Direction Rate and Max Speed);
		Wait(1, Ignore Condition);
		Stop Accelerating(Event Player.H[4]);
		"Freeze Dummy In Air"
		Start Forcing Player Position(Event Player.H[4], Position Of(Event Player.H[4]), False);
		Destroy In-World Text(Event Player.H[6]);
		Event Player.H[6] = 0;
		"Create Spirit Bomb"
		Event Player.L = 0.100;
		Event Player.O = Eye Position(Event Player.H[4]) + Vector(0, 7.500, 0);
		Create Effect(All Players(All Teams), Sphere, Color(Sky Blue), Update Every Frame(Event Player.O), Event Player.L,
			Visible To Position and Radius);
		Event Player.H[5] = Last Created Entity;
		"Grow Spirit Bomb"
		Chase Player Variable Over Time(Event Player, L, 6, 0.600, Destination and Duration);
		Wait(0.600, Ignore Condition);
		Stop Chasing Player Variable(Event Player, L);
		Event Player.L = 6;
		"End Opening Cutscene"
		Stop Camera(Event Player);
		Clear Status(Event Player, Invincible);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Allow Button(Event Player, Button(Ability 1));
		Allow Button(Event Player, Button(Ability 2));
		Allow Button(Event Player, Button(Ultimate));
		Allow Button(Event Player, Button(Melee));
		Allow Button(Event Player, Button(Jump));
		Allow Button(Event Player, Button(Crouch));
		Set Move Speed(Event Player, 100);
		"Begin 60 Second Preparation (skipped if ended during opening cutscene)"
		If(Event Player.perkActivated == True && Event Player.diceRoll == 145);
			Event Player.perkDuration = 60;
			Stop Chasing Player Variable(Event Player, perkDuration);
		End;
		"Resolve HUD"
		Create Progress Bar HUD Text(Event Player, Event Player.G, Custom String("Resolve"), Top, 5, Color(Sky Blue), Color(White),
			Visible To Values and Color, Default Visibility);
		Event Player.H[0] = Last Text ID;
		"Guard HUD"
		Create HUD Text(Event Player, Null, Null, Custom String("{0}", Event Player.J > 0 ? Custom String("GUARDING") : (
			Event Player.I <= 0 ? Custom String("GUARD: READY") : Custom String("GUARD: {0}s", Round To Integer(Event Player.I, Up)))),
			Right, 1, Color(White), Color(White), Event Player.J > 0 ? Color(Sky Blue) : (Event Player.I <= 0 ? Color(Green) : Color(
			Gray)), Visible To String and Color, Default Visibility);
		Event Player.H[1] = Last Text ID;
		"Anti-Hiding Target Icon"
		Create Icon(Filtered Array(All Players(All Teams), Current Array Element != Event Player && Is Dummy Bot(Current Array Element)
			== False), Update Every Frame(Eye Position(Event Player) + Vector(0, 1, 0)), Skull, Visible To and Position, Color(Sky Blue),
			False);
		Event Player.H[3] = Last Created Entity;
		"Preparation Defense"
		Set Damage Received(Event Player, 80);
		Set Knockback Received(Event Player, 50);
		"Defense Loop"
		While(Event Player.perkActivated == True && Is Alive(Event Player) == True && Event Player.perkDuration > 0.050 && Event Player.diceRoll == 145);
			"Resolve"
			If(Event Player.G >= 100);
				Event Player.G = 0;
				Heal(Event Player, Null, Max Health(Event Player) * 0.250);
				Stop All Damage Over Time(Event Player);
				Clear Status(Event Player, Hacked);
				Clear Status(Event Player, Burning);
				Clear Status(Event Player, Knocked Down);
				Clear Status(Event Player, Asleep);
				Clear Status(Event Player, Frozen);
				Clear Status(Event Player, Rooted);
				Clear Status(Event Player, Stunned);
				"Resolve Effects"
				Play Effect(All Players(All Teams), Good Explosion, Color(Sky Blue), Event Player, 8);
				Play Effect(All Players(All Teams), Ring Explosion, Color(Sky Blue), Event Player, 10);
				Play Effect(All Players(All Teams), Ring Explosion Sound, Color(White), Event Player, 200);
				Play Effect(All Players(All Teams), Buff Explosion Sound, Color(White), Event Player, 200);
				"Resolve Shockwave"
				Event Player.K = Filtered Array(Players Within Radius(Event Player, 8, All Teams, Surfaces),
					Current Array Element != Event Player && Is Dummy Bot(Current Array Element) == False);
				Apply Impulse(Event Player.K, Up, 8, To World, Cancel Contrary Motion);
				Apply Impulse(Event Player.K, Direction Towards(Event Player, Event Player.K), 35, To World, Cancel Contrary Motion);
				Event Player.K = 0;
			End;
			"Midway Dialogue Start"
			If(Event Player.perkDuration <= 30 && Event Player.M == 0);
				Event Player.M = 1;
				Create In-World Text(All Players(All Teams), Custom String("Come on... hurry it up..."), Update Every Frame(Eye Position(
					Event Player) + Vector(0, 1, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
				Event Player.H[6] = Last Text ID;
			End;
			"Midway Dialogue End"
			If(Event Player.perkDuration <= 27 && Event Player.M == 1);
				Destroy In-World Text(Event Player.H[6]);
				Event Player.H[6] = 0;
				Event Player.M = 2;
			End;
			"Start Guard"
			If(Is Crouching(Event Player) == True && Is Button Held(Event Player, Button(Crouch))
				== True && Event Player.I <= 0 && Event Player.J <= 0);
				Event Player.J = 2;
				"Disable Attacking"
				Cancel Primary Action(Event Player);
				Disallow Button(Event Player, Button(Primary Fire));
				Disallow Button(Event Player, Button(Secondary Fire));
				Disallow Button(Event Player, Button(Ability 1));
				Disallow Button(Event Player, Button(Ability 2));
				Disallow Button(Event Player, Button(Ultimate));
				Disallow Button(Event Player, Button(Melee));
				"Guard Defense"
				Set Move Speed(Event Player, 35);
				Set Damage Received(Event Player, 25);
				Set Knockback Received(Event Player, 0);
				"Guard Visual"
				Create Effect(All Players(All Teams), Baptiste Immortality Field Protected Effect, Color(Sky Blue), Event Player, 1,
					Visible To Position and Radius);
				Event Player.H[2] = Last Created Entity;
			End;
			"Guard Active"
			If(Event Player.J > 0);
				Event Player.J -= 0.050;
				If(Is Crouching(Event Player) == False || Is Button Held(Event Player, Button(Crouch)) == False || Event Player.J <= 0);
					"End Guard"
					Event Player.J = 0;
					Event Player.I = 7;
					Destroy Effect(Event Player.H[2]);
					Event Player.H[2] = 0;
					Allow Button(Event Player, Button(Primary Fire));
					Allow Button(Event Player, Button(Secondary Fire));
					Allow Button(Event Player, Button(Ability 1));
					Allow Button(Event Player, Button(Ability 2));
					Allow Button(Event Player, Button(Ultimate));
					Allow Button(Event Player, Button(Melee));
					Set Move Speed(Event Player, 100);
					Set Damage Received(Event Player, 80);
					Set Knockback Received(Event Player, 50);
					"Guard Release Shockwave Effects"
					Play Effect(All Players(All Teams), Good Explosion, Color(Sky Blue), Event Player, 6);
					Play Effect(All Players(All Teams), Ring Explosion, Color(Sky Blue), Event Player, 7);
					Play Effect(All Players(All Teams), Ring Explosion Sound, Color(White), Event Player, 200);
					Play Effect(All Players(All Teams), Buff Explosion Sound, Color(White), Event Player, 200);
					"Guard Release Shockwave"
					Event Player.K = Filtered Array(Players Within Radius(Event Player, 6, All Teams, Surfaces),
						Current Array Element != Event Player && Is Dummy Bot(Current Array Element) == False);
					Apply Impulse(Event Player.K, Up, 8, To World, Cancel Contrary Motion);
					Apply Impulse(Event Player.K, Direction Towards(Event Player, Event Player.K), 45, To World, Cancel Contrary Motion);
					Event Player.K = 0;
				End;
			End;
			"Guard Cooldown"
			If(Event Player.I > 0 && Event Player.J <= 0);
				Event Player.I -= 0.050;
				If(Event Player.I <= 0);
					Event Player.I = 0;
					Play Effect(Event Player, Buff Impact Sound, Color(White), Eye Position(Event Player), 200);
				End;
			End;
			"Preparation Timer"
			Event Player.perkDuration -= 0.050;
			Wait(0.050, Ignore Condition);
		End;
		"Preparation Failed"
		If(Is Dead(Event Player) == True);
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
			Big Message(Event Player, Custom String("Spirit Bomb preparation failed."));
		"Preparation Complete"
		Else If(Event Player.perkActivated == True && Event Player.perkDuration <= 0.050 && Event Player.diceRoll == 145);
			"Remove Preparation UI"
			Destroy Progress Bar HUD Text(Event Player.H[0]);
			Destroy HUD Text(Event Player.H[1]);
			Destroy Icon(Event Player.H[3]);
			Destroy Effect(Event Player.H[2]);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[0] = 0;
			Event Player.H[1] = 0;
			Event Player.H[2] = 0;
			Event Player.H[3] = 0;
			Event Player.H[6] = 0;
			"Ending Cutscene Protection"
			Stop All Damage Over Time(Event Player);
			Clear Status(Event Player, Hacked);
			Clear Status(Event Player, Burning);
			Clear Status(Event Player, Asleep);
			Clear Status(Event Player, Frozen);
			Clear Status(Event Player, Rooted);
			Clear Status(Event Player, Stunned);
			Clear Status(Event Player, Knocked Down);
			Set Status(Event Player, Null, Invincible, 9999);
			Set Damage Received(Event Player, 0);
			Set Knockback Received(Event Player, 0);
			Set Move Speed(Event Player, 0);
			Disallow Button(Event Player, Button(Primary Fire));
			Disallow Button(Event Player, Button(Secondary Fire));
			Disallow Button(Event Player, Button(Ability 1));
			Disallow Button(Event Player, Button(Ability 2));
			Disallow Button(Event Player, Button(Ultimate));
			Disallow Button(Event Player, Button(Melee));
			Disallow Button(Event Player, Button(Jump));
			Disallow Button(Event Player, Button(Crouch));
			"User Falls"
			Set Status(Event Player, Null, Knocked Down, 9999);
			Event Player.N = Direction From Angles(Horizontal Facing Angle Of(Event Player), 0);
			"Ending Camera On User"
			Start Camera(Event Player, Update Every Frame(Eye Position(Event Player) + Event Player.N * 2.250 + Vector(0, 0.500, 0)),
				Update Every Frame(Eye Position(Event Player) + Vector(0, 0.250, 0)), 0);
			"I'm Counting On You"
			Create In-World Text(All Players(All Teams), Custom String("I'm counting on you..."), Update Every Frame(Eye Position(Event Player)
				+ Vector(0, 1, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
			Event Player.H[6] = Last Text ID;
			Wait(1.250, Ignore Condition);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[6] = 0;
			"Pan To Dummy"
			Start Camera(Event Player, Update Every Frame(Eye Position(Event Player.H[4]) + Event Player.N * 2.500 + Vector(0, -1.250, 0)),
				Update Every Frame(Eye Position(Event Player.H[4]) + Vector(0, 1.250, 0)), 5);
			Wait(0.750, Ignore Condition);
			"Huh"
			Create In-World Text(All Players(All Teams), Custom String("Huh?"), Update Every Frame(Eye Position(Event Player.H[4]) + Vector(0,
				1.500, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
			Event Player.H[6] = Last Text ID;
			Wait(0.600, Ignore Condition);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[6] = 0;
			"Spirit Bomb Final Growth"
			Start Camera(Event Player, Update Every Frame(Eye Position(Event Player.H[4]) + Event Player.N * 3 + Vector(0, -2, 0)),
				Update Every Frame(Eye Position(Event Player.H[4]) + Vector(0, 3, 0)), 5);
			Chase Player Variable Over Time(Event Player, L, 18, 2, Destination and Duration);
			Chase Player Variable Over Time(Event Player, O, Eye Position(Event Player.H[4]) + Vector(0, 19.500, 0), 3,
				Destination and Duration);
			Wait(2, Ignore Condition);
			Stop Chasing Player Variable(Event Player, L);
			Stop Chasing Player Variable(Event Player, O);
			Event Player.L = 18;
			Event Player.O = Eye Position(Event Player.H[4]) + Vector(0, 19.500, 0);
			"There We Go"
			Create In-World Text(All Players(All Teams), Custom String("There we go!"), Update Every Frame(Eye Position(Event Player.H[4])
				+ Vector(0, 1.500, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
			Event Player.H[6] = Last Text ID;
			Wait(0.800, Ignore Condition);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[6] = 0;
			"Pan Back To User"
			Start Camera(Event Player, Update Every Frame(Eye Position(Event Player) + Event Player.N * 2.250 + Vector(0, 0.500, 0)),
				Update Every Frame(Eye Position(Event Player) + Vector(0, 0.250, 0)), 5);
			Wait(0.500, Ignore Condition);
			"Do It"
			Create In-World Text(All Players(All Teams), Custom String("Do it!"), Update Every Frame(Eye Position(Event Player) + Vector(0, 1,
				0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
			Event Player.H[6] = Last Text ID;
			Wait(1, Ignore Condition);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[6] = 0;
			"Pan Back To Dummy"
			Start Camera(Event Player, Update Every Frame(Eye Position(Event Player.H[4]) + Event Player.N * 2.500 + Vector(0, -1.250, 0)),
				Update Every Frame(Eye Position(Event Player.H[4]) + Vector(0, 1.250, 0)), 5);
			Wait(0.500, Ignore Condition);
			"Nice Work"
			Create In-World Text(All Players(All Teams), Custom String("Nice Work {0}!", Event Player), Update Every Frame(Eye Position(
				Event Player.H[4]) + Vector(0, 1.500, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White),
				Default Visibility);
			Event Player.H[6] = Last Text ID;
			Wait(0.800, Ignore Condition);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[6] = 0;
			"Find Impact Target"
			Event Player.K = Filtered Array(All Living Players(All Teams), Current Array Element != Event Player && Is Dummy Bot(
				Current Array Element) == False);
			If(Count Of(Event Player.K) > 0);
				Event Player.K = First Of(Sorted Array(Event Player.K, Distance Between(Current Array Element, Event Player)));
				Event Player.G = Nearest Walkable Position(Position Of(Event Player.K));
			Else;
				Event Player.K = 0;
				Event Player.G = Nearest Walkable Position(Position Of(Event Player) + Facing Direction Of(Event Player) * 5);
			End;
			"Dummy Faces Impact"
			Start Facing(Event Player.H[4], Direction Towards(Eye Position(Event Player.H[4]), Event Player.G), 10000, To World,
				Direction and Turn Rate);
			"GOOOOOO"
			Create In-World Text(All Players(All Teams), Custom String("GOOOOOO!!!"), Update Every Frame(Eye Position(Event Player.H[4])
				+ Vector(0, 1.500, 0)), 2, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
			Event Player.H[6] = Last Text ID;
			"Throw Spirit Bomb"
			Chase Player Variable Over Time(Event Player, O, Event Player.G, 1.500, Destination and Duration);
			Wait(0.450, Ignore Condition);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[6] = 0;
			"Til Then"
			If(Event Player.K != 0);
				Create In-World Text(All Players(All Teams), Custom String("'Til then, {0}.", Event Player.K), Update Every Frame(Eye Position(
					Event Player.H[4]) + Vector(0, 1.500, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White),
					Default Visibility);
			Else;
				Create In-World Text(All Players(All Teams), Custom String("'Til then."), Update Every Frame(Eye Position(Event Player.H[4])
					+ Vector(0, 1.500, 0)), 1.500, Do Not Clip, Visible To Position and String, Color(White), Default Visibility);
			End;
			Event Player.H[6] = Last Text ID;
			Wait(1, Ignore Condition);
			Destroy In-World Text(Event Player.H[6]);
			Event Player.H[6] = 0;
			"Follow Spirit Bomb"
			Start Camera(Event Player, Update Every Frame(Event Player.O + Event Player.N * 5 + Vector(0, 2, 0)), Update Every Frame(
				Event Player.O), 5);
			Wait(0.600, Ignore Condition);
			Stop Chasing Player Variable(Event Player, O);
			Event Player.O = Event Player.G;
			"Spirit Bomb Impact"
			Destroy Effect(Event Player.H[5]);
			Event Player.H[5] = 0;
			Play Effect(All Players(All Teams), Good Explosion, Color(Sky Blue), Event Player.G, 40);
			Play Effect(All Players(All Teams), Bad Explosion, Color(Sky Blue), Event Player.G, 35);
			Play Effect(All Players(All Teams), Ring Explosion, Color(Sky Blue), Event Player.G, 55);
			Play Effect(All Players(All Teams), Ring Explosion, Color(White), Event Player.G, 75);
			Play Effect(All Players(All Teams), Explosion Sound, Color(White), Event Player.G, 200);
			Play Effect(All Players(All Teams), Bastion Tank Cannon Explosion Sound, Color(White), Event Player.G, 200);
			"Spirit Bomb Victims"
			Event Player.K = Filtered Array(Players Within Radius(Event Player.G, 75, All Teams, Off),
				Current Array Element != Event Player && Is Dummy Bot(Current Array Element) == False);
			"Remove Victim Perks"
			Event Player.K.perkDuration = 0;
			Event Player.K.perkActivated = False;
			"Allow Perk Cleanup"
			Wait(0.100, Ignore Condition);
			"Disable Death Perks"
			Event Player.K.diceRoll = 0;
			Stop All Heal Over Time(Event Player.K);
			Stop All Damage Over Time(Event Player.K);
			Clear Status(Event Player.K, Hacked);
			Clear Status(Event Player.K, Burning);
			Clear Status(Event Player.K, Asleep);
			Clear Status(Event Player.K, Frozen);
			Clear Status(Event Player.K, Unkillable);
			Clear Status(Event Player.K, Invincible);
			Clear Status(Event Player.K, Phased Out);
			Clear Status(Event Player.K, Rooted);
			Clear Status(Event Player.K, Stunned);
			Set Damage Received(Event Player.K, 100);
			"Kill Everyone Except Spirit Bomb User"
			Kill(Event Player.K, Event Player);
			Wait(0.100, Ignore Condition);
			"Extended Dice Cooldown"
			disabled Event Player.K.diceCooldown = 30;
			"End Spirit Bomb"
			Event Player.perkDuration = 0;
			Event Player.perkActivated = False;
		End;
		"Cleanup"
		Destroy Progress Bar HUD Text(Event Player.H[0]);
		Destroy HUD Text(Event Player.H[1]);
		Destroy Effect(Event Player.H[2]);
		Destroy Icon(Event Player.H[3]);
		Destroy Effect(Event Player.H[5]);
		Destroy In-World Text(Event Player.H[6]);
		"Remove Dummy"
		Stop Facing(Event Player.H[4]);
		Stop Accelerating(Event Player.H[4]);
		Stop Forcing Player Position(Event Player.H[4]);
		Destroy Dummy Bot(All Teams, Slot Of(Event Player.H[4]));
		"Restore Player"
		Stop Chasing Player Variable(Event Player, L);
		Stop Chasing Player Variable(Event Player, O);
		Stop Camera(Event Player);
		Clear Status(Event Player, Invincible);
		Clear Status(Event Player, Knocked Down);
		Allow Button(Event Player, Button(Primary Fire));
		Allow Button(Event Player, Button(Secondary Fire));
		Allow Button(Event Player, Button(Ability 1));
		Allow Button(Event Player, Button(Ability 2));
		Allow Button(Event Player, Button(Ultimate));
		Allow Button(Event Player, Button(Melee));
		Allow Button(Event Player, Button(Jump));
		Allow Button(Event Player, Button(Crouch));
		Set Move Speed(Event Player, 100);
		Set Damage Received(Event Player, 100);
		Set Knockback Received(Event Player, 100);
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.I = 0;
		Event Player.J = 0;
		Event Player.K = 0;
		Event Player.L = 0;
		Event Player.M = 0;
		Event Player.N = 0;
		Event Player.O = 0;
	}
}

rule("145: Spirit Bomb - Resolve Charge")
{
	event
	{
		Player Took Damage;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 145;
		Event Player.perkActivated == True;
		Event Player.G < 100;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		Event Player.G += Event Damage * 0.500;
		If(Event Player.G > 100);
			Event Player.G = 100;
		End;
	}
}

rule("146: Heat Seaking Meowssile")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 146;
	}

	actions
	{
		Event Player.perkColour = Color(Orange);
		Event Player.perkName = Custom String("Heat Seaking Meowssile");
		Abort If(Event Player.isSelectingFavourite == True);
		"Save Original Hero"
		Event Player.perkDuration = 13;
		Event Player.G = Ultimate Charge Percent(Event Player);
		Event Player.H = Hero Of(Event Player);
		Event Player.J = False;
		Start Forcing Player To Be Hero(Event Player, Hero(Jetpack Cat));
		Disallow Button(Event Player, Button(Primary Fire));
		Set Ability 1 Enabled(Event Player, False);
		Set Ability 2 Enabled(Event Player, False);
		Set Melee Enabled(Event Player, False);
		Disallow Button(Event Player, Button(Ultimate));
		Disallow Button(Event Player, Button(Jump));
		Disallow Button(Event Player, Button(Crouch));
		"Forced Forward Flight"
		Set Move Speed(Event Player, 300);
		Start Forcing Throttle(Event Player, 1, 1, 0, 0, 0, 0);
		"Initial Grace Period"
		Wait(0.750, Ignore Condition);
		"Detect Stopping"
		While(Event Player.perkActivated == True && Event Player.perkDuration > 0 && Is Alive(Event Player)
			== True && Event Player.J == False);
			If(Magnitude Of(Velocity Of(Event Player)) < 10);
				"Explode"
				Event Player.J = True;
				Event Player.K = Position Of(Event Player);
				Play Effect(All Players(All Teams), Bad Explosion, Color(Orange), Event Player.K, 10);
				Play Effect(All Players(All Teams), Good Explosion, Color(Yellow), Event Player.K, 10);
				Play Effect(All Players(All Teams), Ring Explosion, Color(Orange), Event Player.K, 12);
				Play Effect(All Players(All Teams), Explosion Sound, Color(White), Event Player.K, 200);
				Play Effect(All Players(All Teams), Bastion Tank Cannon Explosion Sound, Color(White), Event Player.K, 200);
				"Explosion Damage"
				Damage(Filtered Array(Players Within Radius(Event Player.K, 10, All Teams, Surfaces And All Barriers),
					Current Array Element != Event Player && Is Dummy Bot(Current Array Element) == False), Event Player, 200);
				Event Player.perkDuration = 0;
				Event Player.perkActivated = False;
			End;
			Wait(0.050, Ignore Condition);
		End;
		Stop Forcing Throttle(Event Player);
		Set Move Speed(Event Player, 100);
		Allow Button(Event Player, Button(Primary Fire));
		Set Ability 1 Enabled(Event Player, True);
		Set Ability 2 Enabled(Event Player, True);
		Set Melee Enabled(Event Player, True);
		Allow Button(Event Player, Button(Ultimate));
		Allow Button(Event Player, Button(Jump));
		Allow Button(Event Player, Button(Crouch));
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
		Wait Until(Is Alive(Event Player), 99999);
		Start Forcing Player To Be Hero(Event Player, Event Player.H);
		Stop Forcing Player To Be Hero(Event Player);
		Wait(0.500, Ignore Condition);
		Set Ultimate Charge(Event Player, Event Player.G);
		If(Event Player.J == True);
			Set Player Health(Event Player, 1);
		Else;
			Set Player Health(Event Player, Max Health(Event Player));
		End;
		"Cleanup"
		Event Player.G = 0;
		Event Player.H = 0;
		Event Player.J = 0;
		Event Player.K = 0;
	}
}

rule("146: Heat Seaking Meowssile Dead")
{
	event
	{
		Player Died;
		All;
		All;
	}

	conditions
	{
		Event Player.diceRoll == 146;
		Event Player.perkActivated == True;
	}

	actions
	{
		Abort If(Event Player.isSelectingFavourite == True);
		"Failed Flight"
		Event Player.J = True;
		Event Player.perkDuration = 0;
		Event Player.perkActivated = False;
		"Resurrection"
		Big Message(Event Player, Custom String("Reviving"));
		Teleport(Event Player, Nearest Walkable Position(Event Player));
		Create Effect(All Players(All Teams), Sphere, Color(Yellow), Eye Position(Event Player), 0.500, None);
		Event Player.I = Last Created Entity;
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
		Destroy Effect(Event Player.I);
		Event Player.I = 0;
	}
}