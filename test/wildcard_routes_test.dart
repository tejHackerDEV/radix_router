import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Wildcard Routes test', () {
    final radixRouter = RadixRouter<String>();

    radixRouter
      ..put(
        method: HttpMethod.get,
        path: '/fruits/*',
        value: 'get wildcard fruits',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/apple/*',
        value: 'get wildcard apple',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/pineapple/*',
        value: 'get wildcard pineapple',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/banana/*',
        value: 'get wildcard banana',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/*',
        value: 'post wildcard fruits',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/apple/*',
        value: 'post wildcard apple',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/pineapple/*',
        value: 'post wildcard pineapple',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/banana/*',
        value: 'post wildcard banana',
      );

    test('Valid Get test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/random'),
        'get wildcard fruits',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/random/xyz'),
        'get wildcard fruits',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple'),
        'get wildcard fruits',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/apple/random'),
        'get wildcard apple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/pineapple'),
        'get wildcard fruits',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/pineapple/random'),
        'get wildcard pineapple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/banana'),
        'get wildcard fruits',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/banana/random'),
        'get wildcard banana',
      );
    });

    test('Valid Post test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/random'),
        'post wildcard fruits',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/random/xyz'),
        'post wildcard fruits',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple'),
        'post wildcard fruits',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/apple/random'),
        'post wildcard apple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/pineapple'),
        'post wildcard fruits',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/pineapple/random'),
        'post wildcard pineapple',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/banana'),
        'post wildcard fruits',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/banana/random'),
        'post wildcard banana',
      );
    });

    test('Invalid Get test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru/random/xyz'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/its/apple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/its'),
        isNull,
      );
    });

    test('Invalid Post test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru/random/xyz'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/its/apple'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/its'),
        isNull,
      );
    });

    test('Clear Get test', () {
      radixRouter.clear();
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/random/xyz'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/apple/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/pineapple'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/pineapple/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/banana'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/banana/random'),
        isNull,
      );
    });

    test('Clear Post test', () {
      radixRouter.clear();
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/random/xyz'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/apple/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/pineapple'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/pineapple/random'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/banana'),
        isNull,
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/banana/random'),
        isNull,
      );
    });
  });
}
