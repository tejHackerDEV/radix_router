import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Combined Routes test', () {
    final radixRouter = RadixRouter<String>();

    final httpMethods = HttpMethod.values;

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      radixRouter
        ..put(
          method: httpMethod,
          path: '/*',
          value: '$httpMethodName wildcard',
        )
        ..put(
          method: httpMethod,
          path: '/fruits',
          value: '$httpMethodName fruits',
        )
        ..put(
          method: httpMethod,
          path: '/countries/india',
          value: '$httpMethodName india',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{state}',
          value: '$httpMethodName dynamic state',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{state}/*',
          value: '$httpMethodName dynamic wildcard state',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{state:\\d+\$}',
          value: '$httpMethodName dynamic number state',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries',
          ),
          '$httpMethodName wildcard',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          '$httpMethodName fruits',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          '$httpMethodName india',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          '$httpMethodName dynamic state',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/2424',
          ),
          '$httpMethodName dynamic number state',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/2424/random',
          ),
          '$httpMethodName wildcard',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/bangladesh/random',
          ),
          '$httpMethodName dynamic wildcard state',
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        radixRouter.clear();
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/2424',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/2424/random',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/bangladesh/random',
          ),
          isNull,
        );
      });
    }
  });
}
