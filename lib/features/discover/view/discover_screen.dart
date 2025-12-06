import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/categories_constants.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../cubit/discover_cubit.dart';
import '../cubit/discover_state.dart';
import '../view/widgets/podcast_grid_item.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discoverCubit = context.watch<DiscoverCubit>();
    final selectedCategory = discoverCubit.selectedCategoryId;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2D),
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(
          'Podkes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, size: 24.sp),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, size: 24.sp),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color(0xFF262033),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) {
                  return SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 48, color: Colors.white38),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications yet',
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'ll notify you when something important happens.',
                            textAlign: TextAlign.center,
                            style:
                            TextStyle(color: Colors.white70, fontSize: 14.sp),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000.w),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) =>
                        context.read<DiscoverCubit>().updateSearch(value),
                    decoration: InputDecoration(
                      hintText: 'Elif',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFF262033),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                  SizedBox(height: 16.h),

                  SizedBox(
                    height: 40.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 10.w),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category.id == selectedCategory;
                        return GestureDetector(
                          onTap: () => context
                              .read<DiscoverCubit>()
                              .selectCategory(category.id),
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF262033),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color:
                                isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    'Trending',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  BlocBuilder<DiscoverCubit, DiscoverState>(
                    builder: (context, state) {
                      if (state is DiscoverError) {
                        return Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline,
                                  size: 48.sp, color: Colors.redAccent),
                              SizedBox(height: 12.h),
                              Text(
                                'Veri alınamadı.',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14.sp),
                              ),
                            ],
                          ),
                        );
                      }

                      final isLoading = state is DiscoverLoading;
                      final loadedState =
                      state is DiscoverLoaded ? state : null;

                      return PodcastGrid(
                        state: loadedState,
                        isLoading: isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}