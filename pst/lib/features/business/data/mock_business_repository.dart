// pst/lib/features/business/data/mock_business_repository.dart

import './business_model.dart';

final List<BusinessModel> mockBusinesses = [
  BusinessModel(
    id: '1',
    name: 'Le Patio Maison d\'Hôtes',
    category: 'Restaurant',
    address: 'Nyékonakpoé, Lomé',
    averageRating: 4.5,
    reviewCount: 38,
    imageUrl: 'https://via.placeholder.com/150', // Placeholder image
  ),
  BusinessModel(
    id: '2',
    name: 'Pharmacie du Peuple',
    category: 'Santé',
    address: 'Bè-Klikamé, Lomé',
    averageRating: 4.8,
    reviewCount: 52,
    imageUrl: 'https://via.placeholder.com/150',
  ),
  BusinessModel(
    id: '3',
    name: 'Garage "Le Bon Mécano"',
    category: 'Services',
    address: 'Adidogomé, Lomé',
    averageRating: 3.9,
    reviewCount: 21,
    imageUrl: 'https://via.placeholder.com/150',
  ),
   BusinessModel(
    id: '4',
    name: 'Boutique "Chez Fifi"',
    category: 'Shopping',
    address: 'Grand Marché, Lomé',
    averageRating: 4.2,
    reviewCount: 18,
    imageUrl: 'https://via.placeholder.com/150',
  ),
];
