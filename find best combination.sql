DROP FUNCTION if EXISTS find_best_combination (varchar, int);

CREATE FUNCTION find_best_combination (IN _preference_name varchar, IN _user_id int) returns TABLE (
	__user_id int,
	__group_id int,
	__preference_name varchar,
	__wonder_id int,
	__wonder_name varchar,
	__allied boolean,
	__base_attribution numeric,
	__synergy_attribution numeric
) language 'plpgsql' AS $BODY$
BEGIN
-- PREPARATION

CREATE TEMPORARY TABLE combinations (group_id int, wonder_id int);

CREATE TEMPORARY TABLE combination_levels (user_id int, group_id int, wonder_id int, level int);

CREATE TEMPORARY TABLE base_values (
	part varchar(50),
	user_id int,
	group_id int,
	wonder_id int,
	bonus_type_id int,
	level int,
	stat_value numeric,
	progression_stat numeric
);
CREATE TEMPORARY TABLE synergies (
	wonder_id int,
	synergy_wonder_id int,
	user_id int,
	preference_name varchar,
	synergy_amount numeric,
	synergy_multiplier smallint,
	base numeric,
	total_synergy numeric
);

CREATE TEMPORARY TABLE prep_best_combination (
	part varchar(50),
	user_id int,
	group_id int,
	wonder_id int,
	preference_name varchar,
	total_weight numeric
);

CREATE TEMPORARY TABLE best_combination (user_id int, group_id int, preference_name varchar, total_weight numeric);

-- TABLES THAT ARE USED IN BOTH SECTIONS	
INSERT INTO
	combinations
SELECT
	group_id,
	wonder_id
FROM
	vw_combinations;
INSERT INTO
	combination_levels
SELECT
	uw.user_id,
	c.group_id,
	c.wonder_id,
	uw.level
FROM
	combinations c
	JOIN wonders w ON c.wonder_id = w.id
	JOIN user_wonders uw ON uw.wonder_id = c.wonder_id
WHERE uw.user_id = _user_id;

-- PREPARING FOR BASE VALUES
INSERT INTO
	base_values
SELECT
	cl.user_id,
	cl.group_id,
	cl.wonder_id,
	wls.bonus_type_id,
	cl.level,
	wls.stat_value,
	wls.progression_stat
FROM
	combination_levels cl
	JOIN wonder_level_stats wls ON cl.wonder_id = wls.wonder_id
	AND cl.level = wls.level;

-- LOADING BASE VALUES
INSERT INTO prep_best_combination
SELECT
	'BASE',
	bv.user_id,
	bv.group_id,
	bv.wonder_id,
	ubp.preference_name,
	SUM(bv.progression_stat * ubp.preference_value) AS total_weight
FROM
	base_values bv
	JOIN user_bonus_preferences ubp ON bv.user_id = ubp.user_id
	AND bv.bonus_type_id = ubp.bonus_type_id
	WHERE ubp.preference_name = _preference_name
GROUP BY
	bv.user_id,
	bv.group_id,
	bv.wonder_id,
	ubp.preference_name;

-- PREPARING SYNERGY VALUES
INSERT INTO synergies
SELECT
	w.id,
	sw.id,
	ubp.user_id,
	ubp.preference_name,
	w.synergy_amount,
	sw.synergy_multiplier,
	bt.base,
	w.synergy_amount/bt.base * sw.synergy_multiplier * ubp.preference_value AS total_synergy
FROM
	wonders w
	JOIN wonders sw ON (
		sw.wonder_type_1_id = w.synergy_wonder_type_id
		OR sw.wonder_type_2_id = w.synergy_wonder_type_id
	)
	AND sw.id != w.id
	JOIN bonus_type bt ON w.synergy_bonus_type_id = bt.id
	JOIN user_bonus_preferences ubp ON ubp.bonus_type_id = bt.id
	WHERE ubp.preference_name = _preference_name;

-- LOADING SYNERGY VALUES
INSERT INTO
	prep_best_combination
SELECT
	'SYNERGIES',
	s.user_id,
	cl.group_id,
	s.wonder_id,
	s.preference_name,
	SUM(s.total_synergy)
FROM
	synergies s
	JOIN combination_levels cl ON s.wonder_id = cl.wonder_id
GROUP BY
	s.user_id,
	cl.group_id,
	s.preference_name,
	s.wonder_id;
-- FINDING BEST COMBINATION	
INSERT INTO
	best_combination
SELECT
	user_id,
	group_id,
	preference_name,
	SUM(total_weight) AS total_weight
FROM
	prep_best_combination
GROUP BY
	user_id,
	group_id,
	preference_name
ORDER BY
	total_weight DESC
LIMIT
	1;

return query
SELECT
	bc.user_id,
	bc.group_id,
	bc.preference_name,
	c.wonder_id,
	w.name AS wonder_name,
	allied,0.0,0.0
FROM
	best_combination bc
	JOIN combinations c ON c.group_id = bc.group_id
	JOIN wonders w ON w.id = c.wonder_id
ORDER BY
	allied,
	wonder_id;
	END
$BODY$