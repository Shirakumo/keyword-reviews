#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

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
