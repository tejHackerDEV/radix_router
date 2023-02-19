import 'package:radix_router/radix_router.dart';
import 'package:test/test.dart';

void main() {
  group('Static Routes test', () {
    final radixRouter = RadixRouter<String>();

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
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries',
          ),
          '$httpMethodName countries',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/india',
          ),
          '$httpMethodName india',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/pakistan',
          ),
          '$httpMethodName pakistan',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/states',
          ),
          '$httpMethodName states',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/states/andhra-pradesh',
          ),
          '$httpMethodName andhra-pradesh',
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits/apple',
          ),
          '$httpMethodName apple',
        );
      });
    }

    for (final httpMethod in httpMethods) {
      final httpMethodName = httpMethod.name;
      test('Invalid $httpMethodName test', () {
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/in/dia',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/pak/stan',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/countries/bangladesh',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/states/telangana',
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
            path: '/fru-its',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits/app/le',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fru/its/pineapple',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fru/its/ban/ana',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/fruits/straw-berry',
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
            path: '/states',
          ),
          isNull,
        );
        expect(
          radixRouter.lookup(
            method: httpMethod,
            path: '/states/andhra-pradesh',
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
      });
    }
  });
}
