import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/main/models/fish.dart';
import 'package:flutter/material.dart';

class FishTile extends StatefulWidget {
  final Fish fish;
  final int total;
  final double userEnergy;
  final double totalExpectEnergy;
  final void Function(int newTotal) onQuantityChanged;
  final void Function(double newTotalExpectEnergy) onExpectEnergyChange;

  const FishTile({
    super.key,
    required this.fish,
    required this.total,
    required this.onQuantityChanged,
    required this.onExpectEnergyChange,
    required this.userEnergy,
    required this.totalExpectEnergy,
  });

  @override
  State<FishTile> createState() => _FishTileState();
}

class _FishTileState extends State<FishTile> {
  int _qty = 0;

  void _onChangeQty(isAddReq) {
    setState(() {
      _qty = isAddReq ? _qty + 1 : _qty - 1;
    });

    int newTotal = isAddReq ? widget.total + 1 : widget.total - 1;

    widget.onQuantityChanged(newTotal);
    _onChangeEnergy(isAddReq);
  }

  void _onChangeEnergy(isAddReq) {
    double thisExpectEnergy = widget.fish.energy * 0.01;
    double totalExpectEnergy = widget.totalExpectEnergy;

    totalExpectEnergy =
        isAddReq
            ? totalExpectEnergy + thisExpectEnergy
            : (totalExpectEnergy - thisExpectEnergy > widget.userEnergy
                ? totalExpectEnergy - thisExpectEnergy
                : widget.userEnergy);

    widget.onExpectEnergyChange(totalExpectEnergy);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AnimatedContainer(
      decoration: BoxDecoration(
        color: _qty > 0 ? Colors.blue.shade200 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
        border: _qty > 0 ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      width: size.width * 0.45,
      height: size.width * 0.45,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
                onPressed: () => _qty > 0 ? _onChangeQty(false) : null,
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
