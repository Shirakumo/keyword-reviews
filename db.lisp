#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:keyword-reviews)

(define-trigger db:connected ()
  (when (db:create 'types '((title (:varchar 16))
                            (icon (:varchar 16))
                            (lookup (:varchar 128))))
    (make-type "Movie" "fa-film")
    (make-type "Game" "fa-gamepad")
    (make-type "Book" "fa-book")
    (make-type "Place" "fa-map-signs"))
  (db:create 'reviews '((type :id)
                        (time (:integer 5))
                        (author (:varchar 32))
                        (item (:varchar 64))
                        (review (:varchar 32)))))
