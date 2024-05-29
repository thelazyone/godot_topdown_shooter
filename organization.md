Trying here to reorganize the structure of a future project in a more readable way: 
	
res
├── autoloads					Global functions, loaded at startu
└── controller					Controls for the player, including GUI overlay.
└── levels						All levels present and future
 ├── level assets				Terrain and obstacles
 ├── level components			Logic for levels (actors node, camera, pathfinding)
 └── level_1 ... n				Folders for each level
└── units						All units
 ├── units assets				Bullets, markers, etc...
 ├── units components			Movement, shooting and other logics
 └── unit_a ... z				One folder for each unit
└── shaders						Empty for now, but all shaders should go here.
