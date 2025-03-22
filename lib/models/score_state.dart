import 'package:flutter/material.dart';
import 'dart:math';


class ScoreState extends ChangeNotifier
{
	// ^ ----------------------------------------------------------------------------------------------------<

	int _score = 0;

	// # ----------------------------------------------------------------------------------------------------<

	int get() => _score;


	void change(int delta)
	{
		final changed = max(0, _score + delta);
		if (changed == _score) return;

		// Updating score value
		_score = changed; notifyListeners();
	}

	// ------------------------------------------------------------------------------------------------------<
}