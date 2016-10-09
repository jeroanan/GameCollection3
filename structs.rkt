#lang racket

(provide (all-defined-out))

(struct game (
	title
	genre
	platform
	number-owned
	number-boxed
	number-of-manuals
	date-purchased
	approximate-purchase-date
	notes))

(struct code-description (
	code
	description))

(struct hardware (
	name
	hardware-type
	platform
	number-owned
	number-boxed
	notes))
