import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Static Routes test', () {
    final radixRouter = RadixRouter<String, String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      radixRouter
        ..put(
          method: httpMethod,
          path: '/countries',
          value: '$httpMethodName countries',
        )
        ..put(
          method: httpMethod,
          path: '/countries/india',
          value: '$httpMethodName india',
        )
        ..put(
          method: httpMethod,
          path: '/countries/pakistan',
          value: '$httpMethodName pakistan',
        )
        ..put(
          method: httpMethod,
          path: '/countries/afghanistan',
          value: '$httpMethodName afghanistan',
        )
        ..put(
          method: httpMethod,
          path: '/states',
          value: '$httpMethodName states',
        )
        ..put(
          method: httpMethod,
          path: '/states/andhra-pradesh',
          value: '$httpMethodName andhra-pradesh',
        )
        ..put(
          method: httpMethod,
          path: '/fruits/apple',
          value: '$httpMethodName apple',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String, String>? result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries',
        );
        expect(
          result?.value,
          '$httpMethodName countries',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
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
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/pakistan',
        );
        expect(
          result?.value,
          '$httpMethodName pakistan',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/states',
        );
        expect(
          result?.value,
          '$httpMethodName states',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/states/andhra-pradesh',
        );
        expect(
          result?.value,
          '$httpMethodName andhra-pradesh',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/fruits/apple',
        );
        expect(
          result?.value,
          '$httpMethodName apple',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/countries/in/dia',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/countries/pak/stan',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/countries/bangladesh',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/states/telangana',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/fruits',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/fru-its',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/fruits/app/le',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/fru/its/pineapple',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/fru/its/ban/ana',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/fruits/straw-berry',
              )
              ?.value,
          isNull,
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Clear $httpMethodName test', () {
        radixRouter.clear();
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/countries',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/countries/india',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/countries/pakistan',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/states',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/states/andhra-pradesh',
              )
              ?.value,
          isNull,
        );
        expect(
          radixRouter
              .lookup(
                method: httpMethod,
                path: '/fruits/apple',
              )
              ?.value,
          isNull,
        );
      });
    }
  });
}
