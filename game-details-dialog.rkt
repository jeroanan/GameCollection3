#lang racket

(require racket/gui/base)

(require "structs.rkt"
	 "parse.rkt"
	 "queries.rkt"
	 "button-tools.rkt"
	 "choice-tools.rkt"
	 "text-field-tools.rkt")

(provide show-game-details-dialog)

(define window-height 150)
(define window-width 500)

(define (show-game-details-dialog parent 
				  [the-game null]
				  #:ok-button-callback [ok-button-callback null]
				  #:cancel-button-callback [cancel-button-callback null])

  (define (get-dialog-title)
    (if (null? the-game) "New Game" (game-title the-game)))

  (define dialog (new dialog%
		      [label (get-dialog-title)] 
		      [parent parent]
		      [height window-height]
		      [width window-width]))

  (define (get-codes xs) 
    (append (list "") (map (lambda (x) (code-description-code x)) xs)))   

  (define genre-codes (get-codes (parse-genres (get-genres))))
  (define platform-codes (get-codes (parse-platforms (get-platforms)))) 

  (define (game-attr attr-f)
    (if (null? the-game) "" (attr-f the-game)))

  (define the-platform (parse-platform (get-platform-by-id (game-attr game-platform)))) 
  (define the-genre (parse-genre (get-genre-by-id (game-attr game-genre))))

  (define game-id (new-text-field dialog "Id" 
				  (if (null? the-game) "" (number->string (game-row-id the-game)))
				  #f))

  (define title (new-text-field dialog "Title" (game-attr game-title)))

  (define genres (new-choice dialog "Genre" genre-codes))
  (set-choice-selection genres (code-description-code the-genre))

  (define platforms (new-choice dialog "Platform" platform-codes))
  (set-choice-selection platforms (code-description-code the-platform))

  (define number-owned (number-field dialog "Number Owned" (game-attr game-number-owned)))
  (define number-boxed (number-field dialog "Number Boxed" (game-attr game-number-boxed)))
  (define number-manuals (number-field dialog "Number of Manuals" (game-attr game-number-of-manuals)))

  (define hpanel (new horizontal-panel%
		      [parent dialog]
		      [alignment (list 'right 'center)]))

  (define button-maker (get-simple-button-maker hpanel))

  (define (cancel-button-clicked)
    (unless (null? cancel-button-callback) (cancel-button-callback))
    (send dialog show #f))

  (define (ok-button-clicked)
    (define selected-platform-name (send platforms get-string-selection)) 
    (define selected-platform-id (code-description-row-id (parse-platform (get-platform-by-name selected-platform-name))))

    (define selected-genre-name (send genres get-string-selection)) 
    (define selected-genre-id (code-description-row-id (parse-genre (get-genre-by-name selected-genre-name))))

    (define save-game (game [send game-id get-value]
			    [send title get-value]
			    selected-genre-id
			    selected-platform-id
			    [send number-owned get-value]
			    [send number-boxed get-value]
			    [send number-manuals get-value]
			    [game-attr game-date-purchased]
			    [game-attr game-approximate-purchase-date]
			    [game-attr game-notes]))

    (if (null? the-game) (create-game save-game) (update-game save-game))

    (unless (null? ok-button-callback) (ok-button-callback))
    (send dialog show #f))

  (define cancel-button (button-maker "&Cancel" cancel-button-clicked))

  (define ok-button (button-maker "&OK" ok-button-clicked)) 

  (when (null? the-game) (send game-id show #f))
  (send dialog show #t))
