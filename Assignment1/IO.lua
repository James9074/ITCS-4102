local open = io.open

local function read_file(path)
    local file = open(path, "r")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function write_file(path,data)
    local file = open(path,"w")
    file:write(data)
    file:close()
end

local answer
io.write("Input a *text* filename to read [defaults to text.txt as provided]: ")
io.flush()
answer=io.read()

if answer=="" then
	answer = "text.txt"
end

local fileContent = read_file(answer);
print ("\nReading Data:",fileContent);

local newData = string.reverse(fileContent);
print ("\nOverwriting Data:",newData);

write_file(answer,newData);

fileContent = read_file(answer);
print("\nReading File's Updated Contents:",fileContent);
