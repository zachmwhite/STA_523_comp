# Regular expressions
library(tidyverse)
library(stringr)

text = c("The","quick","brown","fox","jumps","over","the","lazy","dog")

str_detect(text, "quick")
str_detect(text, "o")
str_detect(text, "row")

cat('\t"hello"\t')
cat('\t"hello"\t')

str_detect("abc[def","\[")
str_detect("abc[def","\\[")

str_detect("abc\\def","\\\\")

str_detect("abc\\\\def","\\\\\\\\")
# Anchor location
text = "the quick brown fox jumps over the lazy dog"

str_replace(text,"^the","---")
str_replace(text,"the$","---")
str_replace(text,"dog$","---")
# ^ beginning
# $ at the end

str_replace(text,"\\Brow\\B","---")
str_replace(text,"\\bthe","---") # It only does the first one.
str_replace_all(text,"\\bthe","---")


#  Phone number
text = c("apple", "(219) 733-8965", "(329) 293-8753")

# No.
str_detect(text, "(\d\d\d) \d\d\d-\d\d\d\d")
str_detect(text,"(\\d\\d\\d) \\d\\d\\d-\\d\\d\\d\\d")
str_detect(text,"\\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d\\d\\d")


# Exercise 1
names = c("Haven Giron", "Newton Domingo", "Kyana Morales", "Andre Brooks", 
  "Jarvez Wilson", "Mario Kessenich", "Sahla al-Radi", "Trong Brown", 
  "Sydney Bauer", "Kaleb Bradley", "Morgan Hansen", "Abigail Cho", 
  "Destiny Stuckey", "Hafsa al-Hashmi", "Condeladio Owens", "Annnees el-Bahri", 
  "Megan La", "Naseema el-Siddiqi", "Luisa Billie", "Anthony Nguyen"
)

# First name starts with vowel.
names[str_detect(names,"^[AEIOU]")]
names[str_detect(names,"^[^AEIOU]")]
vowel = str_detect(names,"^[AEIOU]")
not_vowel = str_detect(names,"^[^AEIOU]")

xor(vowel,not_vowel)

#  Last name starts with vowel.
names[str_detect(names," [aieouAEIOU]")]
# OR change them all to lower
str_detect(tolower(names), " [aeiou]")

# Or
str_detect(names,"^[AEIOU]| [AEIOUaeiou]")

#Neither nor
!str_detect(names,"^[AEIOU]| [AEIOUaeiou]")
str_detect(names,"^[^AEIOU][A-Za-z]* [^AEIOUaeiou][A-Za-z]*")
# Be careful.  THis includes symbols also.