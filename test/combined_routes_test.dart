import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Combined Routes test', () {
    final radixRouter = RadixRouter<String>();

    radixRouter
      ..put(method: HttpMethod.get, path: '/fruit', value: 'get fruit')
      ..put(method: HttpMethod.get, path: '/fruits', value: 'get fruits')
      ..put(method: HttpMethod.get, path: '/fruits/apple', value: 'get apple')
      ..put(
        method: HttpMethod.get,
        path: '/fruits/pineapple',
        value: 'get pineapple',
      )
      ..put(method: HttpMethod.get, path: '/fruits/banana', value: 'get banana')
      ..put(
        method: HttpMethod.get,
        path: '/fruits/{name}',
        value: 'get dynamic fruit name',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/{name}/{quantity}',
        value: 'get dynamic fruit name & quantity',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/apple/1234',
        value: 'get apple with 1234 quantity',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/apple/*',
        value: 'get wildcard apple',
      )
      ..put(method: HttpMethod.post, path: '/fruit', value: 'post fruit')
      ..put(method: HttpMethod.post, path: '/fruits', value: 'post fruits')
      ..put(method: HttpMethod.post, path: '/fruits/apple', value: 'post apple')
      ..put(
        method: HttpMethod.post,
        path: '/fruits/pineapple',
        value: 'post pineapple',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/banana',
        value: 'post banana',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/{name}',
        value: 'post dynamic fruit name',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/{name}/{quantity}',
        value: 'post dynamic fruit name & quantity',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/apple/1234',
        value: 'post apple with 1234 quantity',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/apple/*',
        value: 'post wildcard apple',
      );

    test('Valid Get test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruit'),
        'get fruit',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits'),
        'get fruits',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple'),
        'get apple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/pineapple'),
        'get pineapple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/banana'),
        'get banana',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/strawberry'),
        'get dynamic fruit name',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/random'),
        'get dynamic fruit name',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/random/random'),
        'get dynamic fruit name & quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple/1234'),
        'get apple with 1234 quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/strawberry/1234'),
        'get dynamic fruit name & quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/apple/random'),
        'get wildcard apple',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/apple/1234/1234'),
        'get wildcard apple',
      );
    });

    test('Valid Post test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruit'),
        'post fruit',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits'),
        'post fruits',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple'),
        'post apple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/pineapple'),
        'post pineapple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/banana'),
        'post banana',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/strawberry'),
        'post dynamic fruit name',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/random'),
        'post dynamic fruit name',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/random/random'),
        'post dynamic fruit name & quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple/1234'),
        'post apple with 1234 quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/strawberry/1234'),
        'post dynamic fruit name & quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/apple/random'),
        'post wildcard apple',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/apple/1234/1234'),
        'post wildcard apple',
      );
    });

    test('Invalid Get test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru-it'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru-its'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru/its/ban/ana'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/pineapple/1234'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/pineapple/1234/1234'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/banana/1234'),
        isNull,
      );
    });

    test('Invalid Post test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru-it'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru-its'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru/its/ban/ana'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/pineapple/1234'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/banana/1234'),
        isNull,
      );
    });

    test('Clear Get test', () {
      radixRouter.clear();
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruit'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/pineapple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/banana'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/strawberry'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/random/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple/1234'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/apple/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/apple/1234/1234'),
        isNull,
      );
    });

    test('Clear Post test', () {
      radixRouter.clear();
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruit'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/pineapple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/banana'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/strawberry'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/random/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple/1234'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/apple/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/apple/1234/1234'),
        isNull,
      );
    });
  });
}
