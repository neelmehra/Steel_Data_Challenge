USE steel_data;

CREATE TABLE Teams (
team_id INT PRIMARY KEY,
team_name VARCHAR(50) NOT NULL,
country VARCHAR(50),
captain_id INT
);
--------------------
INSERT INTO Teams (team_id, team_name, country, captain_id)
VALUES (1, 'Cloud9', 'USA', 1),
(2, 'Fnatic', 'Sweden', 2),
(3, 'SK Telecom T1', 'South Korea', 3),
(4, 'Team Liquid', 'USA', 4),
(5, 'G2 Esports', 'Spain', 5);
--------------------
CREATE TABLE Players (
player_id INT PRIMARY KEY,
player_name VARCHAR(50) NOT NULL,
team_id INT,
role VARCHAR(50),
salary INT,
FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);
--------------------
INSERT INTO Players (player_id, player_name, team_id, role, salary)
VALUES (1, 'Shroud', 1, 'Rifler', 100000),
(2, 'JW', 2, 'AWP', 90000),
(3, 'Faker', 3, 'Mid laner', 120000),
(4, 'Stewie2k', 4, 'Rifler', 95000),
(5, 'Perkz', 5, 'Mid laner', 110000),
(6, 'Castle09', 1, 'AWP', 120000),
(7, 'Pike', 2, 'Mid Laner', 70000),
(8, 'Daron', 3, 'Rifler', 125000),
(9, 'Felix', 4, 'Mid Laner', 95000),
(10, 'Stadz', 5, 'Rifler', 98000),
(11, 'KL34', 1, 'Mid Laner', 83000),
(12, 'ForceZ', 2, 'Rifler', 130000),
(13, 'Joker', 3, 'AWP', 128000),
(14, 'Hari', 4, 'AWP', 90000),
(15, 'Wringer', 5, 'Mid laner', 105000);
--------------------
CREATE TABLE Matches (
match_id INT PRIMARY KEY,
team1_id INT,
team2_id INT,
match_date DATE,
winner_id INT,
score_team1 INT,
score_team2 INT,
FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
FOREIGN KEY (winner_id) REFERENCES Teams(team_id)
);
--------------------
INSERT INTO Matches (match_id, team1_id, team2_id, match_date, winner_id, score_team1, score_team2)
VALUES (1, 1, 2, '2022-01-01', 1, 16, 14),
(2, 3, 5, '2022-02-01', 3, 14, 9),
(3, 4, 1, '2022-03-01', 1, 17, 13),
(4, 2, 5, '2022-04-01', 5, 13, 12),
(5, 3, 4, '2022-05-01', 3, 16, 10),
(6, 1, 3, '2022-02-01', 3, 13, 17),
(7, 2, 4, '2022-03-01', 2, 12, 9),
(8, 5, 1, '2022-04-01', 1, 11, 15),
(9, 2, 3, '2022-05-01', 3, 9, 10),
(10, 4, 5, '2022-01-01', 4, 13, 10);



/*1. What are the names of the players whose salary is greater than 100,000?*/

select player_name, salary from Players where salary > 100000

/* 2. What is the team name of the player with player_id = 3? */

select Teams.team_name from Players
join Teams on Teams.team_id= Players.team_id
where player_id = 3
 
-----------------------------------------------------------------------
select player_name, salary from Players 
order by salary desc 

SELECT MAX(salary) AS second_highest_salary FROM Players
WHERE salary < (SELECT MAX(salary) FROM Players);

SELECT MIN(salary) AS second_lowest_highest_salary FROM Players
WHERE salary > (SELECT MIN(salary) FROM Players);


select player_name, role, salary, ROW_NUMBER() over (order by salary desc) rn  from Players -- it's not take duplicate number
select player_name, role, salary, rank() over (order by salary desc) rn  from Players --it's take duplicate and skip next number
select player_name, role, salary, dense_rank() over (order by salary desc) rn  from Players -- it's take duplicate and not skip next number

select * from (select player_name, role, salary, ROW_NUMBER() over (order by salary desc) rn  from Players ) temptable where rn =2

------------------------------------------------------
/* 3. What is the total number of players in each team?*/

select team_id, count(*) as Each_team_players from Players group by team_id

/*4. What is the team name and captain name of the team with team_id = 2?*/



SELECT T.team_name, P.player_name AS captain_name
FROM Teams T
INNER JOIN Players P ON T.captain_id = P.player_id
WHERE T.team_id = 2;

/* 5. What are the player names and their roles in the team with team_id = 1?*/

select player_name , role from Players where team_id= 1

/*6. What are the team names and the number of matches they have won?*/

select team_name , count(*) as winning from Matches 
join teams on Teams.team_id= Matches.winner_id
group by team_name

/*7. What is the average salary of players in the teams with country 'USA'?*/

select team_name, AVG(salary) from Players as avg_salary join Teams on Teams.team_id= Players.team_id
where Teams.country = 'USA'
group by Teams.team_name

SELECT Teams.team_name, AVG(Players.salary) AS average_salary
FROM Players
JOIN Teams ON Teams.team_id = Players.team_id
WHERE Teams.country = 'USA'
GROUP BY Teams.team_name;

/*8. Which team won the most matches?*/

select top 1 team_name , count(*) as winning from Matches 
join teams on Teams.team_id= Matches.winner_id
group by team_name
order by winning desc


SELECT team_name, winning, ROW_NUMBER() OVER (ORDER BY winning DESC) AS rn
FROM (
  SELECT Teams.team_name, COUNT(*) AS winning
  FROM Matches
  JOIN Teams ON Teams.team_id = Matches.winner_id
  GROUP BY team_name
) AS subquery
ORDER BY winning DESC;


/*9. What are the team names and the number of players in each team whose salary is greater than 100,000?*/

SELECT Teams.team_name, COUNT(*) AS player_count
FROM Players
JOIN Teams ON Teams.team_id = Players.team_id
WHERE Players.salary > 100000
GROUP BY Teams.team_name;

/*10. What is the date and the score of the match with match_id = 3?*/

select match_id, match_date, Score_team1, score_team2 from Matches
where match_id = 3


/*select * from teams;
select * from Players;
select * from Matches;
*/
