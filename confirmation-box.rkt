#lang racket

(require racket/gui/base)

(require "button-tools.rkt")

(provide make-confirmation-box)

(define (make-confirmation-box parent 
			       message 
			       [title "Confirm"]
			       #:yes-button-callback [yes-button-callback null]
			       #:no-button-callback [no-button-callback null]
			       #:cancel-button-callback [cancel-button-callback null])

  (define dialog (new dialog%
		      [parent parent]
		      [label title]
		      [min-width 300]
		      [min-height 50]))

  (define message-container (new horizontal-pane%
                                 [parent dialog]))

  (define button-container (new horizontal-pane%
                                [parent dialog]
                                [alignment (list 'center 'center )]))

  (define message-icon (new message%
			    [parent message-container]
			    [label 'app]))


  (define confirm-message (new message%
                               [parent message-container]
                               [label message]))

  (define button-maker (get-simple-button-maker button-container))

  (define (button-callback callback-func)
    (lambda () 
      (unless (null? callback-func) (callback-func))
      (send dialog show #f)))

  (define yes-button (button-maker "&Yes" (button-callback yes-button-callback)))

  (define no-button (button-maker "&No" (button-callback no-button-callback)))
  
  (define cancel-button (button-maker "&Cancel" (button-callback cancel-button-callback)))
  (send dialog show #t))
