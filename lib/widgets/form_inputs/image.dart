import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;

  ImageInput(this.setImage, this.product);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).accentColor;
    return Column(
      children: <Widget>[
        OutlineButton(
          onPressed: _showImagePicker,
          borderSide: BorderSide(color: buttonColor, width: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: buttonColor),
              SizedBox(width: 5.0),
              Text("Add Image", style: TextStyle(color: buttonColor))
            ],
          ),
        ),
        SizedBox(height: 10.0),
        _getImagePreview()
      ],
    );
  }

  Widget _getImagePreview() {
    Widget previewImage = Text("Please pick an image");
    if (_imageFile != null) {
      previewImage = Image.file(
        _imageFile,
        alignment: Alignment.center,
        height: 300.00,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      );
    } else if (widget.product != null) {
      previewImage = Image.network(
        widget.product.image,
        alignment: Alignment.center,
        height: 300.00,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      );
    }
    return previewImage;
  }

  void _showImagePicker() {
    final buttonColor = Theme.of(context).accentColor;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text("Pick an image", style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 10.0),
                FlatButton(
                  onPressed: () {
                    _getImage(ImageSource.camera);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        color: buttonColor,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("From camera", style: TextStyle(color: buttonColor))
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.storage,
                        color: buttonColor,
                      ),
                      SizedBox(width: 5.0),
                      Text("From gallery", style: TextStyle(color: buttonColor))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void _getImage(ImageSource source) async {
    final File imageFile =
        await ImagePicker.pickImage(source: source, maxWidth: 400.0);
    setState(() {
      _imageFile = imageFile;
    });
    widget.setImage(imageFile);
    Navigator.pop(context);
  }
}
