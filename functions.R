libraryCheck <- function(libraryList = NULL) {
	
	if (length(libraryList) > 0) {
		
		for (libraryName in libraryList) {
			
			if (library(libraryName, logical.return = TRUE, character.only = TRUE)) {
				# print('ok')
			} else {
				errorText <- paste('library', libraryName, 'not found')
				print(errorText)
				return(FALSE)
			}
			
		}
		
		return(TRUE)
				
	} else {
		
		return(TRUE)
		
	}
		
}
