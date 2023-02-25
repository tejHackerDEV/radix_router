import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Parametric RegExp Routes test', () {
    final radixRouter = RadixRouter<String>();

    final httpMethods = HttpMethod.values;

    for (final httpMethod in httpMethods) {
      radixRouter
        ..put(
          method: httpMethod,
          path: '/{country:^[a-z]+\$}',
          value: '$httpMethod small country',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[A-Z]+\$}',
          value: '$httpMethod capital country',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[a-z]+\$}/{state:^[a-z-]+\$}',
          value: '$httpMethod small country & state',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[A-Z]+\$}/{state:^[A-Z-]+\$}',
          value: '$httpMethod capital country & state',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[a-z]+\$}/{state:^[a-z-]+\$}/{city:^[a-z]+\$}',
          value: '$httpMethod small country, state & city',
        )
        ..put(
          method: httpMethod,
          path: '/{country:^[A-Z]+\$}/{state:^[A-Z-]+\$}/{city:^[A-Z]+\$}',
          value: '$httpMethod capital country, state & city',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        Result<String>? result = radixRouter.lookup(
          method: httpMethod,
          path: 'india',
        );
        expect(
          result?.value,
          '$httpMethod small country',
        );
        expect(result?.pathParameters['country'], 'india');
        expect(result?.pathParameters.length, 1);

        result = radixRouter.lookup(
          method: httpMethod,
          path: 'INDIA',
        );
        expect(
          result?.value,
          '$httpMethod capital country',
        );
        expect(result?.pathParameters['country'], 'INDIA');
        expect(result?.pathParameters.length, 1);

        result = radixRouter.lookup(
          method: httpMethod,
          path: 'india/andhra-pradesh',
        );
        expect(
          result?.value,
          '$httpMethod small country & state',
        );
        expect(result?.pathParameters['country'], 'india');
        expect(result?.pathParameters['state'], 'andhra-pradesh');
        expect(result?.pathParameters.length, 2);

        result = radixRouter.lookup(
          method: httpMethod,
          path: 'INDIA/ANDHRA-PRADESH',
        );
        expect(
          result?.value,
          '$httpMethod capital country & state',
        );
        expect(result?.pathParameters['country'], 'INDIA');
        expect(result?.pathParameters['state'], 'ANDHRA-PRADESH');
        expect(result?.pathParameters.length, 2);

        result = radixRouter.lookup(
          method: httpMethod,
          path: 'india/andhra-pradesh/kadapa',
        );
        expect(
          result?.value,
          '$httpMethod small country, state & city',
        );
        expect(result?.pathParameters['country'], 'india');
        expect(result?.pathParameters['state'], 'andhra-pradesh');
        expect(result?.pathParameters['city'], 'kadapa');
        expect(result?.pathParameters.length, 3);

        result = radixRouter.lookup(
          method: httpMethod,
          path: 'INDIA/ANDHRA-PRADESH/KADAPA',
        );
        expect(
          result?.value,
          '$httpMethod capital country, state & city',
        );
        expect(result?.pathParameters['country'], 'INDIA');
        expect(result?.pathParameters['state'], 'ANDHRA-PRADESH');
        expect(result?.pathParameters['city'], 'KADAPA');
        expect(result?.pathParameters.length, 3);
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'in-dia',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'IND-IA',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'in-dia/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'IN-DIA/ANDHRA-PRADESH',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/cudd-apah',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/CUDDAP-AH',
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
            path: 'india',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/KADAPA',
          ),
          isNull,
        );
      });
    }
  });
}
