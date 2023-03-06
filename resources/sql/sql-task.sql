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
