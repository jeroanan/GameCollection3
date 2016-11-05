#lang racket

(require racket/gui/base)

(require "structs.rkt"
	 "parse.rkt"
	 "queries.rkt"
	 "button-tools.rkt"
	 "choice-tools.rkt")

(provide show-game-details-dialog)

(define window-height 150)
(define window-width 500)

(define (show-game-details-dialog parent game)
  (define dialog (new dialog%
		      [label (game-title game)]
		      [parent parent]
		      [height window-height]
		      [width window-width]))

  (define (new-text-field label init-value [enabled #t])
    (new text-field%
	 [label label]
	 [parent dialog]
	 [enabled enabled]
	 [init-value init-value]))

  (define (get-codes xs) 
    (append (list "") (map (lambda (x) (code-description-code x)) xs)))   

  (define genre-codes (get-codes (parse-genres (get-genres))))
  (define platform-codes (get-codes (parse-platforms (get-platforms)))) 

  (define the-platform (parse-platform (get-platform-by-id (game-platform game))))
  (define the-genre (parse-genre (get-genre-by-id (game-genre game))))

  (define game-id (new-text-field "Id" (number->string (game-row-id game)) #f))
  (define title (new-text-field "Title" (game-title game)))

  (define genres (new-choice dialog "Genre" genre-codes))
  (set-choice-selection genres (code-description-code the-genre))

  (define platforms (new-choice dialog "Platform" platform-codes))
  (set-choice-selection platforms (code-description-code the-platform))

  (define (number-field label text)
    (new-text-field label 
		    (if (number? text) (number->string text) "0")))

  (define number-owned (number-field "Number Owned" (game-number-owned game)))
  (define number-boxed (number-field "Number Boxed" (game-number-boxed game)))
  (define number-manuals (number-field "Number of Manuals" (game-number-of-manuals game)))

  (define hpanel (new horizontal-panel%
		      [parent dialog]
		      [alignment (list 'right 'center)]))

  (define button-maker (get-simple-button-maker hpanel))

  (define cancel-button (button-maker "&Cancel" (lambda () (send dialog show #f))))
  (define ok-button (button-maker "&OK" (lambda () #f)))

  (send dialog show #t))
