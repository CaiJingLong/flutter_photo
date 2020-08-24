import 'dart:collection';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class ImageLruCache {
  static LRUMap<_ImageCacheEntity, Uint8List> _map = LRUMap(500);

  static Uint8List getData(AssetEntity entity, [int size = 64]) {
    return _map.get(_ImageCacheEntity(entity, size));
  }

  static void setData(AssetEntity entity, int size, Uint8List list) {
    _map.put(_ImageCacheEntity(entity, size), list);
  }

  static void clearCache() {
    _map.clear();
  }
}

class _ImageCacheEntity {
  AssetEntity entity;
  int size;

  _ImageCacheEntity(this.entity, this.size);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ImageCacheEntity &&
          runtimeType == other.runtimeType &&
          entity == other.entity &&
          size == other.size;

  @override
  int get hashCode => entity.hashCode ^ size.hashCode;
}

// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

typedef EvictionHandler<K, V>(K key, V value);

class LRUMap<K, V> {
  final LinkedHashMap<K, V> _map = LinkedHashMap<K, V>();
  final int _maxSize;
  final EvictionHandler<K, V> _handler;

  LRUMap(this._maxSize, [this._handler]);

  V get(K key) {
    V value = _map.remove(key);
    if (value != null) {
      _map[key] = value;
    }
    return value;
  }

  void put(K key, V value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > _maxSize) {
      K evictedKey = _map.keys.first;
      V evictedValue = _map.remove(evictedKey);
      if (_handler != null) {
        _handler(evictedKey, evictedValue);
      }
    }
  }

  void remove(K key) {
    _map.remove(key);
  }

  void clear() {
    _map.clear();
  }
}
