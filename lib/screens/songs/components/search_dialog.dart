import 'package:flutter/material.dart';

class SearchDialog extends StatefulWidget {

  const SearchDialog(this.initialText);

  final String initialText;

  @override
  State<StatefulWidget> createState() {
    return SearchDialogState();
  }

}

class SearchDialogState extends State<SearchDialog>{

  Map mapTagNameChip = {'louvor': false, 'busca': false,'rapida': false,'media': false,'lenta': false,};

  Widget _buildChip(String tagName, Color color) {
    return FilterChip(
              backgroundColor: Colors.blueGrey,
              // avatar: CircleAvatar(
              //   backgroundColor: Colors.cyan,
              //   child: Text(tagName.toUpperCase(), style: TextStyle(color: Colors.white),),
              // ),
              label: Text(tagName,  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              selected: mapTagNameChip[tagName],
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                setState(() => mapTagNameChip.update(tagName, (value) => selected));
              },
            );

  }

  chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: <Widget>[
        _buildChip('louvor', Colors.blue),
        _buildChip('busca', Colors.blue),
        _buildChip('rapida', Colors.blue),
        _buildChip('media', Colors.blue),
        _buildChip('lenta', Colors.blue),
      ],
    );
  }

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
                  initialValue: widget.initialText,
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

                chipList(),

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