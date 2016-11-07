#lang racket

(provide new-choice
	 set-choice-selection)

(require racket/gui/base)

(define (new-choice parent label choices) 
  (new choice% 
	 [label label]
	 [parent parent] 
	 [choices choices]))

(define (set-choice-selection choice-widget selected-text) 
  (define selected-index (send choice-widget find-string selected-text)) 
  (unless (eq? selected-index #f) (send choice-widget set-selection selected-index)))
