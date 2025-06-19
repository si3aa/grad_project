import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/constants.dart';
import '../../viewmodels/cubit/event_cubit.dart';
import '../../data/models/event_model.dart';
import '../../data/models/return_event.dart';
import 'dart:io';
import 'package:Herfa/features/add_new_product/views/widgets/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  final Data? eventToEdit; // Optional event for editing

  const AddEventScreen({Key? key, this.eventToEdit}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _image;
  bool _isLoading = false;

  // Helper getter to check if we're in edit mode
  bool get isEditMode => widget.eventToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _initializeFieldsForEdit();
    }
  }

  void _initializeFieldsForEdit() {
    final event = widget.eventToEdit!;

    // Initialize form fields with existing event data
    _titleController.text = event.name ?? '';
    _descriptionController.text = event.description ?? '';
    _priceController.text = event.price?.toString() ?? '';

    // Parse dates
    if (event.startTime != null) {
      try {
        _startDate = DateTime.parse(event.startTime!);
      } catch (e) {
        print('Error parsing start date: $e');
      }
    }

    if (event.endTime != null) {
      try {
        _endDate = DateTime.parse(event.endTime!);
      } catch (e) {
        print('Error parsing end date: $e');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // For new events, image is required. For editing, image is optional
    if (!isEditMode && _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image for the event'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_image != null) {
      print('Image before sending to cubit: $_image'); // Debug print
    }

    setState(() => _isLoading = true);

    try {
      // Validate dates
      if (_startDate!.isAfter(_endDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End date must be after start date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (isEditMode) {
        // Update existing event
        final event = EventModel(
          id: widget.eventToEdit!.id.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          price: double.parse(_priceController.text),
          imageUrl: widget.eventToEdit!.media ??
              '', // Keep existing image if no new image
          organizerId: 'merchant',
        );

        print('Updating event: ${event.title}');

        if (_image != null) {
          // If there's a new image, create a new event (which will replace the old one)
          await context.read<EventCubit>().createEvent(event, _image!);
        } else {
          // Update without changing the image
          await context.read<EventCubit>().updateEvent(event);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event updated successfully! 🎉'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        // Create new event
        final event = EventModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          price: double.parse(_priceController.text),
          imageUrl: '', // Will be set by the repository
          organizerId:
              'merchant', // This will be handled by the backend based on the token
        );

        print('Creating event: ${event.title}');
        await context.read<EventCubit>().createEvent(event, _image!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event created successfully! 🎉'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('Error ${isEditMode ? 'updating' : 'creating'} event: $e');
      if (mounted) {
        String errorMessage =
            isEditMode ? 'Failed to update event' : 'Failed to create event';

        // Provide more user-friendly error messages
        if (e.toString().contains('UnauthorizedException')) {
          errorMessage =
              'Please log in again to ${isEditMode ? 'update' : 'create'} events';
        } else if (e.toString().contains('Access forbidden')) {
          errorMessage =
              'You don\'t have permission to ${isEditMode ? 'update' : 'create'} events';
        } else if (e.toString().contains('File too large')) {
          errorMessage =
              'Image file is too large. Please choose a smaller image';
        } else if (e.toString().contains('Validation error')) {
          errorMessage = 'Please check your input data and try again';
        } else if (e.toString().contains('Network')) {
          errorMessage = 'Network error. Please check your connection';
        } else if (e.toString().contains('Server error')) {
          errorMessage = 'Server error. Please try again later';
        } else {
          // Extract the actual error message if possible
          String fullError = e.toString();
          String searchPattern = isEditMode
              ? 'Failed to update event: '
              : 'Failed to create event: ';
          if (fullError.contains(searchPattern)) {
            errorMessage = fullError.split(searchPattern).last;
          } else {
            errorMessage = 'Something went wrong. Please try again';
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _submitEvent(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Event' : 'Create Event'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  filled: true,
                  fillColor: Colors.white70,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  filled: true,
                  fillColor: Colors.white70,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  filled: true,
                  fillColor: Colors.white70,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Product Images Section (using ImagePickerWidget)
              const Text(
                'Event Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ImagePickerWidget(
                images: _image != null ? [_image!.path] : [],
                onAddImage: (path) {
                  setState(() {
                    _image = File(path);
                    print(
                        'Image selected path: ${_image!.path}'); // Debug print
                  });
                },
                onDeleteImage: (path) {
                  setState(() {
                    _image = null;
                    print('Image cleared: $_image'); // Debug print
                  });
                },
                maxImages: 1,
              ),
              if (_image == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please add at least one event image',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),

              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context, true),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                          _startDate == null
                              ? 'Select Start Date'
                              : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          style: TextStyle(
                              color: _startDate == null
                                  ? Colors.grey[600]
                                  : Colors.black)),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: kPrimaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context, false),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                          _endDate == null
                              ? 'Select End Date'
                              : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                          style: TextStyle(
                              color: _endDate == null
                                  ? Colors.grey[600]
                                  : Colors.black)),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: kPrimaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitEvent,
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        isEditMode ? 'Update Event' : 'Create Event',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
