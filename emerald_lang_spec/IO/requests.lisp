(:require json)
(:require HTTParty)

(defun make_request
  (query headers)
  (let ((url (str "http://api.open-notify.org" query))
        (response (json/parse (:body (HTTParty/get url {:headers headers}))))
        (metadata (first response))
        (results (second response) ))))

 ; compiles to:

 ; def make_request(url, params)
 ;   begin
 ;      url = "http://api.open-notify.org#{query}"
 ;      body = HTTParty.get(url, :headers => headers)
 ;      response = json.parse(body)
 ;      meta = response.first
 ;      results = response[1]
 ;   end
 ; end


