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

How It Works
The script continuously monitors for the P key press (control ID 199) and disables the associated action that normally opens the map. By doing this, it ensures that pressing P will no longer bring up the map interface.

License
This project is licensed under the MIT License. You are free to use, modify, and distribute this script as long as you comply with the terms of the license.

Contact
For questions or issues, please use the GitHub issue tracker or contact me at dodocz.net@gmail.com.
