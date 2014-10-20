#|
 This file is a part of TyNETv5/Radiance
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:cl-user)
(asdf:defsystem #:keyword-reviews
  :defsystem-depends-on (:radiance)
  :class "radiance:module"
  :components ((:file "module")
               (:file "db")
               (:file "toolkit")
               (:file "objects")
               (:file "api")
               (:file "front"))
  :depends-on ((:interface :database)
               (:interface :dm)
               (:interface :auth)
               :r-clip
               :local-time
               :cl-ppcre))
