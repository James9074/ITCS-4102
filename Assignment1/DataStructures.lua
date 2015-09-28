a = {}    -- new array
    for i=1, 1000 do
      a[i] = 0
    end
    
    print("Traversing new array[100] with random numbers:")
    --Setup random generator
    math.randomseed(os.time())
    
    for i=1, 100 do
      a[i] = math.random(1,100)
      print("Position " .. i .. ": " .. a[i])
    end
    
    print("Creating a matrix data structure in LUA")
    --Build the matrix
    N = 10
    M = 10
    matrix = {}
    for i=1,N do
      matrix[i] = {} -- Create and set a row
      line = "Row " .. i .. ":\t"
      for j=1,M do
        matrix[i][j] = math.random(0,N + M)
        line = line .. tostring(matrix[i][j]) .. "\t"
        -- Create and set column
      end
      print(line)
    end
     
    print("\nCreating and traversing a list of size 10 with random numbers in LUA:")
    --Build the list
    list = nil
    for i=1,10 do
      list = {next=list, value=math.random(0,100)}
    end
    
    l = list
    while l do 
      io.write(l.value .. "  ")
      l = l.next
    end
    print("\n");