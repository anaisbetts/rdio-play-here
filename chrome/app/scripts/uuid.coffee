# Private array of chars to use
CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".split("")

Math.uuid = (len, radix) ->
  chars = CHARS
  uuid = []
  i = undefined
  radix = radix or chars.length
  if len
    
    # Compact form
    i = 0
    while i < len
      uuid[i] = chars[0 | Math.random() * radix]
      i++
  else
    
    # rfc4122, version 4 form
    r = undefined
    
    # rfc4122 requires these characters
    uuid[8] = uuid[13] = uuid[18] = uuid[23] = "-"
    uuid[14] = "4"
    
    # Fill in random data.  At i==19 set the high bits of clock sequence as
    # per rfc4122, sec. 4.1.5
    i = 0
    while i < 36
      unless uuid[i]
        r = 0 | Math.random() * 16
        uuid[i] = chars[(if (i is 19) then (r & 0x3) | 0x8 else r)]
      i++
  uuid.join ""

# A more performant, but slightly bulkier, RFC4122v4 solution.  We boost performance
# by minimizing calls to random()
Math.uuidFast = ->
  chars = CHARS
  uuid = new Array(36)
  rnd = 0
  r = undefined
  i = 0

  while i < 36
    if i is 8 or i is 13 or i is 18 or i is 23
      uuid[i] = "-"
    else if i is 14
      uuid[i] = "4"
    else
      rnd = 0x2000000 + (Math.random() * 0x1000000) | 0  if rnd <= 0x02
      r = rnd & 0xf
      rnd = rnd >> 4
      uuid[i] = chars[(if (i is 19) then (r & 0x3) | 0x8 else r)]
    i++
  uuid.join ""


# A more compact, but less performant, RFC4122v4 solution:
Math.uuidCompact = ->
  "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = (if c is "x" then r else (r & 0x3 | 0x8))
    v.toString 16
