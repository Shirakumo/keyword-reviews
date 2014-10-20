#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:keyword-reviews)

(define-trigger db:connected ()
  (db:create 'keyword-types '((title (:varchar 16))
                              (icon (:varchar 16))
                              (lookup (:varchar 128))))
  (db:create 'keyword-reviews '((type :id)
                                (time (:integer 5))
                                (author (:varchar 32))
                                (item (:varchar 64))
                                (review (:varchar 32)))))
