## 0.4.1

* Make sure it's using Shrine 2.x, as this does not work with 3.0 (yet)

## 0.4.0

* Added support for Shrine versions 2.7.0 and up, while dropping support for lower versions (@famano, see #6)

## 0.3.0

* Fixed incompatibility with Hanami 1.0.1+ leading to `RuntimeError: can't modify frozen Hash` error upon deletion
* Drop support for Hanami versions less than 1.0
