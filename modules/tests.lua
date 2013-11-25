require "torch"
require "nn"
local leftInSize = 2;
local rightInSize = 3;
local totalInSize = leftInSize + rightInSize;

local leftInput = torch.rand(leftInSize)
local rightInput = torch.rand(rightInSize)
local gradOutput = torch.rand(leftInSize)
local concatenedInput = torch.rand(leftInSize + rightInSize)
local sumedGradOutput = torch.Tensor(leftInSize):fill(1)

--test CrossCore --random test
dofile "CrossCore.lua"
local core = nn.CrossCore(
    torch.rand(leftInSize,totalInSize),torch.rand(leftInSize))
core:forward(concatenedInput)
core:backward(concatenedInput,sumedGradOutput)
print(core:parameters())
print(core:getGradWeight())

--test CrossWord
dofile "CrossWord.lua"
local wordSize = rightInSize;
local wordIndexSize = 1;
local inputWord = torch.rand(wordSize);
local inputIndex = torch.rand(wordIndexSize);
local crossWord = nn.CrossWord(inputWord, inputIndex);
print("getGradWeight:");
print(crossWord:getGradWeight(inputWord));
print("getOutput():");
print(crossWord:getOutput());

--test CrossTag
dofile "CrossTag.lua"
local featureSize = leftInSize;
local classesSize = 3;
local weight = torch.rand(classesSize,featureSize);
local bias = torch.rand(classesSize);
local tag = 2;
local crossTag = nn.CrossTag(weight, bias, tag);
local nodeRepresentation = torch.rand(leftInSize);
crossTag:forward(nodeRepresentation);
crossTag:backward(nodeRepresentation);
print("getGradWeight():");
print(crossTag:getGradWeight());
print("getGradInput():");
print(crossTag:getGradInput());
print("getPredTag():");
print(crossTag:getPredTag());

--test Cross
dofile "Cross.lua"
local testCross = nn.Cross(core,crossWord,crossTag)
print(testCross:forward(leftInput))
print(testCross:backward(leftInput,gradOutput))
print(testCross:getGradParameters())

--test LoadedLookupTable
dofile "LoadedLookupTable.lua"
local lookupTable = nn.LoadedLookupTable.load(
    '../embeddings/embeddings.txt', '../embeddings/words.lst')
print(lookupTable:forward(1))
print(lookupTable:queryIndex('reply'))
print(lookupTable:forward('reply'))
lookupTable:reset(torch.Tensor(50, 50):zero())
print(lookupTable:forward(1))
print(lookupTable:backward('reply', torch.rand(50, 50), 0.1))
--TODO(robertsdionne): fix backwardUpdate
--print(lookupTable:backwardUpdate('reply', torch.rand(50, 50), 0.1))
