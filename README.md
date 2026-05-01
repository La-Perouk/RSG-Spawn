<img width="2948" height="497" alt="image" src="https://github.com/user-attachments/assets/f4ef4273-587c-4b44-8036-54c50cdef91f" />

Added multiple spawn locations for new players, so they can randomly spawn rather than all of them be on the same spawn location. 

    vector4(-174.6007, 641.3490, 114.0897, 237.8759),    -- Valentine Train Station
    vector4(2724.6819, -1437.5935, 46.0862, 31.9468),    -- Saint Denis Train Station
    vector4(-874.7919, -1337.3678, 43.9783, 84.1052),    -- Blackwater Train Station
    vector4(1237.5671, -1301.8521, 76.9192, 133.9272),   -- Rhodes Train Station 
    vector4(2929.7390, 1270.4764, 44.6728, 253.0386),    -- Annesburg Train Station

Also, added Discord Logs when a new & existing player spawn / despawn from the server. 

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
