import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Citas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReservaScreen(),
    );
  }
}

class ReservaScreen extends StatefulWidget {
  @override
  _ReservaScreenState createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selección de Reserva')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_selectedDay != null) {
                      _agendarReserva(_selectedDay!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor selecciona una fecha'),
                        ),
                      );
                    }
                  },
                  child: Text('Agendar Reserva'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedDay != null) {
                      _cancelarReserva(_selectedDay!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor selecciona una fecha'),
                        ),
                      );
                    }
                  },
                  child: Text('Cancelar Reserva'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Mis Reservas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _reservas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Reserva el ${_reservas[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> _reservas = [];

  void _agendarReserva(DateTime fecha) {
    setState(() {
      _reservas.add('${fecha.day}/${fecha.month}/${fecha.year}');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reserva agendada para el ${fecha.day}/${fecha.month}/${fecha.year}',
        ),
      ),
    );
  }

  void _cancelarReserva(DateTime fecha) {
    setState(() {
      _reservas.remove('${fecha.day}/${fecha.month}/${fecha.year}');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reserva cancelada para el ${fecha.day}/${fecha.month}/${fecha.year}',
        ),
      ),
    );
  }
}
