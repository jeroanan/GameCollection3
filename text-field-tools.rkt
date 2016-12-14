#lang racket

(require racket/gui/base)

(provide new-text-field
	 number-field)

(define (new-text-field parent 
			label 
			[init-value ""] 
			[enabled #t]
			#:on-text-change [on-text-change null])
  (new text-field%
       [label label]
       [parent parent]
       [enabled enabled]
       [init-value init-value]
       [vert-margin 5]
       [horiz-margin 10]
       [callback (make-text-field-callback (if (null? on-text-change) (lambda () #f) on-text-change))]))

(define (number-field parent label text)
  (new-text-field parent
		  label 
		  (if (number? text) (number->string text) "0")))

(define (make-text-field-callback callback-func)
  (lambda (sender control-event)
    (define event-type (send control-event get-event-type))
    (cond
      [(eq? event-type 'text-field) (callback-func)]
      [else #f])))
