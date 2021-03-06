(in-package :mu-cl-resources)

;;mainly based on https://schema.org/FoodEstablishment

(define-resource postal-address ()
  :class (s-prefix "schema:PostalAddress")

  :properties `((:country :string ,(s-prefix "schema:addressCountry"))
                (:region :string ,(s-prefix "schema:addressRegion"))
                (:postal-code :string, (s-prefix "schema:postalCode")))

  :resource-base (s-url "http://megandfelixeat.cat/postal-address/")

  :features '(include-uri)

  :on-path "postal-addresses")

(define-resource food-establishment ()
  ;;TODO cuisine types, type of establsihment, addres, photo
  :class (s-prefix "schema:FoodEstablishment")
  :properties `((:establishment-name :string ,(s-prefix "schema:name"))
                (:website :string ,(s-prefix "schema:url")))

  :has-one `((aggregate-rating :via ,(s-prefix "schema:itemReviewed")
                               :inverse t
                               :as "aggregate-rating")
             (postal-address :via ,(s-prefix "schema:postalAddress")
                               :as "address"))

  :has-many `((rating :via ,(s-prefix "schema:starRating")
                      :as "ratings")
              (review :via ,(s-prefix "schema:itemReviewed")
                      :inverse t
                      :as "reviews")
              (file :via ,(s-prefix "schema:photo")
                    :as "photos"))

  :resource-base (s-url "http://megandfelixeat.cat/food-establishments/")

  :features '(include-uri)

  :on-path "food-establishments")

;;TODO: I want recurrent review: the notion of preceding review and quality over time
(define-resource rating ()
  :class (s-prefix "schema:Rating")
  :properties `((:rating-value :number ,(s-prefix "schema:ratingValue")) ;;between 0-5
                (:veggie-score :number ,(s-prefix "meg:veggieScore"))
                (:created :date ,(s-prefix "dct:created")))

  :has-one `((review :via ,(s-prefix "schema:reviewRating")
                     :inverse t
                     :as "review")
             (food-establishment :via ,(s-prefix "schema:starRating")
                                 :inverse t
                                 :as "food-establishment"))

  :resource-base (s-url "http://megandfelixeat.cat/ratings/")

  :features '(include-uri)

  :on-path "ratings")

(define-resource aggregate-rating ()
  :class (s-prefix "schema:AggregateRating")
  :properties `((:rating-value :number ,(s-prefix "schema:ratingValue"))
                (:avg-veggie-score :number ,(s-prefix "meg:avgVeggieScore"))
                (:count :number ,(s-prefix "schema:ratingCount")))

  :has-one `((food-establishment :via ,(s-prefix "schema:itemReviewed")
                                 :as "food-establishment"))

  :resource-base (s-url "http://megandfelixeat.cat/aggregate-ratings/")

  :features '(include-uri)

  :on-path "aggregate-ratings")

(define-resource reviewer ()
  :class (s-prefix "schema:Person")
  :properties `((:family-name :string ,(s-prefix "schema:familyName"))
                (:firstname :string ,(s-prefix "schema:name")))

  :resource-base (s-url "http://megandfelixeat.cat/people-in-the-magazines/")

  :features '(include-uri)

  :on-path "reviewers")

(define-resource review ()
  :class (s-prefix "schema:Review")
  :properties `((:review-body :string ,(s-prefix "schema:reviewBody"))
                (:headline :string ,(s-prefix "meg:reviewHeadline"))
                (:created :date ,(s-prefix "dct:created")))

  :has-one `((rating :via ,(s-prefix "schema:reviewRating")
                     :as "rating")
             (food-establishment :via ,(s-prefix "schema:itemReviewed")
                                 :as "food-establishment"))

  :has-many `((reviewer :via ,(s-prefix "schema:author")
                      :as "authors"))

  :resource-base (s-url "http://megandfelixeat.cat/review-your-own-dogfood/")

  :features '(include-uri)

  :on-path "reviews")

(define-resource file ()
  :class (s-prefix "nfo:FileDataObject")
  :properties `((:filename :string ,(s-prefix "nfo:fileName"))
                (:format :string ,(s-prefix "dct:format"))
                (:size :number ,(s-prefix "nfo:fileSize"))
                (:extension :string ,(s-prefix "dbpedia:fileExtension"))
                (:created :datetime ,(s-prefix "nfo:fileCreated")))
  :has-one `((file :via ,(s-prefix "nie:dataSource")
                   :inverse t
                   :as "download"))
  :resource-base (s-url "http://data.example.com/files/")
  :features `(include-uri)
  :on-path "files")
