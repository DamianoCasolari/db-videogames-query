-- 1- Selezionare tutte le software house americane (3)

SELECT * 
FROM `software_houses` 
WHERE `country` = "United States";

-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)

SELECT * 
FROM `players` 
WHERE `city` = 'Rogahnland';

-- 3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)

SELECT * 
FROM `players` 
WHERE `name` LIKE "%a";

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)

SELECT *
FROM `REVIEWS`
WHERE `player_id` = "800"

-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)

SELECT * 
FROM `TOURNAMENTS`
WHERE `year` = "2015"

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)

SELECT * 
FROM `awards`
WHERE `description` LIKE "%facere%"

-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)


SELECT DISTINCT videogame_id,
FROM category_videogame
WHERE category_id IN (2, 6);

-- second version with name instead of ID

SELECT DISTINCT videogames.id, videogames.name
FROM videogames 
JOIN category_videogame 
ON videogames.id = category_videogame.videogame_id
WHERE category_videogame.category_id IN (2, 6);

-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)

SELECT *
FROM `reviews`
WHERE `rating` >= 2 
AND `rating` <= 4; 

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)

SELECT *
FROM `videogames`
WHERE `release_date` 
LIKE "2020%"

-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443) 

SELECT DISTINCT reviews.videogame_id AS id
FROM `reviews`
WHERE `rating` = 5

-- alternativa con il nome

SELECT DISTINCT videogames.id,videogames.name
FROM `videogames`
JOIN `reviews`
ON videogames.id = reviews.videogame_id
WHERE `rating` = 5

-- 11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3.16 circa)

SELECT COUNT(videogame_id) AS total_reviews, AVG(rating) AS avarage_rating
FROM `reviews`
WHERE `videogame_id` = 412


-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)

SELECT COUNT(id) AS number_of_videogame_of_Nintendoon_2018
FROM `videogames`
WHERE `software_house_id` = 1 AND `release_date` LIKE "2018%"


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- GROUP BY

-- 1- Contare quante software house ci sono per ogni paese (3)

SELECT COUNT(id) AS number_softwarehouses, country
FROM `software_houses`
GROUP BY `country`

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)

SELECT COUNT(ID) AS number_reviews
FROM `reviews`
GROUP BY `videogames_id`

-- alternativa con il nome

SELECT COUNT(reviews.id) AS number_reviews, videogames.name
FROM `reviews`
JOIN `videogames`
ON videogames.id = reviews.videogame_id
GROUP BY `videogame_id`

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)

SELECT COUNT(ID)
FROM `pegi_label_videogame`
GROUP BY `pegi_label_id`

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)

SELECT YEAR(release_date) AS release_year, COUNT(id) AS game_count
FROM `videogames`
GROUP BY release_year;


-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)

SELECT COUNT(videogame_id)
FROM `device_videogame`
GROUP BY `device_id`


-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)

SELECT AVG(rating) as avarage_rating,videogame_id
FROM `reviews`
GROUP BY videogame_id
ORDER BY avarage_rating DESC

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN

-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)


SELECT DISTINCT `players`.*
FROM `players`
JOIN `reviews`
ON `players`.`id` = `reviews`.`player_id`

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)

SELECT `videogames`.name,`tournaments`.year AS year
FROM `videogames`
JOIN `tournament_videogame` ON `videogames`.`id` = `tournament_videogame`.`videogame_id`
JOIN `tournaments` ON `tournaments`.`id` = `tournament_videogame`.`tournament_id`
WHERE `tournaments`.year = 2016
GROUP BY `videogames`.name,`tournaments`.year

-- 3- Mostrare le categorie di ogni videogioco (1718)

SELECT `videogames`.`name`.name, `category_videogame`.`category_id`
FROM `videogames`
JOIN `category_videogame` ON `videogames`.`id` = `category_videogame`.`videogame_id`
GROUP by `videogames`.`name`.name, `category_videogame`.`category_id`


-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)

SELECT DISTINCT `software_houses`.`name`
FROM `software_houses`
JOIN `videogames` ON `software_houses`.`id` = `videogames`.`software_house_id`
WHERE  YEAR(`videogames`.`release_date`) >= 2020

 
-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)

