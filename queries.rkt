#lang racket

(require db)

(provide get-games
	get-platforms
	get-platform-by-id
	get-genres
	get-genre-by-id
	get-hardware-types
	get-hardware)

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

(define (get-games [sort-by "title"] [sort-dir "ASC"])
	(get-rows (string-append "SELECT g.RowId, g.Title, g.Genre, g.Platform, g.NumberOwned, " 
				 "g.NumberOfManuals, g.DatePurchased, g.ApproximatePurchaseDate, " 
				 "g.Notes, p.Name as PlatformName " 
				 "FROM Game as g "
				 "JOIN Platform AS p ON g.Platform=p.RowId "
				 "ORDER BY " sort-by " " sort-dir ";")))

(define (get-platforms [sort-dir "ASC"])
	(get-rows (string-append "SELECT RowId, * FROM Platform ORDER BY Name " sort-dir ";")))

(define (get-platform-by-id id)
  (get-row-by-id "SELECT RowId, * FROM Platform WHERE RowId=$1" id))

(define (get-genres [sort-dir "ASC"])
	(get-rows (string-append "SELECT RowId, * From Genre ORDER BY Name " sort-dir ";")))
 
(define (get-genre-by-id id)
  (get-row-by-id "SELECT RowId, * FROM Genre WHERE RowId=$1" id))

(define (get-hardware-types)
	(get-rows "SELECT RowId, * FROM HardwareType;"))

(define (get-hardware)
	(get-rows "SELECT RowId, * FROM Hardware;"))
