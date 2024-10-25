import 'package:flutter/material.dart';
import 'package:demo_s_application1/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Headline text style
  static get headlineLargeJockeyOne =>
      theme.textTheme.headlineLarge!.jockeyOne.copyWith(
        fontWeight: FontWeight.w400,
      );
  static get headlineSmallJsMathcmbx10 =>
      theme.textTheme.headlineSmall!.jsMathcmbx10;
  static get headlineSmallRegular => theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w400,
      );
  // Title style
  static get titleLargeInter => theme.textTheme.titleLarge!.inter;
  static get titleLargeJosefinSans =>
      theme.textTheme.titleLarge!.josefinSans.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleLargeWhiteA700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.whiteA700,
      );
}

extension on TextStyle {
  TextStyle get inika {
    return copyWith(
      fontFamily: 'Inika',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get jsMathcmbx10 {
    return copyWith(
      fontFamily: 'jsMath-cmbx10',
    );
  }

  TextStyle get jockeyOne {
    return copyWith(
      fontFamily: 'Jockey One',
    );
  }

  TextStyle get josefinSans {
    return copyWith(
      fontFamily: 'Josefin Sans',
    );
  }

  TextStyle get playwrite {
    return copyWith(
      fontFamily: 'Play',
    );
  }
}
