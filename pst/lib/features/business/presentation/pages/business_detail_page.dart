import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pst/features/auth/bloc/auth_bloc.dart';
import 'package:pst/features/auth/bloc/auth_state.dart';
import 'package:pst/features/business/bloc/business_bloc.dart';
import 'package:pst/features/business/bloc/business_event.dart';
import 'package:pst/features/business/bloc/business_state.dart';
import 'package:pst/features/reviews/bloc/review_bloc.dart';
import 'package:pst/features/reviews/bloc/review_event.dart';
import 'package:pst/features/reviews/bloc/review_state.dart';
import 'package:pst/features/reviews/data/review_model.dart';

class BusinessDetailPage extends StatefulWidget {
  final String businessId;

  const BusinessDetailPage({
    super.key,
    required this.businessId,
  });

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  @override
  void initState() {
    super.initState();
    // Charger les détails de l'entreprise et les avis
    context.read<BusinessBloc>().add(GetBusinessById(widget.businessId));
    context.read<ReviewBloc>().add(LoadReviews(widget.businessId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'entreprise'),
      ),
      body: BlocBuilder<BusinessBloc, BusinessState>(
        builder: (context, state) {
          if (state is BusinessLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BusinessDetailLoaded) {
            final business = state.business;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    business.category,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  // Placeholder for an image
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 50)),
                  ),
                  const SizedBox(height: 16),
                  Text(business.address),
                  const SizedBox(height: 8),
                  Text(business.contact),
                  const SizedBox(height: 16),
                  const Divider(),
                  Text(
                    'À propos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(business.description),
                  const SizedBox(height: 16),
                  const Divider(),
                  _ReviewsSection(),
                ],
              ),
            );
          } else if (state is BusinessError) {
            return Center(
              child: Text(
                'Erreur: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // Pour l'état initial ou tout autre état non géré
          return const Center(
            child: Text('Chargement des détails de l\'entreprise...'),
          );
        },
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return FloatingActionButton(
              onPressed: () => _showAddReviewDialog(context, state.user.uid),
              child: const Icon(Icons.add_comment),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context, String userId) {
    final _formKey = GlobalKey<FormState>();
    double _rating = 3;
    final _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ajouter un avis'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rating.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() => _rating = value);
                      },
                    );
                  },
                ),
                TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: 'Votre commentaire',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un commentaire.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ReviewBloc>().add(AddReview(
                        businessId: widget.businessId,
                        userId: userId,
                        rating: _rating,
                        comment: _commentController.text,
                      ));
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avis des clients',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewLoaded) {
              if (state.reviews.isEmpty) {
                return const Text('Aucun avis pour le moment.');
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.reviews.length,
                itemBuilder: (context, index) {
                  final review = state.reviews[index];
                  return _ReviewCard(review: review);
                },
              );
            } else if (state is ReviewError) {
              return Text(
                'Erreur: ${state.message}',
                style: const TextStyle(color: Colors.red),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  review.rating.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  'par Utilisateur ${review.userId.substring(0, 6)}...', // Anonymiser
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}
