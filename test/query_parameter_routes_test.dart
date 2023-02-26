import 'package:radix_router/radix_router.dart';
import 'package:samba_helpers/samba_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('QueryParameters Routes test', () {
    final radixRouter = RadixRouter<String, String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      radixRouter.put(
        method: httpMethod,
        path: '/countries',
        value: '$httpMethodName countries',
      );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String, String>? result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries?country=india',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], 'india');
        expect(result?.queryParameters.length, 1);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries?country=india&state=andhra-pradesh',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], 'india');
        expect(result?.queryParameters['state'], 'andhra-pradesh');
        expect(result?.queryParameters.length, 2);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries?country=india&country=pakistan',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], ['india', 'pakistan']);
        expect(result?.queryParameters.length, 1);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path:
              '/countries?country=india&country=pakistan&state=andhra-pradesh',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], ['india', 'pakistan']);
        expect(result?.queryParameters['state'], 'andhra-pradesh');
        expect(result?.queryParameters.length, 2);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path:
              '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters['country'], ['india', 'pakistan']);
        expect(
            result?.queryParameters['state'], ['andhra-pradesh', 'telangana']);
        expect(result?.queryParameters.length, 2);
        expect(result?.middlewares, isNull);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear $httpMethodName test', () {
        radixRouter.clear();
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&state=andhra-pradesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries?country=india&country=pakistan',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path:
                '/countries?country=india&country=pakistan&state=andhra-pradesh&state=telangana',
          ),
          isNull,
        );
      });
    }
  });
}
