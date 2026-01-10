import 'package:compaintsystem/core/utils/api_service.dart';
import 'package:compaintsystem/featuer/users/data/user_admin_model.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/get_cubit/get_all_user_cubit.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/get_cubit/get_all_user_state.dart';
import 'package:compaintsystem/featuer/users/presentation/view/manager/update_cubit/update_user_cubit.dart';
import 'package:compaintsystem/featuer/users/presentation/view/update_user_view.dart';
import 'package:compaintsystem/featuer/users/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UsersCubit(UsersRepository(ApiService()))..fetchUsers(),
      child: const AdminUsersView(),
    );
  }
}

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  String selectedType = 'all';
  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<UsersCubit>().fetchUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "إدارة المستخدمين",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: () =>
                context.read<UsersCubit>().fetchUsers(isRefresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersError) {
                  return _buildErrorWidget(state.message);
                } else if (state is UsersSuccess) {
                  if (state.users.isEmpty) return _buildEmptyWidget();

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<UsersCubit>().fetchUsers(isRefresh: true),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: state.users.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.users.length) {
                          return _buildUserListItem(
                            context,
                            state.users[index],
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                context.read<UsersCubit>().filterAndSearch(
                  type: selectedType,
                  query: searchQuery,
                );
              },
              decoration: InputDecoration(
                hintText: "ابحث بالاسم أو البريد...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _filterChip("الكل", "all", Colors.blueGrey),
                _filterChip("مدراء", "admin", Colors.purple),
                _filterChip("موظفين", "staff", Colors.orange),
                _filterChip("مواطنين", "citizen", Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String type, Color color) {
    bool isSelected = selectedType == type;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: color.withOpacity(0.2),
        checkmarkColor: color,
        labelStyle: TextStyle(
          color: isSelected ? color : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          setState(() => selectedType = type);
          context.read<UsersCubit>().filterAndSearch(
            type: selectedType,
            query: searchQuery,
          );
        },
        backgroundColor: Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(color: isSelected ? color : Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildUserListItem(BuildContext context, UserAdminModel user) {
    return GestureDetector(
      onTap: () async {
        bool? isUpdated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  UpdateUserCubit(UsersRepository(ApiService())),
              child: EditUserScreen(user: user),
            ),
          ),
        );
        if (isUpdated == true && mounted) {
          context.read<UsersCubit>().fetchUsers(isRefresh: true);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: _getTypeColor(user.type).withOpacity(0.1),
            child: Icon(Icons.person_outline, color: _getTypeColor(user.type)),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                user.email ?? "لا يوجد بريد إلكتروني",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _statusBadge(
                    user.type.toUpperCase(),
                    _getTypeColor(user.type),
                  ),
                  const SizedBox(width: 8),
                  _statusBadge(
                    user.isActive ? "نشط" : "معطل",
                    user.isActive ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    if (type == 'admin') return Colors.purple;
    if (type == 'staff') return Colors.orange;
    return Colors.blue;
  }

  Widget _buildEmptyWidget() =>
      const Center(child: Text("لا توجد نتائج مطابقة لبحثك"));

  Widget _buildErrorWidget(String msg) => Center(child: Text("حدث خطأ: $msg"));
}
