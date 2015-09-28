--For
print("======== For loop ========")
for i=1,10 do
  io.write(i * 2, " ")
end
--While
print("\n\n ========While loop ========")
i = 0
while i < 10 do
  i = i+1
  io.write(i, " ")
end

--If
print("\n\n======== If blocks ========")
math.randomseed(os.time())
for x=1, 10 do
  i = math.random(0,20)
  print("Generating a random number for i: " .. i)
  if i < 10 then
    print("i is less than 10")
  else
    print("i is greater than 10")
  end
end

--???