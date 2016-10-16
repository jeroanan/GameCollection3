#lang racket

(require db)

(provide get-games
	get-platforms
	get-genres
	get-hardware-types
	get-hardware)

(define (get-rows query)
	(define dbconn (sqlite3-connect #:database "GameCollection.db"))
	(define rows (query-rows dbconn query))
	(disconnect dbconn)
	rows)

(define (get-games [sort-by "title"] [sort-dir "ASC"])
	(get-rows (string-append "SELECT g.RowId, g.Title, g.Genre, g.Platform, g.NumberOwned, " 
				 "g.NumberOfManuals, g.DatePurchased, g.ApproximatePurchaseDate, " 
				 "g.Notes, p.Name as PlatformName " 
				 "FROM Game as g "
				 "JOIN Platform AS p ON g.Platform=p.RowId "
				 "ORDER BY " sort-by " " sort-dir ";")))

(define (get-platforms)
	(get-rows "SELECT RowId, * FROM Platform;"))

(define (get-genres)
	(get-rows "SELECT RowId, * From Genre;"))

(define (get-hardware-types)
	(get-rows "SELECT RowId, * FROM HardwareType;"))

(define (get-hardware)
	(get-rows "SELECT RowId, * FROM Hardware;"))
