import 'package:flutter_test/flutter_test.dart';
import 'package:resorthub_mobile/main.dart';
import 'package:resorthub_mobile/data/models/chalet_model.dart';
import 'package:resorthub_mobile/data/models/booking_model.dart';
import 'package:resorthub_mobile/data/models/user_model.dart';
import 'package:resorthub_mobile/data/models/review_model.dart';
import 'package:resorthub_mobile/data/models/image_model.dart';

void main() {
  group('ResortHub Yemen Model Serialization Tests', () {
    test('ChaletModel fromJson and toJson serialization', () {
      final json = {
        'chaletId': 1,
        'chaletName': 'Sana\u2019a Mountain Retreat',
        'location': 'Sana\u2019a',
        'pricePerNight': 150.0,
        'capacity': 6,
        'description': 'A luxury mountain retreat.',
      };

      final chalet = ChaletModel.fromJson(json);
      expect(chalet.chaletId, 1);
      expect(chalet.chaletName, 'Sana\u2019a Mountain Retreat');
      expect(chalet.location, 'Sana\u2019a');
      expect(chalet.pricePerNight, 150.0);
      expect(chalet.capacity, 6);
      expect(chalet.description, 'A luxury mountain retreat.');

      final serialized = chalet.toJson();
      expect(serialized['chaletId'], 1);
      expect(serialized['chaletName'], 'Sana\u2019a Mountain Retreat');
    });

    test('BookingModel fromJson and toJson serialization', () {
      final json = {
        'bookingId': 10,
        'userId': 2,
        'chaletId': 1,
        'checkInDate': '2026-09-01T12:00:00.000Z',
        'checkOutDate': '2026-09-05T12:00:00.000Z',
        'guests': 4,
        'totalPrice': 600.0,
        'status': 'Confirmed',
      };

      final booking = BookingModel.fromJson(json);
      expect(booking.bookingId, 10);
      expect(booking.userId, 2);
      expect(booking.chaletId, 1);
      expect(booking.guests, 4);
      expect(booking.totalPrice, 600.0);
      expect(booking.status, 'Confirmed');
    });

    test('UserModel fromJson and toJson serialization', () {
      final json = {
        'userId': 5,
        'fullName': 'Ali Ahmed',
        'email': 'ali@example.com',
        'phoneNumber': '+967771234567',
        'role': 'User',
      };

      final user = UserModel.fromJson(json);
      expect(user.userId, 5);
      expect(user.fullName, 'Ali Ahmed');
      expect(user.email, 'ali@example.com');
      expect(user.role, 'User');
    });

    test('ReviewModel fromJson and toJson serialization', () {
      final json = {
        'reviewId': 3,
        'userId': 2,
        'chaletId': 1,
        'rating': 5,
        'comment': 'Amazing stay!',
        'reviewDate': '2026-08-20T00:00:00.000Z',
      };

      final review = ReviewModel.fromJson(json);
      expect(review.reviewId, 3);
      expect(review.rating, 5);
      expect(review.comment, 'Amazing stay!');
    });

    test('ImageModel fromJson and toJson serialization', () {
      final json = {
        'imageId': 7,
        'chaletId': 1,
        'imageUrl': 'https://example.com/chalet1.jpg',
        'caption': 'Front View',
      };

      final image = ImageModel.fromJson(json);
      expect(image.imageId, 7);
      expect(image.imageUrl, 'https://example.com/chalet1.jpg');
      expect(image.caption, 'Front View');
    });
  });

  group('Application Startup Smoke Test', () {
    testWidgets('ResortHubApp boots and displays the Splash Screen Arabic headline', (WidgetTester tester) async {
      await tester.pumpWidget(const ResortHubApp());
      // Allow the first frame to render (before delayed navigation fires)
      await tester.pump();

      // The SplashScreen shows this Arabic discovery headline — not a plain title bar.
      // This validates the app boots without crash and the first screen renders correctly.
      expect(find.text('اكتشف أجمل  المنتجعات\nوأحجز تجربتك بسهولة'), findsOneWidget);

      // Drain the splash transition timer so no pending timers remain
      await tester.pump(const Duration(milliseconds: 3000));
    });
  });
}
