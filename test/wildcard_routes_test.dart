import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Wildcard Routes test', () {
    final radixRouter = RadixRouter<String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      radixRouter
        ..put(
          method: httpMethod,
          path: '/india/*',
          value: '$httpMethodName wildcard state',
        )
        ..put(
          method: httpMethod,
          path: '/india/andhra-pradesh/*',
          value: '$httpMethodName wildcard city',
        )
        ..put(
          method: httpMethod,
          path: '/india/andhra-pradesh/kadapa/*',
          value: '$httpMethodName wildcard street',
        )
        ..put(
          method: httpMethod,
          path: '/fruits/*',
          value: '$httpMethodName wildcard fruit',
        )
        ..put(
          method: httpMethod,
          path: '/*',
          value: '$httpMethodName wildcard',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = radixRouter.lookup(
          method: httpMethod,
          path: '/india/telangana',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard state',
        );
        expect(result?.pathParameters['*'], 'telangana');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/india/2424',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard state',
        );
        expect(result?.pathParameters['*'], '2424');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/india/andhra-pradesh/cuddapah',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard city',
        );
        expect(result?.pathParameters['*'], 'cuddapah');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard street',
        );
        expect(result?.pathParameters['*'], 'bhagya-nagar-colony');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/india/andhra-pradesh/kadapa/ngo-colony',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard street',
        );
        expect(result?.pathParameters['*'], 'ngo-colony');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/fruits/apple',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard fruit',
        );
        expect(result?.pathParameters['*'], 'apple');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/fruits/apple/1234',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard fruit',
        );
        expect(result?.pathParameters['*'], 'apple/1234');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/random',
        );
        expect(
          result?.value,
          '$httpMethodName wildcard',
        );
        expect(result?.pathParameters['*'], 'random');
        expect(result?.pathParameters.length, 1);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
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
            path: '/india/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
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
            path: '/india/telangana',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/2424',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/cuddapah',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/bhagya-nagar-colony',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa/ngo-colony',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple/1234',
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
            path: '/random',
          ),
          isNull,
        );
      });
    }
  });
}
