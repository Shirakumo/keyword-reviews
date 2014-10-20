#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:keyword-reviews)

(defun review-accessible-p (review &optional (user (auth:current)))
  (let ((review (ensure-review review)))
    (or (user:check user '(keyword review edit))
        (string-equal (user:username user) (dm:field review "author")))))

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
  (api-output (first (db:select 'keyword-types (db:query (:= 'title title)) :amount 1))))

(define-api keyword/type/make (title icon &optional lookup) (:access (keyword type make))
  (with-api-error (make-type title icon lookup))
  (api-return "Type created."))

(define-api keyword/type/delete (title) (:access (keyword type delete))
  (with-api-error (delete-type title))
  (api-return "Type deleted."))

(define-api keyword/type/list () ()
  (api-return (db:select 'keyword-types (db:query :all))))

(define-api keyword/review/info (review) ()
  (api-output (first (db:select 'keyword-reviews (db:query (:= '_id review)) :amount 1))))

(user:add-default-permission '(keyword review make))

(define-api keyword/review/make (type item review) (:access (keyword review make))
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
    ))
