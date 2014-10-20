#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:keyword-reviews)

(defun date-machine (stamp)
  (when (integerp stamp) (setf stamp (local-time:universal-to-timestamp stamp)))
  (let ((local-time:*default-timezone* local-time:+utc-zone+))
    (local-time:format-timestring
     NIL stamp :format '((:year 4) "-" (:month 2) "-" (:day 2) "T" (:hour 2) ":" (:min 2) ":" (:sec 2)))))

(defun date-human (stamp)
  (when (integerp stamp) (setf stamp (local-time:universal-to-timestamp stamp)))
  (let ((local-time:*default-timezone* local-time:+utc-zone+))
    (local-time:format-timestring
     NIL stamp :format '((:year 4) "." (:month 2) "." (:day 2) " " (:hour 2) ":" (:min 2) ":" (:sec 2)))))

(defun date-fancy (stamp)
  (when (integerp stamp) (setf stamp (local-time:universal-to-timestamp stamp)))
  (let ((local-time:*default-timezone* local-time:+utc-zone+))
    (local-time:format-timestring
     NIL stamp :format '(:long-weekday ", " :ordinal-day " of " :long-month " " :year ", " :hour ":" :min ":" :sec))))

(lquery:define-lquery-function keyword-fill-time (node time)
  (let ((stamp (local-time:universal-to-timestamp time)))
    (setf (plump:attribute node "datetime")
          (date-machine stamp))
    (setf (plump:attribute node "title")
          (date-fancy stamp))
    (setf (plump:children node) (plump:make-child-array))
    (plump:make-text-node node (date-human stamp))))

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
      (attr :href (format NIL "/filter/type/~a" (dm:field type "title")))
      (data :lookup (dm:field type "lookup")))))

(define-page frontpage #@"keyword/" (:lquery (template "listing.ctml"))
  (let ((types (types)))
    (r-clip:process
     T :title "Frontpage"
       :types types
       :typemap (make-typemap types)
       :reviews (dm:get 'keyword-reviews (db:query :all) :amount 100 :sort '((time :DESC))))))

(define-page filter #@"keyword/filter/(.+)" (:uri-groups (filter) :lquery (template "listing.ctml"))
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
       :typemap (make-typemap types)
       :reviews (when filters (apply #'reviews filters)))))
