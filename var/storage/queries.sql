select a.username, datetime(s.datetime, 'unixepoch'), s.overall_level, s.overall_xp, s.overall_rank from snapshots s
join accounts a on a.id = s.account_id
order by datetime desc;

SELECT 
    name
FROM 
    sqlite_master 
WHERE 
    type ='table' AND 
    name NOT LIKE 'sqlite_%';