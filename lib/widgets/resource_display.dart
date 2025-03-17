import 'package:flutter/material.dart';
import 'package:material_tap/const.dart';


class ResourceDisplay extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final IconData resource;


	const ResourceDisplay({
		super.key,
		required this.resource
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceDisplay> createState() => ResourceDisplayState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceDisplayState extends State<ResourceDisplay>
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final _res0Key = GlobalKey();
	final _res1Key = GlobalKey();

	IconData _resource0 = Icons.dangerous;
	IconData _resource1 = Icons.dangerous;

	bool _switch = true; // false for 0, true for 1

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState() {
		super.initState();

		// Setting initial resource
		_resource1 = widget.resource;
	}

	// ------------------------------------------------------------------------------------------------------<

	IconData replace(IconData resource)
	{
		final stored = _switch ? _resource1 : _resource0;

		setState(() {
			_switch = !_switch;

			if ( _switch ) {
				_resource1 = resource;
			} else {
				_resource0 = resource;
			}
		});

		return stored;
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Container(
			width: resourceDisplaySize,
			height: resourceDisplaySize,

			decoration: BoxDecoration(
				color: scheme.secondaryFixed,
				borderRadius: BorderRadius.circular(32.0),
				boxShadow: itemBaseShadows
			),

			child: AnimatedSwitcher(
				duration: Duration(milliseconds: 500),
				reverseDuration: Duration(milliseconds: 0),

				switchInCurve: Curves.easeOutQuart,

				transitionBuilder: (child, animation) {
					return ScaleTransition(
						scale: animation, child: child
					);
				},

				child: _switch
					? Icon(_resource1, key: _res1Key,
						size: resourceDisplayIconSize, shadows: iconBaseShadows)
					: Icon(_resource0, key: _res0Key,
						size: resourceDisplayIconSize, shadows: iconBaseShadows),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}