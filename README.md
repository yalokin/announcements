# README

Make a Ruby application with JSON RESTful API.

* The user leaves an announcement about the work, and other users can respond to this announcement (response) with a price (I can do the work for so much).

* The author of the announcement can cancel the announcement. In this case, all responses should be automatically rejected (declined). 

* The author can accept one of the responses, then the other responses should be rejected (declined), and the ad should become closed (closed).

* You can't leave feedback on a closed or canceled announcement.

* The user who left the response can cancel his response (cancel).
  In this case, the response status should be canceled, not declined.

* Also the API needs methods to get your announcement with all responses and get a list of all active announcement (no responses).

Essences

* Announcement(id, user_id, description, status)
  description-text, no more than 1000 characters

* Response(id, announcement_id, user_id, price, status)
  price - int, price in rubles: from 100 to 10000

User(id)


Announcement statuses

* active - active, you can respond
* canceled - canceled by the author
* closed - closed (there is an accepted response)


The status of the response to the announcement

* pending - new response
* canceled - canceled by the author of the response
* declined - canceled by the author of the announcement (or automatically if the ad is closed or canceled)
* accepted - accepted by the author of the announcement


Restrictions
1. you can only respond to an active announcement
2. if the author of the announcement has rejected someone's response, then you can not re-respond
3. if the author of the response canceled his response, he can re-respond to the same announcement.


Authentication

In the API, instead of full authentication, you can pass `user_id` in the request headers.

You can also make an endpoint to create a user for tests ` 'POST /users', which will create a new user and return his ' id`

