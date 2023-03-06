/* TASK-1 */

SELECT aircrafts_data.aircraft_code        AS code,
       aircrafts_data.model::json ->> 'ru' AS model,
       seats.fare_conditions               AS fare_conditions,
       count(seats.seat_no)                AS seat_count
FROM aircrafts_data
         JOIN seats ON aircrafts_data.aircraft_code = seats.aircraft_code
GROUP BY aircrafts_data.aircraft_code, aircrafts_data.model, seats.fare_conditions
ORDER BY aircrafts_data.aircraft_code;

/* TASK-2 */

SELECT aircrafts_data.model::json ->> 'ru' AS model,
       count(seats.seat_no)                AS seat_count
FROM seats
         JOIN aircrafts_data ON aircrafts_data.aircraft_code = seats.aircraft_code
GROUP BY aircrafts_data.model
ORDER BY seat_count DESC
LIMIT 3;

/* TASK-3 */

SELECT aircrafts_data.aircraft_code        AS code,
       aircrafts_data.model::json ->> 'ru' AS model,
       seats.seat_no                       AS seats
FROM aircrafts_data
         JOIN seats ON aircrafts_data.aircraft_code = seats.aircraft_code
WHERE aircrafts_data.model::json ->> 'ru' LIKE 'Аэробус A321-200'
  AND seats.fare_conditions NOT LIKE 'Economy'
ORDER BY seats;

/* TASK-4 */
SELECT airports_data.airport_code               AS code,
       airports_data.airport_name::json -> 'ru' AS name,
       airports_data.city::json ->> 'ru'        AS city
FROM airports_data
WHERE city = ANY
      (SELECT airports_data.city
       FROM airports_data
       GROUP BY airports_data.city
       HAVING count(airport_code) >= 2);

/* TASK-5 */

SELECT flights.flight_id                             AS flight_id,
       flights.flight_no                             AS flight_no,
       flights.scheduled_departure                   AS scheduled_departure,
       flights.scheduled_arrival                     AS scheduled_arrival,
       departure_airport.city::json ->> 'ru'         AS departure_city,
       departure_airport.airport_name::json ->> 'ru' AS departure_airport,
       arrivial_airport.city::json ->> 'ru'          AS arrivial_city,
       arrivial_airport.airport_name::json ->> 'ru'  AS arrivial_airport,
       ad.model::json ->> 'ru'                       AS airplane_model
FROM flights
         JOIN aircrafts_data ad ON ad.aircraft_code = flights.aircraft_code
         JOIN airports_data arrivial_airport ON arrivial_airport.airport_code = flights.arrival_airport
         JOIN airports_data departure_airport ON departure_airport.airport_code = flights.departure_airport
WHERE flights.departure_airport = ANY (SELECT airport_code
                                       FROM airports_data
                                       WHERE city::json ->> 'ru' = 'Екатеринбург')
  AND flights.arrival_airport = ANY (SELECT airport_code
                                     FROM airports_data
                                     WHERE city::json ->> 'ru' = 'Москва')
  AND status IN ('Scheduled', 'On Time', 'Delayed')
ORDER BY scheduled_departure
LIMIT 1;

/* TASK-6 */

SELECT *
FROM (SELECT *
      FROM ticket_flights
      WHERE amount IN (SELECT min(amount)
                       FROM ticket_flights)
      LIMIT 1) AS min
UNION
SELECT *
FROM (SELECT *
      FROM ticket_flights
      WHERE amount IN (SELECT max(amount)
                       FROM ticket_flights)
      LIMIT 1) AS max;

/* TASK-7 */

CREATE TABLE IF NOT EXISTS customers
(
    id        BIGSERIAL    NOT NULL,
    firstname VARCHAR(255) NOT NULL CHECK ( firstname != '' ),
    lastname  VARCHAR(255) NOT NULL CHECK ( lastname != '' ),
    email     VARCHAR(255) NOT NULL,
    phone     VARCHAR(15)  NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (email),
    UNIQUE (phone),
    CONSTRAINT email_check CHECK ( email ~* '^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$' )
);

INSERT INTO customers (firstname, lastname, email, phone)
VALUES ('Alex', 'Alexandrov', 'alex.alexandrov@gmail.com', '+375258572832'),
       ('Angelina', 'Petrova', 'angelina.petrova@gmail.com', '+375258190201'),
       ('Dmitry', 'Ivanov', 'dmitry.ivanov@gmail.com', '+37525010122'),
       ('Tatyana', 'Golub', 'tatyana.golub@gmail.com', '+375251232341'),
       ('Alexey', 'Ivleev', 'alexey.ivleev@gmail.com', '+375256510402');

CREATE TABLE IF NOT EXISTS orders
(
    id          BIGSERIAL NOT NULL,
    quantity    INT       NOT NULL,
    customer_id BIGSERIAL NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (id),
    FOREIGN KEY (customer_id) REFERENCES customers,
    CONSTRAINT phone_check CHECK ( quantity >= 0 )
);

INSERT INTO orders(quantity, customer_id)
VALUES (10, 1),
       (5, 2),
       (3, 3),
       (6, 4),
       (8, 5);

DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS orders;

