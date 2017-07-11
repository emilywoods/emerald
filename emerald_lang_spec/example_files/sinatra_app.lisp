;
; An example of a Sinatra application, written in Emerald.
;

(require-ruby "sinatra/base")

(defclass
  MyApp (Sinatra/Base)
  (get "/"
       (do ()
         "Hello, world!"))

  (get "/hello/:name"
       (do (name)
         (.+ "Hello " name)))

  ; matches "GET /posts?title=foo&author=bar"
  (get "/posts"
       (do ()
         (let ((title (.[] params "title"))
               (author (.[] params "author")))
           (.+ "title: " (.+ title (.+ ", author: " author)))))))

(.run! MyApp)


;
; This would compile to the code below.
;

; require "sinatra/base"
;
; class MyApp < Sinatra::Base
;   get("/") do
;     "Hello, world!"
;   end
;
;   get("/hello/:name") do |name|
;     "Hello, " + name
;   end
;
;   get("/posts") do
;     begin
;       title = params.[]("title")
;       author = params.[]("author")
;       "title: " + title + ", author: " + author
;     end
;   end
; end
;
; MyApp.run!
