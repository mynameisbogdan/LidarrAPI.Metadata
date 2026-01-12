SELECT
  row_to_json(item_data) item
  FROM (
    SELECT
      release_group.gid AS AlbumId,
      release_group.name AS AlbumTitle,
      artist.gid AS ArtistId,
      make_date(
        release_group_meta.first_release_date_year,
        COALESCE(release_group_meta.first_release_date_month, 1),
        COALESCE(release_group_meta.first_release_date_day, 1)
      ) AS ReleaseDate

    FROM release_group
    LEFT JOIN release_group_meta ON release_group_meta.id = release_group.id
    LEFT JOIN artist_credit_name ON artist_credit_name.artist_credit = release_group.artist_credit
    LEFT JOIN artist ON artist_credit_name.artist = artist.id
    JOIN release_group_series ON release_group.id = release_group_series.release_group
    JOIN series ON release_group_series.series = series.id
    WHERE artist_credit_name.position = 0
      AND series.gid = $1
  ) item_data;
