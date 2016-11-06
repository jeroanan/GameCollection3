#lang racket

(require racket/gui/base)

(require "structs.rkt"
	 "parse.rkt"
	 "queries.rkt"
	 "button-tools.rkt"
	 "list-tools.rkt")
	
(provide show-platforms-dialog)

(define window-height 300)
(define window-width 500)

(define (show-platforms-dialog parent)
  (define dialog (new dialog%
		      [label "Platforms"]
		      [parent parent]
		      [height window-height]
		      [width window-width]))

  (define platforms null) 
  (define (from-platforms accessor) (map (lambda (x) (accessor x)) platforms))
  (define platform-names (list)) 
  (define platform-descriptions (list)) 
  (define platform-ids (list))
  
  (define (populate-platform-list) 
    (set! platforms (parse-platforms (get-platforms))) 
    (set! platform-names (from-platforms code-description-code)) 
    (set! platform-descriptions (from-platforms code-description-description)) 
    (set! platform-ids (from-platforms code-description-row-id))

    (send platform-list clear) 

    (define (set-col idx data) (set-list-column-items platform-list idx data))
    (for ([_ platform-names]) (send platform-list append ""))
    (set-col 0 platform-names))

  (define platform-list (new-list-box dialog
				      window-width
				      #:min-height 450
				      platform-names))
  
  (send platform-list set-column-label 0 "Platform Name") 

  (populate-platform-list)

  (define hpanel (new horizontal-panel%
		      [parent dialog]
		      [alignment (list 'right 'center)]))
  
  (define button-maker (get-simple-button-maker hpanel))
  (define close-button (button-maker "&Close" (lambda () (send dialog show #f))))

  (send dialog show #t))
