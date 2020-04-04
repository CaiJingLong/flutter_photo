import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:ui';

class AssetEntityFileImage extends ImageProvider<AssetEntityFileImage> {
  final AssetEntity entity;
  final double scale;

  const AssetEntityFileImage(
    this.entity, {
    this.scale = 1.0,
  });

  @override
  ImageStreamCompleter load(AssetEntityFileImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<Codec> _loadAsync(
      AssetEntityFileImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = (await entity.file).readAsBytesSync();
    return decode(bytes);
  }

  @override
  Future<AssetEntityFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetEntityFileImage>(this);
  }
}

class AssetEntityThumbImage extends ImageProvider<AssetEntityThumbImage> {
  final AssetEntity entity;
  final int width;
  final int height;
  final double scale;

  AssetEntityThumbImage({
    @required this.entity,
    int width,
    int height,
    this.scale = 1.0,
  })  : width = width ?? entity.width,
        height = height ?? entity.height;

  @override
  ImageStreamCompleter load(AssetEntityThumbImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<Codec> _loadAsync(
      AssetEntityThumbImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = await entity.thumbDataWithSize(width, height);
    return decode(bytes);
  }

  @override
  Future<AssetEntityThumbImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetEntityThumbImage>(this);
  }
}
