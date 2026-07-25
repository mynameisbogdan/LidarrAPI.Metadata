SELECT
    release_group.gid AS gid,
    array(
        SELECT release_group_gid_redirect.gid
        FROM release_group_gid_redirect
        WHERE release_group_gid_redirect.new_id = release_group.id
    ) AS oldids,
    COALESCE(release_group_primary_type.name, 'Other') AS primary_type,
    release_group.name AS album,
    array(
        SELECT rgst.name
        FROM release_group_secondary_type rgst
        JOIN release_group_secondary_type_join rgstj ON rgstj.secondary_type = rgst.id
        WHERE rgstj.release_group = release_group.id
        ORDER BY rgst.name ASC
    ) AS secondary_types,
    array(
        SELECT DISTINCT release_status.name
        FROM release_status
        JOIN release ON release.status = release_status.id
        WHERE release.release_group = release_group.id
    ) AS release_statuses
FROM release_group
JOIN artist_credit_name ON artist_credit_name.artist_credit = release_group.artist_credit AND artist_credit_name.position = 0
JOIN artist ON artist_credit_name.artist = artist.id
LEFT JOIN release_group_primary_type ON release_group.type = release_group_primary_type.id
WHERE artist.gid = $1
AND EXISTS (
    SELECT 1
    FROM release
    JOIN medium ON medium.release = release.id
    JOIN track ON track.medium = medium.id AND NOT track.is_data_track
    JOIN recording ON track.recording = recording.id AND NOT recording.video
    WHERE release.release_group = release_group.id
)
