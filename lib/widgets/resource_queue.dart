import 'package:material_tap/widgets/resource_queue_item.dart';
import 'package:material_tap/const.dart';

import 'package:flutter/material.dart';
import 'dart:collection';


class ResourceQueue extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final List<IconData> resources;


	const ResourceQueue({
		super.key,
		required this.resources
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceQueue> createState() => ResourceQueueState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceQueueState extends State<ResourceQueue>
{
	static const double itemsPadding = 10.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	final _remvQueue = Queue<ResourceQueueItem>();
	final _itemQueue = Queue<ResourceQueueItem>();

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
		final key = stackItem.key as GlobalKey<ResourceQueueItemState>;

		final stackState = key.currentState as ResourceQueueItemState;

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

	ResourceQueueItem _createItem(IconData resource, int index)
	{
		// Building tree of widgets
		return ResourceQueueItem(
			key: GlobalKey<ResourceQueueItemState>(),
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
			final key = item.key as GlobalKey<ResourceQueueItemState>;
			final state = key.currentState as ResourceQueueItemState;

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
				children: <ResourceQueueItem>
				[
					..._remvQueue, ..._itemQueue
				],
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}