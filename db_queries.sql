-- QUERY CON SELECT
-- -------------------------------------------------------------
-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT * FROM `students` WHERE YEAR(`date_of_birth`) = 1990;


-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * FROM `courses` WHERE `cfu` > 10;


-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * FROM `students` WHERE TIMESTAMPDIFF(YEAR, `date_of_birth`, CURDATE()) >= 30;


-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * FROM `courses` WHERE `period` LIKE 'I %' AND `year` = 1;


-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * FROM `exams` WHERE DATE(`date`) = '2020-06-20' AND TIME(`hour`) > '14:00';


-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * FROM `degrees` WHERE `level` = 'magistrale';


-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) AS `Numero dipartimenti` FROM `departments`;


-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) AS `Numero insegnanti senza telefono` FROM `teachers` WHERE `phone` IS NULL;



-- QUERY CON GROUP BY
-- -------------------------------------------------------------
-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) AS `Numero studenti per anno`, YEAR(`enrolment_date`) AS `Anno di iscrizione` FROM `students` GROUP BY YEAR(`enrolment_date`);


-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) AS `Numero di insegnanti per ufficio`, `office_address` AS `Indirizzo ufficio` FROM `teachers` GROUP BY `office_address`;


-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT `student_id` AS `ID Studente`, ROUND(AVG(`vote`)) AS `Media` FROM `exam_student` GROUP BY `ID Studente`;


-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) AS `Totale corsi`, `department_id` AS `Dipartimento` FROM `degrees` GROUP BY `department_id`;


-- QUERY CON JOIN
-- -------------------------------------------------------------
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT S.`name` AS `Nome studente`, S.`surname` AS `Cognome studente`, D.`name` AS `Corso di laurea` FROM `degrees` AS D JOIN `students` AS S ON S.`degree_id` = D.`id` WHERE D.`name` = 'Corso di Laurea in Economia';


-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT `DEP`.`name` AS `Nome dipartimento`, DEG.`name` AS `Nome corso` FROM `departments` AS DEP JOIN `degrees` AS DEG ON DEP.`id` = DEG.`department_id` WHERE DEP.`name` = 'Dipartimento di Neuroscienze';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT DISTINCT C.`id`, C.`name` AS `Nome Corso`, T.`name` AS `Nome Insegnante`, T.`surname` AS `Cognome Insegnante` FROM `courses` AS C JOIN `course_teacher` AS CT ON C.`id` = CT.`course_id` JOIN `teachers` AS T ON T.`id` = CT.`teacher_id` WHERE `T`.`name` = 'Fulvio' AND T.`surname` = 'Amato' ORDER BY `Nome Corso`;


-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti ed il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT S.`surname` AS `Cognome`, S.`name` AS `Nome`, DEG.`name` AS `Corso`, DEP.`name` AS `Facoltà` FROM `students` AS S JOIN `degrees` AS DEG ON DEG.`id` = S.`degree_id` JOIN `departments` AS DEP ON DEP.`id` = DEG.`department_id` ORDER BY `Cognome` ASC, `Nome` ASC;


-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT D.`name` AS `Corso`, C.`name` AS `Materia`, T.`name` AS `Nome insegnante`, T.`surname` AS `Cognome Insegnante` FROM `degrees` AS D JOIN `courses` AS C ON D.`id` = C.`degree_id` JOIN `course_teacher` AS CT ON C.`id` = `CT`.`course_id` JOIN `teachers` AS T ON T.`id` = CT.`teacher_id` ORDER BY `Corso` ASC;


-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT DEP.`name` AS `Facoltà`, T.`name` AS `Nome insegnante`, T.`surname` AS `Cognome Insegnante` FROM `departments` AS DEP JOIN `degrees` AS DEG ON DEP.id = DEG.`department_id` JOIN `courses` AS C ON DEG.`id` = C.`degree_id` JOIN `course_teacher` AS CT ON C.`id` = `CT`.`course_id` JOIN `teachers` AS T ON T.`id` = CT.`teacher_id` WHERE DEP.`name` = 'Dipartimento di Matematica' ORDER BY `Facoltà` ASC;


-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami
SELECT S.`name` AS 'Nome', S.`surname` AS 'Cognome', C.`name` AS 'Corso', COUNT(ES.`vote`) AS 'Tentativi d\'esame' FROM `students` AS S JOIN `exam_student` AS ES ON S.`id` = ES.`student_id` JOIN `exams` AS E ON E.`id` = ES.`exam_id` JOIN `courses` AS C ON C.`id` = E.`course_id` GROUP BY S.`id`, C.`id` HAVING MAX(ES.`vote`) >= 18;