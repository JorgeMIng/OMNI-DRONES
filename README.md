# OMNI-DRONES



## GETTING STARTED

Omni-Drones are mostly known for using [VS+Tournament](https://modrinth.com/mod/vs-tournament) thrusters but there are other Valkyrien Skies addons that the Omni-Drone system can use to fly your ship!
It is a bit complicated for beginners to setup an omni-drone using VS+Tournament so let's get you started using [VS+Kontraption](https://modrinth.com/mod/kontraption) instead!

## SETTING UP

### MODPACK DOWNLOAD
   You can get the modpack [here](https://www.planetminecraft.com/project/omni-drone-tutorial-part-4-world-save/).

### BUILDING A KONTRAPTION SHIP
  You can watch this [Mod Showcase about VS+Kontraption](https://youtu.be/XC42jOs6OnY?si=RifRivF0EY3qWojl) to learn how it works.

  Keep track of how many ION thrusters you have facing in each cardinal direction. This will be important later in programming our turtle.
  
  #### Make sure to place the "Ship Controller" facing your ship's positive X direction (EAST).
  Before assembling your structure as a ship, you need to keep track of where EAST is. Face that direction and place your Ship Controller block on your ship. This is what your turtle pilot will use to fly your ship.

### SETTING UP THE OMNI-DRONE CODE
   After downloading this repo thru the green button above and unziping it, you might notice that the `OMNI-DRONES/CC_TURTLE_PILOT/lib` is empty. That's because it's in it's own github repo. You need to download the [OMNI-DRONE-LUA-LIBRARY](https://github.com/19PHOBOSS98/OMNI-DRONE-LUA-LIBRARY) separately.
   Unzip that as well and throw the contents in the lib folder.
   
   If you are a git bash user, you should be able to get all of them in one go using the git clone command.

### SETTING UP COMPUTERCRAFT TURTLE PILOT
   Each Computercraft (CC):Computer/Turtle has its own `computer_id`. Each time you write a lua script on a  CC:computers/turtles, it gets saved in `[worldsave_folder]/computercraft/computer/[computer_id]`.
   If you are playing in a fresh new world, the computercraft folder usually starts out empty. It will stay empty until you create a file in one of the computers/turtles on your world.
   We can get the mod to generate the computer folder for us by creating a file. Type `edit [arbitray_file_name_here]` to create one and save it.
   or we can just visit the `computercraft` folder and create it ourselves.
   
   1. Computercraft (CC) adds a robot called a "turtle". This will be our omni-drone's "pilot". Place one down next to your Ship Controller so we can start programming it to fly the drone.
   2. Turn on your turtle. Type "id" and press enter to get its computer ID.
   3. Go to your world save folder and drop the contents of the `CC_TURTLE_PILOT` folder into your turtle's computer folder: `[worldsave_folder]/computercraft/computer/[computer_id]`. If the turtle's computer folder is not there yet, create one.

### PREPING THE CODE
   #### startup.lua
   In our turtle's computer folder edit the `startup.lua` script using your favourite text editor.
   Our turtle runs this script whenever it wakes up or restarts. This script, in turn, runs a `firmwareScript.lua` file.
   I've prepared a few sample firmwareScripts that you can use as you might have noticed. Since our ship is running on Kontraption. Edit `startup.lua` to run the `firmwareScript_Kontraption.lua`:
   ```
   ...
   shell.run("firmwareScript_Kontraption.lua")
   ...
   ```
   Now each time we need to change our code we just need to restart the drone by hitting its red power button. 

   #### firwareScript_Kontraption.lua
   We next need to edit our `firwareScript_Kontraption.lua` file. This is where your pilot's heart is written : )

   We need to tell it how many ion thrusters our ship is using thru the instance configs:
   `instance_configs > ship_constants_config > ION_THRUSTERS_COUNT`
   Remember +X is east, +Z is south and +Y is up.

### MOVING, TURNING AND SEQUENCING
   We can tell the drone where and how to move thru the `customFlightLoopBehavior` function. 
   Pick a coordinate (XYZ) in your world and type in those coordinates to set the drone's `target_global_position` variable:
   
```
...
self.target_global_position = vector.new(X,Y,Z)
...
```
   
   To learn more on how to use it follow this section of this [tutorial video](https://youtu.be/UjBYnDKEcdQ?si=ytZQRVUE_gKhOeR7&t=325). I know the video is outdated but the parts between 5:25 and 10:31 are still relevant in making it move and stuff:
   
   [POSITIONING](https://youtu.be/UjBYnDKEcdQ?si=MszuQ6OCrB3relZS&t=326)
   
   [DISTANCE MEASURING](https://youtu.be/UjBYnDKEcdQ?si=b0LDGcHqrKWo73Kz&t=376)
   
   [ROTATION](https://youtu.be/UjBYnDKEcdQ?si=aTY2puQDIxiEvRGk&t=429)
   
   [SEQUENCING ACTIONS](https://youtu.be/UjBYnDKEcdQ?si=_8k38H5ehNus8lYZ&t=530)

### FLY!
   Once you are happy with your changes in fligth behavior, we can now start flying. Just restart the turtle pilot. If everything goes well it should start flying to the coordinates you've set it to go. 
   
### WANT MORE?
Whenever you are ready, you can try following the rest of the [tutorial series](https://youtube.com/playlist?list=PL1bsn0MYd0U66LAyrpklsqIQDQLFjEzH0&si=2GKLiGcCHLSxidNb). Add remote control, swap to tournament, learn how to tame a Hound Turret! but most importantly, have fun :) 
   
