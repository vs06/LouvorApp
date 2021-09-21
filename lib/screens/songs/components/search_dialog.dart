import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {

  const SearchDialog(this.initialText);

  final String initialText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(

            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: initialText,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.grey[700],
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                  ),
                  onFieldSubmitted: (text){
                    Navigator.of(context).pop(text);
                  },
                ),

                const ListTile(
                  leading: Icon(Icons.album),
                  title: Text('The Enchanted Nightingale'),
                  subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //
                //     TextFormField(
                //       initialValue: initialText,
                //       textInputAction: TextInputAction.search,
                //       autofocus: true,
                //       decoration: InputDecoration(
                //           border: InputBorder.none,
                //           contentPadding: const EdgeInsets.symmetric(vertical: 15),
                //           prefixIcon: IconButton(
                //             icon: Icon(Icons.arrow_back),
                //             color: Colors.grey[700],
                //             onPressed: (){
                //               Navigator.of(context).pop();
                //             },
                //           )
                //       ),
                //       onFieldSubmitted: (text){
                //         Navigator.of(context).pop(text);
                //       },
                //     ),
                //
                //      TextButton(
                //        child: const Text('BUY TICKETS'),
                //     //   onPressed: () {/* ... */},
                //      ),
                //     // const SizedBox(width: 8),
                //     // TextButton(
                //     //   child: const Text('LISTEN'),
                //     //   onPressed: () {/* ... */},
                //     // ),
                //     // const SizedBox(width: 8),
                //
                //
                //   ],
                // ),
              ],
            ),

          ),
        )
      ],
    );
  }
}