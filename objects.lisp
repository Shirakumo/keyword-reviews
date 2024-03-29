(in-package #:keyword-reviews)

(defun make-type (title icon &optional lookup)
  (let ((title (string-downcase title)))
    (if (dm:get-one 'types (db:query (:= 'title title)))
        (error "A type with that title already exists.")
        (dM:with-model model ('types NIL)
          (l:info :keyword "Adding type ~a." title)
          (setf (dm:field model "title") title
                (dm:field model "icon") icon
                (dm:field model "lookup") lookup)
          (dm:insert model)
          model))))

(defun delete-type (type)
  (let ((type (ensure-type type)))
    (dm:delete type)
    type))

(defun edit-type (type &key title icon lookup)
  (let ((type (ensure-type type)))
    (when title (setf (dm:field type "title") title))
    (when icon (setf (dm:field type "icon") icon))
    (when lookup (setf (dm:field type "lookup") lookup))
    (dm:save type)
    type))

(defun make-review (type author item review)
  (let ((type (ensure-type type)))
    (assert (<= 1 (length item) 64) ()
            "Title must be between 1 and 64 characters long.")
    (assert (<= 1 (length review) 32) ()
            "Review must be between 1 and 32 characters long.")
    (if (dm:get-one 'reviews (db:query (:and (:= 'type (dm:id type))
                                                     (:= 'item (string-downcase item))
                                                     (:= 'author author))))
        (error "A review for this item has already been made.")
        (dm:with-model model ('reviews NIL)
          (setf (dm:field model "type") (dm:id type)
                (dm:field model "time") (get-universal-time)
                (dm:field model "author") author
                (dm:field model "item") (string-downcase item)
                (dm:field model "review") (string-downcase review))
          (dm:insert model)
          model))))

(defun delete-review (review)
  (let ((review (ensure-review review)))
    (dm:delete review)
    review))

(defun edit-review (review &key item review-text)
  (let ((review (ensure-review review)))
    (when item (setf (dm:field review "item") (string-downcase item)))
    (when review-text (setf (dm:field review "review-text") (string-downcase review-text)))
    (dm:save review)
    review))
