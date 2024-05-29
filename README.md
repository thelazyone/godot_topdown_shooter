# godot_topdown_shooter
In this stage I'm mainly experimenting with Godot, restarting from [the previous playground](https://github.com/thelazyone/godot_rts) test with a slightly different scope.

## Main Goals
The goal now is to implement a basic working engine for a topdown shooter, nothing more.

* WASD controls for a vehicle, with independent turret and shooty capabilites
* Testing out environment assets that I have from [my 3D files store](https://www.myminifactory.com/users/TheLazyForger), converted for gamedev.
* Right-click controls for side troops (selected with 1-4 numbers)
* Basic enemies advancing (maybe with field of view, it's kind of simple.
* Damage system of some kind.

## Folder Structure
One of the main changes from the previous attempt is to organize the files per-use rather than per-type. I'm slowly understading how to set up this kind of environment.

```text	
res
├── autoloads					Global functions, loaded at startu
└── controller					Controls for the player, including GUI overlay.
└── levels					All levels present and future
 ├── level assets				Terrain and obstacles
 ├── level components				Logic for levels (actors node, camera, pathfinding)
 └── level_1 ... n				Folders for each level
└── units					All units
 ├── units assets				Bullets, markers, etc...
 ├── units components				Movement, shooting and other logics
 └── unit_a ... z				One folder for each unit
└── shaders					Empty for now, but all shaders should go here.
```
