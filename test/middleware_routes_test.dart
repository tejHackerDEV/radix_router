import 'package:radix_router/radix_router.dart';
import 'package:samba_helpers/samba_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('Middleware Routes test', () {
    final radixRouter = RadixRouter<String, String>();

    final httpMethods = HttpMethod.values;
    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      radixRouter
        ..put(
          method: httpMethod,
          path: '/countries',
          value: '$httpMethodName countries',
          middlewares: [
            '$httpMethodName countries1',
          ],
        )
        ..put(
          method: httpMethod,
          path: '/countries/india/',
          value: '$httpMethodName india',
          middlewares: [
            '$httpMethodName india1',
            '$httpMethodName india2',
          ],
        )
        ..put(
          method: httpMethod,
          path: '/countries/afghanistan',
          value: '$httpMethodName afghanistan',
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
        expect(
          result?.middlewares,
          [
            '$httpMethodName countries1',
          ],
        );

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
        expect(
          result?.middlewares,
          [
            '$httpMethodName india1',
            '$httpMethodName india2',
          ],
        );

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/india/',
          shouldReturnParentMiddlewares: false,
        );
        expect(
          result?.value,
          '$httpMethodName india',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName india1',
            '$httpMethodName india2',
          ],
        );

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/afghanistan/',
        );
        expect(
          result?.value,
          '$httpMethodName afghanistan',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(result?.middlewares, isNull);

        result = radixRouter.lookup(
            method: httpMethod,
            path: '/countries/afghanistan',
            shouldReturnParentMiddlewares: true);
        expect(
          result?.value,
          '$httpMethodName afghanistan',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName countries1',
          ],
        );

        result = radixRouter.lookup(
          method: httpMethod,
          path: '/countries/india',
          shouldReturnParentMiddlewares: true,
        );
        expect(
          result?.value,
          '$httpMethodName india',
        );
        expect(result?.pathParameters.isEmpty, isTrue);
        expect(result?.queryParameters, isEmpty);
        expect(
          result?.middlewares,
          [
            '$httpMethodName countries1',
            '$httpMethodName india1',
            '$httpMethodName india2',
          ],
        );
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
