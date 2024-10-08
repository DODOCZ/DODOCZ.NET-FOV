![ddcz fov](https://github.com/user-attachments/assets/bdca8fb7-a324-4312-bded-b936d70cde9a)
# FOV SYSTEM

**FOV SYSTEM** is a comprehensive script for adjusting the Field of View (FOV) in your game, impacting both on-foot and vehicle modes. This system enhances your gameplay experience by allowing precise control over the camera's perspective, including the ability to disable certain controls when the player is armed.

## Features

- **Adjustable Camera Offsets**: Customize the camera's X, Y, and Z offsets to fine-tune your view.
- **Configurable Field of View (FOV)**: Set and adjust the FOV for a more immersive experience both on-foot and inside vehicles.
- **Control Over Camera Height**: Adjust the camera height to better align with your desired view.
- **Automatic Camera Leveling**: Automatically levels the camera when activated, enhancing stability.
- **Head Bobbing**: Enable head bobbing for a realistic movement effect.
- **Control Disabling**: Temporarily disable specific controls when the player is armed, preventing unintended actions.

## Installation

1. **Add the Script to Your Resources**

   Place the script file in your `resources` folder. For example, if your script is named `ddcz_fov_system`, it should be placed in `resources/ddcz_fov_system`.

2. **Add the Script to Your `server.cfg`**

   Ensure the script is loaded by adding the following line to your `server.cfg`:

   ```plaintext
   ensure ddcz_fov_system
3. **Configure the Script**
-Add the following configuration settings to your server.cfg to customize the FOV system:
   ```plaintext
   setr profile_fpsFieldOfView 30.0
   setr profile_CameraHeight 1  
   setr profile_fpsAutoLevel 1
   setr profile_fpsHeadBob 1
## !Important!: These settings are crucial for the script's functionality. They adjust the FOV across the entire game, not just in vehicles.

## Usage
- Restart the Server

- After configuring the settings in your server.cfg, restart your server for the changes to take effect.

- Testing and Adjustment

- Test the script to ensure the camera and FOV adjustments are applied as expected.

## Troubleshooting
- **Check Configuration:** Verify that all configuration settings in server.cfg are correctly entered and match your desired values.

- **Script Errors:** Check the server console for any errors related to the script and ensure it is properly loaded.

- **Control Conflicts:** Make sure the controls specified in the script do not conflict with other scripts or game settings.

## Screenshots 
![dada](https://github.com/user-attachments/assets/9b95f958-396a-4939-9314-10f0753c80a4)
![image](https://github.com/user-attachments/assets/9f6c6aed-a2dc-4258-9ddf-688965a0b1f2)
![dadwadad](https://github.com/user-attachments/assets/f5e1ecb9-da41-46f8-9425-0e814cd9e9ed)




License
This project is licensed under the MIT License. You are free to use, modify, and distribute this script as long as you comply with the terms of the license.

Contact
For questions or issues, please use the GitHub issue tracker or contact me at dodocz.net@gmail.com.
