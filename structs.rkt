#lang racket

(provide (all-defined-out))

(struct game (
	row-id
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
	row-id
	code
	description))

(struct hardware (
	row-id
	name
	hardware-type
	platform
	number-owned
	number-boxed
	notes))
