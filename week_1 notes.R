# Class Notes
primes = c(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 
43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)
x = c(3, 4, 12, 19, 23, 48, 50, 61, 63, 78)

true.vec = rep(TRUE,length(primes))
not.prime = rep(TRUE,length(x))
for(i in seq_along(x)){
  for(j in seq_along(primes)){
    val = x[i] == primes[j]
    true.vec[j] = val
  }
  not.prime[i] = any(true.vec == TRUE)
}
x[!not.prime]

# Colin's code

for(prime_cand in x){
  found_match = FALSE
  for(prime in primes){
    if(prime_cand == prime){
      found_match = TRUE
      break
    }
  }
  if(!found_match){
    print(prime_cand)
  }
}

## Better
for(prime_cand in x){
  if(!prime_cand %in% primes){
    print(prime_cand)
  }
}

## Best
x[!x %in% primes]


###########################################
# September 6, 2017
c(1,NA+1L,"C") # Integer, na_integer, character
class(c(1,NA+1L,"C")) # This is a character.  Character wins out
class(c(1,"C"))
class(c(1,NA+1L)) # Numeric.  So it seems like the order goes character, numeric, integer.

# Second one
class(c(1L / 0, NA)) # Numeric still wins out? What is numeric in this?
class(1L / 0) # Numeric beats out NA


class(c(1:3, 5)) # Numeric beats out integer.  5 is numeric.  1:3 is integer.

class(c(3L,NaN + 1L)) # Numeric wins out again.

# Character, numeric, integer,logical, NA

class(c(NA         
        ,TRUE))l

## Represent as a list
json.data = list(firstName = "John",lastName = "Smith",
                 age = 25, 
                 address = list(streetAddress = "21 2nd Street",
                                city = "New York",
                                state = "NY",
                                PostalCode = 10021),
                 phoneNumber = list(
                   list(type = "home",
                        number = "212 555-1239"),
                   list(type = "fax",
                        number ="646 555-4567" )
                 )
)
                                    
                   
                
{
