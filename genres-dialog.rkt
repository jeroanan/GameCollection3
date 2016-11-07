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

  (define genres null)
  (define (from-genres accessor) (map (lambda (x) (accessor x)) genres))
  (define genre-names (list))
  (define genre-ids (list)) 
  
  (define (populate-genre-list) 
    (set! genres (parse-genres (get-genres))) 
    (set! genre-names (from-genres code-description-code)) 
    (set! genre-ids (from-genres code-description-row-id))

    (send genre-list clear) 

    (define (set-col idx data) (set-list-column-items genre-list idx data))
    (for ([_ genre-names]) (send genre-list append ""))
    (set-col 0 genre-names))
 
  (define genre-list (new-list-box dialog
				      window-width
				      #:min-height 450
				      genre-names))
  
  (send genre-list set-column-label 0 "Genre Name")

  (populate-genre-list)

  (define hpanel (new horizontal-panel%
		      [parent dialog]
		      [alignment (list 'right 'center)]))
  
  (define button-maker (get-simple-button-maker hpanel))
  (define close-button (button-maker "&Close" (lambda () (send dialog show #f))))

  (send dialog show #t))
