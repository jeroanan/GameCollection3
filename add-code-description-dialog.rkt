#lang racket

(require racket/gui/base)

(require "queries.rkt"
	 "parse.rkt"
	 "structs.rkt"
	 "button-tools.rkt"
	 "text-field-tools.rkt"
	 "caution-box.rkt")

(provide show-add-code-description-dialog)

(define (show-add-code-description-dialog parent 
					  record-type
					  #:ok-button-callback [ok-button-callback null]
					  #:cancel-button-callback [cancel-button-callback null])

  (define window-height 75)
  (define window-width 500)

  (define article "")
  (define window-label "")
  (define already-exists-message "")

  (define (platform-or-genre if-platform if-genre)
    (cond [(eq? record-type 'platform) if-platform]
	  [(eq? record-type 'genre) if-genre]))

  (define (set-strings)
    
    (set! article (platform-or-genre "Platform" "Genre"))
    (set! window-label (string-append "New " article))
    (set! already-exists-message (string-append article " already exists")))
   
  (set-strings)

  (define dialog (new dialog%
		      [parent parent]
		      [label window-label]
		      [height window-height]
		      [width window-width]))

  (define (name-field-changed)
    (send ok-button enable (not (eq? "" (get-name)))))
  
  (define name-field (new-text-field dialog "Name" #:on-text-change name-field-changed))

  (define hpanel (new horizontal-panel%
		      [parent dialog]
		      [alignment (list 'right 'center)]))
  
  (define button-maker (get-simple-button-maker hpanel))

  (define (cancel-button-click)
    (send dialog show #f)
    (unless (null? cancel-button-callback) (cancel-button-callback)))
  
  (define cancel-button (button-maker "Cancel" cancel-button-click))
    
  (define (ok-button-click)
    (define (do-save) 
      (define item (code-description -1 (get-name) (get-name)))
      ((get-save-function) item)
      (send dialog show #f)
      (unless (null? ok-button-callback) (ok-button-callback)))

    (define existing-item (parse-code-description ((get-exists-function) (get-name))))
    (if 
      (eq? "" (code-description-code existing-item)) 
      (do-save)
      (make-caution-box dialog already-exists-message)))
  
  (define ok-button (button-maker "OK" ok-button-click))
  (send ok-button enable #f) 

  (define (get-name) (send name-field get-value))
  
  (define (get-exists-function) (platform-or-genre get-platform-by-name get-genre-by-name))
  
  (define (get-save-function) (platform-or-genre add-platform add-genre))

  (send dialog show #t))
