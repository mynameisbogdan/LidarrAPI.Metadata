SELECT scored.rgid AS rgid, MIN(scored.score) AS score
FROM
(
  SELECT
    matches.rgid,
    ABS(SUM(medium.track_count) - $1) + (1 - CAST(MAX(matches.matchcount) AS float) / SUM(medium.track_count)) AS score
  FROM
  (
    SELECT release_group.gid AS rgid, release.id AS releaseid, count(recording.id) AS matchcount
    FROM release_group
    JOIN release on release.release_group = release_group.id
    JOIN medium on medium.release = release.id
    JOIN track on track.medium = medium.id
    JOIN recording on recording.id = track.recording
    WHERE recording.gid = ANY($2::uuid[])
    GROUP BY release_group.gid, release.id
  ) AS matches
  JOIN medium on medium.release = matches.releaseid
  GROUP BY matches.rgid, matches.releaseid
  ORDER BY score
) AS scored
GROUP BY scored.rgid
ORDER BY score
LIMIT 5
