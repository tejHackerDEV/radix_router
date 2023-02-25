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
          path: '/countries/{country}',
          value: '$httpMethodName dynamic country',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country}/*',
          value: '$httpMethodName dynamic wildcard state',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country:\\d+\$}',
          value: '$httpMethodName dynamic number country',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = radixRouter.lookup(
          method: httpMethod,
          path: '/fruits',
        );
        expect(
          result?.value,
          '$httpMethodName fruits',
        );
        expect(result?.pathParameters, isEmpty);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/india',
        );
        expect(
          result?.value,
          '$httpMethodName india',
        );
        expect(result?.pathParameters, isEmpty);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/pakistan',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic country',
        );
        expect(result?.pathParameters['country'], 'pakistan');
        expect(result?.pathParameters.length, 1);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/2424',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic number country',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters.length, 1);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/bangladesh/random',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic wildcard state',
        );
        expect(result?.pathParameters['country'], 'bangladesh');
        expect(result?.pathParameters['*'], 'random');
        expect(result?.pathParameters.length, 2);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/2424/random',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters['*'], 'random');
        expect(result?.pathParameters.length, 2);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries',
          ),
          isNull,
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear $httpMethodName test', () {
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
