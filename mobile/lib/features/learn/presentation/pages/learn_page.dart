import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/backend_status_badge.dart';
import '../bloc/learn_bloc.dart';
import '../bloc/learn_event.dart';
import '../bloc/learn_state.dart';
import '../widgets/learn_item_card.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  @override
  void initState() {
    super.initState();
    // Load materials when entering page
    context.read<LearnBloc>().add(LoadLearnMaterialsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Bahasa Isyarat'),
        actions: const [
          BackendStatusBadge(),
        ],
      ),
      body: BlocBuilder<LearnBloc, LearnState>(
        builder: (context, state) {
          if (state is LearnLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LearnLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text('Belum ada materi pembelajaran.'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return LearnItemCard(
                  item: item,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Membuka materi: ${item.title}')),
                    );
                  },
                );
              },
            );
          } else if (state is LearnError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Terjadi kesalahan: ${state.message}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LearnBloc>().add(LoadLearnMaterialsEvent());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Siap memulai belajar.'));
        },
      ),
    );
  }
}

