(in-package #:keyword-reviews)

(define-trigger user:ready ()
  (defaulted-config (list
                     (perm keyword review make))
                    :permissions :default)
  (apply #'user:add-default-permissions (config :permissions :default)))

(defmacro with-api-error (&body body)
  `(handler-case (progn ,@body)
     (radiance-error (err)
       (error 'api-error :message (message err)))
     (error (err)
       (error 'api-error :message (princ-to-string err)))))

(defun api-return (output &optional (redirect (referer)))
  (if (string= (post/get "browser") "true")
      (redirect redirect 303)
      (api-output output)))

(define-api keyword/type/info (title) ()
  (api-output (first (db:select 'types (db:query (:= 'title title)) :amount 1))))

(define-api keyword/type/make (title icon &optional lookup) (:access (perm keyword type make))
  (with-api-error (make-type title icon lookup))
  (api-return "Type created."))

(define-api keyword/type/edit (type &optional title icon lookup) (:access (perm keyword type edit))
  (with-api-error (edit-type type :title title :icon icon :lookup lookup))
  (api-return "Type edited."))

(define-api keyword/type/delete (title) (:access (perm keyword type edit))
  (with-api-error (delete-type title))
  (api-return "Type deleted."))

(define-api keyword/type/list () ()
  (api-return (db:select 'types (db:query :all))))

(define-api keyword/review/info (review) ()
  (api-output (first (db:select 'reviews (db:query (:= '_id review)) :amount 1))))

(define-api keyword/review/make (type item review) (:access (perm keyword review make))
  (with-api-error (make-review type (user:username (auth:current)) item review))
  (api-return "Review created."))

(define-api keyword/review/delete (review) ()
  (with-api-error
    (let ((review (ensure-review review)))
      (assert (review-accessible-p review) ()
              'api-auth-error :message "You do not have the permission to delete this review.")
      (delete-review review)))
  (api-return "Review deleted."))

(define-api keyword/review/edit (review &optional item review-text) ()
  (with-api-error
    (let ((review (ensure-review review)))
      (assert (review-accessible-p review) ()
              'api-auth-error :message "You do not have the permission to edit this review.")
      (edit-review review :item item :review-text review-text)))
  (api-return "Review edited."))

(define-api keyword/review/list (&optional type author item review amount skip) ()
  (with-api-error
    (assert (or type author item review) ()
            "At least one of TYPE AUTHOR TITLE REVIEW is required.")
    (let ((amount (parse-integer (or* amount "20")))
          (skip (parse-integer (or* skip "0"))))
      (assert (<= 0 amount 20) () "AMOUNT must be between 0 and 20.")
      (assert (<= 0 skip) () "SKIP must be 0 or greater."))
    ;;Make this work.
    (api-output (reviews :type type :author author :item item :review review :amount amount :skip skip))))
