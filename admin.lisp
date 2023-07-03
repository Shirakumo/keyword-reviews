(in-package #:keyword-reviews)

(define-implement-trigger admin
  (admin:define-panel keyword types (:clip "admin.ctml" :icon "fa-hashtag" :tooltip "Manage keyword review types")
    (with-actions (error info)
        ((:delete
          (dolist (type (or (post-var "selected[]") (list (post-var "type"))))
            (delete-type (db:ensure-id type)))
          (setf info "Type deleted."))
         (:add
          (make-type (post-var "title") (post-var "icon"))
          (setf info "Type added.")))
      (r-clip:process
       T :error error :info info :types (types)))))
