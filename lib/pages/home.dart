import 'package:material_tap/widgets/resource_spawner.dart';
import 'package:material_tap/widgets/resource_sender.dart';
import 'package:material_tap/widgets/resource_slot.dart';
import 'package:material_tap/types.dart';
import 'package:material_tap/const.dart';

import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/material.dart';

import 'dart:async';
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

	// Constants for bottom nav bar components
	static const double bottomNavBtnIconsSize = 48.0;
	static const double bottomNavBarHeight = 64.0;

	static const bottomNavBtnIconShadows = <BoxShadow>
	[
		BoxShadow(
			color: Color.fromARGB(124, 0, 0, 0),
			spreadRadius: 4,
			blurRadius: 4,
			offset: Offset(1, 1)
		)
	];

	static const bottomNavBarShadows = <BoxShadow>
	[
		BoxShadow(
			color: Color.fromARGB(124, 0, 0, 0),
			blurRadius: 3,
			spreadRadius: 2,
		)
	];

	// ^ ----------------------------------------------------------------------------------------------------<

	final _resourceSpawner = GlobalKey<ResourceSpawnerState>();
	final _resourceSlot = GlobalKey<ResourceSlotState>();

	final _resourceSenderL = GlobalKey<ResourceSenderState>();
	final _resourceSenderD = GlobalKey<ResourceSenderState>();
	final _resourceSenderR = GlobalKey<ResourceSenderState>();

	final _randomGenerator = Random();

	late final List<ResourceData> initialResources;
	late bool _canTap = true;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Creating list with initial resources
		initialResources = List.generate(
			initialResourcesCount, (_) => _getRandomResource()
		);

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

		final resource = _rotateSpawner();
		_resourceSenderL.currentState?.send(resource);
	}


	void _handlePressD()
	{
		if ( !_canTap ) return;
		_timeoutTap();

		final resource = _rotateSpawner();
		_resourceSenderD.currentState?.send(resource);
	}


	void _handlePressR()
	{
		if ( !_canTap ) return;
		_timeoutTap();

		final resource = _rotateSpawner();
		_resourceSenderR.currentState?.send(resource);
	}


	void _handleDragEndV(DragEndDetails details)
	{
		if ( details.primaryVelocity! < 0 ) {
			_handlePressD();
		}
	}


	void _handleDragEndH(DragEndDetails details)
	{
		if ( details.primaryVelocity! > 0 ) {
			_handlePressR();
		} else
		if ( details.primaryVelocity! < 0 ) {
			_handlePressL();
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	ResourceData _rotateSpawner()
	{
		final spawnerState = _resourceSpawner.currentState;
		final slotState = _resourceSlot.currentState;

		// Null check for states
		if ( slotState == null || spawnerState == null )
		{
			return Icons.dangerous;
		}

		// Putting next resource to spawner
		final nextResource = _getRandomResource();
		spawnerState.put(nextResource);

		// Updating resource in slot
		final spawnedResource = spawnerState.get();
		slotState.set(spawnerState.pending);

		return spawnedResource;
	}


	ResourceData _getRandomResource()
	{
		final length = resourceDataSet.length;
		final index = _randomGenerator.nextInt(length);

		return resourceDataSet[index];
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
					// Vertical components
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
									child: ResourceSpawner(
										key: _resourceSpawner,
										initialData: initialResources,
									),
								),
							],
						),
					),

					// Horizontal components
					Center(
						child: Row(
							children: <Expanded>
							[
								Expanded(
									child: ResourceSender(
										key: _resourceSenderL,
										direction: AxisDirection.left,
									),
								),

								Expanded(
									child: ResourceSender(
										key: _resourceSenderR,
										direction: AxisDirection.right,
									),
								)
							],
						),
					),

					// Resource slot component
					Center(
						child: ResourceSlot(
							key: _resourceSlot,
							data: initialResources.first,
						),
					),

					GestureDetector(
						onVerticalDragEnd: _handleDragEndV,
						onHorizontalDragEnd: _handleDragEndH,
					)
				],
			),

			bottomNavigationBar: Container(
				key: GlobalKey(debugLabel: "Bottom Nav Bar"),
				height: bottomNavBarHeight,

				decoration: BoxDecoration(
					color: scheme.secondaryFixed,
					boxShadow: bottomNavBarShadows,

					borderRadius: const BorderRadius.only(
						topLeft: Radius.circular(42.0),
						topRight: Radius.circular(42.0),
					),
				),

				child: Row(
					crossAxisAlignment: CrossAxisAlignment.stretch,

					children: <Widget>
					[
						// Left move action button
						Expanded(
							flex: 1,

							child: IconButton(
								onPressed: _handlePressL,
								highlightColor: scheme.secondaryFixedDim,

								tooltip: "Move Left",
								icon: const Icon(
									shadows: bottomNavBtnIconShadows,
									Icons.turn_left, size: bottomNavBtnIconsSize
								),
							),
						),

						// Middle move action button
						Expanded(
							flex: 1,

							child: IconButton(
								onPressed: _handlePressD,
								highlightColor: scheme.secondaryFixedDim,

								tooltip: "Move Delete",
								icon: const Icon(
									shadows: bottomNavBtnIconShadows,
									Icons.delete, size: bottomNavBtnIconsSize
								),
							),
						),

						// Right move action button
						Expanded(
							flex: 1,

							child: IconButton(
								onPressed: _handlePressR,
								highlightColor: scheme.secondaryFixedDim,

								tooltip: "Move Right",
								icon: const Icon(
									shadows: bottomNavBtnIconShadows,
									Icons.turn_right, size: bottomNavBtnIconsSize
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