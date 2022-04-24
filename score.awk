#!/usr/bin/env -S awk -f
BEGIN {
  FS = "[ \t]+"
  split("abcdefghijklmnopqrstuvwxyz", alphabet, "")
}

{
  SETUP = NR <= 26
  FINISH = NR == 26
}

SETUP {
  # First field will be null
  freq[$3] = $2
  freq[1][$5] = $4
  freq[2][$7] = $6
  freq[3][$9] = $8
  freq[4][$11] = $10
  freq[5][$13] = $12
}

FINISH {
  # Normalize frequencies
  total = 0
  for (i in alphabet) {
    total += freq[alphabet[i]]
  }
  for (i in alphabet) {
    freq[alphabet[i]] /= total
  }

  for (col = 1; col <= 5; col++) {
    total = 0
    for (i in alphabet) {
      total += freq[col][alphabet[i]]
    }
    for (i in alphabet) {
      freq[col][alphabet[i]] /= total
    }
  }
}

# Score each word
!SETUP {
  green = 0
  yellow = 0
  delete seen

  split($0, chars, "")
  for (i in chars) {
    char = chars[i]
    if (char in freq[i] && !(char in seen)) {
      green += freq[i][char]
    }
    if (char in freq && !(char in seen)) {
      yellow += freq[char]
    }
    seen[char] = 1
  }

  print green, yellow, green+yellow, $0
}
