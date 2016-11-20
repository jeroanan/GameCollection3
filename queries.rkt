#lang racket

(require db)

(require "structs.rkt")

(provide get-games
	 get-games-by-platform
	 get-games-by-genre
	get-platforms
	get-platform-by-id
	get-platform-by-name
	add-platform
	delete-platform
	get-genres
	get-genre-by-id
	get-genre-by-name
	add-genre
	delete-genre
	get-hardware-types
	get-hardware
	create-game
	update-game)

(define (get-connection)
 (sqlite3-connect #:database "GameCollection.db")) 

(define (get-rows query [connection null])
  	(when (null? connection) (set! connection (get-connection)))
	(define rows (query-rows connection query))
	(disconnect connection)
	rows)

(define (get-row-by-id sql id)
  (define conn (get-connection))
  (define stmt (bind-prepared-statement (prepare conn sql) (list id)))
  (define rows (query-rows conn stmt))
  (if (empty? rows)
    (vector 0 "" "")
    (first rows)))

(define (exec sql params)
 (define conn (get-connection))
 (define stmt (bind-prepared-statement (prepare conn sql) params))
 (query-exec conn stmt))
 
(define (get-games [sort-by "title"] [sort-dir "ASC"] #:where-statement [where-statement ""]) 
  (get-rows (string-append "SELECT g.RowId, g.Title, g.Genre, g.Platform, g.NumberOwned, " 
			   "g.NumberBoxed, g.NumberOfManuals, g.DatePurchased, " 
			   "g.ApproximatePurchaseDate, g.Notes, p.Name as PlatformName " 
			   "FROM Game as g "
			   "JOIN Platform AS p ON g.Platform=p.RowId "
			   where-statement
			   "ORDER BY " sort-by " " sort-dir ";")))

(define (get-games-by-platform platform-id)
  (get-games #:where-statement (string-append "WHERE Platform=" platform-id " ")))

(define (get-games-by-genre genre-id)
  (get-games #:where-statement (string-append "WHERE Genre=" genre-id " ")))

(define (update-game game)
  (define sql (string-append "UPDATE GAME SET Title=$1, Genre=$2, Platform=$3, NumberOwned=$4, " 
			     "NumberBoxed=$5, NumberOfManuals=$6, DatePurchased=$7, "
			     " ApproximatePurchaseDate=$8, Notes=$9 WHERE RowId=$10"))

  (define params (list (game-title game)
		       (game-genre game)
		       (game-platform game)
		       (game-number-owned game)
		       (game-number-boxed game)
		       (game-number-of-manuals game)
		       (game-date-purchased game)
		       (game-approximate-purchase-date game)
		       (game-notes game)
		       (game-row-id game)))
  (exec sql params))

(define (create-game game)
  (define sql (string-append "INSERT INTO GAME (Title, Genre, Platform, NumberOwned, NumberBoxed, NumberOfManuals, "
			                       "DatePurchased, ApproximatePurchaseDate, Notes) "
                             "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)"))
  
  (define params (list (game-title game)
		       (game-genre game)
		       (game-platform game)
		       (game-number-owned game)
		       (game-number-boxed game)
		       (game-number-of-manuals game)
		       (game-date-purchased game)
		       (game-approximate-purchase-date game)
		       (game-notes game)))
  (exec sql params))

(define (get-platforms [sort-dir "ASC"]) 
  (get-rows (string-append "SELECT RowId, * FROM Platform ORDER BY Name " sort-dir ";")))

(define (get-platform-by-id id) 
  (get-row-by-id "SELECT RowId, * FROM Platform WHERE RowId=$1" id))

(define (get-platform-by-name name)
  (get-row-by-id "SELECT RowId, * FROM Platform WHERE Name=$1 LIMIT 1;" name))

(define (add-platform platform)
  (define sql "INSERT INTO Platform (Name, Description) VALUES($1, $2);")
  (define params (list (code-description-code platform)
		       (code-description-description platform)))
  (exec sql params))

(define (delete-platform platform)
  (define sql "DELETE FROM Platform WHERE RowId=$1;")
  (define params (list (code-description-row-id platform)))
  (exec sql params))

(define (get-genres [sort-dir "ASC"])
  (get-rows (string-append "SELECT RowId, * From Genre ORDER BY Name " sort-dir ";")))
 
(define (get-genre-by-id id)
  (get-row-by-id "SELECT RowId, * FROM Genre WHERE RowId=$1" id))

(define (get-genre-by-name name)
  (get-row-by-id "SELECT RowId, * FROM Genre WHERE Name=$1 LIMIT 1;" name))

(define (add-genre genre)
  (define sql ("INSERT INTO Genre (Name, Description) VALUES($1, $2);"))
  (define params (list (code-description-code genre)
		       (code-description-description genre)))
  (exec sql params))

(define (delete-genre genre)
  (define sql "DELETE FROM Genre WHERE RowId=$1;")
  (define params (list (code-description-row-id genre)))
  (exec sql params))

(define (get-hardware-types)
	(get-rows "SELECT RowId, * FROM HardwareType;"))

(define (get-hardware)
	(get-rows "SELECT RowId, * FROM Hardware;"))
