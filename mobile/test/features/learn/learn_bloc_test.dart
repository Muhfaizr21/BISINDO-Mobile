import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/learn/domain/entities/learn_item.dart';
import 'package:mobile/features/learn/domain/repositories/learn_repository.dart';
import 'package:mobile/features/learn/domain/usecases/get_learn_materials_usecase.dart';
import 'package:mobile/features/learn/presentation/bloc/learn_bloc.dart';
import 'package:mobile/features/learn/presentation/bloc/learn_event.dart';
import 'package:mobile/features/learn/presentation/bloc/learn_state.dart';

class FakeLearnRepository implements LearnRepository {
  final List<LearnItem> items;
  FakeLearnRepository(this.items);

  @override
  Future<List<LearnItem>> getLearnMaterials() async {
    return items;
  }
}

void main() {
  group('LearnBloc Test', () {
    const testItems = [
      LearnItem(
        id: '1',
        title: 'Alfabet A - Z',
        description: 'Belajar alfabet',
        category: 'Dasar',
      ),
    ];

    test('initial state is LearnInitial', () {
      final fakeRepo = FakeLearnRepository(testItems);
      final useCase = GetLearnMaterialsUseCase(fakeRepo);
      final bloc = LearnBloc(getLearnMaterialsUseCase: useCase);

      expect(bloc.state, equals(LearnInitial()));
      bloc.close();
    });

    blocTest<LearnBloc, LearnState>(
      'emits [LearnLoading, LearnLoaded] when LoadLearnMaterialsEvent is added',
      build: () {
        final fakeRepo = FakeLearnRepository(testItems);
        final useCase = GetLearnMaterialsUseCase(fakeRepo);
        return LearnBloc(getLearnMaterialsUseCase: useCase);
      },
      act: (b) => b.add(LoadLearnMaterialsEvent()),
      expect: () => [
        LearnLoading(),
        const LearnLoaded(testItems),
      ],
    );
  });
}

