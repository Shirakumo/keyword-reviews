About Keyword-Reviews
---------------------
The idea behind this site is to offer a reviewing service for various items. However, the trick is that users are supposed to review something with a single term (or keyword). Thus the reviews are not meant to be immediately insightful, but rather as an experiment to see what people think the essence of their impression on something is. Comparing these with each other could lead to interesting findings.

How To
------
Set up [Radiance](https://github.com/Shinmera/Radiance) and load Keyword-Reviews with ASDF or Quicklisp. Once it has been started up, you can use `keyword-reviews:make-type` to create new types of items to review. Keyword-Reviews occupies the subdomain `keyword`.

Interface Dependencies
----------------------
* `database`
* `data-model`
* `auth`

Permissions
-----------
* `(keyword type make)`
* `(keyword type edit)`
* `(keyword review make)`
* `(keyword review edit)`
