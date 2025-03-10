local sha2 = require"libs.sha2"

local uint32_max = math.pow(2, 32)
local hashFunc = sha2.sha256
local hashBytes = 8
-- we truncate the hash to this many chars
-- should be <= size of hashFunc's output
local hashHexChars = hashBytes * 2

-- generates a random hash
-- math.randomseed should be called before this is used for the first time
local function randomHash()
  local partialHash = hashFunc()
  partialHash = partialHash(tostring(math.random(uint32_max)))
  partialHash = partialHash(tostring(math.random(uint32_max)))
  return string.sub(partialHash(), 1, hashHexChars)
end

-- hash of every item in input sequence
local function hash(t)
  if type(t) ~= "table" or #t == 0 then
    error("hash(): input should be a list with at least one item")
  end
  local partialHash = hashFunc()
  for i = 1, #t do
    local v = t[i]
    if type(v) == 'table' then
      error("hash(): unexpected table in input list") -- unexpected table in bagging area
    end
    partialHash = partialHash(tostring(v))
  end
  return string.sub(partialHash(), 1, hashHexChars)
end

if not ... then -- if ran as main script with no args do selftest
  math.randomseed(os.time())
  print("randomHash() =\t\t", randomHash())
  local testTable = {"test", 1234, "DEADBEEF"}
  local result = hash(testTable)
  print("hash({test, 1234, DEADBEEF}) =\t", result)
  assert(result == "6398e970acf8dc2c", "hash of test table should be 6398e970acf8dc2c")
end

return {
  hash = hash,
  randomHash = randomHash,
}
