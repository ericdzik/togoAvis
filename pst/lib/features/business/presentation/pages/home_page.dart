import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pst/features/auth/bloc/auth_bloc.dart';
import 'package:pst/features/auth/bloc/auth_event.dart';
import 'package:pst/features/business/bloc/business_bloc.dart';
import 'package:pst/features/business/bloc/business_event.dart';
import 'package:pst/features/business/bloc/business_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // On déclenche l'événement pour charger les entreprises dès que la page est construite
    context.read<BusinessBloc>().add(LoadBusinesses());

    return Scaffold(
      appBar: AppBar(
        title: const Text('TogoAvis - Entreprises'),
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
      body: BlocBuilder<BusinessBloc, BusinessState>(
        builder: (context, state) {
          if (state is BusinessLoading || state is BusinessInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BusinessError) {
            return Center(
              child: Text(
                'Erreur de chargement des entreprises: ${state.message}',
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
              itemCount: state.businesses.length,
              itemBuilder: (context, index) {
                final business = state.businesses[index];
                return ListTile(
                  title: Text(business.name),
                  subtitle: Text(business.address),
                  leading: const Icon(Icons.business),
                  onTap: () {
                    context.go('/business/${business.id}');
                  },
                );
              },
            );
          }
          return const Center(child: Text('Bienvenue !'));
        },
      ),
    );
  }
}
