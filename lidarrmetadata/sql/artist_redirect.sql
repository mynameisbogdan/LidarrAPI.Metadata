SELECT artist.gid
  FROM artist_gid_redirect
  JOIN artist ON artist_gid_redirect.new_id = artist.id
 WHERE artist_gid_redirect.gid = $1
