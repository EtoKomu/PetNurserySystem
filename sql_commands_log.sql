-- Начало Задания 7: Создание базы данных "Друзья человека"
CREATE DATABASE FriendsOfHuman;
USE FriendsOfHuman;

-- Начало Задания 8: Создание таблиц с иерархией
CREATE TABLE Animals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    commands TEXT
);

CREATE TABLE Pets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    animal_id INT NOT NULL,
    FOREIGN KEY (animal_id) REFERENCES Animals(id) ON DELETE CASCADE
);

CREATE TABLE PackAnimals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    animal_id INT NOT NULL,
    FOREIGN KEY (animal_id) REFERENCES Animals(id) ON DELETE CASCADE
);

CREATE TABLE Dogs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    FOREIGN KEY (pet_id) REFERENCES Pets(id) ON DELETE CASCADE
);

CREATE TABLE Cats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    FOREIGN KEY (pet_id) REFERENCES Pets(id) ON DELETE CASCADE
);

CREATE TABLE Hamsters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    FOREIGN KEY (pet_id) REFERENCES Pets(id) ON DELETE CASCADE
);

CREATE TABLE Horses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pack_animal_id INT NOT NULL,
    FOREIGN KEY (pack_animal_id) REFERENCES PackAnimals(id) ON DELETE CASCADE
);

CREATE TABLE Camels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pack_animal_id INT NOT NULL,
    FOREIGN KEY (pack_animal_id) REFERENCES PackAnimals(id) ON DELETE CASCADE
);

CREATE TABLE Donkeys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pack_animal_id INT NOT NULL,
    FOREIGN KEY (pack_animal_id) REFERENCES PackAnimals(id) ON DELETE CASCADE
);

-- Начало Задания 9: Заполнение низкоуровневых таблиц данными
-- Пример 1: Собака Рекс
INSERT INTO Animals (name, birth_date, commands) VALUES ('Рекс', '2022-01-15', 'Сидеть, Лежать, Голос');
INSERT INTO Pets (animal_id) VALUES (LAST_INSERT_ID());
INSERT INTO Dogs (pet_id) VALUES (LAST_INSERT_ID());

-- Пример 2: Кошка Мурка
INSERT INTO Animals (name, birth_date, commands) VALUES ('Мурка', '2023-03-20', 'Мяу, Спать');
INSERT INTO Pets (animal_id) VALUES (LAST_INSERT_ID());
INSERT INTO Cats (pet_id) VALUES (LAST_INSERT_ID());

-- Пример 3: Хомяк Пушок
INSERT INTO Animals (name, birth_date, commands) VALUES ('Пушок', '2024-05-10', 'Бежать');
INSERT INTO Pets (animal_id) VALUES (LAST_INSERT_ID());
INSERT INTO Hamsters (pet_id) VALUES (LAST_INSERT_ID());

-- Пример 4: Лошадь Буцефал
INSERT INTO Animals (name, birth_date, commands) VALUES ('Буцефал', '2021-07-01', 'Галоп, Стой, Шагом');
INSERT INTO PackAnimals (animal_id) VALUES (LAST_INSERT_ID());
INSERT INTO Horses (pack_animal_id) VALUES (LAST_INSERT_ID());

-- Пример 5: Верблюд Горбатый
INSERT INTO Animals (name, birth_date, commands) VALUES ('Горбатый', '2020-11-25', 'Нести груз, Плеваться');
INSERT INTO PackAnimals (animal_id) VALUES (LAST_INSERT_ID());
INSERT INTO Camels (pack_animal_id) VALUES (LAST_INSERT_ID());

-- Пример 6: Осел Иа
INSERT INTO Animals (name, birth_date, commands) VALUES ('Иа', '2022-09-01', 'Стоять, Грузиться');
INSERT INTO PackAnimals (animal_id) VALUES (LAST_INSERT_ID());
INSERT INTO Donkeys (pack_animal_id) VALUES (LAST_INSERT_ID());


-- Начало Задания 10: Удаление верблюдов и объединение таблиц
DELETE FROM Animals WHERE name = 'Горбатый';

-- Создание новой объединенной таблицы EquineAnimals
CREATE TABLE EquineAnimals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pack_animal_id INT NOT NULL,
    animal_type VARCHAR(20) NOT NULL,
    FOREIGN KEY (pack_animal_id) REFERENCES PackAnimals(id) ON DELETE CASCADE
);

-- Копирование данных из Horses в EquineAnimals
INSERT INTO EquineAnimals (pack_animal_id, animal_type)
SELECT pack_animal_id, 'Horse'
FROM Horses;

-- Копирование данных из Donkeys в EquineAnimals
INSERT INTO EquineAnimals (pack_animal_id, animal_type)
SELECT pack_animal_id, 'Donkey'
FROM Donkeys;

-- Удаление старых таблиц Horses и Donkeys
DROP TABLE Horses;
DROP TABLE Donkeys;


-- Начало Задания 11: Создание таблицы "молодые животные" и подсчет возраста
CREATE TABLE YoungAnimals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    animal_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    age_in_months INT NOT NULL
);

INSERT INTO YoungAnimals (animal_id, name, birth_date, age_in_months)
SELECT
    id,
    name,
    birth_date,
    TIMESTAMPDIFF(MONTH, birth_date, CURDATE()) AS age_months
FROM
    Animals
WHERE
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) >= 1
    AND TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) < 3;


-- Начало Задания 12: Объединение всех таблиц в одну
DROP TABLE IF EXISTS AllAnimalsCombined;

CREATE TABLE AllAnimalsCombined AS
SELECT
    A.id AS animal_id,
    A.name,
    A.birth_date,
    A.commands,
    CASE
        WHEN D.pet_id IS NOT NULL THEN 'Собака'
        WHEN C.pet_id IS NOT NULL THEN 'Кошка'
        WHEN H.pet_id IS NOT NULL THEN 'Хомяк'
        WHEN EA.animal_type = 'Horse' THEN 'Лошадь'
        WHEN EA.animal_type = 'Donkey' THEN 'Осел'
        ELSE 'Неизвестно'
    END AS animal_type,
    CASE
        WHEN P.animal_id IS NOT NULL THEN 'Домашнее'
        WHEN PA.animal_id IS NOT NULL THEN 'Вьючное'
        ELSE 'Неизвестно'
    END AS animal_group
FROM
    Animals AS A
LEFT JOIN
    Pets AS P ON A.id = P.animal_id
LEFT JOIN
    Dogs AS D ON P.id = D.pet_id
LEFT JOIN
    Cats AS C ON P.id = C.pet_id
LEFT JOIN
    Hamsters AS H ON P.id = H.pet_id
LEFT JOIN
    PackAnimals AS PA ON A.id = PA.animal_id
LEFT JOIN
    EquineAnimals AS EA ON PA.id = EA.pack_animal_id;