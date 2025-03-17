import 'package:flutter/material.dart';


// Main seed color of whole app
const Color seedColor = Colors.teal;

// Style constants
const iconBaseShadows = <BoxShadow>
[
	BoxShadow(
		color: Color.fromARGB(124, 0, 0, 0),
		spreadRadius: 4,
		blurRadius: 4,
		offset: Offset(1, 1)
	)
];

const itemBaseShadows = <BoxShadow>
[
	BoxShadow(
		color: Color.fromARGB(124, 0, 0, 0),
		blurRadius: 3,
		spreadRadius: 2,
	)
];

// Constant values for sizing
const double resourceSlotSize = 64.0;
const double resourceLineSize = 86.0;

const double resourceDisplayIconSize = 72.0;
const double resourceDisplaySize = 100.0;

const double paddingOffset = 12.0;

const Duration slotAnimationTime = Duration(milliseconds: 800);


// Constant instances
const resourceIconsSet = <IconData>[
	Icons.abc,
	Icons.tab_sharp,
	Icons.ac_unit,
	Icons.dashboard,
	Icons.account_box,
	Icons.work_sharp,
	Icons.accessibility,
	Icons.money,
	Icons.cast_sharp,
	Icons.call_sharp,
	Icons.door_sliding_sharp
];
