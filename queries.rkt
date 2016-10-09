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

(define (get-games)
	(get-rows "SELECT RowId, * FROM Game;"))

(define (get-platforms)
	(get-rows "SELECT RowId, * FROM Platform;"))

(define (get-genres)
	(get-rows "SELECT RowId, * From Genre;"))

(define (get-hardware-types)
	(get-rows "SELECT RowId, * FROM HardwareType;"))

(define (get-hardware)
	(get-rows "SELECT RowId, * FROM Hardware;"))
