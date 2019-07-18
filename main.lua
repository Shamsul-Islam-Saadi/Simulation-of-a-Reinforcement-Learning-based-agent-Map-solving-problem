--Name: Shamsul Islam Saadi
--Solution to a maze solving problem using reinforcement learning
--put all the contents here in 'main.lua' file

--Reinforcement learning variables
numberOfEpisodes = 0
endAtEpisode = 100
stepSize = 64
mapSize_X = 3
mapSize_Y = 3
----agent attributes
agent = {	x = 400,
			y = 300,
		 	img = nil }

----Map of maze
------0 is +10 exit block
------1 is -10 exit block
------2 is normal movable block with 'r' discount factor
------3 is non-movable block
worldMap = {{{2, 0, {'down', 'right'}}, {2, 0, {'left', 'right'}}, {0, 10, {'exit'}}},
			{{2, 0, {'up', 'down'}}, {3, 0, {}}, {1, -10, {'exit'}}},
			{{2, 0, {'up', 'right'}}, {2, 0, {'left', 'right'}}, {2, 0, {'up', 'left'}}}		
			}

--worldMap = {{{3, 0, {}}, {2, 0, {'down', 'right'}}, {0, 1, {'exit'}}},
--			{{2, 0, {'right'}}, {2, 0, {'up', 'down', 'left', 'right'}}, {1, -1, {'exit'}}},
--			{{3, 0, {}}, {2, 0, {'up', 'right'}}, {2, 0, {'up', 'left'}}}		
--			}

s = {x= 3,	y = 2} --x,y values for worldmap

----Q learning components
QTable = {}
for i = 1, mapSize_X do
	QTable[i] = {}	 	
	for j = 1, mapSize_Y do		
		QTable[i][j] = {}	 	
		for l  = 1, 5  do
			QTable[i][j][l] = 0.0
		end
	end
end

discount_factor = 0.9
learning_rate = 0.5

-------Q value functions
-------input: s,a; output: Q-value
function qValueUpdate(currentState, actionTaken)		
	newX = currentState.x
	newY = currentState.y
	
	qNextMax =  -1000

	if actionTaken == 'up' then
		newX = newX - 1
		actionIndex = 1
	elseif actionTaken == 'down' then
		newX = newX + 1
		actionIndex = 2
	elseif actionTaken == 'left' then
		newY = newY - 1
		actionIndex = 3
	elseif actionTaken == 'right' then
		newY = newY + 1
		actionIndex = 4
	elseif actionTaken == 'exit' then		
		actionIndex = 5
	end

if actionTaken == 'exit' then
	qNextMax = 0
else
	newState = {newX, newY}
	Q = QTable[newX][newY]

	for j = 1, 5 do
		if Q[j] > qNextMax then
			qNextMax = Q[j]
		end		
	end 
end

	local qOld = QTable[currentState.x][currentState.y][actionIndex]
	local currentReward = worldMap[currentState.x][currentState.y][2]

	--***THIS IS THE Q-VALUE UPDATE EQUATION***
	local qNew = qOld + (learning_rate * (currentReward + (discount_factor*qNextMax) - qOld))

	--Assign value to Q-Table
	QTable[s.x][s.y][actionIndex] = qNew			
	--update agent location in Map
	s.x = newX
	s.y = newY
	--return new QValue
	return qNew
end
----
function resetAgent()
	s.x = 3
	s.y = 2
	numberOfEpisodes = numberOfEpisodes + 1
end

function love.load(arg)
	agent.img = love.graphics.newImage('assets/agent.png')
	block0 = love.graphics.newImage('assets/exit_high.png')
	block1 = love.graphics.newImage('assets/exit_low.png')
	block2 = love.graphics.newImage('assets/movable_block.png')
	block3 = love.graphics.newImage('assets/non_movable_block.png')
end

oldTime = -1
function love.update(dt)		
	if endAtEpisode ~= numberOfEpisodes then
		currentTime = love.timer.getTime() 

		--update once per n-seconds
		--make n smaller (but grater than 0) to faster update
		n = 0.1
		if  (oldTime + n) < currentTime then		
			--Q learning algorithm
			newActionNumber = math.random(#worldMap[s.x][s.y][3])
			newAction = worldMap[s.x][s.y][3][newActionNumber]		
			qValueUpdate(s, newAction)				
			--check for exit state
			if newAction == 'exit' then
				resetAgent()
			end
			oldTime = currentTime
		end	
	elseif endAtEpisode == numberOfEpisodes then
		optimumPolicyFile = love.filesystem.newFile("Policy.txt")
		optimumPolicyFile:open("w")
		optimumPolicyFile:write('       ' .. '(Up, Down, Left, Right, Exit)' .. ' \r\n')    						
		for i = 1, mapSize_X do	
			for j  = 1, mapSize_Y  do

				QMAX = -1000
				Q = QTable[i][j]
				for l = 1, 5 do
					if Q[l] > QMAX then
						QMAX = Q[l]
					end		
				end 								
				optimumPolicyFile:write('('..j .. ','.. i .. '): ' .. '(' .. string.format("%.2f", QTable[i][j][1]) .. 
				' ' .. string.format("%.2f", QTable[i][j][2]) .. ' ' .. string.format("%.2f", QTable[i][j][3]) ..
				' ' .. string.format("%.2f", QTable[i][j][4]) .. ' ' .. string.format("%.2f", QTable[i][j][5]) .. ')\r\n')    						
			end		
		end
		optimumPolicyFile:close()
	end	
	--escape key detection or training complete detection for program termination 
	if love.keyboard.isDown('escape') then		
		love.event.push('quit')
	end		
end

function love.draw(dt)
	--x and y are inverted for s(matrix) and agent(screen)
	for i = 1, mapSize_X do
		for j = 1, mapSize_Y do
			if worldMap[i][j][1] == 0 then
				love.graphics.draw(block0, (j-1)*64, (i-1)*64)			
			elseif worldMap[i][j][1] == 1 then
				love.graphics.draw(block1, (j-1)*64, (i-1)*64)			
			elseif worldMap[i][j][1] == 2 then
				love.graphics.draw(block2, (j-1)*64, (i-1)*64)			
			elseif worldMap[i][j][1] == 3 then
				love.graphics.draw(block3, (j-1)*64, (i-1)*64)
			end
		end
	end

	agent.x = (s.y-1)*64 
	agent.y = (s.x-1)*64
	love.graphics.draw(agent.img, agent.x, agent.y)
    love.graphics.print("Reinforcement Learning! -- " .. ', Episode #' .. 
    	numberOfEpisodes .. ", Last Action Taken: " .. newAction , 0, 400)    

    for i = 1, mapSize_X do	
		for j  = 1, mapSize_Y  do

			QMAX = -1000
			Q = QTable[i][j]
			for l = 1, 5 do
				if Q[l] > QMAX then
					QMAX = Q[l]
				end		
			end 		
			--love.graphics.print(QMAX, j*100, i*100)    						
			love.graphics.print('(' .. string.format("%.2f", QTable[i][j][1]) .. 
			' ' .. string.format("%.2f", QTable[i][j][2]) .. ' ' .. string.format("%.2f", QTable[i][j][3]) ..
			' ' .. string.format("%.2f", QTable[i][j][4]) .. ' ' .. string.format("%.2f", QTable[i][j][5]) .. ')', j*200, i*100)    						
		end		
	end	
end


	
