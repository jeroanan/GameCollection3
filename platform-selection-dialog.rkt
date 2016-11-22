#lang racket

(require racket/gui/base
	 framework/gui-utils)

(require "structs.rkt"
	 "parse.rkt"
	 "queries.rkt"
	 "choice-tools.rkt")

(provide show-platform-selection-dialog)

(define window-height 50)
(define window-width 300)

(define (show-platform-selection-dialog parent 
					#:ok-button-callback [ok-button-callback null]
					#:cancel-button-callback [cancel-button-callback null])

  (define all-platforms (parse-platforms (get-platforms)))

  (define dialog (new dialog%
		      [label "Select Platform"]
		      [parent parent]
		      [height window-height]
		      [width window-width]))

  (define platform-names (map (lambda (x) (code-description-code x)) all-platforms))
  (define platform-choice (new-choice dialog "Platform" platform-names))

  (define hpane (new horizontal-panel% 
		     [parent dialog]
		     [alignment (list 'right 'center)]))
  
  (define (cancel-button-clicked source event)
    (unless (null? cancel-button-callback) (cancel-button-callback))
    (send dialog show #f))

  (define (ok-button-clicked source event)
    (unless (null? ok-button-callback) 
      (begin
	(define selected-platform-name (send platform-choice get-string-selection))
	(define selected-platform-id (code-description-row-id (parse-platform (get-platform-by-name selected-platform-name))))
	(ok-button-callback selected-platform-id)))
    (send dialog show #f))

  (gui-utils:ok/cancel-buttons hpane ok-button-clicked cancel-button-clicked)

  (send dialog show #t))
