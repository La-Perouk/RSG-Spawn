<img width="2948" height="497" alt="image" src="https://github.com/user-attachments/assets/f4ef4273-587c-4b44-8036-54c50cdef91f" />

Added multiple spawn locations for new players, so they can randomly spawn rather than all of them be on the same spawn location. 

🌅 rsg-spawn

Spawn/respawn flow for RedM servers using RSG Core.

Simple, fast, and polished spawn pipeline for both new and existing players.

Displays localized loading info, applies saved appearance, places the player at a configured spawn, and triggers RSGCore lifecycle events.

🛠️ Dependencies

- rsg-core 🤠
- ox_lib ⚙️ (locales & UI helpers)
- rsg-appearance 💅 (apply saved skin on spawn)
- rsg-weapons 🔫 (optional auto dual‑wield)
- weathersync 🌦️ (optional, toggled on existing player flow)
- Locales: locales/en.json, fr.json, el.json (loaded via lib.locale()).
- Config: config.lua for spawn location, tips, and auto dual‑wield.

✨ Features

🧭 Two Spawn Flows

- Existing Player
- Fades screen, shows Citizen ID and localized loading message (+ random tip).
- Restores last known position and heading from PlayerData.position.
-Optional Auto Dual‑Wield via rsg-weapons (configurable).

Triggers:

- RSGCore:Server:OnPlayerLoaded
 RSGCore:Client:OnPlayerLoaded

New Player

- Applies saved skin with exports['rsg-appearance']:ApplySkin().
- Teleports to Config.SpawnLocation (default: Valentine Station).
- Executes /revive, fades in, and triggers RSGCore load events.

💎 Credits

Original RSG adaptation by Rexshack Gaming

License: GPL‑3.0

RexShack - https://github.com/Rexshack-RedM/rsg-core
