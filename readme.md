![ddcz fov](https://github.com/user-attachments/assets/bdca8fb7-a324-4312-bded-b936d70cde9a)
# DODOCZ.NET [FOV] system - FiveM Script


This script is created so that when you get into the vehicle, so that you have a better view around you.
This script only switches between two cameras.
For better explanation - the camera view cannot be zoomed out, you only have two cameras to choose from.

## Controls
• Switching the camera is done with the `V` button.
• If you are sitting in your car and point the gun with the right button, press `V` to zoom in on the camera.
• Each time you press `V` the camera returns to its original position.


## Features

- **Turn off multiple camera views:** This ensures that players can't zoom out the camera to see what the character couldn't see in reality.
- **Lightweight:** Runs efficiently in the background with minimal performance impact.
- **More visibility:** Thanks to this script you have a much better view around you in the vehicle.
- **Standalone:** Easy to integrate with no external dependencies.

## Installation

1. **Download or clone this repository** to your local machine.
2. **Place the `ddcz_fov` folder** into your FiveM server's `resources` directory.
3. **Add the following line** to your `server.cfg` file to ensure the script is loaded:

   ```cfg
   ensure ddcz_fov

How It Works ? 
Here’s a detailed description of how the script works:

Variable Initialization:

ddcz_cam: Reference to the camera.
ddcz_isCameraActive: Flag indicating whether the camera is active.
ddcz_UsePerson: Flag for toggling between first-person and third-person camera modes.
ddcz_justpressed: Count of how many times the control button has been pressed.
ddcz_disable: Time for disabling certain controls.
ddcz_INPUT_AIM: Input ID for activation (can be changed as needed).
Helper Functions:

ddcz_clamp(value, min, max): Clamps a value between min and max.
Function ddcz_setupCamera():

Creates and sets up the camera.
The camera is attached to a specific bone of the character (typically the head) and initial field of view (FOV) and rotation settings are applied.
Starts a loop that continually adjusts the camera’s rotation based on player input (mouse or analog stick).
If the player exits the vehicle or changes the camera mode, the camera is deactivated and destroyed.
Main Loop for FPS Camera Control:

Monitors for presses and releases of the control button (ddcz_INPUT_AIM).
If the button is pressed, it increments ddcz_justpressed.
If the button is released and the count of presses is less than 15, it sets ddcz_UsePerson to true.
If ddcz_UsePerson is active, it toggles between first-person and third-person camera modes.
Main Loop for Detecting Player Status and Camera Activation/Deactivation:

Monitors the character's status to determine if they are in a vehicle and if the camera is in first-person mode.
Activates the camera if the character is in a vehicle and in first-person mode, and deactivates it if the character exits the vehicle.
This script provides a customized first-person camera experience while driving and ensures that the camera and controls are properly managed based on player inputs and the character's status.



License
This project is licensed under the MIT License. You are free to use, modify, and distribute this script as long as you comply with the terms of the license.

Contact
For questions or issues, please use the GitHub issue tracker or contact me at dodocz.net@gmail.com.
