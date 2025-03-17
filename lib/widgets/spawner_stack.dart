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

	final _keysStacked = List<GlobalKey>.empty(growable: true);
	final _keysRemoved = HashSet<GlobalKey>();

	final _itemsMap = HashMap<GlobalKey, SpawnerStackItem>();

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Adding initial resources to stack
		for ( final resource in widget.resources )
		{
			add(resource);
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	void add(IconData resource)
	{
		final index = _keysStacked.length;

		setState(() {
			final stackItem = _createItem(resource, index);
			final key = stackItem.key as GlobalKey;

			_itemsMap[key] = stackItem;
			_keysStacked.add(key);
		});
	}


	IconData pop()
	{
		if ( _keysStacked.isEmpty )
		{
			return Icons.abc;
		}

		// Pop process
		final key = _keysStacked.first;
		final stackItem = _itemsMap[key]!;

		final stored = stackItem.resource;

		setState(() {
			_keysStacked.removeAt(0);
			_keysRemoved.add(key);

			_itemsMap[key] = SpawnerStackItem.offset(
				source: stackItem,
				offset: -resourceSlotSize
			);

			_updateStackItemsOffset();
		});

		return stored;
	}


	IconData get()
	{
		if ( _keysStacked.isEmpty )
		{
			return Icons.abc;
		}

		// Get process
		final key = _keysStacked.first;
		return _itemsMap[key]!.resource;
	}

	// ------------------------------------------------------------------------------------------------------<

	SpawnerStackItem _createItem(IconData resource, int index)
	{
		// Building tree of widgets
		return SpawnerStackItem(
			key: GlobalKey(),
			resource: resource,

			offset: _getOffsetValue(index),
			itemRemove: _handleItemRemove,
		);
	}


	void _updateStackItemsOffset()
	{
		for ( int i = 0; i < _keysStacked.length; i++ )
		{
			final key = _keysStacked.elementAt(i);
			final stackItem = _itemsMap[key]!;

			// Updating stack item offset
			_itemsMap[key] = SpawnerStackItem.offset(
				source: stackItem,
				offset: _getOffsetValue(i)
			);
		}
	}


	double _getOffsetValue(int index)
	{
		return index * itemsPadding + resourceSlotSize * index;
	}

	// ------------------------------------------------------------------------------------------------------<

	void _handleItemRemove(GlobalKey key)
	{
		if ( _keysRemoved.contains(key) )
		{
			_keysRemoved.remove(key);
			_itemsMap.remove(key);
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return SizedBox(
			width: resourceLineSize,

			child: Stack(
				children: _itemsMap.values.toList(growable: false),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}