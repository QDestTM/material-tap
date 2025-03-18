import 'package:material_tap/widgets/resource_spawner_item.dart';
import 'package:material_tap/widgets/resource_display.dart';
import 'package:material_tap/types.dart';

import 'package:flutter/material.dart';
import 'dart:collection';


class ResourceSpawner extends StatefulWidget
{
	static const double defaultSize = 86.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	final List<ResourceData> initialData;
	final double size;

	const ResourceSpawner({
		super.key,
		this.size = defaultSize,
		required this.initialData
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceSpawner> createState() => ResourceSpawnerState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceSpawnerState extends State<ResourceSpawner>
{
	static const double itemsPadding = 10.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	final _itemQueue = Queue<ResourceSpawnerItem>();
	final _remvQueue = Queue<ResourceSpawnerItem>();

	ResourceData get pending => _itemQueue.isEmpty
		? Icons.dangerous : _itemQueue.first.data;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Adding initial resources to stack
		for ( final res in widget.initialData )
		{
			put(res);
		}
	}

	// @ ----------------------------------------------------------------------------------------------------<

	void put(ResourceData data)
	{
		final index = _itemQueue.length;

		setState(() {
			final item = _createItem(data, index);
			_itemQueue.addLast(item);
		});
	}


	ResourceData get()
	{
		if ( _itemQueue.isEmpty )
		{
			return Icons.dangerous;
		}

		// Pop process
		final item = _itemQueue.first;

		setState(() {
			_itemQueue.removeFirst();

			// Set negative offset value for remove animation
			_remvQueue.addFirst(
				item.withOffset(-ResourceDisplay.defaultDispSize)
			);

			_updateItemsOffset();
		});

		return item.data;
	}

	// ------------------------------------------------------------------------------------------------------<

	ResourceSpawnerItem _createItem(ResourceData data, int index)
	{
		// Building tree of widgets
		return ResourceSpawnerItem(
			key: UniqueKey(),

			size: widget.size,
			data: data,

			offset: _getOffsetAt(index),
			itemRemove: _onItemRemove,
		);
	}


	void _updateItemsOffset()
	{
		for ( int i = 0; i < _itemQueue.length; i++ )
		{
			final offset = _getOffsetAt(i);

			// Updating offset of element
			final item = _itemQueue
				.removeFirst().withOffset(offset);

			_itemQueue.addLast(item);
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	void _onItemRemove()
	{
		setState(() {
			_remvQueue.removeLast();
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Container(
			width: widget.size,
			color: scheme.secondaryFixedDim,

			child: Stack(
				children: <ResourceSpawnerItem>
				[
					..._remvQueue,
					..._itemQueue
				],
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	static double _getOffsetAt(int index)
	{
		return (ResourceDisplay.defaultDispSize + itemsPadding) * index;
	}

	// ------------------------------------------------------------------------------------------------------<
}