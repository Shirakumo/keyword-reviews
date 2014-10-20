#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:keyword-reviews)

(defun ensure-type (object)
  (or
   (etypecase object
     (dm:data-model object)
     (fixnum (dm:get-one 'keyword-types (db:query (:= '_id object))))
     (string (dm:get-one 'keyword-types (db:query (:= 'title (string-downcase object))))))
   (error "No such type found.")))

(defun ensure-review (object)
  (or
   (etypecase object
     (dm:data-model object)
     (fixnum (dm:get-one 'keyword-reviews (db:query (:= '_id object))))
     (string (dm:get-one 'keyword-reviews (db:query (:= '_id (parse-integer object))))))
   (error "No such review found.")))

(defun types ()
  (dm:get 'keyword-types (db:query :all)))

(defun permute (items)
  (loop for (item . rest) on items
        nconc (cons (cons item NIL)
                    (mapcar #'(lambda (rest) (cons item rest))
                            (permute rest)))))

(defmacro %enumerate-combinations (&rest fields)
  `(cond ,@(loop for mut in (sort (permute fields) #'> :key #'length)
                 collect `((and ,@mut)
                           (db:query (:and ,@(loop for item in mut
                                                   collect `(:= ',item ,item))))))))

(defun reviews (&key type author item review (amount 20) (skip 0))
  (let ((type (and type (dm:id (ensure-type type)))))
    (dm:get 'keyword-reviews (%enumerate-combinations type author item review)
            :amount amount :skip skip)))
