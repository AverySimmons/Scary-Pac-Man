
# Walking in Space

---

**Tools Used:** Godot Game Engine, GDScript, Asprite &nbsp;&nbsp;&nbsp;&nbsp; **Keywords:** 2D, AI, Inverse kinamatics, Game design, Lighting

---

### Description:
&nbsp;&nbsp;&nbsp;&nbsp;A dark twist on the arcade classic PacMan. The player game begins with a dark screen and a loud echoing roar. The player moves exactly how the PacMan did in the original game, however this time they can only see around their character, with the tight walls of the maze blocking light from penetrating. As they move around collecting dots, they get glimpses of color tenticles and sharp teeth of the maze's monster. If the monster ever spots them, it shreeks and quickly begins chasing the player. The player must collect all the dots without being caught.


### Features:
- &nbsp;&nbsp;&nbsp;&nbsp;**Enemy Design:**  
While the player moves in a grid based system, the monster moves based on collision, allowing it to cut corners while the player must make multiple inputs. This means that the while the player can outpace the monster in straight sections too many turns will spell certain death. In addition the monster's AI has it switching between two states: patrol and hunting. When patroling the monster pickes a dot that has not been collected and moves to it slowly (the fact that it can only move to dots means that tension increases as the game progresses). On seeing the player the monster will enter hunt mode and rush at the player until it loses sight of them for a few seconds.

- &nbsp;&nbsp;&nbsp;&nbsp;**Lighting:**  
The primary difference in this project compared to PacMan is the lack of lighting. PacMan is quite intense, especially for an arcade game, however most of this tension is displelled by the fact that all the ghosts are visible at all times. It is quite easy to plan ahead rather then having to react in an instant to the ghost's decisions. By removing the light, I remove the information on enemy movements. This game shines both in the need to plan based on momentary sightings of the monster's extremities and in the frightful moments of turning a corner directly into it.

- &nbsp;&nbsp;&nbsp;&nbsp;**Inverse Kinamatics:**  
My idea for this game started with me messing around with making an inerse kinamatics simulation in python. I have made a thick, black, and segmented tentacle, and as I moved it around I realised how unsettling it was. From there I came up with the idea for the monster. The monster's tentacles, actually move quite complexly. The monster itself is just a circle collision box with a sprite, however as it moves each tentacle checks if it is too far away and if it is, it raycasts around the monster to find a new position to latch, looking at angles that would cause the most movement first.

- &nbsp;&nbsp;&nbsp;&nbsp;**Sound Design:**  
The main way this game builds tension is through its sound. When the game is first booted up the player is treated to classic PacMan theme, however as the screen fades to black it becomes distorted. Then the load roar of the monster tells the player that they are not alone in this maze (which is helpful as the monster starts quite distant from the player). Finally the directional sound of the monster's breathing begins to play. This sound while deeply unsettling is actually one of the player's best tools to know the monster's position as it grows louder when the monster is near and can barely be heard when the monster is on the other side of the maze.


### Code Breakdown:
- &nbsp;&nbsp;&nbsp;&nbsp;**Level:**  
This scene holds the tilemap responsible for generating the player and monsters movement, as well as the light occlusion for the player's light.

- &nbsp;&nbsp;&nbsp;&nbsp;**Player:**  
The player scene contains the player sprite and collision as well as the movement logic and the player's light.

- &nbsp;&nbsp;&nbsp;&nbsp;**Monster:**  
The monster scene holds the logic for the enemy AI and pathfinding as well as the monster's primary model and tentacle placement logic.

- &nbsp;&nbsp;&nbsp;&nbsp;**InverseKinamaticsStrand:**
This scene possesses the logic for controling the monster's tentacles. Given a point to move to the strand will work backwords to move its endpoint as close as possible.
