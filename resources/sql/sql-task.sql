/* TASK-1 */

SELECT aircrafts.aircraft_code, aircrafts.model, seats.fare_conditions, count(seats.seat_no)
FROM aircrafts
         INNER JOIN seats ON aircrafts.aircraft_code = seats.aircraft_code
GROUP BY aircrafts.aircraft_code, aircrafts.model, seats.fare_conditions
ORDER BY aircraft_code;

/* TASK-2 */
