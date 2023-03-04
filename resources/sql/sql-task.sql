/* TASK-1 */

SELECT aircrafts.aircraft_code, aircrafts.model, seats.fare_conditions, count(seats.seat_no)
FROM aircrafts
         JOIN seats ON aircrafts.aircraft_code = seats.aircraft_code
GROUP BY aircrafts.aircraft_code, aircrafts.model, seats.fare_conditions
ORDER BY aircraft_code;

/* TASK-2 */

SELECT aircrafts.model, count(seats.seat_no) AS seat_count
FROM seats
         JOIN aircrafts ON aircrafts.aircraft_code = seats.aircraft_code
GROUP BY aircrafts.model
ORDER BY seat_count DESC
LIMIT 3;

/* TASK-3 */

SELECT aircrafts.aircraft_code, aircrafts.model, seats.seat_no
FROM aircrafts
         JOIN seats on aircrafts.aircraft_code = seats.aircraft_code
WHERE aircrafts.model LIKE 'Аэробус A321-200'
  AND seats.fare_conditions NOT LIKE 'Economy'
GROUP BY aircrafts.aircraft_code, aircrafts.model, seats.seat_no
ORDER BY seats.seat_no;