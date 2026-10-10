# Roll The Dice Changelog

This file contains the patch notes for released versions of **Roll The Dice**.

---

# V2.4

## General

- Most perks have been optimised to reduce the total number of rules used by the mode.
- Due to the large number of optimisation changes, some perks may not function in exactly the same way they used to.
- **Please report any unexpected perk behaviour.**
- The internal cooldown for jumping by 5 within the Favourite Perk menu has been decreased.

### Duration Modifier System — New System

*This system allows Double Duration and Halved Duration to affect future perk rolls more consistently.*

- Added a Duration Modifier HUD element.
- Players can now see their current pending duration modifier.
- Several perk wait times have been changed from static waits to dynamic waits.
- This allows perks to better support unexpected duration changes from Double Duration and Halved Duration.
- **Please report any perks that do not correctly work with this new system.**

---

## Map Pool

### Added

- **Black Forest**

### Available

- Eichenwalde
- Ilios Lighthouse
- Ilios Well
- Lijiang Garden
- Nepal Sanctum

### Removed

- Castillo
- Malevento

---

## New Perks

### Endurance

*Restores own health once it reaches 1.*

- If the user drops to 1 HP, the perk is consumed.
- The user is healed for **50% of their Max Health**.
- The user is granted **+1s Phased Out**.

### Camera Lock

- The user's camera is detached from them and locked in place for **10s**.

### Brain Worm

*Take control of another player.*

- Searches for a random living enemy to attach to.
- Once attached, the user becomes invisible, Phased Out and unable to use their own actions.
- While attached, the user can force the host to perform any input they enter, other than the host's camera and movement.

### Auto Counter

*Automatically punishes the next player that damages you.*

When rolled, Auto Counter is randomly assigned one of three types:

- **Auto Counter: Offense Type**
- **Auto Counter: Defense Type**
- **Auto Counter: Disruption Type**

Auto Counter is consumed after successfully triggering.

#### Auto Counter: Offense Type

- Teleports the user in front of the attacker.
- Deals **125 damage** to the attacker.
- Knocks the attacker away.

#### Auto Counter: Defense Type

- Teleports the user away from the attacker.
- Clears several negative statuses from the user.
- Stops all damage-over-time effects on the user.
- Fully heals the user.
- Grants the user **+1.5s Phased Out**.

#### Auto Counter: Disruption Type

- Teleports the user behind the attacker.
- Hacks the attacker for **3s**.
- Adds **+5s** to the attacker's Ability 1, Ability 2 and Secondary Fire cooldowns.
- Removes **5% Ultimate Charge** from the attacker.

### Legendary Warrior

*GRAAAAAAAAAAGH.*

- The user grows larger and gains increased damage, damage resistance, move speed, jump height, knockback resistance and bonus health.
- While active, damaging enemies heals the user and extends the perk duration.
- Final Blows heal the user and extend the perk duration even further.
- The perk duration can be extended up to a maximum of **90s**.
- The user gains **3 Stomp charges**.
- Pressing Crouch while airborne consumes a Stomp charge, slamming the user downward.
- Landing with Stomp knocks nearby enemies down, launches them slightly upward and deals **40 damage**.
- Stomp charges regenerate over time.
- Legendary Warrior clears negative statuses from the user while active.
- Legendary Warrior **cannot be selected as a Favourite Perk**.

---

## Perk Changes

### Filled with: Bravery — Rework

*Refuse to fall.*

*This rework gives Bravery a much stronger and more unique identity, now focusing on last-stand power rather than proximity-based stat buffs.*

- The user becomes stronger and faster as their health gets lower.
- At lower health, the user gains increased damage, move speed, damage resistance and knockback immunity.
- At critical health, the user gains extreme damage, speed, healing received and knockback immunity.

### Double Duration / Halved Duration — Rework

*These perks now have a more consistent impact on perk duration.*

- Double Duration now adds to the player's pending duration modifier.
- Halved Duration now reduces the player's pending duration modifier.
- If a player has no active perk, the duration modifier will apply to their next valid perk.
- Rolling Double Duration or Halved Duration multiple times can stack the duration modifier.
- The modifier is consumed when the player receives a valid non-duration perk.

### Melee Activated Perks — Buff

The following melee-activated perks can now be activated by specific melee-type abilities:

- Black Flash
- 0.2 Second Void
- Berserk
- Filled with: Justice
- One Punch Man
- Strip To Melee

These perks can now be triggered by:

- Brigitte Rocket Flail
- Reinhardt Rocket Hammer
- Vendetta Palatine Fang
- Doomfist Rocket Punch
- Hazard Violent Leap
- Ramattra Pummel — Ability 1 & Ultimate
- Torbjörn Forge Hammer
- Venture Drill Dash
- Universal Melee

### Auto Dodge — New Ability

- Pressing Interact now allows the user to **force dodge** and smoothly move behind their target.

### Black Flash — Buff

- Successfully hitting a Black Flash changes the activation chance from **33%** to **50%**.

### A-Train — Buff

*This change aims to add greater chain-kill potential and strategy to A-Train.*

- Final Blows now add **+5s perk duration** instead of resetting the perk duration to 5s.

### The Horse is Here — Buff

- Removed the **+10s dice cooldown** penalty.

### Filled with: Justice — Buff

*This perk felt like just another instant-kill perk for victims. This change attempts to add more impact to the perk and allow it to stand out.*

- Now removes the guilty player's perk.
- The guilty player is now Hacked for **15s**.

### Filled with: Kindness — Buff

- Healing Aura: **75 HP/s → 100 HP/s**
- User Bonus Healing Aura: **75 HP/s → 100 HP/s**

### Accelerated Ultimate — Buff

- Ultimate charge gain: **20%/s → 40%/s**

### Godmode — Buff

Godmode now protects against:

- Golden Gun
- Yippee
- Kings Demand

### Temporary Ultimate — Buff

- Perk Duration: **15s → 25s**

### Primal Rage — Buff

- **+100% Damage Dealt**

### Flamethrower — Buff

- No longer grants the user an aura.

### Keyboard Spam — Nerf

- Keyboard Spam now also forces Jump, Melee and Crouch inputs.

### Heavenly Restriction — Buff / Rename

- Renamed to **Innate Strength**.
- Now hides the user's outline.

---

## Bug Fixes

- Patched a bug where Ban Hammer would not end after missing Earthshatter.
- Patched a bug that resulted in the Knocked Down effect of Auto Dodge not triggering when the perk ends.
- Many other fixes.