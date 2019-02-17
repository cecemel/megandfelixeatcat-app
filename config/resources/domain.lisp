(in-package :mu-cl-resources)

(define-resource food-establishment ()
  ;;TODO cuisine types, type of establsihment, addres, photo
  :class (s-prefix "schema:FoodEstablishment")
  :properties `((:establishment-name :string ,(s-prefix "schema:name")))

  :has-many `((rating :via ,(s-prefix "schema:starRating")
                      :as "ratings")
              (review :via ,(s-prefix "schema:itemReviewed")
                      :inverse t
                      :as "reviews"))
  :resource-base (s-url "http://megandfelixeat.cat/food-establishments/")

  :features '(include-uri)

  :on-path "food-establishments")

;;TODO: I want recurrent review: the notion of preceding review and quality over time
(define-resource rating ()
  :class (s-prefix "schema:Rating")
  :properties `((:rating-value :number ,(s-prefix "schema:ratingValue")) ;;between 0-5
                (:veggie-score :number ,(s-prefix "meg:veggieScore"))
                (:price-quality :number ,(s-prefix "meg:priceQuality"))
                (:created :date ,(s-prefix "dct:created")))

  :has-one `((review :via ,(s-prefix "schema:reviewRating")
                     :inverse t
                     :as "review"))

  :resource-base (s-url "http://megandfelixeat.cat/ratings/")

  :features '(include-uri)

  :on-path "ratings")

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
