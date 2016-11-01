## Caches the inverse of a function
## functions calculates the inverse of a function and caches it to be used a later times. 
## Creates diffrent functions that will hold and assign values for variables.

makeCacheMatrix <- function(x = matrix()) {
		m <- NULL 
        set <- function(mtxNew) {
            mtxOrg <<- mtxNew
            m <<- NULL
        }
        get <- function() mtxOrg
        setinv <- function(inv) m <<- inv
        getinv <- function() m
        list(set = set, get = get,
             setinv = setinv,
             getinv = getinv)
}


## Verify if a new matrix has be called on makeCacheMatric and otherwise calculates
## and returns the inverse of the function. 

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
	m <- mtxOrg$getinv()
    if(!is.null(m)){
        message("getting cached data")
        return(m)
    }
    data <- mtxOrg$get()
    m <- solve(data, ...)
    mtxOrg$setinv(m)
    m
}
