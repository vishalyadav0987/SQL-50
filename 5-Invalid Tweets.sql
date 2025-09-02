SELECT T.tweet_id 
FROM Tweets AS T 
WHERE LENGTH(T.content) > 15; 