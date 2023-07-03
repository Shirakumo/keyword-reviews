(asdf:defsystem #:keyword-reviews
  :defsystem-depends-on (:radiance)
  :class "radiance:virtual-module"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :license "zlib"
  :version "1.0.0"
  :description "A simple review site allowing reviews of only a few words."
  :homepage "https://Shirakumo.github.io/keyword-reviews/"
  :bug-tracker "https://github.com/Shirakumo/keyword-reviews/issues"
  :source-control (:git "https://github.com/Shirakumo/keyword-reviews.git")
  :components ((:file "module")
               (:file "db")
               (:file "toolkit")
               (:file "objects")
               (:file "api")
               (:file "front")
               (:file "admin"))
  :depends-on ((:interface :database)
               (:interface :auth)
               :r-data-model
               :r-clip
               :local-time
               :cl-ppcre))
