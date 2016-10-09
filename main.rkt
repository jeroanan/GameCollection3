#lang racket
(require db)

(define database-file "GameCollection.db")

(unless (sqlite3-available?)
	(error "sqlite3 is not available and must be installed"))

(define dbconn
	(if (file-exists? database-file)
		(sqlite3-connect #:database database-file)
		(sqlite3-connect #:database database-file #:mode 'create)))

(define (create-genre-table)
	(define sql "CREATE TABLE Genre (Name TEXT NOT NULL PRIMARY KEY, Description TEXT);")
	(query-exec dbconn sql))

(define (create-platform-table)
	(define sql "CREATE TABLE Platform(Name TEXT NOT NULL PRIMARY KEY, Description TEXT);")
	(query-exec dbconn sql))

(define (create-game-table)
	(define sql (string-append 
		"CREATE TABLE Game "
		"(Title TEXT NOT NULL,"
		"Genre TEXT References Genre(rowid),"
		"Platform TEXT References Platform(rowid),"
		"NumberOwned INTEGER,"
		"NumberBoxed INTEGER,"
		"NumberOfManuals INTEGER,"
		"DatePurchased TEXT,"
		"ApproximatePurchaseDate INTEGER,"
		"Notes TEXT)"))
	(query-exec dbconn sql))

(define table-creates (list 
	(list "Genre" create-genre-table)
	(list "Platform" create-platform-table)
	(list "Game" create-game-table)))

(for ([i table-creates])
	(unless (table-exists? dbconn (first i))
		((second i))))

	
	
                       
                       




  
