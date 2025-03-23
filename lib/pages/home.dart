import 'package:material_tap/widgets/resource_dock_frame.dart';
import 'package:material_tap/enums/resource_path_side.dart';
import 'package:material_tap/widgets/resource_spawner.dart';
import 'package:material_tap/widgets/resource_sender.dart';
import 'package:material_tap/widgets/resource_dock.dart';
import 'package:material_tap/widgets/resource_slot.dart';
import 'package:material_tap/widgets/score_display.dart';
import 'package:material_tap/models/score_state.dart';
import 'package:material_tap/types.dart';
import 'package:material_tap/const.dart';
import 'package:provider/provider.dart';

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


class HomePageState extends State<HomePage>
	with WidgetsBindingObserver
{
	static const int initialResourcesCount = 6;
	static const int tapTimeout = 200;

	static const int scoreErrorMultiplier = 2;
	static const int scoreChangeValue = 10;

	// Constants for bottom nav bar components
	static const double bottomNavBtnIconsSize = 48.0;
	static const double bottomNavBarHeight = 64.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	late final Map<ResourcePathSide, GlobalKey<ResourceSenderState>> _resourceSendMap;
	late final Map<ResourcePathSide, GlobalKey<ResourceDockState>> _resourceDockMap;

	late final List<ResourceData> initialResources;

	final _resourceCentralSlot = GlobalKey<ResourceSlotState>();
	final _resourceSpawner = GlobalKey<ResourceSpawnerState>();

	final _random = Random();
	final scoreState = ScoreState();

	late bool _canInteract = true;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Initializing maps
		_resourceSendMap = {
			ResourcePathSide.left  : GlobalKey<ResourceSenderState>(),
			ResourcePathSide.up    : GlobalKey<ResourceSenderState>(),
			ResourcePathSide.right : GlobalKey<ResourceSenderState>(),
		};

		_resourceDockMap = {
			ResourcePathSide.left  : GlobalKey<ResourceDockState>(),
			ResourcePathSide.up    : GlobalKey<ResourceDockState>(),
			ResourcePathSide.right : GlobalKey<ResourceDockState>(),
		};

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

	void _handleInput(ResourcePathSide side)
	{
		if ( !_canInteract ) return;
		_timeoutInteraction();

		// Getting resource sender state
		var senderGlobalKey = _resourceSendMap[side]!;
		var senderState = senderGlobalKey.currentState;

		if ( senderState != null && !senderState.hasSended )
		{
			final resource = _rotateSpawner();
			senderState.send(resource);
		}
	}


	void _handleResourceReceive(ResourcePathSide side, ResourceData data)
	{
		var dockGlobalKey = _resourceDockMap[side]!;
		var dockState = dockGlobalKey.currentState;

		if ( dockState == null ) return;
		final bool isValid = dockState.put(data);

		// Manage points
		if ( isValid ) {
			scoreState.change(scoreChangeValue);
		} else {
			scoreState.change(scoreChangeValue * -scoreErrorMultiplier);
		}

		// Distribute resources between docks
		_distributeDockResources();
	}

	// ------------------------------------------------------------------------------------------------------<

	ResourceData _rotateSpawner()
	{
		final spawnerState = _resourceSpawner.currentState;
		final slotState = _resourceCentralSlot.currentState;

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
		final index = _random.nextInt(length);

		return resourceDataSet[index];
	}


	void _distributeDockResources()
	{
		final spawnerState = _resourceSpawner.currentState;
		if ( spawnerState == null ) return;

		// Get sides where senders are available to use
		final sendSides = ResourcePathSide.values.where((side)
		{
			final state = _resourceSendMap[side]!.currentState;
			return state != null && !state.hasSended;
		});

		if ( sendSides.isEmpty ) return;

		// Select random dock and replace resource
		final sidesList = sendSides.toList();

		final sideIndex = _random.nextInt(sidesList.length);
		final side = sidesList[sideIndex];

		_resourceDockMap[side]!.currentState?.set(spawnerState.pending);
	}

	// ------------------------------------------------------------------------------------------------------<

	void _timeoutInteraction()
	{
		_canInteract = false;

		Timer(
			const Duration(milliseconds: tapTimeout),
			() { _canInteract = true; }
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildBodyVerticalComponents()
	{
		// Building tree of widgets
		return Column(
			children: <Expanded>
			[
				Expanded(
					child: _buildResourceSender(ResourcePathSide.up)
				),

				Expanded(
					child: ResourceSpawner(
						key: _resourceSpawner,
						initialData: initialResources,
					),
				),
			],
		);
	}


	Widget _buildBodyHorizotalComponents()
	{
		// Building tree of widgets
		return Row(
			children: <Expanded>
			[
				Expanded(
					child: _buildResourceSender(ResourcePathSide.left),
				),

				Expanded(
					child: _buildResourceSender(ResourcePathSide.right),
				)
			],
		);
	}


	Widget _buildBodyVerticalResourceDocks()
	{
		// Building tree of widgets
		return Column(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			crossAxisAlignment: CrossAxisAlignment.center,

			children: <Widget>
			[
				// Upper resource dock
				_buildResourceDock(ResourcePathSide.up),

				// Spawner resource dock
				ResourceDockFrame(
					direction: AxisDirection.down,

					child: const Icon(Icons.eject,
						size: ResourceDockFrame.defaultBodySize,

						shadows: <BoxShadow>
						[
							BoxShadow(
								color: Color.fromARGB(124, 0, 0, 0),
								blurRadius: 4, offset: Offset(0, 2)
							)
						],
					),
				),
			],
		);
	}


	Widget _buildBodyHorizontalResourceDocks()
	{
		// Building tree of widgets
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			crossAxisAlignment: CrossAxisAlignment.center,

			children: <ResourceDock>
			[
				_buildResourceDock(ResourcePathSide.left),
				_buildResourceDock(ResourcePathSide.right),
			],
		);
	}


	Widget _buildBodyCentralResourceDisplay(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Center(
			child: DecoratedBox(
				decoration: BoxDecoration(
					color: scheme.secondaryFixed,
					borderRadius: BorderRadius.circular(32.0),

					boxShadow: const <BoxShadow>
					[
						BoxShadow(
							color: Color.fromARGB(124, 0, 0, 0),
							blurRadius: 3, spreadRadius: 2,
						)
					],
				),

				child: SizedBox.square(
					dimension: 100,

					child: ResourceSlot(
						key: _resourceCentralSlot,
						data: initialResources.first,
					),
				)
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	Widget _buildBottomNavBarActionButton(
		BuildContext context, ResourcePathSide side, IconData icon)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Expanded(
			child: IconButton(
				highlightColor: scheme.secondaryFixedDim,
				onPressed: () => _handleInput(side),

				icon: Icon(icon,
					size: bottomNavBtnIconsSize,
					shadows: const <BoxShadow>
					[
						BoxShadow(
							color: Color.fromARGB(124, 0, 0, 0),
							blurRadius: 4, offset: Offset(0, 2)
						)
					]
				),
			),
		);
	}


	ResourceSender _buildResourceSender(ResourcePathSide side)
	{
		// Building tree of widgets
		return ResourceSender(
			key: _resourceSendMap[side],
			side: side,

			onResource: (data) {
				_handleResourceReceive(side, data);
			},
		);
	}


	ResourceDock _buildResourceDock(ResourcePathSide side)
	{
		late final ResourceData data;

		if ( side == ResourcePathSide.up ) {
			data = initialResources.first;
		} else {
			final index = _random.nextInt(initialResources.length);
			data = initialResources[index];
		}

		// Building tree of widgets
		return ResourceDock(
			key: _resourceDockMap[side],
			data: data, side: side,
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
				backgroundColor: scheme.secondaryFixed,

				flexibleSpace: ChangeNotifierProvider.value(
					value: scoreState, child: const ScoreDisplay(),
				),
			),

			body: Stack(
				alignment: Alignment.center,
				fit: StackFit.expand,

				children: <Widget>
				[
					// Build resource spawner and resource senders
					_buildBodyVerticalComponents(),
					_buildBodyHorizotalComponents(),

					// Build resource docks and corresponding receivers
					_buildBodyVerticalResourceDocks(),
					_buildBodyHorizontalResourceDocks(),

					// Central slot to display current resource
					_buildBodyCentralResourceDisplay(context),

					// Gesture detector for controlls by swipe
					GestureDetector(
						onVerticalDragEnd: (details)
						{
							if ( details.primaryVelocity! < 0 )
							{
								_handleInput(ResourcePathSide.up);
							}
						},

						onHorizontalDragEnd: (details)
						{
							if ( details.primaryVelocity! > 0 ) {
								_handleInput(ResourcePathSide.right);
							} else
							if ( details.primaryVelocity! < 0 ) {
								_handleInput(ResourcePathSide.left);
							}
						},
					)
				],
			),

			bottomNavigationBar: Container(
				height: bottomNavBarHeight,

				decoration: BoxDecoration(
					color: scheme.secondaryFixed,

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
						_buildBottomNavBarActionButton(
							context, ResourcePathSide.left, Icons.turn_left
						),

						// Middle move action button
						_buildBottomNavBarActionButton(
							context, ResourcePathSide.up, Icons.delete
						),

						// Right move action button
						_buildBottomNavBarActionButton(
							context, ResourcePathSide.right, Icons.turn_right
						),
					],
				),
			),

			extendBody: false,
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}