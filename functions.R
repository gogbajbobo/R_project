libraryCheck <- function(libraryList = NULL) {

	if (length(libraryList) <= 0) {
		return(FALSE)
	}

    for (libraryName in libraryList) {

        if (!library(libraryName, logical.return = TRUE, character.only = TRUE)) {

            errorText <- paste('library', libraryName, 'not found')
            print(errorText)

            return(FALSE)

        }

    }

    return(TRUE)

}
