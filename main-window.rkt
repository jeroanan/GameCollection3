#lang racket

(require racket/gui/base)

(require "queries.rkt"
	 "parse.rkt"
	 "structs.rkt"
	 "list-tools.rkt"
	 "game-details-dialog.rkt"
	 "code-description-list-dialog.rkt")

(define window-height 300)
(define window-width 1000)

(define (launch-gui)
	(define frame (new frame%
			   [label "Game Collection"]
			   [height window-height]
			   [width window-width]))

	(define menu-bar (new menu-bar%
			      [parent frame]))

	(define (menu-do-nothing menu-item control-event)
	  #f)

	(define (menu-item-maker parent)
	  (lambda (label [callback null])
	    (define the-callback (if (null? callback) menu-do-nothing callback))
	    (new menu-item%
		 [parent parent]
		 [label label]
		 [callback the-callback])))

	(define game-menu (new menu%
			       [parent menu-bar]
			       [label "&Game"]))

	(define game-menu-item-maker (menu-item-maker game-menu))

	(define new-game-menu-item (game-menu-item-maker "&New"))
	(define game-details-menu-item (game-menu-item-maker "&Details"))
	(define quit-menu-item (game-menu-item-maker "&Quit" (lambda (x y) (exit)))) 

	(define collection-menu (new menu%
				     [parent menu-bar]
				     [label "&Collection"]))
		  
	(define collection-menu-item-maker (menu-item-maker collection-menu))

	(define (cmwe caption f t) (collection-menu-item-maker caption (lambda (x y) (f frame t))))
	(define platforms-menu-item (cmwe "&Platforms" show-code-description-list-dialog 'platform))
	(define genres-menu-item (cmwe "&Genres" show-code-description-list-dialog 'genre))

	(define games (parse-games (get-games)))
	(define platforms (parse-platforms (get-platforms)))

	(define sort-col "Title")
	(define sort-dir "ASC")

	(define (from-game field-func)
	  (map (lambda (x) (field-func x)) games))

	(define (list-box-click)
	  #f)

	(define (list-box-dclick)
	  (define selection (first (send games-list get-selections)))
	  (define selected-game (send games-list get-data selection))
	  (show-game-details-dialog frame selected-game #:ok-button-callback populate-games-list))
	
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
			     #:click-callback list-box-click
			     #:col-heading-callback list-box-col-heading-click
			     #:double-click-callback list-box-dclick))

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
	  (set-list-column-items games-list 1 game-platforms)
	  (set-listbox-data games-list games))

	(send games-list set-column-label 0 "Title")
	(send games-list set-column-width 0 300 0 1000000)

	(define (add-games-column label contents)
	  (add-list-column games-list label 300 contents))
	
	(add-list-column games-list "Platform" 300)
	(populate-games-list)
	(send frame show #t))

(launch-gui)
