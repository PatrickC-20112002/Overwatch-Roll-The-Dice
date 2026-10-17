# 🎲 Roll The Dice

**Roll The Dice (RTD)** is a custom **Overwatch Workshop Deathmatch / Free-For-All** mode. Press **Interact** to roll the dice and receive one of **157 random perks** that might help you, hurt you, or completely change how you play.

Inspired by the *Team Fortress 2* Roll the Dice server plugin, RTD combines unpredictable stat changes with custom abilities, hero transformations, unusual challenges and spectacular attacks.

## Current Release

| | |
| --- | --- |
| **Stable Version** | **V2.5** |
| **Available Perks** | **157** |
| **Game Mode** | **Deathmatch / Free-For-All (FFA)** |
| **V2.5 Workshop Import Code** | **`REPLACE_WITH_V2_5_CODE`** |
| **Previous Version** | V2.4 (`4C92C`) |

> **Release setup:** Replace `REPLACE_WITH_V2_5_CODE` with the published V2.5 Overwatch Workshop code before releasing this README. `4C92C` is the previous V2.4 code, **not** a verified V2.5 code.

## How to Play

1. Open **Overwatch** and create a **Custom Game**.
2. Open the Custom Game settings and select **Import Code**.
3. Enter the **V2.5 Workshop Import Code** shown above, once published.
4. Start a Deathmatch match.
5. Press **Interact** to roll the dice.
6. Play with your random perk until it expires or ends. After the Dice Cooldown, you can roll again.

Each perk is different. Some give powerful buffs, some impose handicaps, and others introduce their own inputs, objectives or interactions with other players.

## What's New in V2.5?

- **157 total perks**, up from 145 in V2.4.
- New abilities and challenges, including **Soul Punisher**, **Devil's Bullet**, **Psychokinesis**, **Weeping Angel**, **Hot Potato**, **Poisoned** and **Alien Invasion**.
- **Spirit Bomb** replaces **Legendary Warrior**, and **Cursed Speech** replaces **Innate Strength**.
- Major reworks for **Sorcerer's Jackpot**, **Soul Link**, **Equalizer** and **Grounded**.
- Reworked **Favourite Perks**, with a higher default roll chance and new **Rare Favourite Perks**.
- A custom **Soul Score** counter, HUD improvements, bug fixes and Workshop optimisations.
- Updated map pool.

Read the [full V2.5 patch notes](CHANGELOG.md#v25) for all gameplay changes and exact stats.

## Features

- **157 perks** ranging from straightforward buffs and debuffs to elaborate custom mechanics.
- **Deathmatch-first gameplay**, with random rolls and a Dice Cooldown between perks.
- **Favourite Perks** with adjustable roll probability and rarer choices for particularly impactful perks.
- **Duration Modifiers** that can carry over and stack for eligible future perks.
- **Soul Score**, a custom Final Blow counter used by certain perks.
- Custom on-screen information, progress bars, announcements and visual effects.
- Hero transformations, custom abilities and interactions between different perks.

### Example Perks

| Perk | What It Does |
| --- | --- |
| **Spirit Bomb (145)** | Survive the preparation phase to unleash a massive finishing attack. |
| **Soul Punisher (152)** | Fire a rainbow energy blast whose damage scales with each target's Soul Score. |
| **Devil's Bullet (153)** | Fire six piercing shots before the Devil chooses the seventh shot's victim. |
| **Psychokinesis (154)** | Lift a weakened opponent and trigger a devastating area explosion. |
| **Hot Potato (151)** | Pass a lethal countdown to another player with melee attacks. |
| **Weeping Angel (149)** | Move and attack as long as nobody is watching you. |
| **Sorcerer's Jackpot (102)** | Gamble for an extended, powerful Jackpot. |
| **Alien Invasion (157)** | Temporarily turn eligible players into Junos with unlimited ultimates. |

Many other perks, including **GodMode**, **Noclip**, **One Punch Man**, **Black Flash** and **Cursed Swap**, are also part of RTD.

## Favourite Perks

Players can select a Favourite Perk before entering the match and may change it through the Favourite Perk interface.

- The default chance of receiving a normal Favourite Perk is **1 in 5**.
- **Rare Favourite Perks** can also be selected but have **half the usual chance** (default **1 in 10**).
- The menu displays a perk's Favourite roll chance, with Rare Favourite Perks highlighted in orange.
- The default probability can be adjusted using the mode's Workshop settings.
- The Favourite Perk system can be disabled through Workshop settings.

## Duration Modifiers and Soul Score

**Double Duration (126)** and **Halved Duration (127)** modify the duration of eligible future perks. Modifiers can stack, and pending modifiers appear on the HUD. **Ban Hammer (46)** and **Spirit Bomb (145)** are exempt, so the modifiers remain pending for the next eligible perk.

**Soul Score** tracks Final Blows independently from Overwatch's Deathmatch scoreboard. It appears in RTD's HUD and is used to determine the damage taken from **Soul Punisher (152)**.

## Source Code and Development

The game mode is built with the **Overwatch Workshop**. Its source code is maintained in [`src/RollTheDice.opy`](src/RollTheDice.opy).

| Branch | Purpose |
| --- | --- |
| [`main`](../../tree/main) | Stable public releases. |
| [`dev`](../../tree/dev) | Development and testing for future updates. |

New features are developed and tested on `dev` before being released to `main`. Earlier versions are preserved in Git history.

For release history, see [`CHANGELOG.md`](CHANGELOG.md). Issues and unexpected perk behaviour can be reported through the [GitHub issue tracker](../../issues).

## Previous Releases

- **V2.5:** Current release, 157 perks. See the [V2.5 changelog](CHANGELOG.md#v25).
- **V2.4:** 145 perks, Workshop code `4C92C`. See the [V2.4 changelog](CHANGELOG.md#v24).
- **V2.3.0**, **V2.2.7** and **V2.2.6:** Preserved in repository history.
- Legacy and Celebration Edition versions are also preserved in Git history.

## Credits and Disclaimer

**Created by Patrick Carroll / MarkedDerp.**

RTD is an independent, unofficial fan-made Overwatch Workshop project inspired by the *Team Fortress 2* Roll the Dice plugin.

Overwatch and related characters, names and assets belong to Blizzard Entertainment. This project is not affiliated with or endorsed by Blizzard Entertainment.
