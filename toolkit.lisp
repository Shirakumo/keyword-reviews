(in-package #:keyword-reviews)

(defun ensure-type (object)
  (or
   (etypecase object
     (dm:data-model object)
     (db:id (dm:get-one 'types (db:query (:= '_id object))))
     (string (dm:get-one 'types (db:query (:= 'title (string-downcase object))))))
   (error "No such type found.")))

(defun ensure-review (object)
  (or
   (etypecase object
     (dm:data-model object)
     (db:id (dm:get-one 'reviews (db:query (:= '_id object))))
     (string (dm:get-one 'reviews (db:query (:= '_id (parse-integer object))))))
   (error "No such review found.")))

(defun types ()
  (dm:get 'types (db:query :all)))

(defmacro %enumerate-combinations (&rest fields)
  (labels ((permute (items)
             (loop for (item . rest) on items
                   nconc (cons (cons item NIL)
                               (mapcar #'(lambda (rest) (cons item rest))
                                       (permute rest))))))
    `(cond ,@(loop for mut in (sort (permute fields) #'> :key #'length)
                   collect `((and ,@mut)
                             (db:query (:and ,@(loop for item in mut
                                                     collect `(:= ',item ,item)))))))))

(defun reviews (&key type author item review (amount 20) (skip 0))
  (let ((type (and type (dm:id (ensure-type type)))))
    (dm:get 'reviews (%enumerate-combinations type author item review)
            :amount amount :skip skip)))

(defun review-accessible-p (review &optional (user (auth:current)))
  (and user
       (let ((review (ensure-review review)))
         (or (user:check user (perm keyword review edit))
             (string-equal (user:username user) (dm:field review "author"))))))
