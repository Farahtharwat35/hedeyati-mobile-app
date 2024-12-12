import 'package:flutter/material.dart';
import 'text_form_field_decoration.dart';

Widget buildTextField({required TextEditingController controller, required Map<String, dynamic> args,bool emptyValidator=true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      controller: controller,
      autofocus: true,
      keyboardType: args['keyboardType'] ?? TextInputType.text,
      obscureText: args['obscureText'] ?? false,
      maxLength: args['maxLength'] ?? null,
      maxLines: args['maxLines'] ?? 1,
      expands: args['expands'] ?? false,
      readOnly: args['readOnly'] ?? false,
      decoration: textFormFieldDecoration(args),
      validator : emptyValidator == true ? textFormFieldEmptyValidator(args): null,
    ),
  );
}
