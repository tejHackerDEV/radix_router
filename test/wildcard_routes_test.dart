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
          path: '/countries/*',
          value: '$httpMethodName wildcard states',
        )
        ..put(
          method: httpMethod,
          path: '/countries/states/*',
          value: '$httpMethodName wildcard cities',
        )
        ..put(
          method: httpMethod,
          path: '/countries/states/cities/*',
          value: '$httpMethodName wildcard streets',
        )
        ..put(
          method: httpMethod,
          path: '/fruits/*',
          value: '$httpMethodName wildcard fruits',
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
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          '$httpMethodName wildcard states',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          '$httpMethodName wildcard states',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states',
          ),
          '$httpMethodName wildcard states',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/kadapa',
          ),
          '$httpMethodName wildcard cities',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cuddapah',
          ),
          '$httpMethodName wildcard cities',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cities',
          ),
          '$httpMethodName wildcard cities',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cities/bhagya-nagar-colony',
          ),
          '$httpMethodName wildcard streets',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cities/ngo-colony',
          ),
          '$httpMethodName wildcard streets',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          '$httpMethodName wildcard fruits',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple/1234',
          ),
          '$httpMethodName wildcard fruits',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits',
          ),
          '$httpMethodName wildcard',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/random',
          ),
          '$httpMethodName wildcard',
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
            path: '/countries/states',
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
            path: '/countries/states/cities',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cities/bhagya-nagar-colony',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/states/cities/ngo-colony',
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
