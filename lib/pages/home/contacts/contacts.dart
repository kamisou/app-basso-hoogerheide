import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:basso_hoogerheide/models/repository/contacts.dart';
import 'package:basso_hoogerheide/pages/home/contacts/contact_tile.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'contacts_fab',
        child: const Icon(Icons.person_add),
        onPressed: () => Navigator.pushNamed(context, '/newContact'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Pesquisar contato...',
              onEditingComplete: () => ref
                  .read(contactsFilterProvider.notifier)
                  .state = _searchController.text.trim(),
            ),
          ),
          TabBar(
            controller: _tabController,
            padding: const EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 20,
              top: 16,
            ),
            tabs: const [
              Tab(text: 'Clientes'),
              Tab(text: 'Contatos'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AsyncCollection<Contact>(
                  asyncCollection: ref.watch(filteredFolderContactsProvider),
                  spacing: 0,
                  itemBuilder: (_, item) => ContactTile(contact: item),
                  emptyWidget: const Center(
                    child: EmptyCard(
                      icon: Icons.no_accounts_outlined,
                      message: 'Nenhum contato encontrado',
                    ),
                  ),
                  errorWidget: (_) => const Center(
                    child: EmptyCard(
                      icon: Icons.error,
                      message: 'Houve um erro ao buscar os contatos',
                    ),
                  ),
                  loadingWidget: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(20),
                    child: const CircularProgressIndicator(),
                  ),
                  onRefresh: () async =>
                      ref.refresh(filteredFolderContactsProvider),
                ),
                AsyncCollection<Contact>(
                  asyncCollection: ref.watch(filteredContactsProvider),
                  spacing: 0,
                  itemBuilder: (_, item) => ContactTile(contact: item),
                  emptyWidget: const Center(
                    child: EmptyCard(
                      icon: Icons.no_accounts_outlined,
                      message: 'Nenhum contato encontrado',
                    ),
                  ),
                  errorWidget: (_) => const Center(
                    child: EmptyCard(
                      icon: Icons.error,
                      message: 'Houve um erro ao buscar os contatos',
                    ),
                  ),
                  loadingWidget: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(20),
                    child: const CircularProgressIndicator(),
                  ),
                  onRefresh: () async => ref.refresh(filteredContactsProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
