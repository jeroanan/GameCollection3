#lang racket

(require "structs.rkt")

(provide parse-game
	parse-games
	parse-platform
	parse-platforms
	parse-genre
	parse-genres
	parse-hardware-type
	parse-hardware-types
	parse-hardware
	parse-hardwares
	parse-code-description
	parse-code-descriptions)

(define (vr the-vector ref-index)
	(vector-ref the-vector ref-index))
	
(define (parse-code-description result-set)
	(code-description 
		(vr result-set 0)
		(vr result-set 1)
		(vr result-set 2)))

(define (parse-code-descriptions result-set)
  (map parse-code-description result-set))

(define (parse-game result-set)
	(game 
		(vr result-set 0)
		(vr result-set 1)
		(vr result-set 2)
		(vr result-set 3)
		(vr result-set 4)
		(vr result-set 5)
		(vr result-set 6)
		(vr result-set 7)
		(vr result-set 8)
		(vr result-set 9)))

(define (parse-games results)
	(map parse-game results))

(define (parse-platform result-set)
	(parse-code-description result-set))

(define (parse-platforms result-set)
	(map parse-platform result-set))

(define (parse-genre result-set)
	(parse-code-description result-set))

(define (parse-genres result-set)
	(map parse-genre result-set))

(define (parse-hardware-type result-set)
	(parse-code-description result-set))

(define (parse-hardware-types result-set)
	(map parse-hardware-type result-set))

(define (parse-hardware result-set)
	(hardware
		(vr result-set 0)
		(vr result-set 1)
		(vr result-set 2)
		(vr result-set 3)
		(vr result-set 4)
		(vr result-set 5
		(vr result-set 6))))

(define (parse-hardwares result-set)
	(map parse-hardware result-set))
