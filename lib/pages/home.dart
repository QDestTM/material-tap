import 'dart:async';

import 'package:material_tap/widgets/resource_sender.dart';
import 'package:material_tap/widgets/resource_display.dart';
import 'package:material_tap/widgets/resource_queue.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:material_tap/const.dart';
import 'package:flutter/material.dart';

import 'dart:math';


class HomePage extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	const HomePage({super.key});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<HomePage> createState() => HomePageState();

	// ------------------------------------------------------------------------------------------------------<
}


class HomePageState extends State<HomePage> with WidgetsBindingObserver
{
	static const int initialResourcesCount = 12;
	static const int tapTimeout = 200;

	// ^ ----------------------------------------------------------------------------------------------------<

	final _resourceDisplay = GlobalKey<ResourceDisplayState>();
	final _resourceQueue = GlobalKey<ResourceQueueState>();

	final _resourceSenderL = GlobalKey<ResourceSenderState>();
	final _resourceSenderD = GlobalKey<ResourceSenderState>();
	final _resourceSenderR = GlobalKey<ResourceSenderState>();

	final _random = Random();

	var _canTap = true;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Binding widgets binding observer
		WidgetsBinding.instance.addObserver(this);

		// Enabling wakelock
		WakelockPlus.enable();
	}


	@override
	void dispose()
	{
		super.dispose();

		// Unbinding widgets binding observer
		WidgetsBinding.instance.removeObserver(this);

		// Disabling wakelock
		WakelockPlus.disable();
	}


	@override
	void didChangeAppLifecycleState(AppLifecycleState state)
	{
		if (state case AppLifecycleState.paused) {
			WakelockPlus.disable();
		} else
		if (state case AppLifecycleState.resumed) {
			WakelockPlus.enable();
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	void _handlePressL()
	{
		if ( !_canTap ) return;
		_timeoutTap();

		final resource = _rotateStackResources();
		_resourceSenderL.currentState?.send(resource);
	}


	void _handlePressD()
	{
		if ( !_canTap ) return;
		_timeoutTap();

		final resource = _rotateStackResources();
		_resourceSenderD.currentState?.send(resource);
	}


	void _handlePressR()
	{
		if ( !_canTap ) return;
		_timeoutTap();

		final resource = _rotateStackResources();
		_resourceSenderR.currentState?.send(resource);
	}

	// ------------------------------------------------------------------------------------------------------<

	IconData _rotateStackResources()
	{
		final currentResource = _resourceQueue.currentState?.pop();

		// Receiving next resource
		final nextResource = _getRandomResource();
		_resourceQueue.currentState?.add(nextResource);

		// Updating display
		final nextDisplay = _resourceQueue.currentState?.get();
		_resourceDisplay.currentState?.replace(nextDisplay!);

		return currentResource!;
	}


	IconData _getRandomResource()
	{
		return resourceIconsSet[
			_random.nextInt(resourceIconsSet.length - 1)
		];
	}

	// ------------------------------------------------------------------------------------------------------<

	void _timeoutTap()
	{
		_canTap = false;

		Timer(
			const Duration(milliseconds: tapTimeout),
			() { _canTap = true; }
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Generating set of initial resources
		final initial = List.generate(
			initialResourcesCount, (_) => _getRandomResource()
		);

		// Building tree of widgets
		return Scaffold(
			appBar: AppBar(
				key: GlobalKey(debugLabel: "Upper App Bar"),
				backgroundColor: scheme.secondaryFixed,

				shadowColor: Colors.black,
				elevation: 8,
			),

			body: Stack(
				key: GlobalKey(debugLabel: "App Body"),

				children: <Widget>
				[
					// Middle vertical line display
					Center(
						child: Container(
							width: resourceLineSize,
							color: scheme.secondaryFixedDim,
						),
					),

					// Middle horizontal line display
					Center(
						child: Container(
							height: resourceLineSize,
							color: scheme.secondaryFixedDim,
						),
					),

					// Vertical resource layout items
					Center(
						child: Column(
							children: <Expanded>
							[
								Expanded(
									child: ResourceSender(
										key: _resourceSenderD,
										direction: AxisDirection.up
									),
								),

								Expanded(
									child: ResourceQueue(
										key: _resourceQueue,
										resources: initial,
									),
								),
							],
						),
					),

					// Horizontal resource layout items
					Center(
						child: Row(
							children: <Expanded>[
								Expanded(
									child: ResourceSender(
										key: _resourceSenderL,
										direction: AxisDirection.left
									),
								),

								Expanded(
									child: ResourceSender(
										key: _resourceSenderR,
										direction: AxisDirection.right
									),
								)
							],
						),
					),

					// Resource display component
					Center(
						child: ResourceDisplay(
							key: _resourceDisplay,
							resource: initial.first,
						),
					),
				],
			),

			bottomNavigationBar: Container(
				key: GlobalKey(debugLabel: "Bottom Nav Bar"),

				constraints: const BoxConstraints(
					minHeight: resourceLineSize,
					maxHeight: resourceLineSize
				),

				decoration: BoxDecoration(
					color: scheme.secondaryFixed,

					borderRadius: const BorderRadius.only(
						topLeft: Radius.circular(42.0),
						topRight: Radius.circular(42.0),
					),

					boxShadow: itemBaseShadows
				),

				child: Row(
					crossAxisAlignment: CrossAxisAlignment.stretch,

					children: <Widget>
					[
						// Left move action button
						Expanded(
							child: IconButton(
								onPressed: _handlePressL,
								highlightColor: scheme.secondaryFixedDim,

								tooltip: "Move Left",
								icon: const Icon(
									shadows: iconBaseShadows,
									Icons.turn_left, size: 64.0
								),
							),
						),

						// Middle move action button
						Expanded(
							child: IconButton(
								onPressed: _handlePressD,
								highlightColor: scheme.secondaryFixedDim,

								tooltip: "Move Delete",
								icon: const Icon(
									shadows: iconBaseShadows,
									Icons.delete, size: 64.0
								),
							),
						),

						// Right move action button
						Expanded(
							child: IconButton(
								onPressed: _handlePressR,
								highlightColor: scheme.secondaryFixedDim,

								tooltip: "Move Right",
								icon: const Icon(
									shadows: iconBaseShadows,
									Icons.turn_right, size: 64.0
								),
							),
						)
					],
				),
			),

			extendBody: false,
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}