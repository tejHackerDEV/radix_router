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
          middlewares: [
            '$httpMethodName wildcard middleware1',
            '$httpMethodName wildcard middleware2',
            '$httpMethodName wildcard middleware3',
          ],
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
          middlewares: [
            '$httpMethodName dynamic number country middleware1',
            '$httpMethodName dynamic number country middleware2'
          ],
        )
        ..put(
          method: httpMethod,
          path: '/countries/{country:\\d+\$}/states',
          value: '$httpMethodName dynamic number country & state',
          middlewares: [
            '$httpMethodName dynamic number country & state middleware1',
            '$httpMethodName dynamic number country & state middleware2'
          ],
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
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/india',
        );
        expect(
          result?.value,
          '$httpMethodName india',
        );
        expect(result?.pathParameters, isEmpty);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

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
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

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
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, [
          '$httpMethodName dynamic number country middleware1',
          '$httpMethodName dynamic number country middleware2'
        ]);
        expect(result?.middlewares?.length, 2);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/2424',
          shouldReturnParentMiddlewares: true,
        );
        expect(
          result?.value,
          '$httpMethodName dynamic number country',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName dynamic number country middleware1',
            '$httpMethodName dynamic number country middleware2',
          ],
        );

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/2424/states',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic number country & state',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName dynamic number country & state middleware1',
            '$httpMethodName dynamic number country & state middleware2'
          ],
        );

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/2424/states',
        );
        expect(
          result?.value,
          '$httpMethodName dynamic number country & state',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName dynamic number country & state middleware1',
            '$httpMethodName dynamic number country & state middleware2',
          ],
        );

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/2424/states',
          shouldReturnParentMiddlewares: true,
        );
        expect(
          result?.value,
          '$httpMethodName dynamic number country & state',
        );
        expect(result?.pathParameters['country'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName dynamic number country middleware1',
            '$httpMethodName dynamic number country middleware2',
            '$httpMethodName dynamic number country & state middleware1',
            '$httpMethodName dynamic number country & state middleware2',
          ],
        );

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
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/random/2424/random',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard',
        );
        expect(result?.pathParameters['*'], 'random/2424/random');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName wildcard middleware1',
            '$httpMethodName wildcard middleware2',
            '$httpMethodName wildcard middleware3',
          ],
        );

        result = radixRouter.lookup(
          method: httpMethod,
          path:
              '/random/2424/random?language=telugu&religion=hindu&religion=muslim',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard',
        );
        expect(result?.pathParameters['*'], 'random/2424/random');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters['language'], 'telugu');
        expect(result?.queryParameters['religion'], ['hindu', 'muslim']);
        expect(result?.queryParameters.length, 2);
        expect(
          result?.middlewares,
          [
            '$httpMethodName wildcard middleware1',
            '$httpMethodName wildcard middleware2',
            '$httpMethodName wildcard middleware3',
          ],
        );
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
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
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
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path:
                '/countries/2424/random?language=telugu&religion=hindu&religion=muslim',
          ),
          isNull,
        );
      });
    }
  });
}
