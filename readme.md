# DarkAngel for Wrath of the Lich King `3.3.5`
![GitHub last commit](https://img.shields.io/github/last-commit/Baker002/DarkAngel)

![DarkAngel Preview](https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_main.webp)

DarkAngel provides tools for guild management, raids, loot distribution, EPGP/DKP tracking, logging, and various automations.

The system is built from independent modules that can be used either together or partially.

---

# Modules Overview
- Core / Guild tools: `DarkAngel`
- Raid Time Inviter: `DarkAngel_Inviter`
- Flask Dispenser: `DarkAngel_Dispenser`
- Raid / Award tool: `DarkAngel_Awarder`
- Loot Distribution: `DarkAngel_BidTracker`
- Guild Logging: `DarkAngel_Logger`
- Guild Data Backup: `DarkAngel_Backup`

---

# Core — DarkAngel
The core module provides the base infrastructure, shared API, and common UI components for all addon modules.

### Functionally, the module adds:
- Guild browser (search, sorting, templates)
- Local linking system — ability to link a player without inviting them to the guild (main functionality is tied to the Awarder module)
- EPGP/DKP system support
- General guild utilities for both targeted and mass operations
- Guild GM View

### Guild Browser (Guild Viewer)
<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guild.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guild.webp" width="650">
  </a>
</p>

A full-featured guild browser with the following capabilities:
- Search by:
  - character name
  - level (`>15`, `<80`, `>70<79`)
  - rank (supports mathematical rank ID search as in “level”, and rank name search)
  - notes / officer notes
  - last online
  - class (via dropdown next to the “name” column)

- Sorting:
  - by any column
  - custom sorting (EPGP, DKP, PR, Total/Net/Hrs)
  - main + alt grouping sorted by lowest online time
  - reverse sorting
  - separate online/offline grouping

- Filters:
  - mains / alts only
  - (EPGP) “frozen” players
  - unlinked players
  - link errors / “duplicate alts”
  - links to players who have left the guild

- Bulk operations:
  - mass note / officer note changes
  - rank changes
  - EP/GP/DKP adjustments
  - mass kick
  - relinking alts between mains

- Inline editing:
  - rank / note editing
  - highlighting similar values

### GM View
<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guildControl.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guildControl.webp" width="550">
  </a>
</p>

Guild structure management admin panel:
(available to any guild member, but only the GM can apply changes)

- visual rank schema:
  - permissions per rank
  - create / copy / move ranks anywhere (planning mode)
  - move players between ranks (planning mode)
  - all ranks and permissions on a single page
- export / import configurations
- integration with the Log module
- apply changes in a single action
- automatic backup before applying changes

---

# DarkAngel_Inviter
<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_inviter.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_inviter.webp" width="550">
  </a>
</p>

Automation for guild raid time gatherings.

### Features:
- auto-invite via keyword (default: "+")
- auto raid announcements in guild chat
- works via:
  - guild chat
  - whisper
  - LFG / global channels
    - uses a “secret phrase”
- auto-stop via timer
  - timer in minutes
  - specific stop time
- Discord link auto-send on request
- bulk invite:
  - online level 80 guild members
  - raid snapshot from Awarder
  - players from Guild Browser
  - all matching search results
  - selected via Ctrl/Shift
- raid settings:
  - loot method
  - difficulty

---

# DarkAngel_Dispenser
<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_dispenser.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_dispenser.webp" width="300">
  </a>
</p>

Automatic consumables distribution in raids.

### Features:
- player role detection:
  - tank / healer / melee / ranged
- automatic item distribution:
  - food
  - flasks
  - potions
- up to 5 items per role
- preset pack system
- guild membership verification
- item pickup tracking
- tracking who already received items: integrated with Awarder module

---

# DarkAngel_Awarder
Raid browser and EPGP/DKP award system.

### Features:

#### Raid UI
- raid display (groups 1–8)
- class colors
- status indicators (ready check, RL / assist, Master Looter, Main Tank / Off Tank)
- drag & drop player/group management
- conditional color coding of players:
  - ⬜ Normal — everything is OK (no issues detected)
  - 🟩 External link — not in guild, but locally linked to a guild main
    - such players can receive raid rewards or participate in loot rolls in BidTracker
  - 🟥 Bad — player is not in guild OR incorrectly linked OR linked to a leaver
  - 🟨 New player — joined guild, but has 0 EPGP/DKP
  - 🟦 Frozen (EPGP/DKP only) — character or main is frozen
  - 🟪 Raid duplicate — player already present in raid on another character

#### Player info (Shift hover)
- EP/GP/PR/DKP
- notes
- alts / mains
- local links
- multiple raid presence check

#### Raid snapshots
- raid composition saving
- offline raid representation
- export to Wowhead raid preview

#### EPGP/DKP system
- flexible award criteria:
  - raid participation
  - role (tank/heal/dps)
  - class / build
  - raid leader
  - custom log-based rewards (e.g. top DPS of the raid via Scada logs)
- automatic and manual checkbox assignment
- batch awards
- chat messages with reward breakdown

#### Raid operations on RightClick
- assign MT/OT / ML / Assist
- kick players
- whisper commands (secure actions) — must be enabled in settings
  - check your EPGP/DKP points
  - link to a main character
  - link to a main without joining the guild (local link)

---

# DarkAngel_BidTracker
Auction system for EP-Auction / DKP.

### Features:
- item auction announcement
- bid tracking in raid chat
- validation of EP/DKP availability
- warnings for incorrect class/spec
- configurable bid progression system
- auction conclusion:
  - automatic trade to winner
  - item distribution from loot
- automatic EP/DKP deduction

---

# DarkAngel_Logger
Guild-wide change logging module.

### Logs:
- note changes
- officer note changes
  - EPGP/DKP transactions
  - alt linking / relinking
  - decay and value anomalies
  - change reason detection (loot, slack, decay, raid award, manual)
- rank changes
- guild joins, leaves, and returns
- MOTD / Guild Info / GM rank changes

### Features:
- color diff (positional + semantic)
- EPGP/DKP logic recognition
- cheating detection (both explicit and hidden under EPGP decay systems)
- full player history even after leaving guild
- per-player detailed view

---

# DarkAngel_Backup
Guild backup system.

### Features:
- manual and automatic backups
- configurable backup frequency
- retention of last N backups
- selectable data:
  - notes
  - officer notes
  - ranks
  - MOTD / Guild Info / GM system
  - local links
- storage options:
  - SavedVariables
  - per-character storage

### Restore:
- selective restore (by data type)
- skip rules (if data already exists)
- full restore (GM only)
- rank system restoration
- passive restore mode for players joining the guild
  - useful for transferring players between guilds