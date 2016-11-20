#lang racket

(require xml)

(require "../queries.rkt" 
	 "../parse.rkt" 
	 "../structs.rkt")

(define (all-games-report [file-name null])
  (define report-title "All Games")
  (define all-games (parse-games (get-games)))
  (define all-platforms (parse-code-descriptions (get-platforms)))

  (define (parse-game game)
    (define (game-platform-name)
      (define filtered (filter (lambda (x) (eq? (code-description-row-id x) (string->number (game-platform game)))) all-platforms))
      (if (empty? filtered) "" (code-description-code (first filtered))))

    `(tr
       (td ,(game-title game))
       (td ,(game-platform-name))))

  (define xml `(html
		 (head
		   (title ,report-title)
		   (link ([rel "stylesheet"] [href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"]))
		 (body
		   (div ([class "container"])
			(h1 ,report-title)
		     (span ,(string-append "Showing " (number->string (length all-games)) " games."))
		     (p)
		     (table ([class "table table-striped"])
		       (thead
			 (th "Title")
			 (th "Platform"))
		       (tbody
			 ,@(map parse-game all-games))))))))

  (define xml-str (xexpr->string xml))

  (print xml-str)
  (newline) 

  (unless (null? file-name) 
    (begin
      (when (file-exists? file-name) (delete-file file-name))
      (display-to-file xml-str file-name))))

