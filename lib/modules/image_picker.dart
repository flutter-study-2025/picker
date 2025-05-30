import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'picker_theme.dart';
import 'picker_wrapper.dart';

// 이미지 선택 소스 정의
enum ImageSource {
  camera,
  gallery,
}

class ImagePickerOption {
  final String title;
  final IconData icon;
  final ImageSource source;

  ImagePickerOption({
    required this.title,
    required this.icon,
    required this.source,
  });
}

class ImagePicker extends StatelessWidget {
  final ValueChanged<ImageSource>? onSourceSelected;
  final PickerTheme theme;
  final bool enableCamera;
  final bool enableGallery;

  const ImagePicker({
    Key? key,
    this.onSourceSelected,
    this.theme = const PickerTheme(),
    this.enableCamera = true,
    this.enableGallery = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = <ImagePickerOption>[];
    
    if (enableCamera) {
      options.add(
        ImagePickerOption(
          title: '카메라',
          icon: Icons.camera_alt,
          source: ImageSource.camera,
        ),
      );
    }
    
    if (enableGallery) {
      options.add(
        ImagePickerOption(
          title: '갤러리',
          icon: Icons.photo_library,
          source: ImageSource.gallery,
        ),
      );
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options.map((option) => _buildOption(context, option)).toList(),
    );
  }

  Widget _buildOption(BuildContext context, ImagePickerOption option) {
    return ListTile(
      leading: Icon(
        option.icon,
        color: theme.primaryColor,
      ),
      title: Text(
        option.title,
        style: theme.itemStyle,
      ),
      onTap: () {
        Navigator.pop(context);
        onSourceSelected?.call(option.source);
      },
    );
  }
}

Future<ImageSource?> showCustomImagePicker({
  required BuildContext context,
  bool enableCamera = true,
  bool enableGallery = true,
  String title = '이미지 선택',
  PickerTheme? theme,
}) {
  final completer = Completer<ImageSource?>();
  
  showPickerModal(
    context: context,
    title: title,
    theme: theme,
    showConfirmButton: false,
    child: ImagePicker(
      enableCamera: enableCamera,
      enableGallery: enableGallery,
      theme: theme ?? const PickerTheme(),
      onSourceSelected: (source) {
        completer.complete(source);
      },
    ),
    onCancel: () {
      Navigator.pop(context);
      completer.complete(null);
    },
  );
  
  return completer.future;
}

// 이미지 크롭 옵션
class ImageCropOption {
  final double aspectRatio;
  final String label;

  ImageCropOption({
    required this.aspectRatio,
    required this.label,
  });
}

class ImageCropper extends StatefulWidget {
  final File image;
  final List<ImageCropOption>? cropOptions;
  final ValueChanged<File>? onImageCropped;
  final PickerTheme theme;

  const ImageCropper({
    Key? key,
    required this.image,
    this.cropOptions,
    this.onImageCropped,
    this.theme = const PickerTheme(),
  }) : super(key: key);

  @override
  State<ImageCropper> createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  late ImageCropOption _selectedOption;
  late List<ImageCropOption> _cropOptions;

  @override
  void initState() {
    super.initState();
    _cropOptions = widget.cropOptions ?? _defaultCropOptions;
    _selectedOption = _cropOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 여기에 실제 이미지 크롭 구현이 필요합니다.
        // Flutter에서는 실제 이미지 크롭을 위해 image_cropper 등의 패키지를 사용해야 합니다.
        // 이 예제에서는 UI 구성만 보여줍니다.
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: _selectedOption.aspectRatio,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: widget.theme.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(widget.theme.borderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.theme.borderRadius - 2),
                child: Image.file(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 크롭 옵션 선택
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _cropOptions.map((option) => _buildCropOption(option)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCropOption(ImageCropOption option) {
    final isSelected = _selectedOption.aspectRatio == option.aspectRatio;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text(option.label),
        selected: isSelected,
        selectedColor: widget.theme.primaryColor,
        backgroundColor: widget.theme.backgroundColor,
        labelStyle: TextStyle(
          color: isSelected ? widget.theme.selectedTextColor : widget.theme.textColor,
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedOption = option;
            });
          }
        },
      ),
    );
  }

  static final List<ImageCropOption> _defaultCropOptions = [
    ImageCropOption(aspectRatio: 1.0, label: '1:1'),
    ImageCropOption(aspectRatio: 4/3, label: '4:3'),
    ImageCropOption(aspectRatio: 16/9, label: '16:9'),
    ImageCropOption(aspectRatio: 3/4, label: '3:4'),
    ImageCropOption(aspectRatio: 9/16, label: '9:16'),
  ];
}

Future<File?> showCustomImageCropper({
  required BuildContext context,
  required File image,
  List<ImageCropOption>? cropOptions,
  String title = '이미지 자르기',
  PickerTheme? theme,
}) {
  final completer = Completer<File?>();
  
  showPickerModal(
    context: context,
    title: title,
    theme: theme,
    child: ImageCropper(
      image: image,
      cropOptions: cropOptions,
      theme: theme ?? const PickerTheme(),
      onImageCropped: (croppedImage) {
        completer.complete(croppedImage);
      },
    ),
    onConfirm: () {
      // 실제 구현에서는 여기서 이미지 크롭 작업을 수행하고 결과를 반환해야 합니다.
      Navigator.pop(context);
      completer.complete(image); // 예제에서는 원본 이미지를 반환합니다.
    },
    onCancel: () {
      Navigator.pop(context);
      completer.complete(null);
    },
  );
  
  return completer.future;
}
