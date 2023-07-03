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
      (attr :href (make-url :domains '("keyword")
                            :path (format NIL "/filter/type/~a" (dm:field type "title"))))
      (data :lookup (dm:field type "lookup")))))

(define-page frontpage "keyword/" (:clip "listing.ctml")
  (let ((types (types)))
    (r-clip:process
     T :title "Frontpage"
       :types types
       :typemap (make-typemap types)
       :reviews (dm:get 'reviews (db:query :all) :amount 100 :sort '((time :DESC))))))

(define-page filter "keyword/filter/(.+)" (:uri-groups (filter) :clip "listing.ctml")
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
