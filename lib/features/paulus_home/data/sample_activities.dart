import '../models/activity.dart';

const sampleActivities = [
  Activity(
    title: 'Fun Futsal Bareng',
    category: 'Sepak bola',
    location: 'Jakarta Selatan',
    schedule: 'Minggu, 08.00',
    imagePath: 'assets/images/futsal.jpg',
    timeGroup: ActivityTimeGroup.weekend,
    participants: 8,
    capacity: 12,
  ),
  Activity(
    title: 'Badminton Santai',
    category: 'Badminton',
    location: 'Jakarta Pusat',
    schedule: 'Sabtu, 16.00',
    imagePath: 'assets/images/badminton.jpg',
    timeGroup: ActivityTimeGroup.weekend,
    participants: 5,
    capacity: 8,
  ),
  Activity(
    title: 'Basket Sore',
    category: 'Basket',
    location: 'Jakarta Selatan',
    schedule: 'Jumat, 17.00',
    imagePath: 'assets/images/basket.jpg',
    timeGroup: ActivityTimeGroup.weekday,
    participants: 10,
    capacity: 12,
  ),
  Activity(
    title: 'Lari Pagi Bareng',
    category: 'Lari',
    location: 'GBK, Jakarta',
    schedule: 'Minggu, 06.00',
    imagePath: 'assets/images/home_hero.jpg',
    timeGroup: ActivityTimeGroup.weekend,
    participants: 6,
    capacity: 15,
  ),
];
