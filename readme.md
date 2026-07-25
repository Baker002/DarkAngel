# DarkAngel for Wrath of the Lich King `3.3.5`

![GitHub last commit](https://img.shields.io/github/last-commit/Baker002/DarkAngel)

DarkAngel provides tools for guild and raid management, loot distribution, EPGP/DKP awarding, logging, bulk operations, and other guild utilities.

The addon consists of independent modules that can be used separately or together as a complete guild management suite.

<p align="center"><img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_main.webp" alt="DarkAngel Preview"></p>

[Join my Discord :)](https://discord.gg/wTBNRZcTqv)

---

# Modules Overview

* Core / Guild tools: `DarkAngel`
* Raid Time Inviter: `DarkAngel_Inviter`
* Flask Dispenser: `DarkAngel_Dispenser`
* Raid / Award tool: `DarkAngel_Awarder`
* Loot Distribution: `DarkAngel_BidTracker`
* Guild Logging: `DarkAngel_Logger`
* Guild Data Backup: `DarkAngel_Backup`

---

# Core — DarkAngel

Provides the base infrastructure, shared API, UI components, and main guild management tools.

<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guild.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guild.webp" width="650">
  </a>
</p>

### Guild Browser

Admin-style guild management panel with advanced search, sorting, filtering, and bulk operations.

* Search: name, level, rank, notes/officer notes, last online, class.
* Sorting: any column, custom EPGP/DKP/PR/Total/Net/Hrs values, main/alt grouping, online/offline grouping, reverse order.
* Filters: mains/alts, frozen players, unlinked characters, duplicate alts, link errors, former guild members.
* Bulk actions: notes, officer notes, ranks, EP/GP/DKP adjustments, mass kick, alt relinking.
* Inline editing with similar value highlighting.
* Lua RegExp support, with math operators for level/rank searches (`>15`, `<80`, `>70<79`).

### GM View

<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guildControl.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_guildControl.webp" width="550">
  </a>
</p>

Guild structure management panel.

* Visual rank hierarchy with permissions.
* Create, copy, move, and reorganize ranks in planning mode.
* Move players between ranks before applying changes.
* Import/export configurations.
* Log integration.
* Apply changes in a single action with automatic backup.

### Other Core Features

* Local player linking without requiring guild invitation.
* EPGP/DKP system support.

---

# DarkAngel_Inviter

<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_inviter.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_inviter.webp" width="550">
  </a>
</p>

Automation for guild raid gathering and invitations.

* Keyword-based auto invite.
* Raid announcements via guild chat, whispers, and LFG/global channels.
* Secret phrase support for public channels.
* Automatic stop by timer or specific time.
* Discord link auto-send on request.
* Bulk invites from:

  * online level 80 members
  * Awarder raid snapshots
  * Guild Browser results
  * search results
  * manually selected players
* Raid settings: loot method and difficulty.

---

# DarkAngel_Dispenser

<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_dispenser.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_dispenser.webp" width="300">
  </a>
</p>

Automatic raid consumable distribution.

* Role detection: tank, healer, melee, ranged.
* Automatic distribution of food, flasks, and potions.
* Up to 5 items per role.
* Preset package system.
* Guild verification.
* Pickup tracking.
* Awarder integration for received items.

---

# DarkAngel_Awarder

Raid browser and EPGP/DKP award system.

### Raid Management

* Raid display with groups 1–8.
* Class colors and status indicators (ready check, RL/assist, Master Looter, MT/OT).
* Drag & drop player and group management.

### Player Status Tracking

Visual indicators for:

* normal players
* external links
* invalid links
* new players
* frozen EPGP/DKP characters
* raid duplicates

### Player Information

Shift-hover details:

* EP/GP/PR/DKP
* notes
* mains/alts
* local links
* raid presence history

### Raid Rewards

* Raid snapshots with offline representation.
* Wowhead raid export.
* Flexible EPGP/DKP reward criteria.
* Automatic/manual checkbox assignment.
* Batch awards with reward breakdown messages.

Conditional rewards based on:

* raid participation
* role
* class/spec
* raid leader
* combat logs (Scada integration)

Supports both positive and negative rewards.

### Whisper Commands

* Check EPGP/DKP points.
* Link to main character.
* Create local links without joining the guild.

### Raid Operations

Right-click actions:

* MT/OT, ML, Assist.
* Kick players.
* MS Change loot priority (BidTracker integration).

---

# DarkAngel_BidTracker

EP-Auc / DKP-based loot auction system.

<p align="left">
  <a href="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_bid.webp">
    <img src="https://github.com/Baker002/DarkAngel-images/blob/main/doc_images/preview_bid.webp" width="550">
  </a>
</p>

* Item auction announcements.
* Raid chat bid tracking.
* EP/DKP validation.
* Class/spec restriction checks.
* Configurable bid progression.
* "All in" bids.
* MS Change loot priority system.
* Automatic winner trade and EP/DKP deduction.

---

# DarkAngel_Logger

Guild-wide change tracking system.

Logs:

* notes and officer notes
* EPGP/DKP transactions
* alt linking/relinking
* decay and value anomalies
* rank changes
* joins, leaves, and returns
* MOTD / Guild Info / GM changes

Features:

* Visual change comparison.
* EPGP/DKP logic recognition.
* Suspicious activity detection.
* Full player history after leaving guild.
* Detailed player history view.

---

# DarkAngel_Backup

Guild backup and restoration system.

* Manual and automatic backups.
* Configurable backup frequency.
* Retention of last N backups.
* Selectable data:

  * notes
  * officer notes
  * ranks
  * MOTD / Guild Info / GM system
  * local links
* Storage:

  * SavedVariables
  * per-character storage

### Restore

* Selective restore by data type.
* Existing data skip rules.
* Full GM restore.
* Rank system restoration.
* Passive restore mode for players joining another guild.
