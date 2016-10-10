#lang racket

(require racket/gui/base)

(require "queries.rkt"
	 "parse.rkt"
	 "structs.rkt"
	 "list-tools.rkt")

(define window-height 300)
(define window-width 1000)

(define frame (new frame%
		   [label "Game Collection"]
		   [height window-height]
		   [width window-width]))
		  
(define games (parse-games (get-games)))
(define platforms (parse-platforms (get-platforms)))

(define (from-game field-func)
  (map (lambda (x) (field-func x)) games))

(define games-list (new-list-box 
		     frame 
		     window-width 
		     (from-game game-title)
		     (lambda () #f)))

(send games-list set-column-label 0 "Title")
(send games-list set-column-width 0 300 0 1000000)

(define (add-games-column label contents)
  (add-list-column games-list label 300 contents))

(define game-platforms
  (map (lambda (x)
	 (code-description-description 
	   (first (filter 
		    (lambda (y) 
		      (eq? (string->number (game-platform x)) 
			   (code-description-row-id y))) 
		    platforms)))) 
       games))

(add-games-column "Platform" game-platforms)
(send frame show #t)
