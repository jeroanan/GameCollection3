#lang racket

(require db)

(require "dbinit.rkt"
	"queries.rkt"
	"structs.rkt"
	"parse.rkt"
	"main-window.rkt")

(init-db)                      
(launch-gui)
