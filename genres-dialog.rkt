#lang racket

(require racket/gui/base)

(require "structs.rkt"
	 "parse.rkt"
	 "queries.rkt"
	 "button-tools.rkt"
	 "list-tools.rkt")
	
(provide show-genres-dialog)

(define window-height 300)
(define window-width 500)

(define (show-genres-dialog parent)
  (define dialog (new dialog%
		      [label "Genres"]
		      [parent parent]
		      [height window-height]
		      [width window-width]))

  (define genres (parse-genres (get-genres)))
  (define (from-genres accessor) (map (lambda (x) (accessor x)) genres))
  (define genre-names (from-genres code-description-code))
  (define genre-ids (from-genres code-description-row-id))
  
  (define genre-list (new-list-box dialog
				      window-width
				      #:min-height 450
				      genre-names))
  
  (send genre-list set-column-label 0 "Genre Name")

  (define hpanel (new horizontal-panel%
		      [parent dialog]
		      [alignment (list 'right 'center)]))
  
  (define button-maker (get-simple-button-maker hpanel))
  (define close-button (button-maker "&Close" (lambda () (send dialog show #f))))

  (send dialog show #t))
