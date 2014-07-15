-- RC4
-- http://en.wikipedia.org/wiki/RC4

function KSA(key)
    local key_len = string.len(key)
    local S = {}
    local key_byte = {}

    for i = 0, 255 do
        S[i] = i
    end

    for i = 1, key_len do
        key_byte[i-1] = string.byte(key, i, i)
    end

    local j = 0
    for i = 0, 255 do
        j = (j + S[i] + key_byte[i % key_len]) % 256
        S[i], S[j] = S[j], S[i]
    end
    return S
end

function PRGA(S, text_len)
    local i = 0
    local j = 0
    local K = {}

    for n = 1, text_len do

        i = (i + 1) % 256
        j = (j + S[i]) % 256

        S[i], S[j] = S[j], S[i]
        K[n] = S[(S[i] + S[j]) % 256]
    end
    return K
end

function RC4(key, text)
    local text_len = string.len(text)

    local S = KSA(key)        
    local K = PRGA(S, text_len) 
    return output(K, text)
end

function output(S, text)
    local len = string.len(text)
    local c = nil
    local res = ''
    for i = 1, len do
        c = string.byte(text, i, i)
        res = res..string.char(bxor(S[i], c))
    end
    return res
end


-------------------------------
-------------bit wise-----------
-------------------------------

local bit_op = {}
function bit_op.cond_and(r_a, r_b)
    return (r_a + r_b == 2) and 1 or 0
end

function bit_op.cond_xor(r_a, r_b)
    return (r_a + r_b == 1) and 1 or 0
end

function bit_op.cond_or(r_a, r_b)
    return (r_a + r_b > 0) and 1 or 0
end

function bit_op.base(op_cond, a, b)
    -- bit operation
    if a < b then
        a, b = b, a
    end
    local res = 0
    local shift = 1
    while a ~= 0 do
        r_a = a % 2
        r_b = b % 2
   
        res = shift * bit_op[op_cond](r_a, r_b) + res 
        shift = shift * 2

        a = math.modf(a / 2)
        b = math.modf(b / 2)
    end
    return res
end

function bxor(a, b)
    return bit_op.base('cond_xor', a, b)
end

function band(a, b)
    return bit_op.base('cond_and', a, b)
end

function bor(a, b)
    return bit_op.base('cond_or', a, b)
end

--key = "Key"
--text = "Plaintext"
--K = RC4(key, text)
--print (K)
--text = RC4(key, K)
--print (text)
--
--key = "Wiki"
--text = "pedia"
--K = RC4(key, text)
--print (K)
--
--key = "Secret"
--text = "Attack at dawn"
--K = RC4(key, text)
--print (K)

fp_key = io.open("key.txt", "r")
fp_text = io.open("text.txt", "r")
res = io.open("lua.txt", "w")
for i = 1, 10000 do
    key = fp_key:read()
    text = fp_text:read()
    K = RC4(key, text)
    res:write(K.."\n")
end
fp_key:close()
fp_text:close()
res:close()
