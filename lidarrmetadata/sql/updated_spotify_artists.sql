SELECT artist.gid AS mbid, SUBSTRING(url.url from 33) AS spotifyid
FROM artist
JOIN l_artist_url on l_artist_url.entity0 = artist.id
JOIN url on l_artist_url.entity1 = url.id
WHERE l_artist_url.last_updated > $1
AND url.url like 'https://open.spotify.com/artist/%'
