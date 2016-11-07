#lang racket

(require db)

(require "structs.rkt")

(provide get-games
	get-platforms
	get-platform-by-id
	get-platform-by-name
	get-genres
	get-genre-by-id
	get-genre-by-name
	get-hardware-types
	get-hardware
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
 
(define (get-games [sort-by "title"] [sort-dir "ASC"]) 
  (get-rows (string-append "SELECT g.RowId, g.Title, g.Genre, g.Platform, g.NumberOwned, " 
			   "g.NumberBoxed, g.NumberOfManuals, g.DatePurchased, " 
			   "g.ApproximatePurchaseDate, g.Notes, p.Name as PlatformName " 
			   "FROM Game as g "
			   "JOIN Platform AS p ON g.Platform=p.RowId "
			   "ORDER BY " sort-by " " sort-dir ";")))

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

(define (get-platforms [sort-dir "ASC"]) 
  (get-rows (string-append "SELECT RowId, * FROM Platform ORDER BY Name " sort-dir ";")))

(define (get-platform-by-id id) 
  (get-row-by-id "SELECT RowId, * FROM Platform WHERE RowId=$1" id))

(define (get-platform-by-name name)
  (get-row-by-id "SELECT RowId, * FROM Platform WHERE Name=$1 LIMIT 1;" name))

(define (get-genres [sort-dir "ASC"])
  (get-rows (string-append "SELECT RowId, * From Genre ORDER BY Name " sort-dir ";")))
 
(define (get-genre-by-id id)
  (get-row-by-id "SELECT RowId, * FROM Genre WHERE RowId=$1" id))

(define (get-genre-by-name name)
  (get-row-by-id "SELECT RowId, * FROM Genre WHERE Name=$1 LIMIT 1;" name))

(define (get-hardware-types)
	(get-rows "SELECT RowId, * FROM HardwareType;"))

(define (get-hardware)
	(get-rows "SELECT RowId, * FROM Hardware;"))
