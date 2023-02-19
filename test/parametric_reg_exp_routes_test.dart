import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Parametric RegExp Routes test', () {
    final radixRouter = RadixRouter<String>();

    radixRouter
      ..put(
        method: HttpMethod.get,
        path: '/fruits/{name}',
        value: 'get fruit name',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/{quantity:^\\d+\$}',
        value: 'get quantity',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/{name:^[a-z]+\$}/{quantity}',
        value: 'get fruit small name & quantity',
      )
      ..put(
        method: HttpMethod.get,
        path: '/fruits/{name:^[A-Z]+\$}/{quantity}',
        value: 'get fruit capital name & quantity',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/{name}',
        value: 'post fruit name',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/{quantity:^\\d+\$}',
        value: 'post quantity',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/{name:^[a-z]+\$}/{quantity}',
        value: 'post fruit small name & quantity',
      )
      ..put(
        method: HttpMethod.post,
        path: '/fruits/{name:^[A-Z]+\$}/{quantity}',
        value: 'post fruit capital name & quantity',
      );

    test('Valid Get test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/1234'),
        'get quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple'),
        'get fruit name',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/banana'),
        'get fruit name',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple/1234'),
        'get fruit small name & quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/APPLE/1234'),
        'get fruit capital name & quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/pineapple/6789'),
        'get fruit small name & quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.get, path: '/fruits/PINEAPPLE/6789'),
        'get fruit capital name & quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/random'),
        'get fruit name',
      );
    });

    test('Valid Post test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/1234'),
        'post quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple'),
        'post fruit name',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/banana'),
        'post fruit name',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple/1234'),
        'post fruit small name & quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/APPLE/1234'),
        'post fruit capital name & quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/pineapple/6789'),
        'post fruit small name & quantity',
      );
      expect(
        radixRouter.lookup(
            method: HttpMethod.post, path: '/fruits/PINEAPPLE/6789'),
        'post fruit capital name & quantity',
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/random'),
        'post fruit name',
      );
    });

    test('Invalid Get test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru-its'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fru/its/ban/ana'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apPle/1234'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/APPLe/1234'),
        isNull,
      );
    });

    test('Invalid Post test', () {
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru-its'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fru/its/ban/ana'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apPle/1234'),
        isNull,
      );
      expect(
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/APPLe/1234'),
        isNull,
      );
    });

    test('Clear Get test', () {
      radixRouter.clear();
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
        radixRouter.lookup(method: HttpMethod.get, path: '/fruits/apple/1234'),
        isNull,
      );
    });

    test('Clear Post test', () {
      radixRouter.clear();
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
        radixRouter.lookup(method: HttpMethod.post, path: '/fruits/apple/1234'),
        isNull,
      );
    });
  });
}
