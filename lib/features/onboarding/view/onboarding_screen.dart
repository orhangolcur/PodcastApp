import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/onboarding1.jpg',
      'title': 'Podkes',
      'description':
      'A podcast is an episodic series of spoken word digital audio files that a user can download to a personal device for easy listening.',
    },
    {
      'image': 'assets/images/onboarding2.jpg',
      'title': 'Listen Anywhere',
      'description':
      'Stream or download episodes for offline listening — anytime, anywhere.',
    },
    {
      'image': 'assets/images/onboarding3.jpg',
      'title': 'Curated for You',
      'description':
      'Discover podcasts tailored to your taste. Whether it\'s tech, comedy or true crime — we’ve got you covered.',
    },
    {
      'image': 'assets/images/onboarding4.jpg',
      'title': 'Join the Podkes Journey',
      'description':
      'Follow your favorites, build your library, and never miss an episode again — all in one app.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = 1.sw > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFF15121E),
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (_, index) {
          final page = pages[index];
          return isLandscape
              ? _buildLandscapeLayout(page, isTablet)
              : _buildPortraitLayout(page, isTablet);
        },
      ),
    );
  }

  Widget _buildPortraitLayout(Map<String, String> page, bool isTablet) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image.asset(
                    page['image']!,
                    width: 0.75.sw,
                    height: 0.75.sw,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  page['title']!,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  page['description']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      width: _currentPage == index ? 10.w : 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildNextButton(isTablet),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLandscapeLayout(Map<String, String> page, bool isTablet) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Image.asset(
                  page['image']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                page['title']!,
                                style: TextStyle(
                                  fontSize: isTablet ? 24.sp : 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                page['description']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isTablet ? 14.sp : 12.sp,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  pages.length,
                                      (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                                    width: _currentPage == index ? 10.w : 6.w,
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: _buildNextButton(isTablet),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildNextButton(bool isTablet) {
    return GestureDetector(
      onTap: () {
        if (_currentPage < pages.length - 1) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          context.go('/login');
        }
      },
      child: Container(
        padding: EdgeInsets.all(isTablet ? 12.w : 18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 12.r : 18.r),
        ),
        child: Icon(
          _currentPage == pages.length - 1 ? Icons.check : Icons.arrow_forward,
          color: Colors.black,
          size: isTablet ? 20.sp : 24.sp,
        ),
      ),
    );
  }
}