SELECT COUNT(`awards`.`id`) AS `number_of_award`, `videogames`.`software_house_id`
FROM `awards`
JOIN `award_videogame` ON `awards`.`id` = `award_videogame`.`award_id`
JOIN `videogames` ON `videogames`.`id` = `award_videogame`.`videogame_id`
GROUP BY `videogames`.`software_house_id`


-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)

SELECT DISTINCT videogames.id, categories.name AS category, pagi_labels.name AS PEGI
FROM videogames
JOIN reviews ON reviews.videogame_id = videogames.id
JOIN category_videogame ON category_videogame.category_id = categories.id
JOIN pegi_label_videogame ON videogames.id = pegi_label_videogame.videogame_id
JOIN pagi_labels ON pegi_label_videogame.pegi_label_id = pegi_labels.id 
WHERE reviews.rating >= 4


-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)

SELECT DISTINCT videogames.name
FROM videogames
JOIN tournament_videogame ON videogames.id = tournament_videogame.videogame_id
JOIN tournaments ON tournaments.id = tournament_videogame.tournament_id
JOIN player_tournament ON tournaments.id = player_tournament.tournament_id
JOIN players ON players.id = player_tournament.player_id
WHERE players.name LIKE "S%"


-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)

SELECT DISTINCT tournaments.city AS "city where the best videogame was played"
FROM tournaments
JOIN tournament_videogame ON tournaments.id = tournament_videogame.tournament_id
JOIN videogames ON videogames.id = tournament_videogame.videogame_id
JOIN award_videogame ON videogames.id = award_videogame.videogame_id
JOIN awards ON awards.id = award_videogame.award_id
WHERE awards.name LIKE "Gioco dell'anno" AND award_videogame.year LIKE "2018"


-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)

SELECT players.name
FROM players
JOIN player_tournament ON players.id = player_tournament.player_id
JOIN tournaments ON tournaments.id = player_tournament.tournament_id
JOIN tournament_videogame ON tournaments.id = tournament_videogame.tournament_id
JOIN videogames ON videogames.id = tournament_videogame.videogame_id
JOIN award_videogame ON videogames.id = award_videogame.videogame_id
JOIN awards ON awards.id = award_videogame.award_id
WHERE awards.name LIKE "Gioco più atteso" AND award_videogame.year LIKE "2019" AND tournaments.year = 2019



-- *********** BONUS ***********

-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)


SELECT software_houses.*, videogames.* --in caso volessi mettere dati specifici andrebbero inseriti uno ad uno dato 
FROM software_houses
JOIN videogameS ON videogames.software_house_id = software_houses.id
ORDER BY videogames.release_date ASC
limit 1


-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : potrebbe uscire 449 o 398, sono entrambi a 20)


SELECT videogames.id, videogames.name, videogames.release_date, COUNT(reviews.videogame_id) AS total_reviews
FROM videogames
JOIN reviews ON videogames.id = reviews.videogame_id
GROUP BY videogames.id, videogames.name, videogames.release_date
ORDER BY total_reviews DESC
LIMIT 1;

-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : potrebbe uscire 3 o 1, sono entrambi a 3)


SELECT software_houses.id, software_houses.name, COUNT(awards.id) as Total_awards
from software_houses
JOIN videogames ON videogames.software_house_id = software_houses.id
JOIN award_videogame ON videogames.id = award_videogame.videogame_id
JOIN awards ON awards.id = award_videogame.award_id
WHERE award_videogame.year BETWEEN 2015 AND 2016
GROUP BY software_houses.id, software_houses.name
ORDER BY Total_awards DESC
LIMIT 1


-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 2 (10) 

SELECT categories.name, AVG(reviews.rating) AS avarage_rating
FROM categories
JOIN category_videogame on categories.id = category_videogame.category_id
JOIN videogames on videogames.id = category_videogame.videogame_id
JOIN reviews on videogames.id = reviews.videogame_id
GROUP BY categories.name
HAVING avarage_rating < 2   -- credo la traccia volesse dire superiore a 2 perchè sono tutte superiori a 2 le medie quindi in tal caso darebbe 10 mentre se inferiore 0
