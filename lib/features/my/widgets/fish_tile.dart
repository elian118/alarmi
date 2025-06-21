import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/container_tile.dart';
import 'package:alarmi/features/my/models/fish.dart';
import 'package:flutter/material.dart';

class FishTile extends StatefulWidget {
  final Fish fish;

  const FishTile({super.key, required this.fish});

  @override
  State<FishTile> createState() => _FishTileState();
}

class _FishTileState extends State<FishTile> {
  int _qty = 0;

  void _onChangeQty(isAddReq) {
    setState(() {
      _qty = isAddReq ? _qty + 1 : (_qty - 1 > 0 ? _qty - 1 : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerTile(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/${widget.fish.image}",
            width: 88,
            height: 88,
          ),
          Text(
            widget.fish.name,
            style: TextStyle(
              fontSize: Sizes.size14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _onChangeQty(false),
                icon: Icon(Icons.remove),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text('$_qty'),
              ),
              IconButton(
                onPressed: () => _onChangeQty(true),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
