#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:keyword-reviews)

(defun make-typemap (types)
  (let ((table (make-hash-table)))
    (loop for type in types
          do (setf (gethash (dm:id type) table) type))
    table))

(lquery:define-lquery-function keyword-fill-type (node id typemap)
  (let ((type (gethash id typemap)))
    (lquery:$ node
      (add-class (dm:field type "icon"))
      (text (dm:field type "title"))
      (attr :href (external-pattern "keyword/filter/type/{0}" (dm:field type "title")))
      (data :lookup (dm:field type "lookup")))))

(define-page frontpage "keyword/" (:lquery (@template "listing.ctml"))
  (let ((types (types)))
    (r-clip:process
     T :title "Frontpage"
       :types types
       :typemap (make-typemap types)
       :reviews (dm:get 'keyword-reviews (db:query :all) :amount 100 :sort '((time :DESC))))))

(define-page filter "keyword/filter/(.+)" (:uri-groups (filter) :lquery (@template "listing.ctml"))
  (let ((filters (loop with filters = ()
                       for (arg value) on (cl-ppcre:split "/" filter) by #'cddr
                       for filter = (find arg '(:TYPE :AUTHOR :ITEM :REVIEW) :test #'string-equal)
                       when filter
                       do (push filter filters)
                          (push value filters)
                       finally (return (nreverse filters))))
        (types (types)))
    (r-clip:process
     T :title (format NIL "Filtered by ~{~a: ~a~^, ~}" filters)
       :types types
       :filters filters
       :typemap (make-typemap types)
       :reviews (when filters (apply #'reviews :amount 100 filters)))))
