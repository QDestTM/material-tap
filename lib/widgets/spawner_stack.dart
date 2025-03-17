import 'package:material_tap/widgets/spawner_stack_item.dart';
import 'package:material_tap/const.dart';

import 'package:flutter/material.dart';
import 'dart:collection';


class SpawnerStack extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final List<IconData> resources;


	const SpawnerStack({
		super.key,
		required this.resources
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<SpawnerStack> createState() => SpawnerStackState();

	// ------------------------------------------------------------------------------------------------------<
}


class SpawnerStackState extends State<SpawnerStack>
{
	static const double itemsPadding = 10.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	final _remvQueue = Queue<SpawnerStackItem>();
	final _itemQueue = Queue<SpawnerStackItem>();

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Adding initial resources to stack
		for ( final res in widget.resources )
		{
			add(res);
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	void add(IconData resource)
	{
		final index = _itemQueue.length;

		setState(() {
			final stackItem = _createItem(resource, index);
			_itemQueue.addLast(stackItem);
		});
	}


	IconData pop()
	{
		if ( _itemQueue.isEmpty )
		{
			return Icons.abc;
		}

		// Pop process
		final stackItem = _itemQueue.first;
		final key = stackItem.key as GlobalKey<SpawnerStackItemState>;

		final stackState = key.currentState as SpawnerStackItemState;

		setState(() {
			_remvQueue.addFirst(stackItem);
			_itemQueue.removeFirst();

			stackState.remove();
			_updateStackItemsOffset();
		});

		return stackItem.resource;
	}


	IconData get()
	{
		if ( _itemQueue.isEmpty )
		{
			return Icons.abc;
		}

		return _itemQueue.first.resource;
	}

	// ------------------------------------------------------------------------------------------------------<

	SpawnerStackItem _createItem(IconData resource, int index)
	{
		// Building tree of widgets
		return SpawnerStackItem(
			key: GlobalKey<SpawnerStackItemState>(),
			resource: resource,

			offset: _getOffsetValue(index),
			removeItem: _onRemoveItem,
		);
	}


	void _updateStackItemsOffset()
	{
		int i = 0;

		for ( final item in _itemQueue )
		{
			final key = item.key as GlobalKey<SpawnerStackItemState>;
			final state = key.currentState as SpawnerStackItemState;

			// Updating stack item offset
			final offset = _getOffsetValue(i++);
			state.offset(offset);
		}
	}


	double _getOffsetValue(int index)
	{
		return index * itemsPadding + resourceSlotSize * index;
	}

	// ------------------------------------------------------------------------------------------------------<

	void _onRemoveItem()
	{
		_remvQueue.removeLast();
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return SizedBox(
			width: resourceLineSize,

			child: Stack(
				children: <SpawnerStackItem>
				[
					..._remvQueue, ..._itemQueue
				],
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}