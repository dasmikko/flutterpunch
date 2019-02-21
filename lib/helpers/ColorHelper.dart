import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

Color categoryHeaderItemBackground(BuildContext context) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (brightness == Brightness.light) {
    return  Colors.blueGrey[50];
  }

  if (brightness == Brightness.dark) {
    return  Colors.red.withOpacity(0.5);
  }
}

Color categoryHeaderItemBorder(BuildContext context) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (brightness == Brightness.light) {
    return  Colors.blueGrey[100];
  }

  if (brightness == Brightness.dark) {
    return  Colors.red.withOpacity(0.1);
  }
}

Color threadListItemBackground(bool isSticky, BuildContext context) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (isSticky && brightness == Brightness.light) {
    return  Colors.green[100];
  }

  if (isSticky && brightness == Brightness.dark) {
    return  Colors.green[500];
  }
}

Color threadListItemTitle(bool isSticky, BuildContext context) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (isSticky && brightness == Brightness.light) {
    return  Colors.green[500];
  }

  if (isSticky && brightness == Brightness.dark) {
    return  Colors.green[100];
  }

  if (!isSticky && brightness == Brightness.light) {
    return  Colors.blue[400];
  }

  if (!isSticky && brightness == Brightness.dark) {
    return  Colors.blue[400];
  }
}


Color postHeaderNoBackground(BuildContext context) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (brightness == Brightness.light) {
    return Colors.blueGrey[50];
  }

  if (brightness == Brightness.dark) {
    return Colors.grey;
  }
}


Color postHeaderBackground(BuildContext context) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (brightness == Brightness.light) {
    return Colors.white.withOpacity(0.8);
  }

  if (brightness == Brightness.dark) {
    return Colors.black.withOpacity(0.6);
  }
}


Color alertListItemBackground(BuildContext context, bool seen) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (seen && brightness == Brightness.light) {
    return Colors.grey.withOpacity(0.3);
  }

  if (seen && brightness == Brightness.dark) {
    return Colors.grey[800];
  }

  if (!seen && brightness == Brightness.light) {
    return Colors.white;
  }

  if (!seen && brightness == Brightness.dark) {
    return Colors.grey[700];
  }
}

Color alertListItemText(BuildContext context, bool seen) {
  Brightness brightness = DynamicTheme.of(context).data.brightness;

  if (seen && brightness == Brightness.light) {
    return Colors.grey[600];
  }

  if (seen && brightness == Brightness.dark) {
    return Colors.grey;
  }

  if (!seen && brightness == Brightness.light) {
    return Colors.black;
  }

  if (!seen && brightness == Brightness.dark) {
    return Colors.grey[200];
  }
}