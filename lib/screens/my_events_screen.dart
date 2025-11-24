import 'package:flutter/material.dart';
import 'event store.dart'; 

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  bool showFilter = false;
  bool showSort = false;

  @override
  Widget build(BuildContext context) {
    final int count = myEvents.length;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "My Events",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP FILTER BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, size: 22),
                  SizedBox(width: 12),

                  Text(
                    "All My Events",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // --- FILTER / SORT ---
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showFilter = !showFilter;
                    });
                  },
                  child: _smallButton("Filter", Icons.arrow_drop_down),
                ),
                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      showSort = !showSort;
                    });
                  },
                  child: _smallButton("Sort", Icons.arrow_drop_down),
                ),

                const Spacer(),

                Text(
                  "$count events",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- FILTER POPUP ---
            if (showFilter)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Text(
                  "Filter options coming soon...",
                  style: TextStyle(fontSize: 14),
                ),
              ),

            if (showSort)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Text(
                  "Sort options coming soon...",
                  style: TextStyle(fontSize: 14),
                ),
              ),

            const SizedBox(height: 16),

            // --- "My Events" Header ---
            const Text(
              "My Events",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
              ),
            ),

            const SizedBox(height: 20),

            // --- EVENTS LIST ---
            Expanded(
              child: myEvents.isEmpty
                  ? const Center(
                child: Text(
                  "You haven't added any events yet.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
                  : ListView.builder(
                itemCount: myEvents.length,
                itemBuilder: (context, index) {
                  final EventModel event = myEvents[index];


                  final List<Color> colors = [
                    const Color(0xFFDCE3FF),
                    const Color(0xFFFFE8D9),
                    const Color(0xFFE8F4FF),
                  ];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TITLE
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "${event.date}, ${event.time}",
                          style: const TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${event.location} • ${event.category}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("View Details"),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Icon(icon, size: 20),
        ],
      ),
    );
  }
}
