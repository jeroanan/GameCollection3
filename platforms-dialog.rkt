#lang racket

(require racket/gui/base)

(require "structs.rkt"
	 "parse.rkt"
	 "queries.rkt"
	 "button-tools.rkt"
	 "list-tools.rkt"
	 "confirmation-box.rkt"
	 "add-code-description-dialog.rkt")
	
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
  
  (define sort-direction "ASC")

  (define (populate-platform-list) 
    (set! platforms (parse-platforms (get-platforms sort-direction))) 
    (set! platform-names (from-platforms code-description-code)) 
    (set! platform-descriptions (from-platforms code-description-description)) 
    (set! platform-ids (from-platforms code-description-row-id))

    (send platform-list clear) 

    (define (set-col idx data) (set-list-column-items platform-list idx data))
    (for ([_ platform-names]) (send platform-list append ""))
    (set-col 0 platform-names))

  (define (col-heading-click col-index)
    (set! sort-direction (if (eq? sort-direction "ASC") "DESC" "ASC"))
    (populate-platform-list))

  (define platform-list (new-list-box dialog
				      window-width
				      #:min-height 450
				      platform-names
				      #:col-heading-callback col-heading-click))
  
  (send platform-list set-column-label 0 "Platform Name") 

  (populate-platform-list)

  (define hpanel (new horizontal-panel%
		      [parent dialog]))
  
  (define lpanel (new horizontal-panel%
		      [parent hpanel]
		      [alignment (list 'left 'center)]))
  
  (define rpanel (new horizontal-panel%
		      [parent hpanel]
		      [alignment (list 'right 'center)]))
  
  (define rpanel-button-maker (get-simple-button-maker rpanel))
  (define lpanel-button-maker (get-simple-button-maker lpanel))
  
  (define (delete-button-clicked)
    (make-confirmation-box dialog "Are you sure you want to delete this platform?" "Confirm Platform Deletion"))

  (define delete-button (lpanel-button-maker "&Delete" delete-button-clicked))

  (define (new-button-clicked)
    (define (ok-button-callback)
      (populate-platform-list))

    (show-add-code-description-dialog dialog 'platform #:ok-button-callback ok-button-callback))
	
  (define new-button (rpanel-button-maker "&New" new-button-clicked))
  (define close-button (rpanel-button-maker "&Close" (lambda () (send dialog show #f))))

  (send dialog show #t))
