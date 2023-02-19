import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Parametric Routes test', () {
    final radixRouter = RadixRouter<String>();

    final httpMethods = HttpMethod.values;

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      radixRouter
        ..put(
          method: httpMethod,
          path: '/{country}',
          value: '$httpMethodName dynamic country',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{state}',
          value: '$httpMethodName dynamic state',
        )
        ..put(
          method: httpMethod,
          path: '/countries/states/{city}',
          value: '$httpMethodName dynamic city',
        )
        ..put(
          method: httpMethod,
          path: '/countries/{state}/{city}',
          value: '$httpMethodName dynamic state & city',
        )
        ..put(
          method: httpMethod,
          path: '/{countries}/{state}/{city}',
          value: '$httpMethodName dynamic country, state & city',
        );
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Valid $httpMethodName test', () {
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india',
          ),
          '$httpMethodName dynamic country',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh',
          ),
          '$httpMethodName dynamic state',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/telangana',
          ),
          '$httpMethodName dynamic state',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/kadapa',
          ),
          '$httpMethodName dynamic city',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cuddapah',
          ),
          '$httpMethodName dynamic city',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/kadapa',
          ),
          '$httpMethodName dynamic state & city',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/cuddapah',
          ),
          '$httpMethodName dynamic state & city',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/cuddapah',
          ),
          '$httpMethodName dynamic country, state & city',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/india/andhra-pradesh/kadapa',
          ),
          '$httpMethodName dynamic country, state & city',
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/kadapa/cuddapah',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/cuddapah/kadapa',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/kadapa/cuddapah',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cuddapah/kadapa',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/city/cuddapah',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/city/kadapa',
          ),
          isNull,
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
            path: '/countries/andhra-pradesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/telangana',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/kadapa',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cuddapah',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/kadapa',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/andhra-pradesh/cuddapah',
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
            path: '/india/andhra-pradesh/kadapa',
          ),
          isNull,
        );
      });
    }
  });
}
