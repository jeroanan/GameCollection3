#lang racket

(require racket/gui/base)

(require "queries.rkt"
	 "parse.rkt"
	 "structs.rkt"
	 "list-tools.rkt")

(define window-height 300)
(define window-width 1000)

(define (launch-gui)
	(define frame (new frame%
			   [label "Game Collection"]
			   [height window-height]
			   [width window-width]))
		  
	(define games (parse-games (get-games)))
	(define platforms (parse-platforms (get-platforms)))

	(define sort-col "Title")
	(define sort-dir "ASC")

	(define (from-game field-func)
	  (map (lambda (x) (field-func x)) games))

	(define (list-box-click)
	  (display "moo")
	  (newline))

	(define (list-box-col-heading-click col-index)
	  (define new-sort-col
	    (cond
	      [(eq? 0 col-index) "Title"]
	      [(eq? 1 col-index) "PlatformName"]))

	  (define (toggle-sort-direction)
	    (if (eq? "ASC" sort-dir) "DESC" "ASC")) 

	  ;; If it's the same sort column as last time
	  ;; then we just want to toggle the sort direction.
	  (when (eq? new-sort-col sort-col)
	    (set! sort-dir (toggle-sort-direction)))

	  (set! sort-col new-sort-col)
	  (populate-games-list))
			
	(define games-list (new-list-box 
			     frame 
			     window-width 
			     [from-game game-title]
			     list-box-click
			     list-box-col-heading-click))

	(define (populate-games-list)
	  (set! games (parse-games (get-games sort-col sort-dir)))

	  (define game-platforms
	    (map (lambda (x)
		   (code-description-description 
		     (first (filter 
			      (lambda (y) 
				(eq? (string->number (game-platform x)) 
				     (code-description-row-id y))) 
			      platforms)))) 
		 games))
	  
	  (set-list-column-items games-list 0 (from-game game-title))
	  (set-list-column-items games-list 1 game-platforms))
	

	(send games-list set-column-label 0 "Title")
	(send games-list set-column-width 0 300 0 1000000)

	(define (add-games-column label contents)
	  (add-list-column games-list label 300 contents))
	
	(add-list-column games-list "Platform" 300)
	(populate-games-list)
	(send frame show #t))

(launch-gui)
