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
	(get-rows "SELECT * FROM Game;"))

(define (get-platforms)
	(get-rows "SELECT * FROM Platform;"))

(define (get-genres)
	(get-rows "SELECT * From Genre;"))

(define (get-hardware-types)
	(get-rows "SELECT * FROM HardwareType;"))

(define (get-hardware)
	(get-rows "SELECT * FROM Hardware;"))
