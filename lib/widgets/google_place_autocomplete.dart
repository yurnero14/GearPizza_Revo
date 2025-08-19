import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../constants/api_constants.dart';

class GooglePlacesAutoComplete extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onPlaceSelected;

  const GooglePlacesAutoComplete({
    super.key,
    required this.controller,
    this.validator,
    this.onPlaceSelected,
  });

  @override
  State<GooglePlacesAutoComplete> createState() =>
      _GooglePlacesAutoCompleteState();
}

class _GooglePlacesAutoCompleteState extends State<GooglePlacesAutoComplete> {
  bool _useGooglePlaces = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_useGooglePlaces)
          _buildGooglePlacesField()
        else
          _buildFallbackField(),

        // Custom validation display
        if (widget.validator != null)
          _CustomValidationDisplay(
            controller: widget.controller,
            validator: widget.validator!,
          ),
      ],
    );
  }

  Widget _buildGooglePlacesField() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: widget.controller,
      googleAPIKey: ApiConstants.googlePlacesApiKey,
      inputDecoration: const InputDecoration(
        labelText: 'Address *',
        prefixIcon: Icon(Icons.location_on),
        border: OutlineInputBorder(),
        hintText: 'Start typing your address...',
      ),
      debounceTime: 800,
      countries: const ["it"],
      isLatLngRequired: false,

      // SUCCESS callback
      getPlaceDetailWithLatLng: (Prediction prediction) {
        if (widget.onPlaceSelected != null) {
          widget.onPlaceSelected!(prediction.description ?? '');
        }
        widget.controller.text = prediction.description ?? '';
        FocusScope.of(context).unfocus();
      },

      // CLICK callback
      itemClick: (Prediction prediction) {
        widget.controller.text = prediction.description ?? '';
        if (widget.onPlaceSelected != null) {
          widget.onPlaceSelected!(prediction.description ?? '');
        }
        FocusScope.of(context).unfocus();
      },

      // Remove onError - not supported by this package

      seperatedBuilder: const Divider(height: 1),
      containerHorizontalPadding: 16,

      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  prediction.description ?? '',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },

      isCrossBtnShown: false,
      boxDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackField() {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'Address *',
            prefixIcon: const Icon(Icons.location_on),
            border: const OutlineInputBorder(),
            hintText: 'Enter your delivery address...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _useGooglePlaces = true;
                });
              },
              tooltip: 'Try Google Places again',
            ),
          ),
          maxLines: 2,
          onChanged: (value) {
            if (widget.onPlaceSelected != null && value.isNotEmpty) {
              widget.onPlaceSelected!(value);
            }
          },
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Google Places autocomplete temporarily unavailable. Please enter address manually.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange[700],
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Keep your existing _CustomValidationDisplay class as is
class _CustomValidationDisplay extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const _CustomValidationDisplay({
    required this.controller,
    required this.validator,
  });

  @override
  State<_CustomValidationDisplay> createState() =>
      _CustomValidationDisplayState();
}

class _CustomValidationDisplayState extends State<_CustomValidationDisplay> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateText);
    super.dispose();
  }

  void _validateText() {
    final error = widget.validator(widget.controller.text);
    if (error != errorText) {
      setState(() {
        errorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorText == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, top: 8),
      child: Text(
        errorText!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
