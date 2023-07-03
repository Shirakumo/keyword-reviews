(in-package #:rad-user)
(define-module #:keyword-reviews
  (:use #:cl #:radiance)
  ;; objects.lisp
  (:export
   #:make-type
   #:delete-type
   #:edit-type
   #:make-review
   #:delete-review
   #:edit-review)
  ;; toolkit.lisp
  (:export
   #:ensure-type
   #:ensure-review
   #:types
   #:reviews))
(in-package #:keyword-reviews)
