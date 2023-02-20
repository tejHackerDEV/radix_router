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
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'india',
          ),
          '$httpMethod small country',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA',
          ),
          '$httpMethod capital country',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh',
          ),
          '$httpMethod small country & state',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH',
          ),
          '$httpMethod capital country & state',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'india/andhra-pradesh/cuddapah',
          ),
          '$httpMethod small country, state & city',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/CUDDAPAH',
          ),
          '$httpMethod capital country, state & city',
        );
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
            path: 'india/andhra-pradesh/cuddapah',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: 'INDIA/ANDHRA-PRADESH/CUDDAPAH',
          ),
          isNull,
        );
      });
    }
  });
}
