import 'package:material_tap/widgets/consumer_stack_item.dart';

import 'package:material_tap/const.dart';
import 'package:flutter/material.dart';

import 'dart:collection';


class ConsumerStack extends StatefulWidget
{
	// # ----------------------------------------------------------------------------------------------------<

	final AxisDirection direction;


	const ConsumerStack({
		super.key,
		required this.direction
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ConsumerStack> createState() => ConsumerStackState();

	// ------------------------------------------------------------------------------------------------------<
}


class ConsumerStackState extends State<ConsumerStack>
{
	static const double endPadding = 10.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	final _itemQueue = Queue<ConsumerStackItem>();
	var _pending = GlobalKey<ConsumerStackItemState>();

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Creating initial pending item
		_createPendingItem();
	}

	// ------------------------------------------------------------------------------------------------------<

	void send(IconData resource)
	{
		final pendingState = _pending.currentState!;

		setState(() {
			pendingState.send(resource);
			_createPendingItem();
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	ConsumerStackItem _createItem()
	{
		// Building tree of widgets
		return ConsumerStackItem(
			key: GlobalKey<ConsumerStackItemState>(),

			startAlignment: _getStartAlignment(),
			endAlignment: _getEndAlignment(),

			checkResource: _onCheckResource,
			removeItem: _onRemoveItem,
		);
	}


	void _createPendingItem()
	{
		final pendingItem = _createItem();

		// Getting and updating key of new pending item
		_pending = pendingItem.key as GlobalKey<ConsumerStackItemState>;

		// Adding item to items stack
		_itemQueue.add(pendingItem);
	}

	// ------------------------------------------------------------------------------------------------------<

	void _onCheckResource(IconData resource)
	{

	}


	void _onRemoveItem()
	{
		_itemQueue.removeFirst();
	}

	// ------------------------------------------------------------------------------------------------------<

	double _getContainerWidth()
	{
		final bool directed =
			widget.direction == AxisDirection.up ||
			widget.direction == AxisDirection.down;

		return directed ? resourceLineSize : double.infinity;
	}


	double _getContainerHeight()
	{
		final bool directed =
			widget.direction == AxisDirection.left ||
			widget.direction == AxisDirection.right;

		return directed ? resourceLineSize : double.infinity;
	}

	// ------------------------------------------------------------------------------------------------------<

	Alignment _getStartAlignment()
	{
		switch (widget.direction)
		{
			case AxisDirection.up:
				return Alignment.bottomCenter;
			case AxisDirection.right:
				return Alignment.centerLeft;
			case AxisDirection.down:
				return Alignment.topCenter;
			case AxisDirection.left:
				return Alignment.centerRight;
		}
	}


	Alignment _getEndAlignment()
	{
		switch (widget.direction)
		{
			case AxisDirection.up:
				return Alignment.topCenter;
			case AxisDirection.right:
				return Alignment.centerRight;
			case AxisDirection.down:
				return Alignment.bottomCenter;
			case AxisDirection.left:
				return Alignment.centerLeft;
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	EdgeInsets _getPadding()
	{
		switch (widget.direction)
		{
			case AxisDirection.up:
				return const EdgeInsets.only(top: endPadding);
			case AxisDirection.right:
				return const EdgeInsets.only(right: endPadding);
			case AxisDirection.down:
				return const EdgeInsets.only(bottom: endPadding);
			case AxisDirection.left:
				return const EdgeInsets.only(left: endPadding);
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return SizedBox(
			width: _getContainerWidth(),
			height: _getContainerHeight(),

			child: Padding(
				padding: _getPadding(),

				child: Stack(
					children: _itemQueue.toList(),
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}