# Simulation-of-a-Reinforcement-Learning-based-agent-Map-solving-problem
Simulation using the lua programming language and the LOVE2D engine of a Reinforcement Learning based agent – Map solving problem

##Description

This project is a maze solving problem. The aim is to implement an agent that can find an optimal set of actions that can be followed to get to our desired destination in the maze.
We have a maze, similar to the grid world example in Russel and Norvig book. [1] We have blocks in the maze –the states, we have a set of actions available from each state – up, down, left, right, etc., and we have end blocks (states) where the only action is to exit the map. The exit states might be our desired exit state or an undesired one. 
The conditions are as follows:

  •	Our agent can identify a state uniquely and once the agent reaches a state it is given a set of possible actions to choose from for   that particular state.
  •	The agent does not know about the possible actions that it can take in states other than the one it is currently in.
  •	The agent needs to find the optimal sequence of actions for any state such that once it has that set of actions, the agent will always  be able to follow the optimum route to our desires locations, given the actual map hasn’t been changed.
  •	If the map changes the agent needs to rediscover the new map and repeat the whole process.

To summarize, we have an undiscovered maze and a desired destination in the maze that we want to reach – our input. We need an agent that can find a way to our destination and give us a map that can be followed to get to our destination most optimally – our output. 

##How to run the Simulation

1. Clone the repository.
2. Make sure all the files are in one folder.
3. Download the LOVE2D engine (https://love2d.org/)
4. Open the Love2D engine folder and find the executable.
5. Drag and Drop the project folder onto the LOVE2D executable.

At this point the simulation should start running. 
