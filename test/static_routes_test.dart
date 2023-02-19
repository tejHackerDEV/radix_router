import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Static Routes test', () {
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
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/app/le'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru/its/pineapple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru/its/ban/ana'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/straw-berry'),
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
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/app/le'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru/its/pineapple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru/its/ban/ana'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/straw-berry'),
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
    });
  });
}
