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

### SETTING UP COMPUTERCRAFT TURTLE PILOT
   Each Computercraft (CC):Computer/Turtle has its own `computer_id`. Each time you write a lua script on a  CC:computers/turtles, it gets saved in `[worldsave_folder]/computercraft/computer/[computer_id]`.
   If you are playing in a fresh new world, the computercraft folder usually starts out empty. It will stay empty until you create a file in one of the computers/turtles on your world.
   We either go into our worldsave folder
   
   
   If you are playing on a fresh new world without any programmed computers yet, the `computercraft` folder in your worldsave folder would be empty.
   
   1. Computercraft (CC) adds a robot called a "turtle". This will be our omni-drone's "pilot". Place one down next to your Ship Controller so we can start programming it to fly the drone.
   2. Turn on your turtle. Type "id" and press enter to get its computer ID.
      
   4. In your worldsave folder, there should be a folder called "computercraft". If you haven't programmed any CC:computers yet it should be empty.
