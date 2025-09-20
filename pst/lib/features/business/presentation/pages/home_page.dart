import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pst/features/auth/bloc/auth_bloc.dart';
import 'package:pst/features/auth/bloc/auth_event.dart';
import 'package:pst/features/business/bloc/business_bloc.dart';
import 'package:pst/features/business/bloc/business_event.dart';
import 'package:pst/features/business/bloc/business_state.dart';
import 'package:pst/features/business/presentation/widgets/business_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // On déclenche l'événement pour charger les entreprises une seule fois
    context.read<BusinessBloc>().add(LoadBusinesses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TogoAvis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Rechercher un restaurant, un garage...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onTap: () {
                // Non-functional for now
              },
            ),
          ),

          // --- Category Chips ---
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildCategoryChip(context, '🍽️ Restaurants'),
                _buildCategoryChip(context, '🛍️ Boutiques'),
                _buildCategoryChip(context, '🩺 Santé'),
                _buildCategoryChip(context, '🔧 Services'),
                _buildCategoryChip(context, '🏨 Hôtels'),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              'Populaires',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // --- Business List ---
          Expanded(
            child: BlocBuilder<BusinessBloc, BusinessState>(
              builder: (context, state) {
                if (state is BusinessLoading || state is BusinessInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BusinessError) {
                  return Center(
                    child: Text(
                      'Erreur: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is BusinessLoaded) {
                  if (state.businesses.isEmpty) {
                    return const Center(
                      child: Text('Aucune entreprise trouvée.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    itemCount: state.businesses.length,
                    itemBuilder: (context, index) {
                      final business = state.businesses[index];
                      return BusinessListTile(business: business);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        onPressed: () {
          // Non-functional for now
        },
      ),
    );
  }
}
