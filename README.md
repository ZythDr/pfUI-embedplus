## pfUI-EmbedPlus

### Overview  
pfUI-EmbedPlus enhances the pfUI "dock" feature with combat-based visibility controls.

### Features 
- **Combat Toggle**: Show/hide damage meters when entering/leaving combat
- **Combat Start**: Optionally display meters when entering combat
- **Combat Exit**: Optionally hide meters when leaving combat
- **Configurable Delay**: Set a custom delay before hiding meters after combat
- **Login Visibility Fix**: Ensures correct display state on login/reload  
<img src="https://github.com/user-attachments/assets/a4e7e8f6-87bd-49ac-b1e9-558a7801cd32" float="right" align="right" width="270" >  

> I experienced some strange behavior with my DPS meter where reloading while the meter was showing and pfUI set to not display meters by default caused the damage meter window to appear undocked on login  

### Configuration  
All settings are found in pfUI:
- Open pfUI configuration `/pfui`
- Navigate to `Thirdparty` → `Embed Plus`

### Requirements  
- [pfUI](https://github.com/shagu/pfUI)

### Credit
- [**Shagu**](https://github.com/shagu) for providing details which helped me achieve what I needed with this plugin, and for creating [pfUI](https://github.com/shagu/pfUI) to begin with!
- [**Mr_Rosh**](https://github.com/mrrosh)'s [pfUI-WeakIcons](https://github.com/mrrosh/pfUI-WeakIcons) & [pfUI-ElitePlayerFrame](https://github.com/mrrosh/pfUI-ElitePlayerFrame) for inspiration and better understanding on how to integrate my plugin into pfUI's GUI
- [**Lexiebean**](https://github.com/Lexiebean)'s [pfUI-pvpoverlay](https://github.com/Lexiebean/pfUI-pvpoverlay) for inspiration and better understanding on how to integrate my plugin into pfUI's GUI

---

Created by Peachoo @ Nordanaar - Turtle WoW 
> Actually made using AI Chatbots, primarily Claude 3.7 through Github Copilot
