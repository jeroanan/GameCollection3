#lang racket

(require racket/gui/base)

(require "structs.rkt"
	 "parse.rkt"
	 "queries.rkt"
	 "button-tools.rkt"
	 "list-tools.rkt"
	 "confirmation-box.rkt"
	 "caution-box.rkt"
	 "add-code-description-dialog.rkt")
	
(provide show-code-description-list-dialog)

(define window-height 300)
(define window-width 500)

(define (show-code-description-list-dialog parent type)

  ;; strings that appear in the dialog
  (define dialog-title "")
  (define item-desc "")
  (define item-desc-lcase "")
  (define column-heading "")
  (define associated-games-message "")
  (define deletion-confirmation-message "")
  (define deletion-confirmation-title "")

  ;; functions that vary depending on the value of type.
  (define get-items (lambda () #f))
  (define get-games-by-item (lambda () #f))
  (define delete-item (lambda () #f))

  (define (init-platform-settings)
    (set! dialog-title "Platforms")
    (set! item-desc "Platform")
    (set! get-items get-platforms)
    (set! get-games-by-item get-games-by-platform)
    (set! delete-item delete-platform))

  (define (init-genre-settings)
    (set! dialog-title "Genres")
    (set! item-desc "Genre")
    (set! get-items get-genres)
    (set! get-games-by-item get-games-by-genre)
    (set! delete-item delete-genre))

  (define (init-settings)
    (match type
	   ['platform (init-platform-settings)]
	   ['genre (init-genre-settings)])

    (set! column-heading (string-append item-desc " Name"))
    (set! item-desc-lcase (string-downcase item-desc))
    (set! associated-games-message (string-append "This " item-desc-lcase " has associated games; reassign them before deleting it"))
    (set! deletion-confirmation-title (string-append "Confirm " item-desc " Deletion"))
    (set! deletion-confirmation-message (string-append "Are you sure you want to delet this " item-desc-lcase "?")))

  (init-settings)
  
  (define dialog (new dialog%
		      [label dialog-title]
		      [parent parent]
		      [height window-height]
		      [width window-width]))

  (define items null) 
  (define (from-items accessor) (map (lambda (x) (accessor x)) items))
  (define item-names (list)) 
  (define item-descriptions (list)) 
  (define item-ids (list))
  
  (define sort-direction "ASC")

  (define (populate-item-list) 
    (set! items (parse-code-descriptions (get-items sort-direction))) 
    (set! item-names (from-items code-description-code)) 
    (set! item-descriptions (from-items code-description-description)) 
    (set! item-ids (from-items code-description-row-id))

    (send item-list clear) 

    (define (set-col idx data) (set-list-column-items item-list idx data))
    (for ([_ item-names]) (send item-list append ""))
    (set-col 0 item-names)
    (set-listbox-data item-list items))

  (define (col-heading-click col-index)
    (set! sort-direction (if (eq? sort-direction "ASC") "DESC" "ASC"))
    (populate-item-list))

  (define item-list (new-list-box dialog
				      window-width
				      #:min-height 450
				      item-names
				      #:col-heading-callback col-heading-click))
  
  (send item-list set-column-label 0 column-heading) 

  (populate-item-list)

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
    (define (yes-button-callback)
      (define selected-item (get-listbox-selected-data item-list)) 
      (when (code-description? selected-item)
	(begin
	  (define selected-id (number->string (code-description-row-id selected-item)))
	  (define item-game (parse-code-descriptions (get-games-by-item selected-id)))
	  (if (eq? 0 (length item-game))
		   (delete-item selected-item)
		   (make-caution-box dialog associated-games-message))))
      (populate-item-list))

    (make-confirmation-box dialog 
			   deletion-confirmation-message
			   deletion-confirmation-title
			   #:yes-button-callback yes-button-callback))

  (define delete-button (lpanel-button-maker "&Delete" delete-button-clicked))

  (define (new-button-clicked)
    (define (ok-button-callback)
      (populate-item-list))

    (show-add-code-description-dialog dialog 'platform #:ok-button-callback ok-button-callback))
	
  (define new-button (rpanel-button-maker "&New" new-button-clicked))
  (define close-button (rpanel-button-maker "&Close" (lambda () (send dialog show #f))))

  (send dialog show #t))
