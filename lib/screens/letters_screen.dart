import 'package:flutter/material.dart';

class LettersScreen extends StatefulWidget {
  const LettersScreen({super.key});

  @override
  State<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends State<LettersScreen> {

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Letters to Tomorrow"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),

            const SizedBox(height:20),

            Expanded(
              child: TextField(
                controller: messageController,
                expands: true,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Write to your future self...",
                ),
              ),
            ),

            const SizedBox(height:20),

            ElevatedButton(

              onPressed: () async {

                final picked = await showDatePicker(

                  context: context,

                  firstDate: DateTime.now(),

                  lastDate: DateTime(2050),

                  initialDate: DateTime.now(),

                );

                if(picked!=null){

                  setState(() {

                    selectedDate = picked;

                  });

                }

              },

              child: Text(

                selectedDate==null

                ? "Choose Opening Date"

                : selectedDate.toString().split(" ")[0],

              ),

            ),

            const SizedBox(height:15),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: (){

                  ScaffoldMessenger.of(context).showSnackBar(

                    const SnackBar(

                      content: Text("Letter saved successfully."),

                    ),

                  );

                },

                child: const Text("Save Letter"),

              ),

            )

          ],

        ),

      ),

    );

  }

}